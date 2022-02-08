;; -*- lexical-binding: t; -*-

;; Diminui a coleta de lixo
(setq gc-cons-threshold (* 50 1000 1000))

;; Compilação nativa no emacs 28
;; Silencia os avisos de compilação nativa
;; (setq native-comp-async-report-warnings-errors nil)
;; Ajusta o diretório correto para salvar o cache de compilação
;; (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))

;; Desativa package.el
(setq package-enable-at-startup nil)

;; Boostrap straight.el
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

;; Integra a expressão use-package ao straight
(straight-use-package 'use-package)
;; Automaticamente instala todos os pacotes sem usar o :straight t, equivalente ao :ensure t
(setq straight-use-package-by-default t)

;; Hack para rápida coleta de lixo
(use-package gcmh)
(gcmh-mode 1)

;; Move arquivos temporários/cache para pastas separadas
(use-package no-littering)

;; Move arquivo de auto salvamento para outra pasta
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(tooltip-mode -1)     ; Desativa as tooltips
(tool-bar-mode -1)    ; Desativa a aba de ferramentas
(menu-bar-mode -1)    ; Desativa o menu
(set-fringe-mode 0)   ; Bordas das janelas
(scroll-bar-mode -1)  ; Desativa a barra de scroll
(setq visible-bell t) ; Barra pisca em erros
(setq-default mode-line-format nil)  ; Remove a mode-line
(set-face-attribute 'default nil :font "Fira Code" :height 115) ; Fonte

;; Transparência
(set-frame-parameter (selected-frame) 'alpha '(90 90))
(add-to-list 'default-frame-alist '(alpha 90  90))

;; Tema original do emacs
(load-theme 'wombat)
;; Doom temas
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t     ; se nil, negrito é globalmente desativado
        doom-themes-enable-italic t)  ; se nil, italico é globalmente desativado
  (load-theme 'doom-gruvbox t)        ; Tema claro
  (load-theme 'doom-solarized-dark t) ; Tema escuro
  (doom-themes-visual-bell-config)    ; ativa piscar a barra em erros
  (doom-themes-neotree-config)        ; tema na neotree
  (doom-themes-org-config))           ; melhora as fontes do org-mode

;; Melhora suporte a ícones
(use-package all-the-icons)

;; Desativa a tela de inicio
(setq inhibit-startup-message t)

;; Evita erros no windows usando utf-8
(set-default-coding-systems 'utf-8)

;; scroll uma linha por vez
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
;; scroll na janela sobre o mouse
(setq mouse-wheel-follow-mouse 't)
;; scroll do teclado desce uma linha por vez
(setq scroll-step 1)

;; Ativa numero de linhas para alguns modos
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))
;; Remove o modo para modos não listados acima
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Não alerta sobre arquivos grandes
(setq large-file-warning-threshold nil)
;; Não alerta quando seguindo symlinks
(setq vc-follow-symlinks t)
;; Não alertar para funções
(setq ad-redefinition-action 'accept)

;; Tamanho dos tabs
(setq-default tab-width 2)
;; Usar espaços no lugar de tabs
(setq-default indent-tabs-mode nil)

;; Indica parentese correspondente
(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#444444")
  (show-paren-mode 1))

;; Parenteses inteligentes
(use-package smartparens
  :defer 1
  :config
  ;; Carrega valores padrão do smartparens para varias linguas
  (require 'smartparens-config)
  (setq sp-max-prefix-length 25)
  (setq sp-max-pair-length 4)
  (setq sp-highlight-pair-overlay nil
        sp-highlight-wrap-overlay nil
        sp-highlight-wrap-tag-overlay nil)
  (with-eval-after-load 'evil
    (setq sp-show-pair-from-inside t)
    (setq sp-cancel-autoskip-on-backward-movement nil)
    (setq sp-pair-overlay-keymap (make-sparse-keymap)))
  (let ((unless-list '(sp-point-before-word-p
                       sp-point-after-word-p
                       sp-point-before-same-p)))
    (sp-pair "'"  nil :unless unless-list)
    (sp-pair "\"" nil :unless unless-list))
  ;; Em lisps ( deve abrir nova form se antesa de outro parenteses
  (sp-local-pair sp-lisp-modes "(" ")" :unless '(:rem sp-point-before-same-p))
  ;; Não fazer expansão de espaços em colchetes a onde não faz sentido
  (sp-local-pair '(emacs-lisp-mode org-mode markdown-mode gfm-mode)
                 "[" nil :post-handlers '(:rem ("| " "SPC")))
  (dolist (brace '("(" "{" "["))
    (sp-pair brace nil
             :post-handlers '(("||\n[i]" "RET") ("| " "SPC"))
             ;; Don't autopair opening braces if before a word character or
             ;; other opening brace. The rationale: it interferes with manual
             ;; balancing of braces, and is odd form to have s-exps with no
             ;; whitespace in between, e.g. ()()(). Insert whitespace if
             ;; genuinely want to start a new form in the middle of a word.
             :unless '(sp-point-before-word-p sp-point-before-same-p)))
  (smartparens-global-mode t))

;; Limpa espaços em branco automaticamente
(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))

;; Salva posição no buffer
(use-package saveplace
  :init (setq save-place-limit 100)
  :config (save-place-mode))

;; Abre um terminal externo
(use-package terminal-here)
(setq terminal-here-linux-terminal-command 'st)

;; Previsão de cores
(use-package rainbow-mode
      :defer t
      :hook (org-mode
             emacs-lisp-mode
             web-mode
             typescript-mode
             js2-mode))

;; Folding
(use-package origami
  :hook (yaml-mode . origami-mode))

;; Indica diffs
(use-package git-gutter
  :config (global-git-gutter-mode +1))

;; Expande região selecionada
(use-package expand-region)

;; Melhorias no buffer de ajuda
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Popup do corretor ortográfico
(use-package flyspell-popup)

;; Correção ortográfica
(use-package flyspell
  :defer t
  :config
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
  (dolist (mode '(org-mode-hook
                  mu4e-compose-mode-hook))
    (add-hook mode (lambda () (flyspell-mode 1)))))
(setq flyspell-sort-corrections nil) ; Não organizar correções por ordem alfabetica
(setq flyspell-issue-message-flag nil) ; Não mandar mensagens para cada palavra errada
(with-eval-after-load "ispell"
  ;; Uma lingua padrão deve ser configurada embora outras linguas sejam adicionadas mais abaixo
  (setenv "LANG" "pt_BR.UTF-8")          ; lingua padrão
  (setq ispell-program-name "hunspell")  ; ferramenta uilizada
  (setq ispell-dictionary "pt_BR,en_US") ; lista de linguas
  (ispell-set-spellchecker-params)       ; isso deve ser chamado antes de adicionar multi dicionários
  (ispell-hunspell-add-multi-dic "pt_BR,en_US")
  ;; Local do dicionario pessoal, caso não definida novas palavras são adicionadas ao .hunspell_pt_BR
  (setq ispell-personal-dictionary "~/.config/hunspell/hunspell_personal"))

;; Gerenciador de arquivos
(use-package dired
  :ensure nil
  :straight nil
  :defer 1
  :commands (dired dired-jump)
  :config
  (setq dired-listing-switches "-agho --group-directories-first"
        dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil
        dired-hide-details-hide-symlink-targets nil))
(use-package dired-single ; mantem uma instancia do dired
  :defer t)
(use-package dired-collapse
  :defer t)

;; Melhora ícones no explorador de arquivos
(use-package all-the-icons-dired
:hook (dired-mode . all-the-icons-dired-mode))

;; Facilita o controle de projetos
(use-package projectile
  :config (projectile-mode)
  :demand t
  :init
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code/c/" "~/code/csharp/" "~/code/shell/" "~/code/unity/" "~/code/webPages/")))
  (setq projectile-switch-project-action #'projectile-dired))

;; Explorador arvore de arquivos
(use-package neotree
  :after all-the-icons
  :config
  (setq neo-smart-open t
        neo-window-width 40 ; define a largura da neotree
        inhibit-compacting-font-caches t
      neo-theme 'icons
      projectile-switch-project-action 'neotree-projectile-action)
  (add-hook 'neo-after-create-hook
            #'(lambda (_)
                (with-current-buffer (get-buffer neo-buffer-name)
          (setq truncate-lines t) ; trunca nomes de arquivo muito grandes
                  (setq word-wrap nil)
                  (make-local-variable 'auto-hscroll-mode)
          (display-line-numbers-mode -1) ; desativa numero de linhas
          (setq auto-hscroll-mode nil)))))
(setq-default neo-show-hidden-files t) ; mostrar arquivos ocultos

(global-unset-key (kbd "C-SPC"))
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; ESQ fecha prompts
(global-set-key (kbd "C-M-u") 'universal-argument) ; Tecla padrão utilizada pelo evil

;; Comenta e vai pra proxima linha
(fset 'comentar-proxima-linha
   (kmacro-lambda-form [?\s-i down] 0 "%d"))
(global-set-key (kbd "s-c") 'comentar-proxima-linha)

;; Modo vim
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  (("M-x" . counsel-M-x))
  (("C-s" . swiper))
  (("s-i" . evilnc-comment-or-uncomment-lines))
  (("s-s" . evil-mc-make-all-cursors))
  (("s-x" . evil-mc-undo-all-cursors))
  (("<s-down>" . evil-mc-make-cursor-move-next-line))
  (("<s-up>" . evil-mc-make-cursor-move-prev-line))
  (("M-v" . evil-paste-before))
  (("M-s" . flyspell-popup-correct))
  (("M-c" . evil-yank))
  (("M-d" . org-babel-demarcate-block))
  (("<M-tab>" . evil-toggle-fold))
  (("<M-up>" . er/expand-region))
  (("<M-down>" . er/contract-region))
  (("<s-left>" . evil-next-buffer))
  (("<s-right>" . evil-prev-buffer))
  (("<C-tab>" . other-window))
  (("<C-s-right>" . evil-window-vsplit))
  (("<C-s-down>"  . evil-window-split))
  :init
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-keybinding nil) ; Desativa comandos no insert mode
  (setq evil-undo-system 'undo-tree)
  :config
  ;; Formato e cor dos cursores em diferentes modos
  (setq evil-emacs-state-cursor    '("#ffff00" box))
  (setq evil-normal-state-cursor   '("#ffffff" box))
  (setq evil-operator-state-cursor '("#ebcb8b" hollow))
  (setq evil-visual-state-cursor   '("#555555" box))
  (setq evil-insert-state-cursor   '("#ffffff" (bar . 2)))
  (setq evil-replace-state-cursor  '("#ff0000" hbar))
  (setq evil-motion-state-cursor   '("#ad8beb" box))
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  (evil-mode 1))
(setq-default evil-shift-width tab-width)

;; Não copia logo após colar
(defun evil-paste-after-from-0 ()
  (interactive)
  (let ((evil-this-register ?0))
    (call-interactively 'evil-paste-after)))
(define-key evil-visual-state-map "p" 'evil-paste-after-from-0)

;; Vai para a proxima linha quando no final da linha
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

;; Movimenta horizontalmente entre partes da mesma linha
(setq-default evil-cross-lines t)

;; Comenta código
(use-package evil-nerd-commenter)

(defun copiar-buffer ()
    "Copia todo o buffer"
    (interactive)
    (clipboard-kill-ring-save (point-min) (point-max)))

;; Facilita configuração de teclas
(use-package general
  :after evil
  :config
  (general-evil-setup t)
  (general-create-definer keys/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))
(keys/leader-keys
  "c" '(copiar-buffer :which-key "Copiar o buffer")
  "E" '((lambda () (interactive) (load-file "~/.config/emacs/init.el")) :which-key "Avaliar configuração do emacs")
  "l" '(log/toggle-command-window :which-key "Log de comandos")
  "n" '(neotree-toggle :which-key "Ativa/Desativa a neotree")
  "p" '(projectile-command-map :which-key "Projectile")
  "R" '(rainbow-mode :which-key "Indicar cores")
  "r" '(counsel-colors-emacs :which-key "Escolher cores")
  "T" '(enable-theme :which-key "Escolher tema")
  "t" '(org-babel-tangle :which-key "Tangle file")
  "u" '(undo-tree-visualize :which-key "Undo tree")
  "y" '(aya-create :which-key "Criar snippet")
  "e b" '(eval-buffer :which-key "Avaliar buffer")
  "e r" '(eval-region :which-key "Avaliar região")
  "w w" '(save-buffer :which-key "Salvar")
  "w q" '(evil-save-and-quit :which-key "Salvar e sair")
  "q q" '(evil-quit :which-key "Sair sem salvar")
  "SPC" '(org-toggle-checkbox :which-key "Marcar")
  "RET" '(terminal-here-launch :which-key "Abrir terminal externo")
  "<tab>" '(counsel-switch-buffer :which-key "Mudar de buffer"))

(use-package flyspell
  :general ;; Troca corrigir palavra do botão do meio para o botão direito do mouse
  (general-define-key :keymaps 'flyspell-mouse-map
                      "<mouse-3>" #'flyspell-correct-word
                      "<mouse-2>" nil))

;; Suporte do evil em outros modos
(use-package evil-collection
  :after evil
  :init
  (setq evil-collection-company-use-tng nil)  ;; Bug no evil-collection?
  :config
  (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;;(use-package undo-fu)
(use-package undo-tree ; Refazer/Desfazer como no vim, Não necessário no emacs 28, Adicionar suporte a ligaturas no emacs 28
  :straight t
  :delight
  :config
  (global-undo-tree-mode))

;; Múltiplos cursores
(use-package evil-mc)
(global-evil-mc-mode  1)

;; Menu de compleção de atalhos
(use-package which-key
  :init (which-key-mode)
  :config
  (which-key-setup-side-window-right-bottom) ;; Teclas do lado se houver espaço
  (setq which-key-side-window-max-width 0.33) ;; Tamanho máximo da janela ao lado
  (setq which-key-use-C-h-commands nil) ;; Paging com C-h
  (setq which-key-show-early-on-C-h t) ;; Mostra atalhos C-h na hora
  (setq which-key-idle-delay 0.3)) ;; Atrasa o popup em atalhos mais usados

;; Cria múltiplos comandos com um único prefixo
(use-package hydra
  :defer 1)

;; Popups
(use-package posframe)

;; Retorna comandos utilizados
(use-package command-log-mode
  :straight t
  :after posframe)

;; Popup que retorna comandos sendo usados
(setq log/command-window-frame nil)
(defun log/toggle-command-window ()
  (interactive)
  (if log/command-window-frame
      (progn
        (posframe-delete-frame clm/command-log-buffer)
        (setq log/command-window-frame nil))
      (progn
        (global-command-log-mode t)
        (with-current-buffer
          (setq clm/command-log-buffer
                (get-buffer-create " *command-log*"))
          (text-scale-set -1))
        (setq log/command-window-frame
          (posframe-show
            clm/command-log-buffer
            :position `(,(- (x-display-pixel-width) 590) . 15)
            :width 40
            :height 10
            :min-width 38
            :min-height 5
            :internal-border-width 1
            :internal-border-color "#444444"
            :override-parameters '((parent-frame . nil)))))))

;; Front-end para compleção ivy
(use-package ivy
  :bind (:map ivy-switch-buffer-map
              ("C-d" . ivy-switch-buffer-kill))
  :config
  (ivy-mode 1))

;; Mais detalhes nas compleções do ivy
(use-package counsel
  :config
  (setq counsel-switch-buffer-preview-virtual-buffers nil) ;; Remove arquivos recente/marcados do counsel-switch-buffer
  (setq counsel-find-file-ignore-regexp
        (concat
         ;; Esconde nomes de arquivos que começam com .
         "\\(?:\\`[#.]\\)"))
  ;; Lista arquivos recentes na ordem de ultimos acessados
  (add-to-list 'ivy-sort-functions-alist
               '(counsel-recentf . file-newer-than-file-p)))

;; Melhora a interface do ivy
(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1)
  :config
  (setq ivy-format-function #'ivy-format-function-line)
  (setq ivy-rich-display-transformers-list
        (plist-put ivy-rich-display-transformers-list
                   'ivy-switch-buffer
                   '(:columns
                     ((ivy-rich-candidate (:width 40))
                      (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right)) ; Retorna os indicadores de buffers
                      (ivy-rich-switch-buffer-major-mode (:width 12 :face warning)) ; Retorna informações do major mode
                      (ivy-rich-switch-buffer-project (:width 15 :face success)) ; Retorna o nome do projeto usando `projectile'
                      ;; Retorna o caminho do arquivo relativo a raiz do projeto ou `default-directory' se projeto é nil
                      (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))))))

;; Ícones nas pesquisas do ivy
(use-package all-the-icons-ivy-rich
  :init (all-the-icons-ivy-rich-mode 1)
  :config
  (setq all-the-icons-ivy-rich-icon-size 1.0))

;; Prioriza comandos mais utilizados
(use-package prescient
  :config
  (setq-default history-length 1000)
  (setq-default prescient-history-length 1000) ;; Histórico maior
  (prescient-persist-mode +1))

(use-package ivy-prescient
  :after ivy
  :config
  (ivy-prescient-mode +1)
  (setq ivy-prescient-retain-classic-highlighting t)
  (prescient-persist-mode 1)) ; Lembra dos comandos caso o emacs seja fechado

;; Menu de compleção
(use-package vertico
  :custom
  (vertico-cycle t)
  :custom-face
  (vertico-current ((t (:background "#444444"))))
  :init
  (vertico-mode))

;; Popup de compleção
(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map lsp-mode-map
              ("<tab>" . company-indent-or-complete-common))
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-minimum-prefix-length 2
        company-tooltip-limit 14
        company-tooltip-align-annotations t
        company-require-match 'never
        company-global-modes '(not erc-mode message-mode help-mode gud-mode)
        company-frontends
        '(company-pseudo-tooltip-frontend
          company-echo-metadata-frontend)
        company-backends '(company-capf company-files company-keywords)
        company-auto-complete nil
        company-auto-complete-chars nil
        company-dabbrev-other-buffers nil
        company-dabbrev-ignore-case nil
        company-dabbrev-downcase nil)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; Prioriza comandos mais utilizados
(use-package company-prescient
  :defer 2
  :after company
  :config
  (company-prescient-mode +1))

;; Integração do projectile ao ivy
(use-package counsel-projectile
  :after projectile
  :config
  (counsel-projectile-mode 1))

;; Templates de código
(use-package yasnippet
  :config
  (yas-reload-all)
  (yas-global-mode 1)
  (require 'warnings))
(use-package yasnippet-snippets) ;; Coleção de snippets para o yasnippets
(defvar yas/company-point nil)
(advice-add 'company-complete-common :before (lambda () (setq yas/company-point (point))))
(advice-add 'company-complete-common :after (lambda ()
                                              (when (equal yas/company-point (point))
                                                (yas-expand))))

;; Popup de erros no código e ortográficos
(use-package flycheck-pos-tip)

;; Mostra informações da linguagem no minibuffer
(use-package eldoc
  :hook
  (prog-mode . turn-on-eldoc-mode)
  (cider-repl-mode . turn-on-eldoc-mode))

;; Checagem de sintaxe
(use-package flycheck
  :after (flycheck-pos-tip-mode)
  :config
  (show-paren-mode 1)
  (flycheck-pos-tip-mode)
  :hook
  ((after-init . global-flycheck-mode)))

(use-package tree-sitter
  :init
  (global-tree-sitter-mode))
(use-package tree-sitter-langs
  :after (tree-sitter))
(use-package tree-sitter-indent)

;; Servidor de compleção de linguagens
(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred)
  :hook ((csharp-mode . lsp-mode)
         (js2-mode . lsp-mode)
         (web-mode . lsp-mode)
         (prog-mode . lsp-mode)
         (python-mode . lsp-mode)
         (java-mode . lsp-mode)
         (lsp-mode . lsp-enable-which-key-integration))
  :bind (:map lsp-mode-map
              ("TAB" . completion-at-point))
  :custom
  (setq lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-which-key-integration t))

;; Integração do lsp no ivy
(use-package lsp-ivy
  :after ivy)

;; Melhora a interface do lsp
(use-package lsp-ui
  :straight t
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show))

;; Debugar código
(use-package dap-mode
  :straight t
  :custom
  (lsp-enable-dap-auto-configure nil)
  :config
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (require 'dap-node)
  (dap-node-setup))
(setq dap-auto-configure-features '(sessions locals controls tooltip))

;; C/C++
(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

;; GO
(use-package go-mode
  :hook (go-mode . lsp-deferred))

;; C#
(use-package csharp-mode
  :mode ("\\.cs\\'" . csharp-mode)
  :hook ((csharp-mode) .
         (lambda () (require 'dap-netcore) (lsp))))
(use-package omnisharp
  :hook (csharp-mode . omnisharp-mode))
;; C# debugger
(require 'dap-netcore)
(use-package sln-mode
  :mode "\\.sln\\'")

;; Unity
(use-package shader-mode
  :mode "\\.shader\\'")

;; Vimscript
(use-package vimrc-mode)
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; YAML
(use-package yaml-mode
  :mode ("\\.ya?ml\\'" . yaml-mode))

;; JSON
(use-package json-mode
  :mode ("\\.json\\'" . json-mode))

;; Python
(use-package python-mode
  :defer t)
;; Usa ambientes virtuais
(use-package pyvenv
  :defer t
  :init
  (setenv "WORKON_HOME" "~/.config/pyenv/versions")) ;; Localização dos ambientes
;; Automaticamente ativa o ambiente virtual quando entrando em um diretório
(use-package auto-virtualenv
  :defer 2
  :config
  (add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv))

;; Lisps
(add-hook 'emacs-lisp-mode-hook #'flycheck-mode)
(use-package parinfer
  :disabled ;; Problema com o pacote antigo cl, possivelmente consertado no emacs 28
  :hook ((clojure-mode . parinfer-mode)
         (emacs-lisp-mode . parinfer-mode)
         (common-lisp-mode . parinfer-mode)
         (scheme-mode . parinfer-mode)
         (lisp-mode . parinfer-mode))
  :config
  (setq parinfer-extensions
        '(defaults       ; deve ser incluido
           pretty-parens  ; diferentes estilos de parenteses para modos diferentes
           evil
           smart-tab      ; C-b & C-f pula posições e shift inteligente com tab e S-tab
           smart-yank)))  ; comportamento do yank depende do modo
;; Common lisp
(use-package sly
  :mode "\\.lisp\\'")
(use-package slime
  :mode "\\.lisp\\'")

;; Javascript
(defun js/set-js-indentation ()
  (setq js-indent-level 2)
  (setq evil-shift-width js-indent-level)
  (setq-default tab-width 2))
(use-package js2-mode
  :mode "\\.jsx?\\'"
  :config
  ;; Use js2-mode para scripts do node
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))
  ;; Não usar a checagem de sintaxe nativa
  (setq js2-mode-show-strict-warnings nil)
  ;; Indentação apropriada para JAVASCRIPT e JSON
  (add-hook 'js2-mode-hook #'js/set-js-indentation)
  (add-hook 'json-mode-hook #'js/set-js-indentation))
(use-package apheleia
  :config
  (apheleia-global-mode +1))

;; Markdown
(use-package markdown-mode
  :straight t
  :mode "\\.md\\'"
  :config
  (setq markdown-command "marked")
  (defun md/set-markdown-header-font-sizes ()
    (dolist (face '((markdown-header-face-1 . 1.2)
                    (markdown-header-face-2 . 1.1)
                    (markdown-header-face-3 . 1.0)
                    (markdown-header-face-4 . 1.0)
                    (markdown-header-face-5 . 1.0)))
      (set-face-attribute (car face) nil :weight 'normal :height (cdr face))))
  (defun md/markdown-mode-hook ()
    (dw/set-markdown-header-font-sizes))
  (add-hook 'markdown-mode-hook 'md/markdown-mode-hook))

;; HTML
(use-package web-mode
  :mode "\\.html\\'"
  :config
  (setq-default web-mode-code-indent-offset 2)
  (setq-default web-mode-markup-indent-offset 2)
  (setq-default web-mode-attribute-indent-offset 2))
;; 1. Inicie o server com `httpd-start'
;; 2. Use `impatient-mode' em qualquer buffer
(use-package impatient-mode
  :straight t)
(use-package skewer-mode
  :straight t)

;; Compilar
(use-package compile
  :straight nil
  :custom
  (compilation-scroll-output t))
(defun auto-recompile-buffer ()
  (interactive)
  (if (member #'recompile after-save-hook)
      (remove-hook 'after-save-hook #'recompile t)
    (add-hook 'after-save-hook #'recompile nil t)))

;; Função ao iniciar o orgmode
(defun orgm/org-mode-setup ()
  (org-indent-mode)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil)
  (define-key org-mode-map (kbd "<M-up>") nil)
  (define-key org-mode-map (kbd "<M-down>") nil))

(use-package org
  :hook (org-mode . orgm/org-mode-setup)
  :config
  (setq org-ellipsis " "
        org-hide-emphasis-markers t))

;; Aparencia dos marcadores
(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Trocar listas com hífens por pontos
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-indent)

;; Retira fundo de headings
(set-face-attribute 'org-column nil :background nil)
(set-face-attribute 'org-column-title nil :background nil)

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (C . t)
     (css . t)
     (js . t)
     (makefile . t)
     (python . t))))

;; Indicação de sintaxe em blocos de código, não pergunta se quer avaliar código
(setq org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-confirm-babel-evaluate nil
      org-edit-src-content-indentation 0)

;; Templates para o orgmode
(require 'org-tempo)
;; Snippets para templates de codigo
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

;; Cria sumario automaticamente
(use-package org-make-toc
  :hook (org-mode . org-make-toc-mode))

;; Mostra marcação do orgmode quando necessário
(use-package org-appear
  :hook (org-mode . org-appear-mode))

;; Automaticamente separa a configuração do init.org quando o salva
(defun orgm/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.config/emacs/init.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'orgm/org-babel-tangle-config)))

;; Volta com a velocidade normal da coleta de lixo
(setq gc-cons-threshold (* 2 1000 1000))

;; Confirma se tudo foi configurado com sucesso
(message "Emacs totalmente configurado!")