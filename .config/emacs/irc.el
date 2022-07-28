;;; irc.el --- Emacs como um cliente irc -*- lexical-binding: t; -*-
(load-file "~/.config/emacs/early-init.el")
(toggle-debug-on-error)

;;; Pacotes
;; prefere versões mais recentes de pacotes
(setq load-prefer-newer t)

;; carrega o straight
(load-file "~/.config/emacs/modulos/mystraight.el")

;;; Aparência
;; tamanho das fringes
(set-fringe-mode 5)

;; divisórias
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(set-face-attribute 'window-divider nil :foreground "#fff")
(window-divider-mode 1)

;; informações no minibuffer
(use-package awesome-tray
  :straight (awesome-tray :type git :host github :repo "manateelazycat/awesome-tray")
  :init
  (setq awesome-tray-info-padding-right 1
        awesome-tray-separator "  "
        awesome-tray-essential-modules '("circe" "evil")
        awesome-tray-active-modules    '("circe" "evil" "buffer-name"))
  (awesome-tray-mode))

;; esconde a mode-line
(use-package hide-mode-line
  :init (global-hide-mode-line-mode))

;; tema
(load-theme 'modus-vivendi t)
(set-face-attribute 'default nil :background "#000")
(set-face-attribute 'region nil :background "#00f")

;; fontes
(set-face-attribute 'default nil :family "Terminus" :height 140)
(set-face-attribute 'variable-pitch nil :family "Ubuntu" :weight 'light)
(set-face-attribute 'font-lock-string-face nil :foreground "#ffff00")
(set-face-attribute 'font-lock-comment-face nil :family "SauceCodePro Nerd Font Mono"
                    :slant 'italic :height 130 :foreground "#009900")

;; indica buffers sem foco
(use-package auto-dim-other-buffers
  :init (auto-dim-other-buffers-mode)
  (set-face-attribute 'auto-dim-other-buffers-face nil :background "#080808"))

;;; Teclas
(use-package evil
  :init
  (setq-default evil-cross-lines t ; da a volta para a proxima linha
                ;; tabs > espaços
                tab-width 4
                evil-shift-width tab-width
                indent-tabs-mode nil)
  (setq evil-respect-visual-line-mode t
        evil-undo-system 'undo-tree
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

;; teclas evil para vários modos
(use-package evil-collection
  :after (evil)
  :init (evil-collection-init)
  (setq forge-add-default-bindings nil))

;;; Correção ortográfica
(load-file "~/.config/emacs/modulos/myspell.el")

;;; Miscelânea
(setq large-file-warning-threshold 100000000 ; considera 100MB> um arquivo grande
      use-short-answers t ; apenas confirmações com "y" e "n"
      kill-do-not-save-duplicates t ; não salva duplicadas ao copiar
      user-full-name "Lucas Tavares"
      user-mail-address "tavares.lassuncao@gmail.com"
      ;; scroll
      auto-window-vscroll nil ; diminui o stuttering do scroll
      fast-but-imprecise-scrolling t ; scroll mais rápido
      scroll-margin 10 ; distancia de onde o scroll começa
      scroll-conservatively 101 ; tolerância para centralizar cursor
      scroll-preserve-screen-position t
      ;; desativa barra piscando
      visible-bell       nil
      ring-bell-function #'ignore)

(global-so-long-mode 1) ; melhora suporte para arquivos com linhas longas
(global-visual-line-mode +1) ; quebra parágrafos de acordo com as palavras
(electric-pair-mode 1) ; auto-inserir "{}()[]"
(show-paren-mode 1) ; indica parenteses

;; Não permite o cursor no minibuffer
(setq minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;; Ativa minibuffers recursivos
(setq enable-recursive-minibuffers t)

;; Ativa case insensitivity em compleções
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; shell
(setq-default explicit-shell-file-name "/bin/sh"
              shell-file-name "/bin/sh")

;; Mover arquivos para pastas apropriadas
(use-package no-littering)
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
(setq bookmark-default-file "~/documentos/bookmarks.el")

(use-package vertico
  :init (vertico-mode))

;;; Teclas
;; SPC
(defalias 'spc-map (make-sparse-keymap))
(defvar spc-map (symbol-function 'spc-map))
(define-key spc-map (kbd "SPC") 'switch-to-buffer)
(define-key spc-map (kbd "k") 'kill-current-buffer)
(define-key spc-map (kbd "K") 'kill-some-buffers)
(define-key spc-map (kbd "l") 'inserir-link)
(define-key spc-map (kbd ";") 'eval-expression)
(define-key spc-map (kbd "<up>") 'windmove-up)
(define-key spc-map (kbd "<down>") 'windmove-down)
(define-key spc-map (kbd "<left>") 'windmove-left)
(define-key spc-map (kbd "<right>") 'windmove-right)
(define-key spc-map (kbd "<next>") #'flymake-goto-next-error)
(define-key spc-map (kbd "<prior>") #'flymake-goto-prev-error)
(define-key spc-map (kbd "b b") 'bookmark-jump)
(define-key spc-map (kbd "b m") 'bookmark-set)
(define-key spc-map (kbd "b d") 'bookmark-delete)
(define-key spc-map (kbd "f b") 'flyspell-buffer)
(define-key spc-map (kbd "f f") 'find-file)
(define-key spc-map (kbd "w w") 'save-buffer)
(define-key spc-map (kbd "w q") 'evil-save-and-quit)
(define-key spc-map (kbd "q q") 'evil-quit)
;; SPC h
(defalias 'h-map (make-sparse-keymap))
(defvar h-map (symbol-function 'h-map))
(define-key spc-map (kbd "h") 'h-map)
(define-key h-map (kbd "b") 'describe-bindings)
(define-key h-map (kbd "m") 'describe-mode)
(define-key h-map (kbd "K") 'describe-keymap)
(define-key h-map (kbd "k") 'describe-key)
(define-key h-map (kbd "v") 'describe-variable)
(define-key h-map (kbd "f") 'describe-function)
(define-key h-map (kbd "F") 'describe-face)
(define-key h-map (kbd "c") 'describe-command)
(define-key h-map (kbd "p") 'describe-package)
;; SPC e
(defalias 'e-map (make-sparse-keymap))
(defvar e-map (symbol-function 'e-map))
(define-key spc-map (kbd "e") 'e-map)
(define-key e-map (kbd "e") 'eval-defun)
;; evil-insert-state-map
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;; evil-motion-state-map
(define-key evil-motion-state-map (kbd "SPC") 'spc-map)
(define-key evil-motion-state-map "?" (lambda () (interactive) (evil-ex-search-word-forward nil (thing-at-point 'symbol))))
(define-key evil-motion-state-map (kbd "C-M-i") 'completion-at-point)
(define-key evil-motion-state-map (kbd "M") 'evil-record-macro)
;; evil-normal-state-map
(define-key evil-normal-state-map (kbd "C-.") #'flyspell-correct-wrapper)
(define-key evil-normal-state-map (kbd "m") 'evil-execute-macro)
(define-key evil-normal-state-map (kbd "p") 'evil-colar)
(define-key evil-normal-state-map (kbd "P") 'evil-collection-unimpaired-paste-below)
(define-key evil-normal-state-map (kbd "q") nil)
;; toggles
(define-key evil-normal-state-map (kbd "z n") (lambda () (interactive) (if display-line-numbers (setq display-line-numbers nil)
                                                                    (setq display-line-numbers t))))
(define-key evil-normal-state-map (kbd "z t") 'toggle-truncate-lines)
(define-key evil-normal-state-map (kbd "z h") 'hl-line-mode)
(define-key evil-normal-state-map (kbd "z s") 'flyspell-mode)
(define-key evil-normal-state-map (kbd "z r") 'rainbow-mode)
(define-key evil-motion-state-map (kbd "z x") 'marcar-checkbox)
(define-key evil-normal-state-map (kbd "z z") 'evil-toggle-fold)
(define-key evil-normal-state-map (kbd "Z Z") 'evil-scroll-line-to-center)
;; dired-mode-map
(define-key dired-mode-map (kbd "SPC") 'spc-map)
(define-key dired-mode-map (kbd "<normal-state> SPC") 'spc-map)
;; minibuffer-local-map
(define-key minibuffer-local-map (kbd "C-<tab>") #'vertico-next)
(define-key minibuffer-local-map (kbd "<backtab>") #'vertico-previous)
;; Vertico-mode-map
(define-key vertico-map "?" #'minibuffer-completion-help)
;; global
(fset 'comentar-e-descer-linha
      (kmacro-lambda-form [?, ?c ?i down] 0 "%d"))
(global-set-key (kbd "C-c C-c") 'comentar-e-descer-linha)
(global-set-key (kbd "M-c") 'evil-yank)
(global-set-key (kbd "M-v") 'evil-colar)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") 'text-scale-adjust)
(global-set-key (kbd "<C-M-right>") 'evil-window-vsplit)
(global-set-key (kbd "<C-M-down>") 'evil-window-split)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;;; Circe
(load-file (expand-file-name "~/.gnupg/private.el"))

(defun irc ()
          "Abre todos os servers IRC"
          (interactive)
          (circe "Libera Chat")
          (circe "OFTC"))

(use-package circe
  :init
  (setq circe-reduce-lurker-spam t
        circe-format-server-topic "*** Topic change by {userhost}: {topic-diff}"
        circe-split-line-length 800
        lui-flyspell-p t
        lui-flyspell-alist '((".*" "american" "pt_BR"))
        lui-logging-directory (concat user-emacs-directory "circelogs")
        lui-time-stamp-position 'right-margin
        lui-time-stamp-format "%H:%M"
        lui-prompt ">"
        lui-track-bar-behavior 'before-switch-to-buffer
        circe-format-say "{nick:-8s}>{body}"
        circe-format-self-say "({nick})>{body}"
        circe-network-options
        `(("Libera Chat"
           :nick "lucasta"
           :sasl-username "lucasta"
           :sasl-password ,libera-password
           :channels ("#emacs" "#herbstluftwm" "#qutebrowser" "#stumpwm" "#git"
                      "#systemcrafters" "#suckless" "#qbittorrent" "#artix" "#archlinux"))
          ("OFTC"
           :nick "lucasta"
           :channels ("#suckless"))
          ))
  (load "lui-logging" nil t)
  (enable-circe-color-nicks)
  (enable-circe-display-images)
  (enable-lui-logging-globally)
  (enable-lui-track-bar))

;; comentários de bots em cinza
(defvar my-circe-bot-list '("fsbot" "rudybot"))
(defun my-circe-message-option-bot (nick &rest ignored)
  (when (member nick my-circe-bot-list)
    '((text-properties . (face circe-fool-face
                               lui-do-not-track t)))))
(add-hook 'circe-message-option-functions 'my-circe-message-option-bot)

(add-hook 'lui-mode-hook 'my-circe-set-margin)
(defun my-circe-set-margin ()
  (setq right-margin-width 5)
  (setq left-margin-width 25))

(irc)

;;; Coleta de lixo
(use-package gcmh
  :init (gcmh-mode))

(setq gc-cons-threshold (* 2 1000 1000))
