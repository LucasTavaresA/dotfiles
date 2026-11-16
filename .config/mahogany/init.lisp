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
  (xkb:with-xkb-rule-names (rules (:layout "br"))
    (mh::mahogany-set-keymap mh::*compositor-state* :rules rules)))

(pcall "settings"
  (config-system:set-config
    mh::keyboard-repeat-rate 100
    mh::keyboard-repeat-delay 300
    mh::touchpad-tap-to-click t
    mh::touchpad-disable-while-typing t
    ;; obviously depends on a patch
    mh::hide-single-frame-borders t
    mh::touchpad-accel-speed 0.3
    mahogany/system::*default-terminals* '("foot")))

(defmacro defexec (name command)
  `(mh::defcommand ,name ()
     (:documentation ,command)
     (:method () (uiop:launch-program ,command))))

;; menu / launchers
(defexec menu-drun     "tofi-drun --drun-launch=true")
(defexec menu-org      "orgmenu ~/documentos/favs.md")
(defexec menu-pass     "keepassxc")
(defexec menu-clip     "cliphist list | tofi | cliphist decode | wl-copy")
(defexec menu-calc     "foot -T calculadora -a calculadora python")
(defexec menu-edit     "foot -T nvim -a nvim nvim ~/documentos/")
(defexec menu-emoji    "emojis")
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
(defparameter *workspaces*
  '("Browser" "Code" "Fullscreen" "Message"))

(once "workspaces"
  (mh::grename (first *workspaces*))
  (mapc #'mh::gnewbg (rest *workspaces*)))

(defmacro defmove (name group)
  `(mh::defcommand ,name ()
     (:documentation ,(format nil "Move the current view to the ~a group" group))
     (:method () (mh::gmove (mh::state-find-group mh::*compositor-state* ,group)))))

(defmove move-to-browser    "Browser")
(defmove move-to-code       "Code")
(defmove move-to-fullscreen "Fullscreen")
(defmove move-to-message    "Message")

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

(defmacro deffocus (name direction)
  `(mh::defcommand ,name (mh::seat)
     (:documentation ,(format nil "Focus the next frame going ~(~a~)" direction))
     (:method (mh::seat) (focus-in-direction ,direction mh::seat))))

(deffocus focus-left  :left)
(deffocus focus-right :right)
(deffocus focus-up    :up)
(deffocus focus-down  :down)

(mh::defcommand toggle-fullscreen ()
  (:documentation "Toggle fullscreen on the view in the current frame")
  (:method ()
    (alexandria:when-let*
      ((state mh::*compositor-state*)
       (frame (mh::state-current-frame state))
       (view (mahogany/tree:frame-surface frame)))
      (when (typep view 'hrt:view)
        (mh::mahogany-state-view-fullscreen
          ;; no output, so the view goes fullscreen on its own
          state view nil
          ;; view-fullscreen-p only changes once the client acks, so a
          ;; second press before that would fullscreen it again:
          (not (typep frame 'mahogany/tree:output-node)))))))

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
    (mh:kbd "s-Q")      #'mh::remove-current-frame
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
    (mh:kbd "s-1")      #'mh::group-select-1
    (mh:kbd "s-2")      #'mh::group-select-2
    (mh:kbd "s-3")      #'mh::group-select-3
    (mh:kbd "s-4")      #'mh::group-select-4
    (mh:kbd "s-!")      #'move-to-browser
    (mh:kbd "s-@")      #'move-to-code
    (mh:kbd "s-#")      #'move-to-fullscreen
    (mh:kbd "s-$")      #'move-to-message

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

(defun nested-p ()
  (let ((env (uiop:read-file-string "/proc/self/environ" :external-format :latin-1)))
    (some (lambda (var) (search (format nil "~C~A=" #\Nul var)
                                (format nil "~C~A" #\Nul env)))
          '("WAYLAND_DISPLAY" "WAYLAND_SOCKET" "DISPLAY"))))

(once "startup"
  (unless (nested-p)
    (uiop:launch-program
     (format nil "systemd-cat -t mahogany-session sh -c '~{~a~^; ~}'"
             (list "export SYSTEMD_LOG_TARGET=console"
                   ;; waybar socket depends on a patch, it hides waybar when super is held
                   (format nil "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP~@[ MAHOGANY_WAYBAR_SOCK=~a~]"
                           mahogany:*waybar-swaysock*)
                   "systemctl --user stop graphical-session.target"
                   "systemctl --user start wayland-session.target")))))

;; missing things to look at:
;;
;; window rules      stumpwm define-frame-preference, define-fullscreen-in-frame-rule,
;;                   or sway for_window/assign
;;
;; floating          floating windows, much less always on top or sticky windows
;;
;; resize            no resize for frames/splits, only :ratio at split time
;;
;; no IPC            sway related tools don't work, check if some of them could be worked
;;                   around, swayidle, swaylock and others
