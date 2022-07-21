;;; mycompletion.el -*- lexical-binding: t; -*-
;; ui
(use-package vertico
  :config (setq vertico-cycle t)
  :init (vertico-mode))
;; descrições no mini-buffer
(use-package marginalia
  :config (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init (marginalia-mode))
;; varias funções no mini-buffer
(use-package consult
  :config
  (setq completion-in-region-function #'consult-completion-in-region
        consult-preview-key nil)) ; desativa previsão consult
;; procura items usando "fuzzy find"
(use-package orderless
  :config
  (setq completion-styles '(orderless)
        completion-category-overrides '((file (styles . (partial-completion))))))
;; popups
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
;; descrições em popup
(use-package corfu-doc
  :hook (corfu-mode . corfu-doc-mode))
;; adiciona vários tipos de completações
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  ;; completação não-intrusiva
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify))

(provide 'mycompletion)
;;; mycompletion.el ends here
