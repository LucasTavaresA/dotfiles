;;; mykeys.el -*- lexical-binding: t; -*-
;;; SPC
(defalias 'spc-map (make-sparse-keymap))
(defvar spc-map (symbol-function 'spc-map))
(define-key spc-map (kbd "SPC") 'consult-recent-file)
(define-key spc-map (kbd "d") 'consult-dir)
(define-key spc-map (kbd "k") 'kill-current-buffer)
(define-key spc-map (kbd "K") 'kill-some-buffers)
(define-key spc-map (kbd "l") 'inserir-link)
(define-key spc-map (kbd "u") 'undo-tree-visualize)
(define-key spc-map (kbd ";") 'eval-expression)
(define-key spc-map (kbd "RET") 'terminal-here)
(define-key spc-map (kbd "<up>") 'windmove-up)
(define-key spc-map (kbd "<down>") 'windmove-down)
(define-key spc-map (kbd "<left>") 'windmove-left)
(define-key spc-map (kbd "<right>") 'windmove-right)
(define-key spc-map (kbd "<next>") #'flymake-goto-next-error)
(define-key spc-map (kbd "<prior>") #'flymake-goto-prev-error)
(define-key spc-map (kbd "b c") 'copiar-buffer)
(define-key spc-map (kbd "b b") 'consult-bookmark)
(define-key spc-map (kbd "b m") 'bookmark-set)
(define-key spc-map (kbd "b d") 'bookmark-delete)
(define-key spc-map (kbd "f b") 'flyspell-buffer)
(define-key spc-map (kbd "f f") 'find-file)
(define-key spc-map (kbd "f F") 'consult-find)
(define-key spc-map (kbd "i i") 'aggressive-indent-indent-defun)
(define-key spc-map (kbd "s l") 'consult-locate)
(define-key spc-map (kbd "s f") 'consult-flymake)
(define-key spc-map (kbd "s s") 'consult-focus-lines)
(define-key spc-map (kbd "s g") 'consult-git-grep)
(define-key spc-map (kbd "s G") 'consult-grep)
(define-key spc-map (kbd "v v") 'consult-imenu)
(define-key spc-map (kbd "v V") 'ver-headings)
(define-key spc-map (kbd "w w") 'save-buffer)
(define-key spc-map (kbd "w q") 'evil-save-and-quit)
(define-key spc-map (kbd "q q") 'evil-quit)
;;; SPC g
(defalias 'g-map (make-sparse-keymap))
(defvar g-map (symbol-function 'g-map))
(define-key spc-map (kbd "g") 'g-map)
(define-key g-map (kbd "g") 'magit-status)
(define-key g-map (kbd "l") 'git-link)
;;; SPC c
(defalias 'c-map (make-sparse-keymap))
(defvar c-map (symbol-function 'c-map))
(define-key spc-map (kbd "c") 'c-map)
(define-key c-map (kbd "c") 'compile)
;;; SPC h
(defalias 'h-map (make-sparse-keymap))
(defvar h-map (symbol-function 'h-map))
(define-key spc-map (kbd "h") 'h-map)
(define-key h-map (kbd "a") 'consult-apropos)
(define-key h-map (kbd "b") 'describe-bindings)
(define-key h-map (kbd "M") 'consult-man)
(define-key h-map (kbd "m") 'describe-mode)
(define-key h-map (kbd "K") 'describe-keymap)
(define-key h-map (kbd "k") 'describe-key)
(define-key h-map (kbd "v") 'describe-variable)
(define-key h-map (kbd "f") 'describe-function)
(define-key h-map (kbd "F") 'describe-face)
(define-key h-map (kbd "c") 'describe-command)
(define-key h-map (kbd "p") 'describe-package)
;;; SPC e
(defalias 'e-map (make-sparse-keymap))
(defvar e-map (symbol-function 'e-map))
(define-key spc-map (kbd "e") 'e-map)
(define-key e-map (kbd "t") (lambda () (interactive) (find-file "~/.config/emacs/etc/templates")))
(define-key e-map (kbd "e") 'eval-defun)
(define-key e-map (kbd "b") 'aval-buffer)
(define-key e-map (kbd "r") 'aval-region)
(define-key e-map (kbd "E") 'edebug-mode)
;;; evil-insert-state-map
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;;; evil-motion-state-map
(define-key evil-motion-state-map (kbd "SPC") 'spc-map)
(define-key evil-motion-state-map "?" (lambda () (interactive) (evil-ex-search-word-forward nil (thing-at-point 'symbol))))
(define-key evil-motion-state-map "|" (lambda () (interactive) (consult-line (thing-at-point 'symbol))))
(define-key evil-motion-state-map (kbd "C-M-i") 'completion-at-point)
(define-key evil-motion-state-map (kbd "K") 'helpful-at-point)
(define-key evil-motion-state-map (kbd "M") 'evil-record-macro)
;;; evil-normal-state-map
(define-key evil-normal-state-map (kbd "C-.") #'flyspell-correct-wrapper)
(define-key evil-normal-state-map (kbd "m") 'evil-execute-macro)
(define-key evil-normal-state-map (kbd "p") 'evil-colar)
(define-key evil-normal-state-map (kbd "P") 'evil-collection-unimpaired-paste-below)
(define-key evil-normal-state-map "\\" 'consult-line)
(define-key evil-normal-state-map (kbd "q") nil)
;;; outshine-mode-map
(define-key outshine-mode-map (kbd "M-<up>") nil)
(define-key outshine-mode-map (kbd "M-<down>") nil)
;;; toggles
(define-key evil-normal-state-map (kbd "z n") (lambda () (interactive) (if display-line-numbers (setq display-line-numbers nil)
                                                                    (setq display-line-numbers t))))
(define-key evil-normal-state-map (kbd "z v") 'visible-mode)
(define-key evil-normal-state-map (kbd "z c") 'obvious-mode)
(define-key evil-normal-state-map (kbd "z l") 'log/toggle-command-window)
(define-key evil-normal-state-map (kbd "z t") 'toggle-truncate-lines)
(define-key evil-normal-state-map (kbd "z h") 'hl-line-mode)
(define-key evil-normal-state-map (kbd "z f") 'flycheck-mode)
(define-key evil-normal-state-map (kbd "z s") 'flyspell-mode)
(define-key evil-normal-state-map (kbd "z r") 'rainbow-mode)
(define-key evil-motion-state-map (kbd "z x") 'marcar-checkbox)
(define-key evil-normal-state-map (kbd "z z") 'evil-toggle-fold)
(define-key evil-normal-state-map (kbd "Z Z") 'evil-scroll-line-to-center)
;;; dired-mode-map
(define-key dired-mode-map (kbd "SPC") 'spc-map)
(define-key dired-mode-map (kbd "<normal-state> SPC") 'spc-map)
;;; minibuffer-local-map
(define-key minibuffer-local-map (kbd "C-<tab>") #'vertico-next)
(define-key minibuffer-local-map (kbd "<backtab>") #'vertico-previous)
;;; minibuffer-local-completion-map
(define-key minibuffer-local-map (kbd "C-.") 'consult-dir-jump-file)
;;; Vertico-mode-map
(define-key vertico-map "?" #'minibuffer-completion-help)
(define-key vertico-map (kbd "RET") #'vertico-directory-enter)
(define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
;;; Outline-mode-map
(define-key outline-mode-map (kbd "<normal-state> z l") nil)
(define-key outline-mode-map (kbd "<normal-state> M-<return>") nil)
;;; tempel-map
(define-key tempel-map (kbd "<backtab>") 'tempel-next)
;;; corfu-map
(define-key corfu-map (kbd "TAB") 'corfu-next)
(define-key corfu-map (kbd "<tab>") 'corfu-next)
(define-key corfu-map (kbd "C-M-i") 'corfu-next)
(define-key corfu-map (kbd "S-TAB") 'corfu-previous)
(define-key corfu-map (kbd "<backtab>") 'corfu-previous)
(define-key corfu-map (kbd "<up>") 'evil-previous-line)
(define-key corfu-map (kbd "<down>") 'evil-next-line)
(define-key corfu-map (kbd "E") 'tempel-expand)
;;; edebug-mode-map
(define-key edebug-mode-map (kbd "Q") 'edebug-mode)
;;; forge-topic-mode-map
(define-key forge-topic-mode-map (kbd "R") 'code-review-forge-pr-at-point)
;;; global
(fset 'comentar-e-descer-linha
      (kmacro-lambda-form [?, ?c ?i down] 0 "%d"))
(global-set-key (kbd "C-c C-c") 'comentar-e-descer-linha)
(global-set-key (kbd "C-<tab>") 'consult-buffer)
(global-set-key (kbd "C-s") 'evil-mc-make-all-cursors)
(global-set-key (kbd "M-c") 'evil-yank)
(global-set-key (kbd "M-v") 'evil-colar)
(global-set-key (kbd "M-e") 'tempel-expand)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") 'text-scale-adjust)
(global-set-key (kbd "<C-S-down>") 'evil-mc-make-and-goto-next-match)
(global-set-key (kbd "<C-down>") 'evil-mc-skip-and-goto-next-match)
(global-set-key (kbd "<C-S-up>") 'evil-mc-make-and-goto-prev-match)
(global-set-key (kbd "<C-up>") 'evil-mc-skip-and-goto-prev-match)
(global-set-key (kbd "<S-up>") 'er/expand-region)
(global-set-key (kbd "<S-down>") 'er/contract-region)
(global-set-key (kbd "<C-M-right>") 'evil-window-vsplit)
(global-set-key (kbd "<C-M-down>") 'evil-window-split)
(global-set-key (kbd "<M-up>") 'drag-stuff-up)
(global-set-key (kbd "<M-down>") 'drag-stuff-down)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;;; org-mode
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "<M-up>") nil)
  (define-key org-mode-map (kbd "<M-down>") nil)
  (define-key org-mode-map (kbd "C-c C-c") nil)
  (define-key org-mode-map (kbd "<S-down>") nil)
  (define-key org-mode-map (kbd "<S-up>") nil)
  (define-key org-mode-map (kbd "<C-S-down>") nil)
  (define-key org-mode-map (kbd "<C-S-up>") nil)
  (define-key org-mode-map (kbd "b t") 'org-babel-tangle)
  (define-key org-mode-map (kbd "M-d") 'org-babel-demarcate-block))

(provide 'mykeys)
;;; mykeys.el ends here
