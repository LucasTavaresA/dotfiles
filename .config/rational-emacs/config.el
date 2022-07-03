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
(require 'rational-evil)
;; necessario para carregar o rational-completion
(add-to-list 'load-path (expand-file-name "straight/build/vertico/extensions" straight-base-dir))
(require 'rational-completion)
(require 'rational-ide)
(require 'rational-lisp)
(require 'rational-org)
(require 'rational-python)

;;; Miscelanea
(use-package git-gutter-fringe
  :straight t
  :config
  (set-face-foreground 'git-gutter-fr:modified "#ff0")
  (set-face-foreground 'git-gutter-fr:added    "#090")
  (set-face-foreground 'git-gutter-fr:deleted  "#f00")
  (setq-default left-fringe-width  2)
  (setq-default right-fringe-width 2)
  (fringe-helper-define 'git-gutter-fr:added nil
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX")

  (fringe-helper-define 'git-gutter-fr:deleted nil
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX")

  (fringe-helper-define 'git-gutter-fr:modified nil
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX"
    "XXXXXXXXX")
  :init (global-git-gutter-mode))
(use-package rainbow-mode
  :straight t)
(use-package terminal-here
  :straight t
  :config (setq terminal-here-linux-terminal-command 'st))
;; salva posição nos arquivos
(setq save-place-file "~/.config/rational-emacs/var/save-place")
(save-place-mode 1)
;; desativa barra piscando
(setq visible-bell       nil
      ring-bell-function #'ignore)
;; desativa previsão consult
(setq consult-preview-key nil)
;; para GPG, email, clientes, templates
(setq user-full-name "Lucas Tavares"
      user-mail-address "tavares.lassuncao@gmail.com")
;; undotree não salva backups
(with-eval-after-load 'undo-tree
  (setq undo-tree-auto-save-history nil))
(with-eval-after-load 'evil
  ;; evil search mais parecido com o do vim
  (evil-select-search-module 'evil-search-module 'evil-search)
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
;; vai ate definições de codigo, ex: `gd'
(use-package dumb-jump
  :straight t)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
;; melhora buffers de ajuda
(use-package helpful
  :straight t)
(require 'helpful)
(define-key helpful-mode-map [remap revert-buffer] #'helpful-update)
(global-set-key [remap describe-command] #'helpful-command)
(global-set-key [remap describe-function] #'helpful-callable)
(global-set-key [remap describe-key] #'helpful-key)
(global-set-key [remap describe-symbol] #'helpful-symbol)
(global-set-key [remap describe-variable] #'helpful-variable)
;; adiciona exemplos em buffers de ajuda
(use-package elisp-demos
  :straight t)
(require 'elisp-demos)
(advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update)

;;; Linguagens
;; modo simples para o sxhkd
(define-generic-mode sxhkd-mode
  '(?#)
  '("alt" "Escape" "super" "bspc" "dwmc" "herbstclient" "stumpish" "ctrl" "space" "shift" "Return" "Menu" "backslash" "slash" "comma" "period" "Tab" "Left" "Right" "Up" "Down" "Print") nil
  '("sxhkdrc") nil
  "Modo simples para o sxhkd.")
;; markdown
(use-package markdown-mode
  :straight t
  :mode ("\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))
(use-package markdown-toc
  :straight t
  :after (markdown-mode))

;;; Orgmode
(with-eval-after-load 'org
  (require 'org-indent)
  (use-package org-starless
    :straight (org-starless :type git :host github :repo "toncherami/org-starless")
    :hook (org-mode . org-starless-mode))
  ;; tangle automatico
  (use-package org-auto-tangle
    :straight t
    :hook (org-mode . org-auto-tangle-mode)
    :config (setq org-auto-tangle-default nil))
  ;; templates de código
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
  (add-to-list 'org-structure-template-alist '("bash" . "src bash"))
  (add-to-list 'org-structure-template-alist '("zsh" . "src zsh"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("li" . "src lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("go" . "src go"))
  (add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("json" . "src json"))
  (add-to-list 'org-structure-template-alist '("conf" . "src conf"))
  (add-to-list 'org-structure-template-alist '("vim" . "src vimrc"))
  (push '("conf-unix" . conf-unix) org-src-lang-modes)
  ;; cria sumarios automaticamente
  (use-package org-make-toc
    :straight t
    :hook (org-mode . org-make-toc-mode))
  ;; headers variam de tamanho
  (defun orgm/org-fonts ()
    "Define o tamanho de fontes orgmode"
    (dolist (face '((org-level-1 . 1.3)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.0)
                    (org-level-4 . 0.9)
                    (org-level-5 . 0.9)
                    (org-level-6 . 0.9)
                    (org-level-7 . 0.9)
                    (org-level-8 . 0.9)))
      (set-face-attribute (car face) nil :font "Ubuntu" :weight 'regular :height (cdr face))))
  (add-hook 'org-mode-hook 'orgm/org-fonts)
  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-ellipsis "  "
        org-startup-folded 'content
        org-hide-emphasis-markers t
        org-src-fontify-natively t  ; formatação em codigo fonte
        org-src-tab-acts-natively t ; tab em codigo fonte
        org-startup-indented nil
        org-confirm-babel-evaluate nil
        org-hide-leading-stars t           ; mostra asteriscos das headers
        org-edit-src-content-indentation 2 ; Indentação nos blocos de código
        org-table-convert-region-max-lines 20000))

;;; Edição
(use-package corfu
  :straight t
  :custom
  (corfu-auto-delay 1)
  (corfu-cycle t)
  (corfu-preselect-first nil) ;; Preseleção de candidato
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  :init
  (global-corfu-mode))
;; templates
(use-package tempel
  :straight t
  :config
  (setq tempel-path "/home/lucas/.config/rational-emacs/templates")
  :init
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))
(use-package evil-surround
  :straight t
  :config
  (global-evil-surround-mode 1))
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
(setq-default evil-cross-lines t ; da a volta para a proxima linha
              tab-width 4
              evil-shift-width tab-width
              indent-tabs-mode nil)

;;; Aparencia
;; modeline
(use-package awesome-tray
  :straight (awesome-tray :type git :host github :repo "manateelazycat/awesome-tray")
  :config
  (setq awesome-tray-git-format "%b %s"
        awesome-tray-file-path-show-filename t
        awesome-tray-file-path-full-dirname-levels 1
        awesome-tray-file-path-truncate-dirname-levels 3
        awesome-tray-separator ""
        awesome-tray-essential-modules '("git" " " "location" "  " "file-path")
        awesome-tray-active-modules    '("git" " " "location" "  " "file-path"))
  :init (awesome-tray-mode))
(use-package hide-mode-line
  :straight t
  :init (global-hide-mode-line-mode))
;; tema
(use-package doom-themes
  :straight t)
(load-theme 'doom-outrun-electric t)
(set-face-attribute 'default nil :background "#000")
(set-face-attribute 'default nil :foreground "#fff")
(set-face-attribute 'region nil :background "#007")
(set-face-attribute 'corfu-current nil :background "#007")
;; fonte
(variable-pitch-mode 1)
;; ativa indicação de indentação em código
(setq whitespace-style '(face tabs spaces space-mark trailing space-before-tab big-indent
                              indentation empty space-after-tab tab-mark missing-newline-at-eof))
(global-whitespace-mode +1)
;; indicação visual quando muda o foco
(require 'pulse)
(set-face-attribute 'pulse-highlight-start-face nil :background "#00f")
(defun pulse-line (&rest _)
  "Pulse the current line."
  (pulse-momentary-highlight-one-line (point)))
(dolist (command '(scroll-up-command scroll-down-command
                                     recenter-top-bottom other-window))
  (advice-add command :after #'pulse-line))

;;; Funções
(defun +evil/alt-paste ()
  "Call `evil-paste-after' but invert `evil-kill-on-visual-paste'.
By default, this replaces the selection with what's in the clipboard without
replacing its contents."
  (interactive)
  (let ((evil-kill-on-visual-paste (not evil-kill-on-visual-paste)))
    (call-interactively #'evil-paste-after)))

;;; Teclas
;; which-key
(use-package which-key
  :straight t
  :init (which-key-mode))
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
(define-key spc-map (kbd "RET") 'terminal-here)
(define-key spc-map (kbd "<up>") 'windmove-up)
(define-key spc-map (kbd "<down>") 'windmove-down)
(define-key spc-map (kbd "<left>") 'windmove-left)
(define-key spc-map (kbd "<right>") 'windmove-right)
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
(defun alterna-numero-de-linhas ()
  "alterna visibilidade do numero de linhas."
  (interactive)
  (defvar estado display-line-numbers)
  (if display-line-numbers
      (setq display-line-numbers nil)
    (setq display-line-numbers t)))
(define-key t-map (kbd "n") 'alterna-numero-de-linhas)
;; popup que retorna comandos sendo usados
(use-package posframe
  :straight t)
(use-package command-log-mode
  :straight t
  :after posframe)
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
             :override-parameters '((parent-frame . nil)))))))
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
;; evil-normal-state-map
(define-key evil-normal-state-map (kbd "m") 'evil-execute-macro)
(define-key evil-normal-state-map (kbd "p") '+evil/alt-paste)
(define-key evil-normal-state-map (kbd "P") 'evil-collection-unimpaired-paste-below)
(define-key evil-normal-state-map "\\" 'consult-line)
;; minibuffer
(define-key minibuffer-local-map (kbd "C-d") 'embark-act)
(define-key minibuffer-local-map (kbd "C-<tab>") #'vertico-next)
(define-key minibuffer-local-map (kbd "<backtab>") #'vertico-previous)
;; corfu popups
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
(global-set-key (kbd "M-v") '+evil/alt-paste)
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
(with-eval-after-load 'markdown-mode
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
  (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:")))
(setq flyspell-sort-corrections nil) ; Não organizar correções por ordem alfabetica
(setq flyspell-issue-message-flag nil) ; Não mandar mensagens para cada palavra errada
(with-eval-after-load "ispell"
  ;; uma lingua padrão deve ser configurada embora outras linguas sejam adicionadas mais abaixo
  (setenv "LANG" "pt_BR.UTF-8")          ; lingua padrão
  (setq ispell-program-name "hunspell")  ; ferramenta uilizada
  (setq ispell-dictionary "pt_BR,en_US") ; lista de linguas
  (ispell-set-spellchecker-params)       ; isso deve ser chamado antes de adicionar multi dicionários
  (ispell-hunspell-add-multi-dic "pt_BR,en_US")
  ;; local do dicionario pessoal, caso não definida novas palavras são adicionadas ao .hunspell_pt_BR
  (setq ispell-personal-dictionary "~/.config/hunspell/hunspell_personal"))
;; não  carrega dicionario pessoal caso ele não exista
(unless (file-exists-p ispell-personal-dictionary)
  (write-region "" nil ispell-personal-dictionary nil 0))
(use-package flyspell-popup
  :straight t)

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
