;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; fonte
(setq doom-font (font-spec :family "Terminus" :size 18)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 18)
      doom-big-font (font-spec :family "Terminus" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :family "SauceCodePro Nerd Font Mono" :slant italic)
  '(font-lock-doc-face :family "SauceCodePro Nerd Font Mono" :slant italic)
  '(font-lock-warning-face :family "SauceCodePro Nerd Font Mono" :slant italic))

;; transparencia - emacs 29
;;(set-frame-parameter (selected-frame) 'alpha-background 85)
;;(add-to-list 'default-frame-alist '(alpha-background . 85))

;; desativa a modeline
(setq-default mode-line-format nil)

;; previne flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; compleção mais lenta
(after! company
  (setq company-idle-delay 0.5))

;; carregar um tema com `doom-theme' ou `load-theme'
(setq doom-theme 'blinding-dark)

;; desabilita numero de linhas
(setq display-line-numbers-type nil)

;; desativa indicação de linha atual
(remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)

;; formato e cor dos cursor em diferentes modos
(setq evil-emacs-state-cursor    '("#ffff00" box))
(setq evil-normal-state-cursor   '("#ffffff" box))
(setq evil-operator-state-cursor '("#ebcb8b" hollow))
(setq evil-visual-state-cursor   '("#ffffff" box))
(setq evil-insert-state-cursor   '("#ffffff" (bar . 2)))
(setq evil-replace-state-cursor  '("#ff0000" box))
(setq evil-motion-state-cursor   '("#ad8beb" box))

;; controle de projetos
(use-package! projectile
  :init
  (when (file-directory-p "~/code/")
    (setq projectile-project-search-path '("~/code/c/" "~/code/csharp/" "~/code/shell/" "~/code/unity/" "~/code/webpages/" "~/.config/doom/")))
  (setq projectile-switch-project-action #'projectile-dired))

;; undotree não salva backups
(with-eval-after-load 'undo-tree
  (setq undo-tree-auto-save-history nil))

;; para GPG, email, clientes, templates e snippets
(setq user-full-name "Lucas Tavares"
      user-mail-address "tavares.lassuncao@gmail.com")

;; muda systema de desfazer para o undo-tree
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

;; barra pisca em alertas
(setq visible-bell t)

;; avisa e pergunta se quer recarregar o arquivo caso ele tenha mudado em disco
(global-auto-revert-mode)
(setq global-auto-revert-non-file-buffers t)

;; terminal do systema
(setq terminal-here-linux-terminal-command 'st)

;; cursor da a volta na tela para a proxima linha
(setq-default evil-cross-lines t)

;; tamanho dos tabs
(setq-default tab-width 4)
(setq-default evil-shift-width tab-width)
(setq-default indent-tabs-mode nil)

;; correção ortográfica
(use-package! flyspell
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

;; desabilita funções incomodantes do lsp
(after! lsp-mode
  (setq lsp-enable-symbol-highlighting nil))
(after! lsp-ui
  (setq lsp-ui-sideline-enable nil
        lsp-ui-doc-enable nil)) ; desabilita docstrings, use `K'

;; adiciona o modo vimrc
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; modo simples para o sxhkd
(define-generic-mode sxhkd-mode
  '(?#)
  '("alt" "Escape" "super" "bspc" "dwmc" "herbstclient" "stumpish" "ctrl" "space" "shift" "Return" "Menu" "backslash" "slash" "comma" "period" "Tab" "Left" "Right" "Up" "Down" "Print") nil
  '("sxhkdrc") nil
  "Modo simples para o sxhkd.")

;; funções
(defun orgm/org-cycle-current-headline ()
  "Abre e fecha a header atual."
  (interactive)
  (org-cycle-internal-local))
(defun salvar-e-fechar-tudo ()
  "Salva, fecha o buffer e a janela."
  (interactive)
  (call-interactively 'save-buffer)
  (call-interactively 'kill-current-buffer)
  (call-interactively 'evil-quit))
(defun fechar-tudo ()
  "Fecha o buffer e a janela sem salvar."
  (interactive)
  (call-interactively 'kill-current-buffer)
  (call-interactively 'evil-quit))

;; macros
(fset 'comentar-e-descer-linha
   (kmacro-lambda-form [?\C-x ?\C-\; down] 0 "%d"))
(fset 'copiar-buffer
   (kmacro-lambda-form [?g ?g ?V ?G ?y] 0 "%d"))
(fset 'colar-abaixo
   (kmacro-lambda-form [?o ?\M-v] 0 "%d"))

;; desabilita teclas
(with-eval-after-load "org"
  (define-key org-mode-map (kbd "<M-up>") nil)
  (define-key org-mode-map (kbd "<M-down>") nil)
  (define-key org-mode-map (kbd "C-c C-c") nil)
  (define-key org-mode-map (kbd "<S-down>") nil)
  (define-key org-mode-map (kbd "<S-up>") nil)
  (define-key org-mode-map (kbd "<C-S-down>") nil)
  (define-key org-mode-map (kbd "<C-S-up>") nil))
(define-key evil-normal-state-map (kbd "<C-tab>") nil)
(define-key evil-normal-state-map (kbd "M-d") nil)
(define-key evil-normal-state-map (kbd "m") nil)
(define-key evil-normal-state-map (kbd "P") nil)
(define-key evil-visual-state-map (kbd "<C-tab>") nil)
(define-key evil-motion-state-map (kbd ";") nil)
(define-key flyspell-mode-map (kbd "C-M-i") nil)

;; define teclas
(define-key evil-motion-state-map "?" 'evil-ex-search-word-forward)
(define-key evil-motion-state-map ":" '+vertico/search-symbol-at-point)
(define-key evil-normal-state-map ";" '+default/search-buffer)
;; SPC t
(define-key doom-leader-toggle-map (kbd "l") 'toggle-truncate-lines)
(define-key doom-leader-toggle-map (kbd "n") 'doom/toggle-line-numbers)
(define-key doom-leader-toggle-map (kbd "h") 'hl-line-mode)
(define-key doom-leader-toggle-map (kbd "c") 'log/toggle-command-window)
(define-key doom-leader-toggle-map (kbd "r") 'rainbow-mode)
;; SPC
(define-key doom-leader-map (kbd "e b") 'eval-buffer)
(define-key doom-leader-map (kbd "e d") 'eval-defun)
(define-key doom-leader-map (kbd "e l") 'eval-last-sexp)
(define-key doom-leader-map (kbd "e r") 'eval-region)
(define-key doom-leader-map (kbd "e e") 'erc-tls)
(define-key doom-leader-map (kbd "b c") 'copiar-buffer)
(define-key doom-leader-map (kbd "b s") 'flyspell-buffer)
(define-key doom-leader-map (kbd "o l") 'org-insert-link)
(define-key doom-leader-map (kbd "o t") 'org-babel-tangle)
(define-key doom-leader-map (kbd "n") 'neotree-toggle)
(define-key doom-leader-map (kbd "P") 'projectile-command-map)
(define-key doom-leader-map (kbd "k") 'kill-current-buffer)
(define-key doom-leader-map (kbd "K") 'kill-some-buffers)
(define-key doom-leader-map (kbd "u") 'undo-tree-visualize)
(define-key doom-leader-map (kbd "w f") 'write-file)
(define-key doom-leader-map (kbd "w w") 'save-buffer)
(define-key doom-leader-map (kbd "w q") 'salvar-e-fechar-tudo)
(define-key doom-leader-map (kbd "q q") 'fechar-tudo)
(define-key doom-leader-map (kbd "RET") 'terminal-here-launch)
;; move entre partes da mesma linha
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "m") 'evil-execute-macro)
(define-key evil-normal-state-map (kbd "p") '+evil/alt-paste)
(define-key evil-normal-state-map (kbd "P") 'colar-abaixo)
;; globais
(global-set-key (kbd "C-c C-c") 'comentar-e-descer-linha)
(global-set-key (kbd "C-s") 'evil-mc-make-all-cursors)
(global-set-key (kbd "<C-S-down>") 'evil-mc-make-and-goto-next-match)
(global-set-key (kbd "<C-S-up>") 'evil-mc-make-and-goto-prev-match)
(global-set-key (kbd "<C-down>") 'evil-mc-skip-and-goto-next-match)
(global-set-key (kbd "<C-up>") 'evil-mc-skip-and-goto-prev-match)
(global-set-key (kbd "M-c") 'evil-yank)
(global-set-key (kbd "M-v") '+evil/alt-paste)
(global-set-key (kbd "M-d") 'org-babel-demarcate-block)
(global-set-key (kbd "C-M-i") 'orgm/org-cycle-current-headline)
(global-set-key (kbd "<S-up>") 'er/expand-region)
(global-set-key (kbd "<S-down>") 'er/contract-region)
(global-set-key (kbd "<M-tab>") 'next-buffer)
(global-set-key (kbd "<C-tab>") 'evil-window-next)
(global-set-key (kbd "<C-M-right>") 'evil-window-vsplit)
(global-set-key (kbd "<C-M-down>") 'evil-window-split)

;; erc
(setq erc-prompt (lambda () (concat "[" (buffer-name) "]"))
      erc-server "irc.libera.chat"
      erc-nick "lucas_tavares"
      erc-user-full-name "Lucas Tavares"
      erc-track-shorten-start 24
      erc-autojoin-channels-alist '(("irc.libera.chat" "#unixtube" "#stumpwm"))
      erc-kill-buffer-on-part t
      erc-fill-column 100
      erc-fill-function 'erc-fill-static
      erc-auto-query 'bury ; reconecta a canais irc de fundo
      erc-fill-static-center 20)

;; neotree
(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))

;; popup que retorna comandos sendo usados
(use-package! command-log-mode
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
            :internal-border-color "#ffffff"
            :override-parameters '((parent-frame . nil)))))))

;; Markdown ;;
;; headers variam de tamanho
(custom-set-faces
  '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
  '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.1))))
  '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 0.95))))
  '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 0.9))))
  '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 0.9))))
  '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 0.9)))))

;; Orgmode ;;
(after! org
  (setq org-ellipsis "  "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-item-bullet-alist '((?+ . ?➤) (?- . ?✦))
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-startup-indented nil
        org-hide-leading-stars t
        org-confirm-babel-evaluate nil ; Não pergunta antes de avaliar
        org-edit-src-content-indentation 0 ; Indentação nos blocos de código
        org-table-convert-region-max-lines 20000))

(defun lt/org-fonts ()
    "Define o tamanho de fontes orgmode"
        ;; headers variam de tamanho
        (dolist (face '((org-level-1 . 1.1)
                        (org-level-2 . 1.0)
                        (org-level-3 . 1.0)
                        (org-level-4 . 1.1)
                        (org-level-5 . 1.0)
                        (org-level-6 . 1.0)
                        (org-level-7 . 1.0)
                        (org-level-8 . 1.0)))
                (set-face-attribute (car face) nil :font "Ubuntu" :weight 'regular :height (cdr face))))
(add-hook 'org-mode-hook 'lt/org-fonts)

(require 'org-indent)
;; snippets para templates de código
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
(use-package! org-make-toc
  :hook (org-mode . org-make-toc-mode))

;; pergunta se quer separar apos salvar arquivos org
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook (lambda ()(if (y-or-n-p "Tangle?")(org-babel-tangle))) nil t)))
