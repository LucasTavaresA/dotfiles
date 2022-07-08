;;; mymisc.el -*- lexical-binding: t; -*-
;; checagens de sistema
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))

;; necessário no windows
(set-default-coding-systems 'utf-8)
(setq backup-by-copying t
      delete-old-versions t
      version-control t
      kept-new-versions 5
      backup-directory-alist `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      kept-old-versions 2
      ;; custom.el
      custom-file (expand-file-name "custom.el" user-emacs-directory)
      large-file-warning-threshold 100000000 ; considera 100MB> um arquivo grande
      whitespace-action nil ; desativa limpeza de espaços ao salvar
      use-short-answers t ; apenas confirmações com "y" e "n"
      kill-do-not-save-duplicates t ; não salva duplicadas ao copiar
      user-full-name "Lucas Tavares"
      user-mail-address "tavares.lassuncao@gmail.com"
      ;; scroll
      auto-window-vscroll nil ; diminui o stuttering do scroll
      fast-but-imprecise-scrolling t ; scroll mais rápido
      scroll-margin 1 ; distancia de onde o scroll começa
      scroll-conservatively 0 ; tolerância para centralizar cursor
      scroll-preserve-screen-position t
      ;; desativa barra piscando
      visible-bell       nil
      ring-bell-function #'ignore)
;; reverte buffer caso haja mudanças externas no arquivo
(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode 1)
;; ativa lembrar arquivos recentes
(add-hook 'after-init-hook #'recentf-mode)
(setq recentf-save-file (expand-file-name "recentf" config-var-directory))
;; torna arquivos com shebang (#!) executáveis quando salvados
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)
;; salva posição nos arquivos
(setq save-place-file (expand-file-name "save-place" config-var-directory))
(save-place-mode 1)
;; salva histórico de comandos
(savehist-mode 1)
(setq savehist-file (expand-file-name "history" config-var-directory))
(global-so-long-mode 1) ; melhora suporte para arquivos com linhas longas
(global-visual-line-mode +1) ; quebra parágrafos de acordo com as palavras
(electric-pair-mode 1) ; auto-inserir "{}()[]"
(show-paren-mode 1) ; indica parenteses

;; lista possíveis teclas de atalho
(use-package which-key
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.5))

;;; mostra cores `#fff'
(use-package rainbow-mode)
;; abre um terminal no diretório atual
(use-package terminal-here
  :config (setq terminal-here-linux-terminal-command 'st))
;; melhora `gd' para ir a definições de código
(use-package dumb-jump)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)
;; melhora buffers de ajuda
(use-package helpful
  :config
  (define-key helpful-mode-map [remap revert-buffer] #'helpful-update)
  (global-set-key [remap describe-command] #'helpful-command)
  (global-set-key [remap describe-function] #'helpful-callable)
  (global-set-key [remap describe-key] #'helpful-key)
  (global-set-key [remap describe-symbol] #'helpful-symbol)
  (global-set-key [remap describe-variable] #'helpful-variable))
;; mostra código em buffers de ajuda
(use-package elisp-demos
  :config (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))
;; popup que retorna comandos sendo usados
(use-package posframe)
(use-package command-log-mode
  :after (posframe)
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

(provide 'mymisc)
;;; mymisc.el ends here
