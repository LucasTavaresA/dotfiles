;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; Ativa debug em erros
(toggle-debug-on-error)

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

;; ativa a awesome-tray e desativa a modeline
(awesome-tray-mode 1)
(setq awesome-tray-date-format "%a %d/%m/%Y - %H:%M"
      awesome-tray-git-format "%b%2s"
      awesome-tray-file-path-show-filename t
      awesome-tray-file-path-full-dirname-levels 1
      awesome-tray-file-path-truncate-dirname-levels 2
      awesome-tray-separator ""
      awesome-tray-essential-modules '("┃ " "file-path" " ┃ " "git" " ┃ " "date")
      awesome-tray-active-modules    '("┃ " "file-path" " ┃ " "git" " ┃ " "date"))
(global-hide-mode-line-mode)

;; previne flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; compleção mais lenta
(after! company
  (setq company-idle-delay 0.5))

;; carregar um tema com `doom-theme' ou `load-theme'
(load-theme 'doom-outrun-electric t)
(set-face-attribute 'default nil :background "#000")
(set-face-attribute 'default nil :foreground "#fff")
(set-face-attribute 'region nil :background "#007")
(set-face-attribute 'awesome-tray-default-face nil :foreground "#BA45A3")

;; desabilita numero de linhas
(setq display-line-numbers-type nil)
;; desativa indicação de linha atual
(remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)
;; ativa indicação de indentação em código
(setq whitespace-style '(face tabs spaces space-mark trailing space-before-tab big-indent
                              indentation empty space-after-tab tab-mark missing-newline-at-eof))
(global-whitespace-mode +1)

;; formato e cor do cursor em diferentes modos
(setq evil-emacs-state-cursor    '("#ffff00" box)
      evil-normal-state-cursor   '("#ffffff" box)
      evil-operator-state-cursor '("#ebcb8b" hollow)
      evil-visual-state-cursor   '("#ffffff" box)
      evil-insert-state-cursor   '("#ffffff" (bar . 2))
      evil-replace-state-cursor  '("#ff0000" box)
      evil-motion-state-cursor   '("#ad8beb" box))

;; undotree não salva backups
(with-eval-after-load 'undo-tree
  (setq undo-tree-auto-save-history nil))

;; para GPG, email, clientes, templates e snippets
(setq user-full-name "Lucas Tavares"
      user-mail-address "tavares.lassuncao@gmail.com")

;; diretório de snippets
(setq yas-snippet-dirs '("~/.config/doom/snippets"))

;; muda systema de desfazer para o undo-tree
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

;; barra pisca em alertas
(setq visible-bell nil)

;; avisa e pergunta se quer recarregar o arquivo caso ele tenha mudado em disco
(global-auto-revert-mode)
(setq global-auto-revert-non-file-buffers t)

;; terminal do sistema
(setq terminal-here-linux-terminal-command 'st)

;; cursor da a volta na tela para a proxima linha
(setq-default evil-cross-lines t)

;; tamanho dos tabs
(setq-default tab-width 4
              evil-shift-width tab-width
              indent-tabs-mode nil)

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

;; ativa indentação globalmente
(global-aggressive-indent-mode 1)

;; adiciona o modo vimrc
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; modo simples para o sxhkd
(define-generic-mode sxhkd-mode
  '(?#)
  '("alt" "Escape" "super" "bspc" "dwmc" "herbstclient" "stumpish" "ctrl" "space" "shift" "Return" "Menu" "backslash" "slash" "comma" "period" "Tab" "Left" "Right" "Up" "Down" "Print") nil
  '("sxhkdrc") nil
  "Modo simples para o sxhkd.")

;; funções
(defun salvar-e-fechar-buffer ()
  "Salvar e fechar buffer e a janela."
  (interactive)
  (call-interactively 'save-buffer)
  (call-interactively 'kill-current-buffer)
  (call-interactively 'evil-quit))
(defun fechar-buffers ()
  "Fecha todos os buffers e janelas."
  (interactive)
  (setq list (buffer-list))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (and name
       (not (string-equal name ""))
       (/= (aref name 0) ?\s)
       (kill-buffer buffer)))
    (setq list (cdr list)))
  (call-interactively 'evil-quit))
(defun elisp-view ()
  (interactive)
  (call-interactively (occur "^;;;;* \\|^(")))

;; macros
(fset 'comentar-e-descer-linha
      (kmacro-lambda-form [?\C-x ?\C-\; down] 0 "%d"))
(fset 'copiar-buffer
      (kmacro-lambda-form [?g ?g ?V ?G ?y] 0 "%d"))
(fset 'colar-abaixo
      (kmacro-lambda-form [?o ?\M-v escape] 0 "%d"))

;; desabilita teclas
(with-eval-after-load "org"
  (defun orgm/org-cycle-current-headline ()
    "Abre e fecha a header atual."
    (interactive)
    (org-cycle-internal-local))
  (global-set-key (kbd "C-M-i") 'orgm/org-cycle-current-headline)
  (global-set-key (kbd "M-d") 'org-babel-demarcate-block)
  (define-key spc-map (kbd "l") 'org-insert-link)
  (define-key spc-map (kbd "b t") 'org-babel-tangle)
  ;; desativa teclas
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
(define-key evil-motion-state-map (kbd "|") nil)
(define-key evil-motion-state-map (kbd "\\") nil)
(define-key flyspell-mode-map (kbd "C-M-i") nil)
(define-key global-map (kbd "<Menu>") nil)

;; define teclas
(define-key evil-motion-state-map "?" 'evil-ex-search-word-forward)
(define-key evil-motion-state-map "|" '+vertico/search-symbol-at-point)
(define-key evil-normal-state-map "\\" '+default/search-buffer)
;; SPC t
(define-key doom-leader-toggle-map (kbd "l") 'toggle-truncate-lines)
(define-key doom-leader-toggle-map (kbd "n") 'doom/toggle-line-numbers)
(define-key doom-leader-toggle-map (kbd "h") 'hl-line-mode)
(define-key doom-leader-toggle-map (kbd "c") 'log/toggle-command-window)
(define-key doom-leader-toggle-map (kbd "r") 'rainbow-mode)
(define-key doom-leader-toggle-map (kbd "f") 'flyspell-mode)
;; SPC
(define-key doom-leader-map (kbd "e b") 'eval-buffer)
(define-key doom-leader-map (kbd "e e") 'eval-defun)
(define-key doom-leader-map (kbd "e r") 'eval-region)
(define-key doom-leader-map (kbd "e v") 'elisp-view)
(define-key doom-leader-map (kbd "i i") 'sp-indent-defun)
(define-key doom-leader-map (kbd "b c") 'copiar-buffer)
(define-key doom-leader-map (kbd "b s") 'flyspell-buffer)
(define-key doom-leader-map (kbd "b b") 'consult-bookmark)
(define-key doom-leader-map (kbd "k") 'kill-current-buffer)
(define-key doom-leader-map (kbd "K") 'kill-some-buffers)
(define-key doom-leader-map (kbd "u") 'undo-tree-visualize)
(define-key doom-leader-map (kbd "w w") 'save-buffer)
(define-key doom-leader-map (kbd "w q") 'salvar-e-fechar-buffer)
(define-key doom-leader-map (kbd "q q") 'fechar-buffers)
(define-key doom-leader-map (kbd "RET") 'terminal-here-launch)
(define-key doom-leader-map (kbd "<up>") 'windmove-up)
(define-key doom-leader-map (kbd "<down>") 'windmove-down)
(define-key doom-leader-map (kbd "<left>") 'windmove-left)
(define-key doom-leader-map (kbd "<right>") 'windmove-right)
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
(global-set-key (kbd "<S-up>") 'er/expand-region)
(global-set-key (kbd "<S-down>") 'er/contract-region)
(global-set-key (kbd "<C-tab>") 'next-buffer)
(global-set-key (kbd "<C-M-right>") 'evil-window-vsplit)
(global-set-key (kbd "<C-M-down>") 'evil-window-split)

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
             :internal-border-color "#BA45A3"
             :override-parameters '((parent-frame . nil)))))))

;; Markdown ;;
(with-eval-after-load 'markdown-mode
  (define-key spc-map (kbd "l") 'markdown-insert-link))
;; headers variam de tamanho
(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.1))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 0.95))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 0.9))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 0.9))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 0.9)))))

;; Orgmode ;;
(require 'org-indent)
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
        org-table-convert-region-max-lines 20000)

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

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config (setq org-auto-tangle-default t))

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
  :hook (org-mode . org-make-toc-mode)))
