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

;;;; Split resizing ;;;;;
(defparameter *resize-step* 20
  "Pixels the resize line moves on each key press.")

(defparameter *resize-line-width* 2
  "Half the thickness of the resize line, in pixels.")

(defstruct (resize (:constructor make-resize
                       (frame before after layer style position)))
  frame before after layer style line position)

(defvar *resize* nil
  "The split resize in progress, or NIL.")

(defun split-edge (frame)
  "The two neighbouring children of FRAME's split whose shared edge resizes
FRAME: FRAME and the one after it, or the one before it and FRAME when FRAME
is the last one. NIL when FRAME is not in a split."
  (let ((parent (mahogany/tree:frame-parent frame)))
    (when (typep parent 'mahogany/tree:tree-frame)
      (let* ((children (mahogany/tree:tree-children parent))
             (tail (member frame children)))
        (cond ((cdr tail) (values frame (second tail)))
              ((and tail (cdr children)) (values (car (last children 2)) frame)))))))

(defun split-horizontal-p (frame)
  "Whether FRAME's parent places its children side by side."
  (eq :horizontal (mahogany/tree:tree-split-direction
                   (mahogany/tree:frame-parent frame))))

(defun frame-span (frame horizontal)
  "Where FRAME starts and ends along the split axis."
  (if horizontal
      (let ((x (mahogany/tree:frame-x frame)))
        (values x (+ x (mahogany/tree:frame-width frame))))
      (let ((y (mahogany/tree:frame-y frame)))
        (values y (+ y (mahogany/tree:frame-height frame))))))

(defun set-split-edge (before after position)
  "Move the edge between the neighbouring split children BEFORE and AFTER to
POSITION, keeping their outer edges in place."
  (let* ((horizontal (split-horizontal-p before))
         (start (frame-span before horizontal))
         (end (nth-value 1 (frame-span after horizontal))))
    ;; AFTER moves before it is resized, a split frame scales its children
    ;; from its current position:
    (if horizontal
        (setf (mahogany/tree:frame-width before) (- position start)
              (mahogany/tree:frame-x after) position
              (mahogany/tree:frame-width after) (- end position))
        (setf (mahogany/tree:frame-height before) (- position start)
              (mahogany/tree:frame-y after) position
              (mahogany/tree:frame-height after) (- end position)))))

(defun resize-limits (resize)
  "The lowest and highest positions the edge can move to while both frames
keep the minimum frame size."
  (let ((horizontal (split-horizontal-p (resize-before resize)))
        (minimum mahogany/tree::*minimum-frame-size*))
    (values (+ (frame-span (resize-before resize) horizontal) minimum)
            (- (nth-value 1 (frame-span (resize-after resize) horizontal))
               minimum))))

(defun resize-line-geometry (resize)
  (let ((parent (mahogany/tree:frame-parent (resize-before resize)))
        (position (resize-position resize))
        (width *resize-line-width*))
    (if (split-horizontal-p (resize-before resize))
        (values (- position width) (mahogany/tree:frame-y parent)
                (* 2 width) (mahogany/tree:frame-height parent))
        (values (mahogany/tree:frame-x parent) (- position width)
                (mahogany/tree:frame-width parent) (* 2 width)))))

(defun resize-layer-alive-p (resize)
  "Whether the group holding the line still exists; killing it destroys the line."
  (find (resize-layer resize) (mh::state-groups mh::*compositor-state*)
        :key #'mh::mahogany-group-tiled-container))

(defun resize-valid-p (resize)
  "Whether the focus and the split are still the ones the resize started on."
  (and (resize-layer-alive-p resize)
       (eq (mh::state-current-frame mh::*compositor-state*) (resize-frame resize))
       (multiple-value-bind (before after) (split-edge (resize-frame resize))
         (and (eq before (resize-before resize))
              (eq after (resize-after resize))))))

(defun resize-draw (resize)
  (multiple-value-bind (x y width height) (resize-line-geometry resize)
    (let ((line (resize-line resize)))
      (hrt:hrt-border-box-set-relative line (round x) (round y))
      (hrt:hrt-border-box-set-size line (round width) (round height))
      (hrt:hrt-border-box-raise-to-top line))))

(defun resize-finish ()
  (let ((resize *resize*))
    (setf *resize* nil)
    (split-resize-mode nil)
    (when (and resize (resize-layer-alive-p resize))
      (hrt:hrt-border-box-destroy (resize-line resize)))))

(defun resize-cancel-changed ()
  (resize-finish)
  (error 'mahogany/util:invalid-operation
         :text "The split changed, resize canceled"))

(defun resize-move (delta)
  (alexandria:when-let ((resize *resize*))
    (unless (resize-valid-p resize)
      (resize-cancel-changed))
    (multiple-value-bind (low high) (resize-limits resize)
      (when (<= low high)
        (setf (resize-position resize)
              (alexandria:clamp (+ (resize-position resize) delta)
                                (ceiling low) (floor high)))
        (resize-draw resize)))))

(defun resize-apply ()
  (alexandria:when-let ((resize *resize*))
    (if (resize-valid-p resize)
        (unwind-protect
             (set-split-edge (resize-before resize) (resize-after resize)
                             (resize-position resize))
          (resize-finish))
        (resize-cancel-changed))))

(mh::defcommand resize-split ()
  (:documentation "Move the edge of the focused frame's split with h/j/k/l or
the arrows, Return applies it and Escape cancels")
  (:method ()
    (let ((frame (mh::state-current-frame mh::*compositor-state*)))
      (unless *resize*
        (multiple-value-bind (before after)
            (when (typep frame 'mahogany/tree:view-frame)
              (split-edge frame))
          (unless before
            (error 'mahogany/util:invalid-operation
                   :text "The focused frame is not in a split"))
          (let* ((layer (mahogany/tree:frame-find-layer frame))
                 (style (hrt:border-box-style-create
                         :hrt-border-solid (cl-colors2:as-rgb "#ACE1AF")
                         (float *resize-line-width* 1d0)))
                 (resize (make-resize
                          frame before after layer style
                          (round (nth-value 1 (frame-span
                                               before
                                               (split-horizontal-p before)))))))
            (setf (resize-line resize)
                  (multiple-value-call #'hrt:border-box-create
                    (mahogany/tree:layer-container-layer layer) style
                    (resize-line-geometry resize)))
            (hrt:hrt-border-box-raise-to-top (resize-line resize))
            (setf *resize* resize)
            (split-resize-mode t)))))))

(mh::defcommand resize-split-decrease ()
  (:documentation "Move the resize line left or up")
  (:method () (resize-move (- *resize-step*))))

(mh::defcommand resize-split-increase ()
  (:documentation "Move the resize line right or down")
  (:method () (resize-move *resize-step*)))

(mh::defcommand resize-split-apply ()
  (:documentation "Resize the split to where the line is")
  (:method () (resize-apply)))

(mh::defcommand resize-split-cancel ()
  (:documentation "Stop resizing without changing the split")
  (:method () (resize-finish)))

(defparameter *resize-map*
  (mh:define-kmap
    (mh:kbd "h")      #'resize-split-decrease
    (mh:kbd "k")      #'resize-split-decrease
    (mh:kbd "Left")   #'resize-split-decrease
    (mh:kbd "Up")     #'resize-split-decrease
    (mh:kbd "l")      #'resize-split-increase
    (mh:kbd "j")      #'resize-split-increase
    (mh:kbd "Right")  #'resize-split-increase
    (mh:kbd "Down")   #'resize-split-increase
    (mh:kbd "Return") #'resize-split-apply
    (mh:kbd "Escape") #'resize-split-cancel))

(mh::define-kmap-mode split-resize-mode
  :documentation "Keys that move the line while resizing a split"
  :top-binding *resize-map*)
;;;; Split resizing ;;;;;

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
    (mh:kbd "s-r")      #'resize-split

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
