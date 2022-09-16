;;; irc.el -*- lexical-binding: t; -*-
(toggle-debug-on-error)
;;; early-init
(load-file (expand-file-name "early-init.el" user-emacs-directory))

;;; módulos do emacs
(add-to-list 'load-path (expand-file-name "modulos/" user-emacs-directory))
(require 'mystraight)
(require 'mylooks)
(require 'myedit)
(require 'mymisc)
(require 'mygit)
(require 'mycompletion)
(require 'myspell)
(require 'mykeys)

;;; Circe
(load-file (expand-file-name "private.el" (getenv "GNUPGHOME")))

(use-package circe
  :init
  (setq circe-reduce-lurker-spam t
        circe-format-server-topic "*** Mudança de topico por {userhost}: {topic-diff}"
        circe-split-line-length 880
        lui-flyspell-p t
        lui-flyspell-alist '((".*" "american" "pt_BR"))
        lui-logging-directory (concat user-emacs-directory "var/circelogs")
        lui-time-stamp-position 'right-margin
        lui-time-stamp-format "%H:%M"
        lui-track-bar-behavior 'before-switch-to-buffer
        tracking-ignored-buffers '("#emacs-circe" "#archlinux" "#artix" "#voidlinux"
                                   "#sway" "#freebsd" "#lineageos" "#git" "#qbittorrent")
        circe-format-say "<{nick}> {body}"
        circe-format-self-say ">{nick}< {body}"
        circe-network-options
        `(("Libera Chat"
           :nick "lucasta"
           :sasl-username "lucasta"
           :sasl-password ,libera-password
           :channels ("#lucasta" "#sway" "#emacs" "#emacs-circe" "#herbstluftwm" "#qutebrowser" "#stumpwm" "#git"
                      "#lineageos" "#systemcrafters" "#qbittorrent" "#voidlinux" "#freebsd" "#artix" "#archlinux"))))
  (load "lui-logging" nil t)
  (enable-circe-color-nicks)
  (enable-circe-display-images)
  (enable-lui-logging-globally)
  (enable-lui-track-bar))

;;;; Prompt
(defun my-circe-prompt ()
  (lui-set-prompt
   (concat (propertize (concat (buffer-name) ">")
                       'face 'circe-prompt-face)
           " ")))
(add-hook 'circe-chat-mode-hook 'my-circe-prompt)

;;;; comentários de bots em cinza
(defvar my-circe-bot-list '("fsbot" "rudybot" "judybot"))
(defun my-circe-message-option-bot (nick &rest ignored)
  (when (member nick my-circe-bot-list)
    '((text-properties . (face circe-fool-face
                               lui-do-not-track t)))))
(add-hook 'circe-message-option-functions 'my-circe-message-option-bot)

;;;; Margens
(defun my-circe-set-margin ()
  (setq right-margin-width 5)
  (setq left-margin-width 25))
(add-hook 'lui-mode-hook 'my-circe-set-margin)

;;;; Notificações
(use-package circe-notifications)

(autoload 'enable-circe-notifications "circe-notifications" nil t)

(eval-after-load "circe-notifications"
  '(setq circe-notifications-watch-strings
         '("lucasta")))

(add-hook 'circe-server-connected-hook 'enable-circe-notifications)

;;;; Abre os canais
(circe "Libera Chat")

;;; Emacs
;;;; Acelerar a coleta de lixo
(use-package gcmh
  :init (gcmh-mode))

;;;; Aumenta pausas para coleta de lixo
(setq gc-cons-threshold (* 2 1000 1000))

;;; myirc.el ends here
