;;; mycompletion.el -*- lexical-binding: t; -*-
;;; Ui
(use-package vertico
  :straight (vertico :includes vertico-directory
                     :files (:defaults "extensions/vertico-directory.el"
                                       "extensions/vertico-multiform.el"))
  :init
  (vertico-mode)
  (vertico-multiform-mode)
  (setq vertico-multiform-categories
        '((symbol (vertico-sort-function . vertico-sort-alpha))
          (file (vertico-sort-function . sort-directories-first))))
  (setq vertico-multiform-commands
        '((describe-symbol (vertico-sort-function . vertico-sort-alpha))))
  ;; mostra diretórios antes de arquivos
  (defun sort-directories-first (files)
    (setq files (vertico-sort-history-length-alpha files))
    (nconc (seq-filter (lambda (x) (string-suffix-p "/" x)) files)
           (seq-remove (lambda (x) (string-suffix-p "/" x)) files)))
  ;; prefixa candidato selecionado com uma seta
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand prefix suffix index _start)
                (setq cand (funcall orig cand prefix suffix index _start))
                (concat
                 (if (= vertico--index index)
                     (propertize "> " 'face 'vertico-current)
                   "")
                 cand)))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; descrições no mini-buffer
(use-package marginalia
  :config (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init (marginalia-mode))

;; descrições em popups
(use-package corfu-doc
  :hook (corfu-mode . corfu-doc-mode))

;; adiciona icones ao corfu
(use-package kind-icon
  :after (corfu)
  :custom (kind-icon-default-face 'corfu-default)
  :config (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;;; Funções no mini-buffer
(use-package consult
  :config
  (setq completion-in-region-function #'consult-completion-in-region
        consult-buffer-sources '(consult--source-hidden-buffer consult--source-modified-buffer
                                                               consult--source-buffer consult--source-project-buffer)
        consult-preview-key nil)) ; desativa previsão consult

;; Lida com diretórios usando consult
(use-package consult-dir)

;;; Ordenar items
(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

;; adiciona vários tipos de compleções
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  ;; completação não-intrusiva
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify))

;;; popups
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.5)
  (corfu-cycle t)
  (corfu-preselect-first nil)
  (corfu-echo-documentation 0.25)
  :config
  (set-face-attribute 'corfu-current nil :background "#007")
  (set-face-attribute 'corfu-default nil :background "#000")
  (set-face-attribute 'corfu-border nil :background "#fff")
  :init (global-corfu-mode))

(provide 'mycompletion)
;;; mycompletion.el ends here
