;;; mymisc.el -*- lexical-binding: t; -*-
;;; checagens de sistema
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))

;;; configurações
;; desativa aviso ao usar `dired-find-alternate-file'
(put 'dired-find-alternate-file 'disabled nil)
;; necessário no windows
(set-default-coding-systems 'utf-8)
(setq large-file-warning-threshold 100000000 ; considera 100MB> um arquivo grande
      use-short-answers t ; apenas confirmações com "y" e "n"
      kill-do-not-save-duplicates t ; não salva duplicadas ao copiar
      switch-to-buffer-obey-display-actions t
      help-window-select t
      cursor-in-non-selected-windows nil
      visible-cursor nil
      auth-sources '("~/.gnupg/authinfo")
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
;; reverte buffer caso haja mudanças externas no arquivo
(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode 1)
;; salva posição nos arquivos
(save-place-mode 1)
;; salva histórico de comandos
(savehist-mode 1)
(global-so-long-mode 1) ; melhora suporte para arquivos com linhas longas
(global-visual-line-mode +1) ; quebra parágrafos de acordo com as palavras
(electric-pair-mode 1) ; auto-inserir "{}()[]"
(show-paren-mode 1) ; indica parenteses
;; não permite o cursor no minibuffer
(setq minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
;; ativa minibuffers recursivos
(setq enable-recursive-minibuffers t)
;; ativa case insensitivity em compleções
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)
;; desativa quebras de linha quando programando
(add-hook 'prog-mode-hook 'toggle-truncate-lines)
(add-hook 'prog-mode-hook (lambda () (interactive) (visual-line-mode -1)))
;; cursor não pisca
(blink-cursor-mode -1)
;; nomeia os buffers apropriadamente
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward
      uniquify-trailing-separator-p t)
;; sai mais facilmente com o ESC
(setq buffer-quit-function (lambda () t))

;;; async
(use-package async
  :defer t
  :init (async-bytecomp-package-mode 1)
  :custom (async-bytecomp-allowed-packages '(all)))

;;; shell
(setq-default explicit-shell-file-name "/bin/sh"
              shell-file-name "/bin/sh")
;; torna arquivos com shebang (#!) executáveis quando salvados
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)

;;; mover arquivos para pastas apropriadas
(use-package no-littering)
(require 'recentf)
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
(setq bookmark-default-file "~/documentos/bookmarks.el")
;; ativa lembrar arquivos recentes
(add-hook 'after-init-hook #'recentf-mode)
(add-to-list 'recentf-exclude no-littering-var-directory)
(add-to-list 'recentf-exclude no-littering-etc-directory)

;;; limpa espaços apenas em linhas editadas
(use-package ws-butler
  :init
  (setq whitespace-action nil) ; desativa limpeza de espaços usando `whitespace'
  (ws-butler-global-mode))

;;; mostra quantidade e índice de palavras procuradas
(use-package anzu
  :init
  (global-anzu-mode +1)
  (setq anzu-deactivate-region t
        anzu-search-threshold 1000
        anzu-replace-threshold 50
        anzu-replace-to-string-separator " => "))
(use-package evil-anzu
  :init (require 'evil-anzu))

;;; indica todos
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))

;;; mostra cores `#fff'
(use-package rainbow-mode)

;;; abre um terminal no diretório atual
(use-package terminal-here
  :config (setq terminal-here-linux-terminal-command (list (getenv "TERMINAL"))))

;;; folding
;;;; folding baseado em comentários
(use-package outli
  :straight (outli :type git :host github :repo "jdtsmith/outli")
  :init (setq outli-blend nil))

;;;; folding baseado em indentação
(use-package yafolding
  :straight (yafolding :type git :host github :repo "lucastavaresa/yafolding.el")
  :config
  (add-to-list 'evil-fold-list
               `((yafolding-mode)
                 :open-all   yafolding-show-all
                 :close-all  yafolding-close-all
                 :toggle     yafolding-toggle-element-dwim
                 :open       yafolding-show-element-dwim
                 :open-rec   nil
                 :close      yafolding-hide-element-dwim)))

;;;; ativa folding apropriado dependendo do major-mode
(defun my-folding-modes ()
  "Ativa folding apropriado dependendo do major-mode"
  (cond
   ((and (string= major-mode "emacs-lisp-mode")
         (string-match-p (regexp-quote ".config/emacs/modulos/") buffer-file-name))
    (progn (call-interactively #'outli-mode)
           (call-interactively #'outline-hide-body)))
   ((or (string= major-mode "fish-mode") (string= major-mode "sh-mode"))
    (progn (call-interactively #'yafolding-mode)
           (call-interactively #'yafolding-hide-all)))
   ((or (string= major-mode "mhtml-mode") (string= major-mode "html-mode"))
    (hs-minor-mode))
   (t (progn
        (call-interactively #'hs-minor-mode)
        (call-interactively #'hs-hide-all)))))
(add-hook 'prog-mode-hook 'my-folding-modes)

;;; indentação
(use-package aggressive-indent
  :config (global-aggressive-indent-mode))

(defun normalizar-buffer ()
  "Organiza o buffer, formata espaço e tabs e conserta indentação."
  (interactive)
  (save-excursion
    (delete-trailing-whitespace)
    (untabify (point-min) (point-max))
    (indent-region (point-min) (point-max))))

;;; ajuda
;; melhora `gd' para ir a definições de código
(use-package dumb-jump)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)

;; melhora buffers de ajuda
(use-package helpful
  :config
  (setq helpful-switch-buffer-function #'pop-to-buffer-same-window)
  (define-key helpful-mode-map [remap revert-buffer] #'helpful-update)
  (global-set-key [remap describe-command] #'helpful-command)
  (global-set-key [remap describe-function] #'helpful-callable)
  (global-set-key [remap describe-key] #'helpful-key)
  (global-set-key [remap describe-symbol] #'helpful-symbol)
  (global-set-key [remap describe-variable] #'helpful-variable))

;; mostra código em buffers de ajuda
(use-package elisp-demos
  :config (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

;;;; eldoc
(require 'eldoc)
(setq eldoc-mode-line-string nil
      eldoc-echo-area-use-multiline-p t
      eldoc-echo-area-prefer-doc-buffer nil
      eldoc-display-functions '(eldoc-display-in-echo-area))
(global-eldoc-mode 1)

;;; trocar de buffer
(defun buffers-outros ()
  "Navega por buffers cujo o nome não começa com uma letra."
  (interactive)
  (pop-to-buffer-same-window (completing-read ">" (mapcar #'buffer-name (buffer-list)) nil nil "^[^A-z] ")))

(defun buffers-arquivo ()
  "Navega por buffers cujo o nome começa com uma letra."
  (interactive)
  (pop-to-buffer-same-window (completing-read ">" (mapcar #'buffer-name (buffer-list)) nil nil "^[A-z] ")))

(provide 'mymisc)
;;; templates
(use-package tempel
  :init
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)
  :config (setq tempel-path "/home/lucas/.config/emacs/etc/templates"))

;;; expande região selecionada
(use-package expand-region)

;;; move linhas
(use-package move-text)

;;; pula para palavras
(use-package avy)

;;; desfazer com timeline
(use-package undo-tree
  :after (evil)
  :init (global-undo-tree-mode)
  :config (setq undo-tree-auto-save-history nil))

;;; funções
(defun copiar-buffer ()
  "Copia todo o buffer"
  (interactive)
  (clipboard-kill-ring-save (point-min) (point-max)))

;;; mymisc.el ends here
