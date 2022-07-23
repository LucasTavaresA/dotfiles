;;; myedit.el -*- lexical-binding: t; -*-
;;; templates
(use-package tempel
  :init
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)
  :config (setq tempel-path "/home/lucas/.config/emacs/etc/templates"))

;;; expande região selecionada
(use-package expand-region)

;;; move linhas
(use-package drag-stuff)

;;; Evil
(use-package evil
  :init
  (setq-default evil-cross-lines t ; da a volta para a proxima linha
                ;; tabs > espaços
                tab-width 4
                evil-shift-width tab-width
                indent-tabs-mode nil)
  (setq evil-respect-visual-line-mode t
        evil-undo-system 'undo-tree
        evil-split-window-below t  ; foca em novas splits
        evil-vsplit-window-right t
        evil-want-Y-yank-to-eol t
        evil-want-fine-undo t      ; desfazer em passos menores
        evil-want-keybinding nil   ; desabilitado em prol do evil-collection
        ;; formato e cor do cursor em diferentes modos
        evil-emacs-state-cursor    '("#ffff00" box)
        evil-normal-state-cursor   '("#ffffff" box)
        evil-operator-state-cursor '("#ebcb8b" hollow)
        evil-visual-state-cursor   '("#ffffff" box)
        evil-insert-state-cursor   '("#ffffff" (bar . 2))
        evil-replace-state-cursor  '("#ff0000" box)
        evil-motion-state-cursor   '("#ad8beb" box))
  (evil-mode 1)
  :config (evil-select-search-module 'evil-search-module 'evil-search))

;;; Teclas evil para vários modos
(use-package evil-collection
  :after (evil)
  :init (evil-collection-init)
  (setq forge-add-default-bindings nil))

;;; desfazer com timeline
(use-package undo-tree
  :after (evil)
  :init (global-undo-tree-mode)
  :config (setq undo-tree-auto-save-history nil))

;;; comenta código
(use-package evil-nerd-commenter
  :after (evil)
  :init (evilnc-default-hotkeys))

;;; cerca com parêntesis,aspas,etc.
(use-package evil-surround
  :after (evil)
  :init (global-evil-surround-mode))

;;; múltiplos cursores
(use-package evil-mc
  :after (evil)
  :init (global-evil-mc-mode))

;;; funções
(defun copiar-buffer ()
  "Copia todo o buffer"
  (interactive)
  (clipboard-kill-ring-save (point-min) (point-max)))

(defun evil-colar ()
  "Chama `evil-paste-after' porem inverte `evil-kill-on-visual-paste'.

isso cola o item sem copiar texto selecionado, tambem cola antes do cursor no modo de inserção."
  (interactive)
  (let ((evil-kill-on-visual-paste (not evil-kill-on-visual-paste)))
    (if (evil-insert-state-p)
        (call-interactively #'evil-paste-before)
      (call-interactively #'evil-paste-after))))

(provide 'myedit)
;;; myedit.el ends here
