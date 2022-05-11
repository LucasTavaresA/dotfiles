;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Fonte
(setq doom-font (font-spec :family "Terminus" :size 18)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 18)
      doom-big-font (font-spec :family "Terminus" :size 24))
(custom-set-faces!
  '(font-lock-comment-face :family "Iosevka Term" :slant italic))

;; Transparencia - emacs 29
;;(set-frame-parameter (selected-frame) 'alpha-background 85)
;;(add-to-list 'default-frame-alist '(alpha-background . 85))

;; Desativa a modeline
(setq-default mode-line-format nil)

;; Carregar um tema com `doom-theme' ou `load-theme'
(setq doom-theme 'spaceway)

;; Desabilita numero de linhas
(setq display-line-numbers-type nil)

;; Formato e cor dos cursor em diferentes modos
(setq evil-emacs-state-cursor    '("#ffff00" box))
(setq evil-normal-state-cursor   '("#ffffff" box))
(setq evil-operator-state-cursor '("#ebcb8b" hollow))
(setq evil-visual-state-cursor   '("#ffffff" box))
(setq evil-insert-state-cursor   '("#ffffff" (bar . 2)))
(setq evil-replace-state-cursor  '("#ff0000" (hbar . 4)))
(setq evil-motion-state-cursor   '("#ad8beb" box))

;; Controle de projetos
(use-package! projectile
  :init
  (when (file-directory-p "~/code/")
    (setq projectile-project-search-path '("~/code/c/" "~/code/csharp/" "~/code/shell/" "~/code/unity/" "~/code/webpages/" "~/.config/doom/")))
  (setq projectile-switch-project-action #'projectile-dired))

;; undotree não salva backups
(with-eval-after-load 'undo-tree
  (setq undo-tree-auto-save-history nil))

;; Para GPG, email, clientes, templates e snippets
(setq user-full-name "Lucas Tavares"
      user-mail-address "tavares.lassuncao@gmail.com")

;; Muda systema de desfazer para o undo-tree
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

;; Barra pisca em alertas
(setq visible-bell t)

;; Avisa e pergunta se quer recarregar o arquivo caso ele tenha mudado em disco
(global-auto-revert-mode)

;; Terminal do systema
(setq terminal-here-linux-terminal-command 'st)

;; Cursor da a volta na tela para a proxima linha
(setq-default evil-cross-lines t)

;; Tamanho dos tabs
(setq-default tab-width 4)
(setq-default evil-shift-width tab-width)
(setq-default indent-tabs-mode nil)

;; Correção ortográfica
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
  ;; Uma lingua padrão deve ser configurada embora outras linguas sejam adicionadas mais abaixo
  (setenv "LANG" "pt_BR.UTF-8")          ; lingua padrão
  (setq ispell-program-name "hunspell")  ; ferramenta uilizada
  (setq ispell-dictionary "pt_BR,en_US") ; lista de linguas
  (ispell-set-spellchecker-params)       ; isso deve ser chamado antes de adicionar multi dicionários
  (ispell-hunspell-add-multi-dic "pt_BR,en_US")
  ;; Local do dicionario pessoal, caso não definida novas palavras são adicionadas ao .hunspell_pt_BR
  (setq ispell-personal-dictionary "~/.config/hunspell/hunspell_personal"))
;; Não  carrega dicionario pessoal caso ele não exista
(unless (file-exists-p ispell-personal-dictionary)
  (write-region "" nil ispell-personal-dictionary nil 0))

;; Desabilita funções incomodantes do lsp
(after! lsp-mode
  (setq lsp-enable-symbol-highlighting nil))
(after! lsp-ui
  (setq lsp-ui-sideline-enable nil))

;; Adiciona o modo vimrc
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; Modo simples para o sxhkd
(define-generic-mode sxhkd-mode
  '(?#)
  '("alt" "Escape" "super" "bspc" "dwmc" "herbstclient" "stumpish" "ctrl" "space" "shift" "Return" "Menu" "backslash" "slash" "comma" "period" "Tab" "Left" "Right" "Up" "Down" "Print") nil
  '("sxhkdrc") nil
  "Modo simples para o sxhkd.")

;; Funções
(defun orgm/org-cycle-current-headline ()
  "Abre e fecha a header atual"
  (interactive)
  (org-cycle-internal-local))
(defun salvar-e-fechar-tudo ()
  "Salva, fecha todos os buffers e a janela."
  (interactive)
  (call-interactively 'save-buffer)
  (call-interactively 'doom/kill-all-buffers)
  (call-interactively 'evil-quit))
(defun fechar-tudo ()
  "Fecha todos os buffers e a janela"
  (interactive)
  (call-interactively 'doom/kill-all-buffers)
  (call-interactively 'evil-quit))

;; Macros
(fset 'comentar-e-descer-linha
   (kmacro-lambda-form [?\C-x ?\C-\; down] 0 "%d"))
(fset 'copiar-buffer
   (kmacro-lambda-form [?g ?g ?v ?G ?y] 0 "%d"))

;; Desabilita teclas
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
(define-key evil-visual-state-map (kbd "<C-tab>") nil)
(define-key evil-motion-state-map (kbd ";") nil)
(define-key flyspell-mode-map (kbd "C-M-i") nil)

;; Define
(define-key evil-motion-state-map "?" 'evil-ex-search-word-forward)
(define-key evil-motion-state-map ":" '+vertico/search-symbol-at-point)
(define-key evil-normal-state-map ";" '+default/search-buffer)
;; Prefixadas com espaço
(define-key doom-leader-map (kbd "c b") 'copiar-buffer)
(define-key doom-leader-map (kbd "e r") 'eval-region)
(define-key doom-leader-map (kbd "s s") 'flyspell-mode)
(define-key doom-leader-map (kbd "s b") 'flyspell-buffer)
(define-key doom-leader-map (kbd "h l") 'hl-line-mode)
(define-key doom-leader-map (kbd "l") 'org-insert-link)
(define-key doom-leader-map (kbd "L") 'log/toggle-command-window)
(define-key doom-leader-map (kbd "n") 'neotree-toggle)
(define-key doom-leader-map (kbd "P") 'projectile-command-map)
(define-key doom-leader-map (kbd "r") 'rainbow-mode)
(define-key doom-leader-map (kbd "k") 'kill-current-buffer)
(define-key doom-leader-map (kbd "K") 'kill-some-buffers)
(define-key doom-leader-map (kbd "U") 'undo-tree-visualize)
(define-key doom-leader-map (kbd "b t") 'org-babel-tangle)
(define-key doom-leader-map (kbd "w w") 'save-buffer)
(define-key doom-leader-map (kbd "w q") 'salvar-e-fechar-tudo)
(define-key doom-leader-map (kbd "q q") 'fechar-tudo)
(define-key doom-leader-map (kbd "RET") 'terminal-here-launch)
(define-key doom-leader-map (kbd "<up>") 'windmove-up)
(define-key doom-leader-map (kbd "<down>") 'windmove-down)
(define-key doom-leader-map (kbd "<left>") 'windmove-left)
(define-key doom-leader-map (kbd "<right>") 'windmove-right)
;; Move entre partes da mesma linha
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "m") 'evil-execute-macro)
;; Globais
(global-set-key (kbd "C-c C-c") 'comentar-e-descer-linha)
(global-set-key (kbd "C-s") 'evil-mc-make-all-cursors)
(global-set-key (kbd "<C-S-down>") 'evil-mc-make-and-goto-next-match)
(global-set-key (kbd "<C-S-up>") 'evil-mc-make-and-goto-prev-match)
(global-set-key (kbd "<C-down>") 'evil-mc-skip-and-goto-next-match)
(global-set-key (kbd "<C-up>") 'evil-mc-skip-and-goto-prev-match)
(global-set-key (kbd "M-c") 'evil-yank)
(global-set-key (kbd "M-v") 'evil-paste-before)
(global-set-key (kbd "M-d") 'org-babel-demarcate-block)
(global-set-key (kbd "C-M-i") 'orgm/org-cycle-current-headline)
(global-set-key (kbd "<S-up>") 'er/expand-region)
(global-set-key (kbd "<S-down>") 'er/contract-region)
(global-set-key (kbd "<C-tab>") 'next-buffer)
(global-set-key (kbd "<C-M-right>") 'evil-window-vsplit)
(global-set-key (kbd "<C-M-down>") 'evil-window-split)

;; Popup que retorna comandos sendo usados
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

;; Trocar listas com hífens por pontos
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-indent)

(setq org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-confirm-babel-evaluate nil ;; Não pergunta antes de avaliar
      org-ellipsis " v"
      org-hide-emphasis-markers t ;; Esconde marcação
      org-edit-src-content-indentation 0) ;; Indentação nos blocos de código

;; Orgmode mais rápido
(after! org
  ;; (define-key doom-leader-map (kbd "SPC") 'org-toggle-checkbox)
  (setq org-fontify-quote-and-verse-blocks nil
        org-fontify-whole-heading-line nil
        org-hide-leading-stars nil
        org-startup-indented nil))

;; Snippets para templates de código
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

;; Cria sumarios automaticamente
(use-package! org-make-toc
  :hook (org-mode . org-make-toc-mode))

;; Mostra marcação quando necessário
(use-package! org-appear
  :hook (org-mode . org-appear-mode))

;; Pergunta se quer separar apos salvar arquivos org
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook (lambda ()(if (y-or-n-p "Tangle?")(org-babel-tangle))) nil t)))
