;;; mymisc.el -*- lexical-binding: t; -*-
;;; Checagens de sistema
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))

;;; Configurações
;; desativa aviso ao usar `dired-find-alternate-file'
(put 'dired-find-alternate-file 'disabled nil)
;; necessário no windows
(set-default-coding-systems 'utf-8)
(setq large-file-warning-threshold 100000000 ; considera 100MB> um arquivo grande
      use-short-answers t ; apenas confirmações com "y" e "n"
      kill-do-not-save-duplicates t ; não salva duplicadas ao copiar
      switch-to-buffer-obey-display-actions t
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
;; Não permite o cursor no minibuffer
(setq minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
;; Ativa minibuffers recursivos
(setq enable-recursive-minibuffers t)
;; Ativa case insensitivity em compleções
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)
;; Desativa quebras de linha quando programando
(add-hook 'prog-mode-hook 'toggle-truncate-lines)
(add-hook 'prog-mode-hook (lambda () (interactive) (visual-line-mode -1)))

;;; Async
(use-package async
  :defer t
  :init (async-bytecomp-package-mode 1)
  :custom (async-bytecomp-allowed-packages '(all)))

;;; Shell
(setq-default explicit-shell-file-name "/bin/sh"
              shell-file-name "/bin/sh")
;; torna arquivos com shebang (#!) executáveis quando salvados
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)

;;; Mover arquivos para pastas apropriadas
(use-package no-littering)
(require 'recentf)
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
(setq bookmark-default-file "~/documentos/bookmarks.el")
;; ativa lembrar arquivos recentes
(add-hook 'after-init-hook #'recentf-mode)
(add-to-list 'recentf-exclude no-littering-var-directory)
(add-to-list 'recentf-exclude no-littering-etc-directory)

;;; Limpa espaços apenas em linhas editadas
(use-package ws-butler
  :init
  (setq whitespace-action nil) ; desativa limpeza de espaços usando `whitespace'
  (ws-butler-global-mode))

;;; Mostra quantidade e índice de palavras procuradas
(use-package anzu
  :init
  (global-anzu-mode +1)
  (setq anzu-deactivate-region t
        anzu-search-threshold 1000
        anzu-replace-threshold 50
        anzu-replace-to-string-separator " => "))
(use-package evil-anzu
  :init (require 'evil-anzu))

;;; Indica todos
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))

;;; Mostra cores `#fff'
(use-package rainbow-mode)

;;; Abre um terminal no diretório atual
(use-package terminal-here
  :config (setq terminal-here-linux-terminal-command (list (getenv "TERMINAL"))))

;;; Folding
;; Folding baseado em comentários
(use-package outshine
  :straight (outshine :type git :host github :repo "alphapapa/outshine")
  :init
  (setq outshine-startup-folded-p t
        outshine-cycle-emulate-tab t)
  :config
  (dolist (face '((outshine-level-1 . 1.2)
                  (outshine-level-2 . 1.1)
                  (outshine-level-3 . 1.0)
                  (outshine-level-4 . 0.9)
                  (outshine-level-5 . 0.9)
                  (outshine-level-6 . 0.9)
                  (outshine-level-7 . 0.9)
                  (outshine-level-8 . 0.9)))
    (set-face-attribute (car face) nil :font "Ubuntu" :weight 'regular :height (cdr face) :background nil)))

;; Folding baseado em indentação
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

;; Ativa folding apropriado dependendo do major-mode
(defun my-folding-modes ()
  "Ativa folding apropriado dependendo do major-mode"
  (cond
   ((and (string= major-mode "emacs-lisp-mode")
         (string-match-p (regexp-quote ".config/emacs/modulos/") buffer-file-name))
    (outshine-mode))
   ((or (string= major-mode "fish-mode") (string= major-mode "sh-mode"))
    (progn (call-interactively #'yafolding-mode)
           (call-interactively #'yafolding-hide-all)))
   ((or (string= major-mode "mhtml-mode") (string= major-mode "html-mode"))
    (hs-minor-mode))
   (t (progn
        (call-interactively #'hs-minor-mode)
        (call-interactively #'hs-hide-all)))))
(add-hook 'prog-mode-hook 'my-folding-modes)

;;; Indentação
(use-package aggressive-indent
  :init (global-aggressive-indent-mode))

(defun normalizar-buffer ()
  "Organiza o buffer, formata espaço e tabs e conserta indentação."
  (interactive)
  (save-excursion
    (delete-trailing-whitespace)
    (untabify (point-min) (point-max))
    (indent-region (point-min) (point-max))))

;;; Ajuda
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

;;; Trocar de buffer
(defun buffers-outros ()
  "Navega por buffers cujo o nome não começa com uma letra."
  (interactive)
  (pop-to-buffer-same-window (completing-read ">" (mapcar #'buffer-name (buffer-list)) nil nil "^[^A-z] ")))

(defun buffers-arquivo ()
  "Navega por buffers cujo o nome começa com uma letra."
  (interactive)
  (pop-to-buffer-same-window (completing-read ">" (mapcar #'buffer-name (buffer-list)) nil nil "^[A-z] ")))

(provide 'mymisc)
;;; mymisc.el ends here
