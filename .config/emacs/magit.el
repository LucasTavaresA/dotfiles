;;; magit.el -*- lexical-binding: t; -*-
(toggle-debug-on-error)
;;; early-init
(load-file (expand-file-name "early-init.el" user-emacs-directory))

;;; straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; instala use-package
(straight-use-package 'use-package)
;; usa :straight t por padrão
(setq straight-use-package-by-default t)

;;; aparência
;; tamanho das fringes
(set-fringe-mode 10)
;; divisórias entre frames
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(set-face-attribute 'window-divider nil :foreground "#fff")
(window-divider-mode 1)

;;;; tema
(load-theme 'misterioso t)
(set-face-attribute 'default nil :family "Terminus" :height 140)
(set-face-attribute 'default nil :background "#000")
(set-face-attribute 'fringe nil :background "#000")
(set-face-attribute 'region nil :background "#00f")

;;; evil
(use-package evil
  :init
  (setq-default evil-cross-lines t ; da a volta para a proxima linha
                ;; tabs > espaços
                tab-width 4
                evil-shift-width tab-width
                indent-tabs-mode nil)
  (setq evil-respect-visual-line-mode t
        evil-undo-system 'undo-redo
        evil-split-window-below t  ; foca em novas splits
        evil-vsplit-window-right t
        evil-want-Y-yank-to-eol t
        evil-want-fine-undo t      ; desfazer em passos menores
        evil-want-keybinding nil   ; desabilitado em prol do evil-collection
        ;; formato e cor do cursor em diferentes modos
        evil-emacs-state-cursor    '("#ffff00" box)
        evil-normal-state-cursor   '("#ffffff" box)
        evil-operator-state-cursor '("#ebcb8b" hollow)
        evil-visual-state-cursor   '("#ffffff" box)
        evil-insert-state-cursor   '("#ffffff" (bar . 2))
        evil-replace-state-cursor  '("#ff0000" box)
        evil-motion-state-cursor   '("#ad8beb" box))
  (evil-mode 1)
  :config (evil-select-search-module 'evil-search-module 'evil-search))

;;;; funções
(defun evil-colar ()
  "Chama `evil-paste-after' porem inverte `evil-kill-on-visual-paste'.

isso cola o item sem copiar texto selecionado, tambem cola antes do cursor no modo de inserção."
  (interactive)
  (let ((evil-kill-on-visual-paste (not evil-kill-on-visual-paste)))
    (if (evil-insert-state-p)
        (call-interactively #'evil-paste-before)
      (call-interactively #'evil-paste-after))))

;;;; compleção
(fido-vertical-mode)

;;; teclas
;;;; SPC
(defalias 'spc-map (make-sparse-keymap))
(defvar spc-map (symbol-function 'spc-map))
(define-key spc-map (kbd "SPC") 'switch-to-buffer)
(define-key spc-map (kbd "g g") 'magit)
(define-key spc-map (kbd "k") 'kill-current-buffer)
(define-key spc-map (kbd "K") 'kill-some-buffers)
(define-key spc-map (kbd "<up>") 'windmove-up)
(define-key spc-map (kbd "<down>") 'windmove-down)
(define-key spc-map (kbd "<left>") 'windmove-left)
(define-key spc-map (kbd "<right>") 'windmove-right)
(define-key spc-map (kbd "w w") 'save-buffer)
(define-key spc-map (kbd "w q") 'evil-save-and-quit)
(define-key spc-map (kbd "q q") 'evil-quit)
;;;; SPC h
(defalias 'h-map (make-sparse-keymap))
(defvar h-map (symbol-function 'h-map))
(define-key spc-map (kbd "h") 'h-map)
(define-key h-map (kbd "a") 'apropos)
(define-key h-map (kbd "b") 'describe-bindings)
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
(define-key e-map (kbd "e") 'eval-defun)
(define-key e-map (kbd "r") 'eval-region)
;;; evil-insert-state-map
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;;; evil-motion-state-map
(define-key evil-motion-state-map (kbd "SPC") 'spc-map)
(define-key evil-motion-state-map "?" (lambda () (interactive) (evil-ex-search-word-forward nil (thing-at-point 'symbol))))
(define-key evil-motion-state-map (kbd "C-M-i") 'completion-at-point)
(define-key evil-motion-state-map (kbd "M") 'evil-record-macro)
;;; evil-normal-state-map
(define-key evil-normal-state-map (kbd "C-.") #'flyspell-correct-wrapper)
(define-key evil-normal-state-map (kbd "m") 'evil-execute-macro)
(define-key evil-normal-state-map (kbd "p") 'evil-colar)
(define-key evil-normal-state-map (kbd "P") 'evil-collection-unimpaired-paste-below)
(define-key evil-normal-state-map (kbd "z a") nil)
(define-key evil-normal-state-map (kbd "q") nil)
;;; toggles
(define-key evil-normal-state-map (kbd "z n") (lambda () (interactive) (if display-line-numbers (setq display-line-numbers nil)
                                                                        (setq display-line-numbers t))))
(define-key evil-normal-state-map (kbd "z v") 'visible-mode)
(define-key evil-normal-state-map (kbd "z t") 'toggle-truncate-lines)
(define-key evil-normal-state-map (kbd "z h") 'hl-line-mode)
(define-key evil-normal-state-map (kbd "z s") 'flyspell-mode)
(define-key evil-motion-state-map (kbd "z z") 'evil-toggle-fold)
(define-key evil-normal-state-map (kbd "Z Z") 'evil-scroll-line-to-center)
;;; minibuffer-local-map
(define-key minibuffer-local-map (kbd "C-<tab>") #'icomplete-forward-completions)
(define-key minibuffer-local-map (kbd "<backtab>") #'icomplete-backward-completions)
;;; global
(global-set-key (kbd "C-<tab>") 'switch-to-buffer)
(global-set-key (kbd "C-S-c") 'evil-yank)
(global-set-key (kbd "C-S-v") 'evil-colar)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") 'text-scale-adjust)
(global-set-key (kbd "<C-M-right>") 'evil-window-vsplit)
(global-set-key (kbd "<C-M-down>") 'evil-window-split)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;;; módulos do emacs
(add-to-list 'load-path (expand-file-name "modulos/" user-emacs-directory))
(require 'mygit)
(require 'mymisc)
(require 'myspell)
(require 'myevil)

;;;; Acelerar a coleta de lixo
(use-package gcmh
  :init (gcmh-mode))

;;;; Aumenta pausas para coleta de lixo
(setq gc-cons-threshold (* 2 1000 1000))

;;; magit.el ends here
