;;; mymarkup.el -*- lexical-binding: t; -*-
;;; Org mode
(use-package org
  :defer t
  :hook (org-mode . aumenta-fonte)
  :init
  (setq org-ellipsis "  "
        org-startup-folded 'content
        org-return-follows-link t
        org-mouse-1-follows-link t
        org-descriptive-links t
        org-hide-emphasis-markers t
        org-confirm-babel-evaluate nil
        org-src-fontify-natively t  ; formatação em código fonte
        org-src-tab-acts-natively t ; tab em código fonte
        org-startup-indented t      ; carrega o org-indent ao iniciar
        org-hide-leading-stars t           ; mostra asteriscos das headers
        org-edit-src-content-indentation 2 ; Indentação nos blocos de código
        org-table-convert-region-max-lines 20000)
  ;; remove asteriscos de headings
  (font-lock-add-keywords 'org-mode `(("^\\(\\*+ \\)\\s-*\\S-"
                                       (1 (put-text-property (match-beginning 1) (match-end 1) 'invisible t)
                                          nil))))
  ;; Trocar listas com hifens por pontos
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  :config
  ;; ativa blocos em varias linguagens
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (js . t)
     (shell . t)
     (python . t)
     (makefile . t)
     (org . t)
     (C . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes)
  ;; headers variam de tamanho
  (dolist (face '((org-level-1 . 1.3)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.0)
                  (org-level-4 . 0.9)
                  (org-level-5 . 0.9)
                  (org-level-6 . 0.9)
                  (org-level-7 . 0.9)
                  (org-level-8 . 0.9)))
    (set-face-attribute (car face) nil :font "Ubuntu" :weight 'regular :height (cdr face) :background nil)))
;; esconde marcação
(use-package org-appear
  :after (org)
  :config
  (setq org-appear-autolinks t
        org-appear-autosubmarkers t
        org-appear-autoentities t
        org-appear-autokeywords t)
  :hook (org-mode . org-appear-mode))
;; tangle automático
(use-package org-auto-tangle
  :after (org)
  :hook (org-mode . org-auto-tangle-mode)
  :config (setq org-auto-tangle-default nil))
;; cria sumários automaticamente
(use-package org-make-toc
  :after (org))

;;; Markdown
(use-package markdown-mode
  :init
  ;; Trocar listas com hifens por pontos
  (font-lock-add-keywords 'gfm-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  :hook (((gfm-mode markdown-mode) . aumenta-fonte)
         ((gfm-mode markdown-mode) . markdown-esconde-marcação))
  :config
  (dolist (face '((markdown-header-face-1 . 1.3)
                  (markdown-header-face-2 . 1.1)
                  (markdown-header-face-3 . 1.0)
                  (markdown-header-face-4 . 0.9)
                  (markdown-header-face-5 . 0.9)
                  (markdown-header-face-6 . 0.9)))
    (set-face-attribute (car face) nil :font "Ubuntu" :weight 'regular :height (cdr face)))
  :mode ("\\.md\\'" . gfm-mode))
;; faz sumários automaticamente
(use-package markdown-toc
  :after (gfm-mode markdown-mode)
  :hook ((gfm-mode markdown-mode) . markdown-toc))

;;; Funções
(defun inserir-link ()
  "insere link dependendo do major-mode"
  (interactive)
  (cond ((string= major-mode "org-mode") (org-insert-link))
        ((string= major-mode "gfm-mode") (markdown-insert-link))))

(defun marcar-checkbox ()
  "marca checkbox dependendo do major-mode"
  (interactive)
  (cond ((string= major-mode "org-mode") (org-toggle-checkbox))
        ((string= major-mode "gfm-mode") (markdown-toggle-gfm-checkbox))))

(defun ver-headings ()
  "ve as headings dependendo do major-mode"
  (interactive)
  (cond ((string= major-mode "org-mode") (consult-org-heading))
        (t (consult-outline))))

(defun aumenta-fonte ()
  "Aumenta o tamanho da fonte."
  (text-scale-set 2))

(defun markdown-esconde-marcação ()
  "Esconde marcação em markdown."
  (markdown-toggle-markup-hiding))

(provide 'mymarkup)
;;; mymarkup.el ends here
