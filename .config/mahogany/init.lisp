(in-package #:mahogany-user)

(defmacro pcall (label &body body)
  "Run BODY, downgrading any error to a log line tagged LABEL."
  `(handler-case (progn ,@body)
     (error (c) (mh::log-string :error "config [~a]: ~a" ,label c))))

(defmacro once (label &body body)
  "Like `pcall', but runs only at startup."
  `(when mh::*initializing* (pcall ,label ,@body)))

;; log-init defaults to *error-output*
(mahogany/log:log-init :level :debug :output *standard-output*)

(pcall "xkb layout"
  (xkb:with-xkb-rule-names (rules (:layout "br" :variant "abnt2"))
    (mh::mahogany-set-keymap mh::*compositor-state* :rules rules)))

(pcall "settings"
  (config-system:set-config
    mh::keyboard-repeat-rate 100
    mh::keyboard-repeat-delay 300
    ;; NOTE(LucasTA): these depend on a patch
    mh::touchpad-tap-to-click t
    mh::touchpad-disable-while-typing t
    mh::touchpad-accel-speed 0.3))

(pcall "terminal"
  (let ((term (uiop:getenvp "TERMINAL")))
    (when term
      (push term mahogany/system::*default-terminals*))))

(defmacro defexec (name command &optional doc)
  `(mh::defcommand ,name ()
     (:documentation ,(or doc command))
     (:method () (uiop:launch-program ,command))))

;; menu / launchers
(defexec menu-drun     "tofi-drun --drun-launch=true")
(defexec menu-org      "orgmenu ~/documentos/favs.md")
(defexec menu-pass     "keepassxc")
(defexec menu-clip     "cliphist list | tofi | cliphist decode | wl-copy")
(defexec menu-calc     "foot -T calculadora -a calculadora python")
(defexec menu-edit     "foot -T nvim -a nvim nvim ~/documentos/")
(defexec menu-emoji    "foot -T float -a float fzf_emojis")
(defexec menu-browser  "qutebrowser")
(defexec menu-htop     "foot -T float -a float htop")
(defexec menu-lock     "swaylock -c 000000ff --scaling fill")
(defexec menu-notes    "foot -T nvim -a nvim nvim ~/documentos/anotações.md")

;; top level
(defexec screenshot    "wayland_print")
(defexec search-web    "search")
(defexec brightness-up   "brightnessctl set +5%")
(defexec brightness-down "brightnessctl set 5%-")

;; music / audio
(defexec music-player  "foot -T ncmpcpp -a ncmpcpp ncmpcpp")
(defexec music-mixer   "foot -T float -a float pulsemixer")
(defexec music-toggle  "playerctl play-pause || mpc toggle")
(defexec music-prev    "mpc prev")
(defexec music-next    "mpc next")
(defexec volume-up     "wpctl set-volume @DEFAULT_SINK@ 5%+")
(defexec volume-down   "wpctl set-volume @DEFAULT_SINK@ 5%-")

;; Groups
(defun group-named (name)
  (find name (mh::state-groups mh::*compositor-state*)
        :key #'mh::mahogany-group-name :test #'string=))

(defun switch-to-group (name)
  (let* ((state mh::*compositor-state*)
         (target (group-named name))
         (current (mh::state-current-group state)))
    (cond
      ((null target)
       (mh::log-string :warn "No group named ~s" name))
      ((eq target current))
      (t
       (let ((hidden (mh::state-hidden-groups state)))
         (ring-list:remove-item hidden target :test #'eq)
         (ring-list:add-item hidden current))
       (setf (mh::state-current-group state) target)))))

(defparameter *workspaces*
  '("Browser" "Code" "Fullscreen" "Message"))

(once "workspaces"
  (let ((state mh::*compositor-state*))
    (setf (mh::mahogany-group-name (mh::state-current-group state))
          (first *workspaces*))
    (dolist (name (rest *workspaces*))
      (mh::mahogany-state-group-add state :group-name name :make-current t))
    (switch-to-group (first *workspaces*))))

(mh::defcommand goto-browser ()
  (:documentation "Switch to the Browser group")
  (:method () (switch-to-group "Browser")))

(mh::defcommand goto-code ()
  (:documentation "Switch to the Code group")
  (:method () (switch-to-group "Code")))

(mh::defcommand goto-fullscreen ()
  (:documentation "Switch to the Fullscreen group")
  (:method () (switch-to-group "Fullscreen")))

(mh::defcommand goto-message ()
  (:documentation "Switch to the Message group")
  (:method () (switch-to-group "Message")))

;; Directional frame focus
(defun frame-probe-point (frame direction)
  "The point just outside FRAME's DIRECTION edge, centred along it."
  (let* ((x (mahogany/tree:frame-x frame))
         (y (mahogany/tree:frame-y frame))
         (w (mahogany/tree:frame-width frame))
         (h (mahogany/tree:frame-height frame))
         (mid-x (+ x (floor w 2)))
         (mid-y (+ y (floor h 2))))
    (ecase direction
      (:left  (values (1- x)  mid-y))
      (:right (values (+ x w) mid-y))
      (:up    (values mid-x   (1- y)))
      (:down  (values mid-x   (+ y h))))))

(defun focus-in-direction (direction seat)
  (let* ((state mh::*compositor-state*)
         (current (mh::state-current-frame state)))
    (when (typep current 'mahogany/tree:frame)
      (multiple-value-bind (x y) (frame-probe-point current direction)
        (let ((target (mahogany/tree:frame-at
                       (mh::mahogany-group-tiled-container
                        (mh::state-current-group state))
                       x y)))
          (when (and target (not (eq target current)))
            (mh::state-focus-frame state target seat)))))))

(mh::defcommand focus-left (mh::seat)
  (:documentation "Focus the frame left of the current one")
  (:method (mh::seat) (focus-in-direction :left mh::seat)))

(mh::defcommand focus-right (mh::seat)
  (:documentation "Focus the frame right of the current one")
  (:method (mh::seat) (focus-in-direction :right mh::seat)))

(mh::defcommand focus-up (mh::seat)
  (:documentation "Focus the frame above the current one")
  (:method (mh::seat) (focus-in-direction :up mh::seat)))

(mh::defcommand focus-down (mh::seat)
  (:documentation "Focus the frame below the current one")
  (:method (mh::seat) (focus-in-direction :down mh::seat)))

(defun remove-tiled-frame (state frame seat)
  "Remove FRAME, a view-frame, and move focus to a surviving neighbour."
  (let ((parent (mahogany/tree:frame-parent frame))
        (group (mh::state-current-group state)))
    (if (mahogany/tree:topmost-frame-p frame)
        (error 'mahogany/util:invalid-operation
               :text "Only frame on this output")
        (let* ((sibling (find-if (lambda (child) (not (eq child frame)))
                                 (mahogany/tree:tree-children parent)))
               (target (and sibling (mahogany/tree:find-first-leaf sibling)))
               (hidden (mh::mahogany-group-hidden-views group)))
          ;; Focus has to leave FRAME before it is removed
          (if (not target)
              (error 'mahogany/util:invalid-operation
                     :text "No frame to focus after removal")
              (let ((rescued nil))
                (mh::state-focus-frame state target seat)
                (mahogany/tree:remove-frame
                 frame
                 (lambda (removed)
                   (let ((view (mahogany/tree:frame-view removed)))
                     (when view
                       (setf rescued view)))))
                ;; This has to run after remove-frame
                (cond
                  ((null rescued) nil)
                  ((mahogany/tree:frame-view target)
                   (mh::%add-hidden hidden rescued))
                  (t (setf (mahogany/tree:frame-view target) rescued)))
                (hrt:dirty-view-transaction)))))))

(mh::defcommand remove-frame (mh::seat)
  (:documentation "Remove the current frame; its space goes to the neighbours")
  (:method (mh::seat)
    (let* ((state mh::*compositor-state*)
           (frame (mh::state-current-frame state)))
      (typecase frame
        (mahogany/tree:view-frame  (remove-tiled-frame state frame mh::seat))
        (mahogany/tree:output-node
         (error 'mahogany/util:invalid-operation :text "Unfullscreen first"))
        (t nil)))))

(mh::defcommand toggle-fullscreen ()
  (:documentation "Toggle fullscreen on the view in the current frame")
  (:method ()
    (let* ((state mh::*compositor-state*)
           (frame (mh::state-current-frame state))
           (view (typecase frame
                   ((or mahogany/tree:view-frame mahogany/tree:output-node)
                    (mahogany/tree:frame-view frame))
                   (t nil))))
      (when view
        (mh::mahogany-state-view-fullscreen
         state view
         (mh::group-current-output (mh::state-current-group state))
         (not (hrt:view-fullscreen-p view)))))))

;;; Menu map
(defparameter *menu-map*
  (mh:define-kmap
    (mh:kbd "Menu")   #'menu-drun
    (mh:kbd "o")      #'menu-org
    (mh:kbd "p")      #'menu-pass
    (mh:kbd "c")      #'menu-clip
    (mh:kbd "C")      #'menu-calc
    (mh:kbd "e")      #'menu-edit
    (mh:kbd "E")      #'menu-emoji
    (mh:kbd "f")      #'menu-browser
    (mh:kbd "h")      #'menu-htop
    (mh:kbd "l")      #'menu-lock
    (mh:kbd "a")      #'menu-notes
    (mh:kbd "R")      #'mh::loadrc
    (mh:kbd "Q")      #'mh::handle-server-stop))

;;; Keys
(pcall "keybindings"
  (mh:add-to-kmap mh:*top-map*
    ;; windows
    (mh:kbd "s-q")      #'mh::close-current-view
    (mh:kbd "s-Q")      #'remove-frame
    (mh:kbd "s-m")      #'mh::maximize-current-frame
    (mh:kbd "s-f")      #'toggle-fullscreen
    (mh:kbd "s-Return") #'mh::open-terminal
    (mh:kbd "s-Tab")    #'mh::next-view

    ;; directional frames
    (mh:kbd "s-h")      #'focus-left
    (mh:kbd "s-j")      #'focus-down
    (mh:kbd "s-k")      #'focus-up
    (mh:kbd "s-l")      #'focus-right
    (mh:kbd "s-Left")   #'focus-left
    (mh:kbd "s-Down")   #'focus-down
    (mh:kbd "s-Up")     #'focus-up
    (mh:kbd "s-Right")  #'focus-right
    (mh:kbd "s-L")      #'mh::split-frame-h
    (mh:kbd "s-J")      #'mh::split-frame-v

    ;; groups
    (mh:kbd "s-1")      #'goto-browser
    (mh:kbd "s-2")      #'goto-code
    (mh:kbd "s-3")      #'goto-fullscreen
    (mh:kbd "s-4")      #'goto-message

    ;; launchers
    (mh:kbd "s-p")      #'screenshot
    (mh:kbd "Print")    #'screenshot
    (mh:kbd "s-o")      #'search-web
    (mh:kbd "Menu")     *menu-map*

    ;; audio
    (mh:kbd "s-a")       #'music-player
    (mh:kbd "s-A")       #'music-mixer
    (mh:kbd "s-space")   #'music-toggle
    (mh:kbd "s-comma")   #'volume-down
    (mh:kbd "s-period")  #'volume-up
    (mh:kbd "s-<")       #'music-prev
    (mh:kbd "s->")       #'music-next
    (mh:kbd "XF86AudioPlay")        #'music-toggle
    (mh:kbd "XF86AudioLowerVolume") #'volume-down
    (mh:kbd "XF86AudioRaiseVolume") #'volume-up
    (mh:kbd "XF86MonBrightnessUp")   #'brightness-up
    (mh:kbd "XF86MonBrightnessDown") #'brightness-down))

;; NOTE(LucasTA): the necessary mahogany-portal.conf is generated by my nix config
(pcall "desktop name"
  (setf (uiop:getenv "XDG_CURRENT_DESKTOP") "mahogany"))

(once "startup"
  (dolist (cmd '("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                 "wl-paste --watch cliphist store"
                 "wl-clip-persist --clipboard regular"
                 "mako"
                 "swaybg -i $HOME/media/imagens/wallpapers/stsr1.png -m fill >$XDG_CACHE_HOME/swaybg.log 2>&1"
                 "pgrep -fx sway-audio-idle-inhibit || sway-audio-idle-inhibit"
                 "pgrep -x playerctld || playerctld daemon"
                 "waybar"
                 "pgrep -fx 'sh /home/lucas/code/shellscripts/notify-bat' || notify-bat"))
    (uiop:launch-program cmd)))

;; missing things to look at:
;;
;; window rules      stumpwm define-frame-preference, define-fullscreen-in-frame-rule,
;;                   or sway for_window/assign
;;
;; floating          floating windows, much less always on top or sticky windows
;;
;; move window       move-window up/down/left/right (s-HJKL, S-s-arrows) and
;;                   gnext/gprev-with-window (M-s-Left/Right)
;;
;; resize            check if there is a resize for frames/splits
;;
;; no IPC            sway related tools don't work, check if some of them could be worked
;;                   around, swayidle, swaylock and others
