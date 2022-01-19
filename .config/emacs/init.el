(setq inhibit-startup-message t)    ; Desativa a tela de inicio
(setq scroll-step            1
      scroll-conservatively  10000)

;;; APARÊNCIA
(tooltip-mode -1)       ; desativa as tooltips
(tool-bar-mode -1)      ; desativa a aba de ferramentas
(menu-bar-mode -1)      ; desativa o menu
(set-fringe-mode 0)
(scroll-bar-mode -1)    ; desativa a barra de scroll
(setq visible-bell t)   ; barra pisca em erros
(global-hl-line-mode 1) ; indica a linha atual
(setq-default mode-line-format nil)  ; remove a mode-line
(global-display-line-numbers-mode t) ; numero de linhas
(set-frame-parameter (selected-frame) 'alpha '(85 70))                 ; transparência
(set-face-attribute 'default nil :font "Fira Code Retina" :height 115) ; fonte

;;; TECLAS
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; ESQ fecha prompts
(global-set-key (kbd "<C-tab>") 'counsel-switch-buffer)
(global-unset-key (kbd "M-c"))
(global-unset-key (kbd "M-v"))
(global-unset-key (kbd "M-s"))
(global-unset-key (kbd "C-SPC"))

;;; PACOTES
(require 'package)

;; Repositórios de pacotes
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("elpa" . "https://elpa.gnu.org/packages/")))

;; USE-PACKAGE
;; Checa pacotes presentes na máquina
;; Inicia/Instala use package
(package-initialize)
    (setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; Refazer/Desfazer como no vim
;; Não necessário no emacs 28
(use-package undo-fu)

;; Modo vim
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
	(("s-c" . comment-line))
	(("M-v" . evil-paste-before))
	(("M-c" . evil-yank))
	(("M-z" . evil-toggle-fold))
	(("M-s" . org-toggle-checkbox))
  :init
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-keybinding nil)  ; desativa comandos no insert mode
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; Teclas do vim pra tudo
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Compleção
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-switch-buffer-map
  	 ("C-d" . ivy-switch-buffer-kill))
  :config
  (ivy-mode 1))
(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
  :config
  (setq ivy-format-function #'ivy-format-function-line)
  (setq ivy-rich-display-transformers-list
        (plist-put ivy-rich-display-transformers-list
                   'ivy-switch-buffer
                   '(:columns
                     ((ivy-rich-candidate (:width 40))
                      (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right)); retorna os indicadores de buffers
                      (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))          ; retorna informações do major mode
                      (ivy-rich-switch-buffer-project (:width 15 :face success))             ; retorna o nome do projeto usando `projectile'
                      (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))))))  ; retorna o caminho do arquivo relativo a raiz do projeto ou `default-directory' se projeto é nil
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)))

;; Menu de compleção
(use-package vertico
  :config
  (vertico-mode))

;; Previsão de cores
(use-package rainbow-mode)

;; Previsão de Teclas/Atalhos
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0)
  (setq which-key-idle-secondary-delay 0))

;; Retorna comandos sendo usados
(use-package command-log-mode)

;; Buffer de ajuda
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Indica indentação/prioridade de parenteses,etc
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;; TEMA
(load-theme 'wombat) ; tema original do emacs
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t     ; se nil, negrito é globalmente desativado
        doom-themes-enable-italic t)  ; se nil, italico é globalmente desativado
  (load-theme 'doom-solarized-dark t)
  (doom-themes-visual-bell-config)    ; ativa piscar a barra em erros
  (doom-themes-org-config))           ; melhora as fontes do org-mode

;; facilita a criação de teclas de atalho
(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))
(rune/leader-keys
  "t" '(enable-theme :which-key "escolher tema")
  "p" '(projectile-command-map :which-key "projectile")
  "r" '(rainbow-mode :which-key "rainbow mode")
  "s" '(flyspell-mode :which-key "corretor ortográfico")
  "C" '(global-command-log-mode :which-key "ativa o log de comandos")
  "c" '(clm/toggle-command-log-buffer :which-key "buffer do log de comandos"))

;; facilita o controle de projetos
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :init
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (setq projectile-switch-project-action #'projectile-dired))
(use-package counsel-projectile
 :after projectile
 :config
 (counsel-projectile-mode 1))

;; correção ortográfica
(with-eval-after-load "ispell"
  ;; uma lingua padrão deve ser configurada embora outras linguas sejam adicionadas mais abaixo
  (setenv "LANG" "pt_BR.UTF-8")          ; lingua padrão
  (setq ispell-program-name "hunspell")  ; programa utilizado
  (setq ispell-dictionary "pt_BR,en_US") ; lista de linguas
  (ispell-set-spellchecker-params)       ; isso deve ser chamado antes de adicionar multi dicionários
  (ispell-hunspell-add-multi-dic "pt_BR,en_US")
  ;; local do dicionario pessoal, caso não definida novas palavras são adicionadas ao .hunspell_pt_BR
  (setq ispell-personal-dictionary "~/.config/hunspell/hunspell_personal"))
;; caso o arquivo do dicionario pessoal não exista, essa funcionalidade não é utilizada
(unless (file-exists-p ispell-personal-dictionary)
  (write-region "" nil ispell-personal-dictionary nil 0))
(use-package flyspell-popup)
(define-key flyspell-mode-map (kbd "M-s") #'flyspell-popup-correct)

(defun orgm/org-mode-setup ()
  (org-hide-block-all)
  (visual-line-mode 1))
(use-package org
  :hook (org-mode . orgm/org-mode-setup)
  :config
  (setq org-ellipsis " "
        org-hide-emphasis-markers t))
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))
(require 'org-indent)

