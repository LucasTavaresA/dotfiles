;;; mycompletion.el -*- lexical-binding: t; -*-
;;; ui
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

;;; descrições no mini-buffer
(use-package marginalia
  :config (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init (marginalia-mode))

;;; varias funções no mini-buffer
(use-package consult
  :config
  (setq completion-in-region-function #'consult-completion-in-region
        consult-preview-key nil)) ; desativa previsão consult

;;; procura items usando "fuzzy find"
(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

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

;;; descrições em popups
(use-package corfu-doc
  :hook (corfu-mode . corfu-doc-mode))

;;; adiciona vários tipos de compleções
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  ;; completação não-intrusiva
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify))

(provide 'mycompletion)
;;; mycompletion.el ends here
