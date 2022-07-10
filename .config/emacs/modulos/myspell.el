;;; myspell.el -*- lexical-binding: t; -*-
(use-package flyspell
  :defer t
  :config
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
  (setq flyspell-sort-corrections nil    ; Não organizar correções por ordem alfabetiza
        flyspell-issue-message-flag nil) ; Não mandar mensagens para cada palavra errada
  :hook ((nroff-mode mu4e-compose-mode mail-mode git-commit-mode org-mode gfm-mode markdown-mode) . flyspell-mode))

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

(provide 'myspell)
;;; myspell.el ends here
