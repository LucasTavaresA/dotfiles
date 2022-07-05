;;; config.el --- My rational-emacs config -*- lexical-binding: t; -*-
;;; Ativa debug em erros
(toggle-debug-on-error)

;;; Straight
;; boostrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; substitui macro do package.el
(defmacro rational-package-install-package (package)
  "Install PACKAGE using straight"
  `(straight-use-package ,package))
;; instala use-package
(straight-use-package 'use-package)

;; Modulos
(require 'rational-defaults)
(require 'rational-editing)
(with-eval-after-load 'evil
  (evil-select-search-module 'evil-search-module 'evil-search)
  (setq-default evil-cross-lines t ; da a volta para a proxima linha
                tab-width 4
                evil-shift-width tab-width
                indent-tabs-mode nil)
  (setq evil-split-window-below t  ; foca em novas splits
        evil-vsplit-window-right t
        evil-want-Y-yank-to-eol t
        evil-want-fine-undo t      ; desfazer em passos menores
        ;; formato e cor do cursor em diferentes modos
        evil-emacs-state-cursor    '("#ffff00" box)
        evil-normal-state-cursor   '("#ffffff" box)
        evil-operator-state-cursor '("#ebcb8b" hollow)
        evil-visual-state-cursor   '("#ffffff" box)
        evil-insert-state-cursor   '("#ffffff" (bar . 2))
        evil-replace-state-cursor  '("#ff0000" box)
        evil-motion-state-cursor   '("#ad8beb" box)))
;; undotree não salva backups
(with-eval-after-load 'undo-tree
  (setq undo-tree-auto-save-history nil))
(require 'rational-evil)
;; necessario para carregar o rational-completion
(add-to-list 'load-path (expand-file-name "straight/build/vertico/extensions" straight-base-dir))
(require 'rational-completion)
(require 'rational-ide)
(require 'rational-lisp)
(require 'rational-python)

;;; Miscelanea
;; quebra paragrafos de acordo com as palavras
(global-visual-line-mode +1)
;; salva posição nos arquivos
(setq save-place-file "~/.config/rational-emacs/var/save-place")
(save-place-mode 1)
;; desativa barra piscando
(setq visible-bell       nil
      ring-bell-function #'ignore)
;; distancia de onde o scroll começa
(customize-set-variable 'scroll-margin 1)
(customize-set-variable 'scroll-conservatively 0)
;; para GPG, email, clientes, templates
(setq user-full-name "Lucas Tavares"
      user-mail-address "tavares.lassuncao@gmail.com")
(use-package which-key
  :straight t
  :init (which-key-mode))
(use-package rainbow-mode
  :straight t)
(use-package terminal-here
  :straight t
  :config (setq terminal-here-linux-terminal-command 'st))
;; desativa previsão consult
(setq consult-preview-key nil)
;; vai ate definições de codigo, ex: `gd'
(use-package dumb-jump
  :straight t
  :init (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))
;; melhora buffers de ajuda
(use-package helpful
  :straight t
  :config
  (define-key helpful-mode-map [remap revert-buffer] #'helpful-update)
  (global-set-key [remap describe-command] #'helpful-command)
  (global-set-key [remap describe-function] #'helpful-callable)
  (global-set-key [remap describe-key] #'helpful-key)
  (global-set-key [remap describe-symbol] #'helpful-symbol)
  (global-set-key [remap describe-variable] #'helpful-variable))
;; adiciona exemplos em buffers de ajuda
(use-package elisp-demos
  :straight t
  :init (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

;;; Linguagens
(add-hook 'prog-mode-hook 'prettify-symbols-mode)
;; sxhkd
(define-generic-mode sxhkd-mode
  '(?#)
  '("alt" "Escape" "super" "bspc" "dwmc" "herbstclient" "stumpish" "ctrl" "space" "shift" "Return" "Menu" "backslash" "slash" "comma" "period" "Tab" "Left" "Right" "Up" "Down" "Print") nil
  '("sxhkdrc") nil
  "Modo simples para o sxhkd.")
;; markdown
(use-package markdown-mode
  :straight t
  :mode ("\\.md\\'" . gfm-mode)
  :config
  ;; remove asteriscos de headings
  (font-lock-add-keywords 'gfm-mode `(("^\\(\\#+ \\)\\s-#\\S-"
                                       (1 (put-text-property (match-beginning 1) (match-end 1) 'invisible t)
                                          nil))))
  ;; Trocar listas com hífens por pontos
  (font-lock-add-keywords 'gfm-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  :init (setq markdown-command "multimarkdown"))
(use-package markdown-toc
  :straight t
  :after (markdown-mode)
  :hook (gfm-mode . markdown-toc))
;; lsp
(use-package eglot
  :hook
  (html-mode . eglot-ensure)
  (csharp-mode . eglot-ensure)
  (c-mode . eglot-ensure)
  (python-mode . eglot-ensure)
  (js-mode . eglot-ensure))
;; csharp
(use-package csharp-mode
  :straight t
  :config (add-to-list 'aggressive-indent-excluded-modes 'csharp-mode)
  :mode ("\\.cs\\'" . csharp-mode))
(use-package csproj-mode
  :mode ("\\.csproj\\'" . csproj-mode)
  :straight t)
(use-package sln-mode
  :mode ("\\.sln\\'" . sln-mode)
  :straight t)
;; css
(use-package css-eldoc
  :straight t
  :hook (css-mode . turn-on-css-eldoc))

;;; Orgmode
(with-eval-after-load 'org
  (setq org-ellipsis "  "
        org-startup-folded 'content
        org-return-follows-link t
        org-mouse-1-follows-link t
        org-descriptive-links t
        org-hide-emphasis-markers t
        org-src-fontify-natively t  ; formatação em codigo fonte
        org-src-tab-acts-natively t ; tab em codigo fonte
        org-startup-indented t      ; carrega o org-indent ao iniciar
        org-confirm-babel-evaluate nil
        org-hide-leading-stars t           ; mostra asteriscos das headers
        org-edit-src-content-indentation 2 ; Indentação nos blocos de código
        org-table-convert-region-max-lines 20000)
  ;; esconde marcação
  (add-hook 'org-mode-hook 'org-appear-mode)
  ;; desativa auto-pairing de "<" em org-mode
  (add-hook 'org-mode-hook (lambda ()
                             (setq-local electric-pair-inhibit-predicate
                                         `(lambda (c)
                                            (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))
  ;; remove asteriscos de headings
  (font-lock-add-keywords 'org-mode `(("^\\(\\*+ \\)\\s-*\\S-"
                                       (1 (put-text-property (match-beginning 1) (match-end 1) 'invisible t)
                                          nil))))
  ;; Trocar listas com hífens por pontos
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  ;; ativa blocos em varias linguagens
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (js . t)
     (shell . t)
     (python . t)
     (org . t)
     (C . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes)
  ;; headers variam de tamanho
  (dolist (face '((org-level-1 . 1.3)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.0)
                  (org-level-4 . 0.9)
                  (org-level-5 . 0.9)
                  (org-level-6 . 0.9)
                  (org-level-7 . 0.9)
                  (org-level-8 . 0.9)))
    (set-face-attribute (car face) nil :font "Ubuntu" :weight 'regular :height (cdr face))))
(use-package org-appear
  :straight t
  :after (org))
;; tangle automatico
(use-package org-auto-tangle
  :straight t
  :after (org)
  :hook (org-mode . org-auto-tangle-mode)
  :config (setq org-auto-tangle-default nil))
;; cria sumarios automaticamente
(use-package org-make-toc
  :straight t
  :after (org)
  :hook (org-mode . org-make-toc-mode))

;;; Edição
(use-package corfu
  :straight t
  :custom
  (corfu-auto-delay 1)
  (corfu-cycle t)
  (corfu-preselect-first nil)
  :config (set-face-attribute 'corfu-current nil :background "#007")
  :init (global-corfu-mode))
;; templates
(use-package tempel
  :straight t
  :config (setq tempel-path "/home/lucas/.config/rational-emacs/templates")
  :init
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))
(use-package evil-surround
  :straight t
  :init (global-evil-surround-mode))
(use-package evil-mc
  :straight t
  :init (global-evil-mc-mode))
(use-package expand-region
  :straight t)
(use-package drag-stuff
  :straight t)
(use-package aggressive-indent
  :straight t
  :init (global-aggressive-indent-mode))

;;; Aparencia
;; fontes de diferentes tamanhos
(variable-pitch-mode 1)
;; ativa indicação de spaços e tabs em código
(setq whitespace-style '(face tabs spaces space-mark trailing space-before-tab indentation
                              empty space-after-tab tab-mark missing-newline-at-eof))
(global-whitespace-mode +1)
(set-face-attribute 'whitespace-space nil :background "#000" :foreground "#333")
;; modeline
(use-package awesome-tray
  :straight (awesome-tray :type git :host github :repo "manateelazycat/awesome-tray")
  :config
  (setq awesome-tray-git-format "%b %s"
        awesome-tray-file-path-show-filename t
        awesome-tray-file-path-full-dirname-levels 1
        awesome-tray-file-path-truncate-dirname-levels 3
        awesome-tray-separator ""
        awesome-tray-essential-modules '("buffer-read-only" "  " "git" " " "location" "  ")
        awesome-tray-active-modules    '("buffer-read-only" "  " "git" " " "location" "  " "file-path"))
  :init (awesome-tray-mode))
(use-package hide-mode-line
  :straight t
  :init (global-hide-mode-line-mode))
;; tema
(use-package emacs
  :init
  (setq modus-themes-vivendi-color-overrides '((fg-comment-yellow . "#009900")
                                               (green . "#ffff00"))
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-variable-pitch-ui t
        modus-themes-markup '(italic bold)
        modus-themes-syntax '(yellow-comments green-strings)
        modus-themes-paren-match '(bold intense)
        modus-themes-links '(neutral-underline)
        modus-themes-box-buttons '(flat)
        modus-themes-prompts '(intense bold)
        modus-themes-completions '((matches . (extrabold))
                                   (selection . (semibold accented))
                                   (popup . (accented intense)))
        modus-themes-org-blocks 'gray-background
        modus-themes-headings
        '((1 . (variable-pitch background variable-pitch))
          (2 . (variable-pitch rainbow))
          (t . (variable-pitch semibold))))
  (set-face-attribute 'default nil :background "#000" :foreground "#fff")
  (set-face-attribute 'region nil :background "#007")
  :config (load-theme 'modus-vivendi))
;; Indica profundidade de parenteses
(use-package rainbow-delimiters
  :straight t
  :config
  ;; gradiente gerado usando: https://colordesigner.io/gradient-generator
  (set-face-attribute 'rainbow-delimiters-depth-1-face nil :foreground "#333333")
  (set-face-attribute 'rainbow-delimiters-depth-2-face nil :foreground "#4e4e4e")
  (set-face-attribute 'rainbow-delimiters-depth-3-face nil :foreground "#a2a2a2")
  (set-face-attribute 'rainbow-delimiters-depth-4-face nil :foreground "#ffffff")
  (set-face-attribute 'rainbow-delimiters-depth-5-face nil :foreground "#a2a2a2")
  (set-face-attribute 'rainbow-delimiters-depth-6-face nil :foreground "#4e4e4e")
  (set-face-attribute 'rainbow-delimiters-depth-7-face nil :foreground "#333333")
  (set-face-attribute 'rainbow-delimiters-depth-8-face nil :foreground "#ffffff")
  (set-face-attribute 'rainbow-delimiters-depth-9-face nil :foreground "#a2a2a2")
  :hook (prog-mode . rainbow-delimiters-mode))
;; indicação visual quando muda o foco
(require 'pulse)
(set-face-attribute 'pulse-highlight-start-face nil :background "#00f")
(defun pulsar-linha (&rest _)
  "Pulsa a linha atual."
  (pulse-momentary-highlight-one-line (point)))
(dolist (command '(scroll-up-command scroll-down-command
                                     recenter-top-bottom other-window))
  (advice-add command :after #'pulsar-linha))

;;; Funções
(defun evil-colar ()
  "Chama `evil-paste-after' porem inverte `evil-kill-on-visual-paste'.

isso cola o item sem copiar texto selecionado, tambem cola antes do cursor no modo de inserção."
  (interactive)
  (let ((evil-kill-on-visual-paste (not evil-kill-on-visual-paste)))
    (if (evil-insert-state-p)
        (call-interactively #'evil-paste-before)
      (call-interactively #'evil-paste-after))))

;;; Teclas
;; spc-map
(defalias 'spc-map (make-sparse-keymap))
(defvar spc-map (symbol-function 'spc-map))
;; h-map
(defalias 'h-map (make-sparse-keymap))
(defvar h-map (symbol-function 'h-map))
;; t-map
(defalias 't-map (make-sparse-keymap))
(defvar t-map (symbol-function 't-map))
;; SPC
(define-key spc-map (kbd "h") 'h-map)
(define-key spc-map (kbd "t") 't-map)
(define-key spc-map (kbd "SPC") 'consult-recent-file)
(define-key spc-map (kbd "k") 'kill-current-buffer)
(define-key spc-map (kbd "K") 'kill-some-buffers)
(define-key spc-map (kbd "u") 'undo-tree-visualize)
(define-key spc-map (kbd "c") 'list-colors-display)
(define-key spc-map (kbd "RET") 'terminal-here)
(define-key spc-map (kbd "<up>") 'windmove-up)
(define-key spc-map (kbd "<down>") 'windmove-down)
(define-key spc-map (kbd "<left>") 'windmove-left)
(define-key spc-map (kbd "<right>") 'windmove-right)
(define-key spc-map (kbd "<next>") #'flymake-goto-next-error)
(define-key spc-map (kbd "<prior>") #'flymake-goto-prev-error)
(fset 'copiar-buffer
      (kmacro-lambda-form [?g ?g ?V ?G ?y] 0 "%d"))
(define-key spc-map (kbd "b c") 'copiar-buffer)
(define-key spc-map (kbd "b b") 'consult-bookmark)
(define-key spc-map (kbd "b m") 'bookmark-set)
(define-key spc-map (kbd "b r") 'bookmark-delete)
(define-key spc-map (kbd "b s") 'flyspell-buffer)
(define-key spc-map (kbd "e e") 'eval-defun)
(define-key spc-map (kbd "e b") 'eval-buffer)
(define-key spc-map (kbd "e r") 'eval-region)
(define-key spc-map (kbd "f f") 'find-file)
(define-key spc-map (kbd "f F") 'consult-find)
(define-key spc-map (kbd "i i") 'aggressive-indent-indent-defun)
(define-key spc-map (kbd "s l") 'consult-locate)
(define-key spc-map (kbd "s f") 'consult-flymake)
(define-key spc-map (kbd "s g") 'consult-git-grep)
(define-key spc-map (kbd "v v") 'consult-outline)
(define-key spc-map (kbd "w w") 'save-buffer)
(define-key spc-map (kbd "w q") 'evil-save-and-quit)
(define-key spc-map (kbd "q q") 'evil-quit)
;; SPC h
(define-key h-map (kbd "a") 'consult-apropos)
(define-key h-map (kbd "b") 'embark-bindings)
(define-key h-map (kbd "M") 'consult-man)
(define-key h-map (kbd "m") 'describe-mode)
(define-key h-map (kbd "K") 'describe-keymap)
(define-key h-map (kbd "k") 'describe-key)
(define-key h-map (kbd "v") 'describe-variable)
(define-key h-map (kbd "f") 'describe-function)
(define-key h-map (kbd "F") 'describe-face)
(define-key h-map (kbd "c") 'describe-command)
;; SPC t
(define-key t-map (kbd "n") (lambda () (interactive)
                              (if display-line-numbers
                                  (setq display-line-numbers nil)
                                (setq display-line-numbers t))))
;; popup que retorna comandos sendo usados
(use-package posframe
  :straight t)
(use-package command-log-mode
  :after (posframe)
  :straight t
  :config
  (setq log/command-window-frame nil)
  (defun log/toggle-command-window ()
    (interactive)
    (if log/command-window-frame
        (progn
          (posframe-delete-frame clm/command-log-buffer)
          (setq log/command-window-frame nil))
      (progn
        (command-log-mode t)
        (with-current-buffer
            (setq clm/command-log-buffer
                  (get-buffer-create " *command-log*"))
          (text-scale-set -1))
        (setq log/command-window-frame
              (posframe-show
               clm/command-log-buffer
               :position `(,(- (x-display-pixel-width) 590) . 15)
               :width 50
               :height 15
               :min-width 50
               :min-height 15
               :internal-border-width 1
               :internal-border-color "#BA45A3"
               :override-parameters '((parent-frame . nil))))))))
(define-key t-map (kbd "c") 'log/toggle-command-window)
(define-key t-map (kbd "r") 'rainbow-mode)
(define-key t-map (kbd "l") 'toggle-truncate-lines)
(define-key t-map (kbd "h") 'hl-line-mode)
(define-key t-map (kbd "f") 'flyspell-mode)
(define-key t-map (kbd "t") (lambda () (interactive) (find-file "~/.config/rational-emacs/templates")))
;; evil-motion-state-map
(define-key evil-motion-state-map (kbd "SPC") 'spc-map)
(define-key evil-motion-state-map "?" (lambda () (interactive) (evil-ex-search-word-forward nil (thing-at-point 'symbol))))
(define-key evil-motion-state-map "|" (lambda () (interactive) (consult-line (thing-at-point 'symbol))))
(define-key evil-motion-state-map (kbd "E") 'completion-at-point)
(define-key evil-motion-state-map (kbd "K") 'helpful-at-point)
;; evil-normal-state-map
(define-key evil-normal-state-map (kbd "z =") 'flyspell-popup-correct)
(define-key evil-normal-state-map (kbd "m") 'evil-execute-macro)
(define-key evil-normal-state-map (kbd "p") 'evil-colar)
(define-key evil-normal-state-map (kbd "P") 'evil-collection-unimpaired-paste-below)
(define-key evil-normal-state-map "\\" 'consult-line)
;; evil-visual-state-map
(define-key evil-visual-state-map (kbd "z =") 'flyspell-popup-correct)
;; minibuffer
(define-key minibuffer-local-map (kbd "C-d") 'embark-act)
(define-key minibuffer-local-map (kbd "C-<tab>") #'vertico-next)
(define-key minibuffer-local-map (kbd "<backtab>") #'vertico-previous)
;; tempel-map
(define-key tempel-map (kbd "<backtab>") 'tempel-next)
;; corfu popups
(define-key corfu-map (kbd "TAB") 'corfu-next)
(define-key corfu-map (kbd "<tab>") 'corfu-next)
(define-key corfu-map (kbd "S-TAB") 'corfu-previous)
(define-key corfu-map (kbd "<backtab>") 'corfu-previous)
(define-key corfu-map (kbd "<up>") 'evil-previous-line)
(define-key corfu-map (kbd "<down>") 'evil-next-line)
(define-key corfu-map (kbd "E") 'tempel-expand)
;; evil-mc
(define-key evil-mc-cursors-map (kbd "ESC") 'evil-mc-undo-all-cursors)
;; global
(fset 'comentar-e-descer-linha
      (kmacro-lambda-form [?, ?, ?, down] 0 "%d"))
(global-set-key (kbd "C-c C-c") 'comentar-e-descer-linha)
(global-set-key (kbd "C-<tab>") 'consult-buffer)
(global-set-key (kbd "C-s") 'evil-mc-make-all-cursors)
(global-set-key (kbd "M-c") 'evil-yank)
(global-set-key (kbd "M-v") 'evil-colar)
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
;; markdown
(with-eval-after-load 'gfm-mode
  (define-key spc-map (kbd "l") 'markdown-insert-link))
;; orgmode
(with-eval-after-load 'org
  ;; desativa teclas
  (define-key org-mode-map (kbd "<M-up>") nil)
  (define-key org-mode-map (kbd "<M-down>") nil)
  (define-key org-mode-map (kbd "C-c C-c") nil)
  (define-key org-mode-map (kbd "<S-down>") nil)
  (define-key org-mode-map (kbd "<S-up>") nil)
  (define-key org-mode-map (kbd "<C-S-down>") nil)
  (define-key org-mode-map (kbd "<C-S-up>") nil)
  ;; teclas
  ;; SPC
  (define-key spc-map (kbd "v v") 'consult-org-heading)
  (define-key spc-map (kbd "l") 'org-insert-link)
  (define-key spc-map (kbd "b t") 'org-babel-tangle)
  ;; evil-motion-state-map
  (define-key evil-motion-state-map (kbd "RET") 'org-toggle-checkbox)
  ;; globais
  (defun orgm/org-cycle-current-headline ()
    "Abre e fecha a header atual."
    (interactive)
    (org-cycle-internal-local))
  (global-set-key (kbd "C-M-i") 'orgm/org-cycle-current-headline)
  (global-set-key (kbd "M-d") 'org-babel-demarcate-block))

;;; Correção ortográfica
(use-package flyspell
  :straight t
  :defer t
  :config
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
  (setq flyspell-sort-corrections nil    ; Não organizar correções por ordem alfabetica
        flyspell-issue-message-flag nil) ; Não mandar mensagens para cada palavra errada
  :hook (org-mode . flyspell-mode) (gfm-mode . flyspell-mode) (markdown-mode . flyspell-mode))
(with-eval-after-load "ispell"
  ;; a lingua padrão deve ser configurada depois mais linguas são adicionadas
  (setenv "LANG" "pt_BR.UTF-8") ; lingua padrão
  (setq ispell-program-name "hunspell"
        ispell-personal-dictionary "~/.config/hunspell/hunspell_personal"
        ispell-dictionary "pt_BR,en_US")
  (ispell-set-spellchecker-params) ; deve ser chamado antes de adicionar multi dicionários
  (ispell-hunspell-add-multi-dic "pt_BR,en_US"))
;; não carrega dicionario pessoal caso ele não exista
(unless (file-exists-p ispell-personal-dictionary)
  (write-region "" nil ispell-personal-dictionary nil 0))
(use-package flyspell-popup
  :straight t
  :after (flyspell))

;;; Fecha popups e modos com esc
;; retirado do doom-emacs
(use-package evil-escape
  :straight t)
(defvar rational-escape-hook nil
  "A hook run when C-g is pressed (or ESC in normal mode, for evil users).
all hooks after it are ignored.")
(defun rational-escape (&optional interactive)
  "Run `rational-escape-hook'."
  (interactive (list 'interactive))
  (cond ((minibuffer-window-active-p (minibuffer-window))
         ;; quit the minibuffer if open.
         (when interactive
           (setq this-command 'abort-recursive-edit))
         (abort-recursive-edit))
        ;; Run all escape hooks. If any returns non-nil, then stop there.
        ((run-hook-with-args-until-success 'rational-escape-hook))
        ;; don't abort macros
        ((or defining-kbd-macro executing-kbd-macro) nil)
        ;; Back to the default
        ((unwind-protect (keyboard-quit)
           (when interactive
             (setq this-command 'keyboard-quit))))))
(global-set-key [remap keyboard-quit] #'rational-escape)
(dolist (fn '((backward-kill-word)
              (company-complete-common . evil-mc-execute-default-complete)
              ;; :editor evil
              (evil-delete-back-to-indentation . evil-mc-execute-default-call)
              (evil-escape . evil-mc-execute-default-evil-normal-state)  ; C-g
              (evil-numbers/inc-at-pt-incremental)
              (evil-numbers/dec-at-pt-incremental)
              (evil-digit-argument-or-evil-beginning-of-visual-line
               (:default . evil-mc-execute-default-call)
               (visual . evil-mc-execute-visual-call))
              ;; :tools eval
              (+eval:replace-region . +multiple-cursors-execute-default-operator-fn)
              ;; :lang org
              (evil-org-delete . evil-mc-execute-default-evil-delete))))
(add-hook 'rational-escape-hook
          (defun +multiple-cursors-escape-multiple-cursors-h ()
            "Clear evil-mc cursors and restore state."
            (when (evil-mc-has-cursors-p)
              (evil-mc-undo-all-cursors)
              (evil-mc-resume-cursors)
              t)))
(defun +evil-escape-a (&rest _)
  "Call `rational-escape' if `evil-force-normal-state' is called interactively."
  (when (called-interactively-p 'any)
    (call-interactively #'rational-escape)))
(add-hook 'rational-escape-hook
          (defun +evil-disable-ex-highlights-h ()
            "Disable ex search buffer highlights."
            (when (evil-ex-hl-active-p 'evil-ex-search)
              (evil-ex-nohighlight)
              t)))
;; Make ESC (from normal mode) the universal escaper. See `rational-escape-hook'.
(advice-add #'evil-force-normal-state :after #'+evil-escape-a)
(setq evil-escape-excluded-states '(normal visual multiedit emacs motion)
      evil-escape-excluded-major-modes '(neotree-mode treemacs-mode vterm-mode)
      evil-escape-key-sequence "jk"
      evil-escape-delay 0.15)
(evil-define-key* '(insert replace visual operator) 'global "\C-g" #'evil-escape)
;; `evil-escape' in the minibuffer is more disruptive than helpful. That is,
;; unless we have `evil-collection-setup-minibuffer' enabled, in which case we
;; want the same behavior in insert mode as we do in normal buffers.
(add-hook 'evil-escape-inhibit-functions
          (defun +evil-inhibit-escape-in-minibuffer-fn ()
            (and (minibufferp)
                 (or (not (bound-and-true-p evil-collection-setup-minibuffer))
                     (evil-normal-state-p)))))
;; Turn on Evil Escape
(evil-escape-mode 1)
