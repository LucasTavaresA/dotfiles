;;; myevil.el -*- lexical-binding: t; -*-
;;; evil
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

;;; teclas evil para vários modos
(use-package evil-collection
  :after (evil)
  :init (evil-collection-init)
  (setq forge-add-default-bindings nil))

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
(defun evil-colar ()
  "Chama `evil-paste-after' porem inverte `evil-kill-on-visual-paste'.

isso cola o item sem copiar texto selecionado, tambem cola antes do cursor no modo de inserção."
  (interactive)
  (let ((evil-kill-on-visual-paste (not evil-kill-on-visual-paste)))
    (if (evil-insert-state-p)
        (call-interactively #'evil-paste-before)
      (call-interactively #'evil-paste-after))))

;;;; evil-mc sai com ESC
;; copiado do doom emacs
(defvar evil-escape-hook nil
  "A hook run when C-g is pressed (or ESC in normal mode, for evil users).
all hooks after it are ignored.")
(defun evil-escape (&optional interactive)
  "Run `evil-escape-hook'."
  (interactive (list 'interactive))
  (cond ((minibuffer-window-active-p (minibuffer-window))
         ;; quit the minibuffer if open.
         (when interactive
           (setq this-command 'abort-recursive-edit))
         (abort-recursive-edit))
        ;; run all escape hooks. If any returns non-nil, then stop there.
        ((run-hook-with-args-until-success 'evil-escape-hook))
        ;; don't abort macros
        ((or defining-kbd-macro executing-kbd-macro) nil)
        ;; back to the default
        ((unwind-protect (keyboard-quit)
           (when interactive
             (setq this-command 'keyboard-quit))))))
(add-hook 'evil-escape-hook
          (defun +multiple-cursors-escape-multiple-cursors-h ()
            "Clear evil-mc cursors and restore state."
            (when (evil-mc-has-cursors-p)
              (evil-mc-undo-all-cursors)
              (evil-mc-resume-cursors)
              t)))
(defun +evil-escape-a (&rest _)
  "Call `evil-escape' if `evil-force-normal-state' is called interactively."
  (when (called-interactively-p 'any)
    (call-interactively #'evil-escape)))
(advice-add #'evil-force-normal-state :after #'+evil-escape-a)

;;;; evil-search não da erro quando palavra não é encontrada
(defun evil-ex-start-search (direction count)
  "Start a new search in a certain DIRECTION."
  ;; store buffer and window where the search started
  (let ((evil-ex-current-buffer (current-buffer)))
    (setq evil-ex-search-count count
          evil-ex-search-direction direction
          evil-ex-search-start-point (point)
          evil-ex-last-was-search t)
    (progn
      ;; ensure minibuffer is initialized accordingly
      (add-hook 'minibuffer-setup-hook #'evil-ex-search-start-session)
      ;; read the search string
      (let* ((minibuffer-local-map evil-ex-search-keymap)
             (search-string
              (condition-case err
                  (minibuffer-with-setup-hook
                      #'evil-ex-search-setup
                    (read-string (if (eq evil-ex-search-direction 'forward)
                                     "/" "?")
                                 (and evil-ex-search-history
                                      (propertize
                                       (car evil-ex-search-history)
                                       'face 'shadow))
                                 'evil-ex-search-history))
                (quit
                 (evil-ex-search-stop-session)
                 (evil-ex-delete-hl 'evil-ex-search)
                 (goto-char evil-ex-search-start-point)
                 (signal (car err) (cdr err))))))
        ;; pattern entered successful
        (goto-char (if (eq evil-ex-search-direction 'forward)
                       (1+ evil-ex-search-start-point)
                     (1- evil-ex-search-start-point)))
        (let* ((result
                (evil-ex-search-full-pattern search-string
                                             evil-ex-search-count
                                             evil-ex-search-direction))
               (success (pop result))
               (pattern (pop result))
               (offset (pop result)))
          (setq evil-ex-search-pattern pattern
                evil-ex-search-offset offset)
          (cond
           ((memq success '(t wrap))
            (goto-char (match-beginning 0))
            (setq evil-ex-search-match-beg (match-beginning 0)
                  evil-ex-search-match-end (match-end 0))
            (evil-ex-search-goto-offset offset)
            (evil-push-search-history search-string (eq direction 'forward))
            (when (and (not evil-ex-search-incremental) evil-ex-search-highlight-all)
              (evil-ex-search-activate-highlight pattern))
            (when (and evil-ex-search-incremental (not evil-ex-search-persistent-highlight))
              (evil-ex-delete-hl 'evil-ex-search)))
           (t
            (goto-char evil-ex-search-start-point)
            (evil-ex-delete-hl 'evil-ex-search))))))))

(provide 'myevil)
;;; myevil.el ends here
