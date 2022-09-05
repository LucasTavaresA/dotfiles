;;; irc.el -*- lexical-binding: t; -*-
;;; módulos
(toggle-debug-on-error)
(load-file (expand-file-name "early-init.el" user-emacs-directory))

;;;; prefere versões mais recentes de pacotes
(setq load-prefer-newer t)

;;;; adiciona pasta módulos ao load-path
(add-to-list 'load-path (expand-file-name "modulos/" user-emacs-directory))

;;;; carrega módulos
(require 'mystraight)
(require 'mylooks)
(require 'myedit)
(require 'mymisc)
(require 'mycompletion)
(require 'myspell)

;;; Teclas
;;;; SPC
(defalias 'spc-map (make-sparse-keymap))
(defvar spc-map (symbol-function 'spc-map))
(define-key spc-map (kbd "SPC") 'consult-buffer)
(define-key spc-map (kbd "d") 'consult-dir)
(define-key spc-map (kbd "k") 'kill-current-buffer)
(define-key spc-map (kbd "K") 'kill-some-buffers)
(define-key spc-map (kbd "l") 'inserir-link)
(define-key spc-map (kbd "u") 'undo-tree-visualize)
(define-key spc-map (kbd ";") 'eval-expression)
(define-key spc-map (kbd "RET") 'terminal-here)
(define-key spc-map (kbd "<up>") 'windmove-up)
(define-key spc-map (kbd "<down>") 'windmove-down)
(define-key spc-map (kbd "<left>") 'windmove-left)
(define-key spc-map (kbd "<right>") 'windmove-right)
(define-key spc-map (kbd "<next>") #'flymake-goto-next-error)
(define-key spc-map (kbd "<prior>") #'flymake-goto-prev-error)
(define-key spc-map (kbd "b c") 'copiar-buffer)
(define-key spc-map (kbd "b b") 'consult-bookmark)
(define-key spc-map (kbd "b m") 'bookmark-set)
(define-key spc-map (kbd "b d") 'bookmark-delete)
(define-key spc-map (kbd "f b") 'flyspell-buffer)
(define-key spc-map (kbd "f F") 'find-file)
(define-key spc-map (kbd "f f") 'consult-recent-file)
(define-key spc-map (kbd "i i") 'aggressive-indent-indent-defun)
(define-key spc-map (kbd "s l") 'consult-locate)
(define-key spc-map (kbd "s f") 'consult-flymake)
(define-key spc-map (kbd "s s") 'consult-focus-lines)
(define-key spc-map (kbd "s g") 'consult-git-grep)
(define-key spc-map (kbd "s G") 'consult-grep)
(define-key spc-map (kbd "v v") 'consult-imenu)
(define-key spc-map (kbd "v V") 'ver-headings)
(define-key spc-map (kbd "w w") 'save-buffer)
(define-key spc-map (kbd "w q") 'evil-save-and-quit)
(define-key spc-map (kbd "q q") 'evil-quit)
;;;; SPC h
(defalias 'h-map (make-sparse-keymap))
(defvar h-map (symbol-function 'h-map))
(define-key spc-map (kbd "h") 'h-map)
(define-key h-map (kbd "a") 'consult-apropos)
(define-key h-map (kbd "b") 'describe-bindings)
(define-key h-map (kbd "M") 'consult-man)
(define-key h-map (kbd "m") 'describe-mode)
(define-key h-map (kbd "K") 'describe-keymap)
(define-key h-map (kbd "k") 'describe-key)
(define-key h-map (kbd "v") 'describe-variable)
(define-key h-map (kbd "f") 'describe-function)
(define-key h-map (kbd "F") 'describe-face)
(define-key h-map (kbd "c") 'describe-command)
(define-key h-map (kbd "p") 'describe-package)
;;;; SPC e
(defalias 'e-map (make-sparse-keymap))
(defvar e-map (symbol-function 'e-map))
(define-key spc-map (kbd "e") 'e-map)
(define-key e-map (kbd "t") (lambda () (interactive) (find-file "~/.config/emacs/etc/templates")))
(define-key e-map (kbd "e") 'eval-defun)
(define-key e-map (kbd "b") 'aval-buffer)
(define-key e-map (kbd "r") 'aval-region)
;;;; evil-insert-state-map
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;;;; evil-motion-state-map
(define-key evil-motion-state-map (kbd "SPC") 'spc-map)
(define-key evil-motion-state-map "?" (lambda () (interactive) (evil-ex-search-word-forward nil (thing-at-point 'symbol))))
(define-key evil-motion-state-map "|" (lambda () (interactive) (consult-line (thing-at-point 'symbol))))
(define-key evil-motion-state-map (kbd "C-M-i") 'completion-at-point)
(define-key evil-motion-state-map (kbd "K") 'helpful-at-point)
(define-key evil-motion-state-map (kbd "M") 'evil-record-macro)
;;;; evil-normal-state-map
(define-key evil-normal-state-map (kbd "C-.") #'flyspell-correct-wrapper)
(define-key evil-normal-state-map (kbd "m") 'evil-execute-macro)
(define-key evil-normal-state-map (kbd "p") 'evil-colar)
(define-key evil-normal-state-map (kbd "P") 'evil-collection-unimpaired-paste-below)
(define-key evil-normal-state-map "\\" 'consult-line)
(define-key evil-normal-state-map (kbd "q") nil)
;;;; toggles
(define-key evil-normal-state-map (kbd "z n") (lambda () (interactive) (if display-line-numbers (setq display-line-numbers nil)
                                                                    (setq display-line-numbers t))))
(define-key evil-normal-state-map (kbd "z v") 'visible-mode)
(define-key evil-normal-state-map (kbd "z l") 'log/toggle-command-window)
(define-key evil-normal-state-map (kbd "z t") 'toggle-truncate-lines)
(define-key evil-normal-state-map (kbd "z h") 'hl-line-mode)
(define-key evil-normal-state-map (kbd "z s") 'flyspell-mode)
;;;; minibuffer-local-map
(define-key minibuffer-local-map (kbd "C-<tab>") #'vertico-next)
(define-key minibuffer-local-map (kbd "<backtab>") #'vertico-previous)
;;;; minibuffer-local-completion-map
(define-key minibuffer-local-map (kbd "C-.") 'consult-dir-jump-file)
;;;; Vertico-mode-map
(define-key vertico-map "?" #'minibuffer-completion-help)
(define-key vertico-map (kbd "RET") #'vertico-directory-enter)
(define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
;;;; corfu-map
(define-key corfu-map (kbd "TAB") 'corfu-next)
(define-key corfu-map (kbd "<tab>") 'corfu-next)
(define-key corfu-map (kbd "C-M-i") 'corfu-next)
(define-key corfu-map (kbd "S-TAB") 'corfu-previous)
(define-key corfu-map (kbd "<backtab>") 'corfu-previous)
(define-key corfu-map (kbd "<up>") 'evil-previous-line)
(define-key corfu-map (kbd "<down>") 'evil-next-line)
;;;; global
(global-set-key (kbd "C-<tab>") #'buffers-mesmo-modo)
(global-set-key (kbd "C-s") 'evil-mc-make-all-cursors)
(global-set-key (kbd "M-c") 'evil-yank)
(global-set-key (kbd "M-v") 'evil-colar)
(global-set-key (kbd "M-e") 'tempel-expand)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") 'text-scale-adjust)
(global-set-key (kbd "<C-S-down>") 'evil-mc-make-and-goto-next-match)
(global-set-key (kbd "<C-down>") 'evil-mc-skip-and-goto-next-match)
(global-set-key (kbd "<C-S-up>") 'evil-mc-make-and-goto-prev-match)
(global-set-key (kbd "<C-up>") 'evil-mc-skip-and-goto-prev-match)
(global-set-key (kbd "<S-up>") 'er/expand-region)
(global-set-key (kbd "<S-down>") 'er/contract-region)
(global-set-key (kbd "<C-M-right>") 'evil-window-vsplit)
(global-set-key (kbd "<C-M-down>") 'evil-window-split)
(global-set-key (kbd "<M-up>") 'drag-stuff-up)
(global-set-key (kbd "<M-down>") 'drag-stuff-down)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

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
