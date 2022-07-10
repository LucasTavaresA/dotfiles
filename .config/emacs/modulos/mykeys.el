;;; mykeys.el -*- lexical-binding: t; -*-
;; spc-map
(defalias 'spc-map (make-sparse-keymap))
(defvar spc-map (symbol-function 'spc-map))
;; SPC
(define-key spc-map (kbd "SPC") 'consult-recent-file)
(define-key spc-map (kbd "k") 'kill-current-buffer)
(define-key spc-map (kbd "K") 'kill-some-buffers)
(define-key spc-map (kbd "l") 'inserir-link)
(define-key spc-map (kbd "u") 'undo-tree-visualize)
(define-key spc-map (kbd "c") 'list-colors-display)
(define-key spc-map (kbd "m") 'markdown-toggle-markup-hiding)
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
(define-key spc-map (kbd "b r") 'bookmark-delete)
(define-key spc-map (kbd "b t") 'org-babel-tangle)
(define-key spc-map (kbd "e e") 'eval-defun)
(define-key spc-map (kbd "e b") 'aval-buffer)
(define-key spc-map (kbd "e r") 'aval-region)
(define-key spc-map (kbd "f b") 'flyspell-buffer)
(define-key spc-map (kbd "f f") 'find-file)
(define-key spc-map (kbd "f F") 'consult-find)
(define-key spc-map (kbd "i i") 'aggressive-indent-indent-defun)
(define-key spc-map (kbd "s l") 'consult-locate)
(define-key spc-map (kbd "s f") 'consult-flymake)
(define-key spc-map (kbd "s g") 'consult-git-grep)
(define-key spc-map (kbd "v v") 'ver-headings)
(define-key spc-map (kbd "w w") 'save-buffer)
(define-key spc-map (kbd "w q") 'evil-save-and-quit)
(define-key spc-map (kbd "q q") 'evil-quit)
;; SPC c
;; c-map
(defalias 'c-map (make-sparse-keymap))
(defvar c-map (symbol-function 'c-map))
(define-key spc-map (kbd "c") 'c-map)
(define-key c-map (kbd "c") 'compile)
;; SPC h
;; h-map
(defalias 'h-map (make-sparse-keymap))
(defvar h-map (symbol-function 'h-map))
(define-key spc-map (kbd "h") 'h-map)
(define-key h-map (kbd "a") 'consult-apropos)
(define-key h-map (kbd "b") 'embark-bindings)
(define-key h-map (kbd "M") 'consult-man)
(define-key h-map (kbd "m") 'describe-mode)
(define-key h-map (kbd "K") 'describe-keymap)
(define-key h-map (kbd "k") 'describe-key)
(define-key h-map (kbd "v") 'describe-variable)
(define-key h-map (kbd "f") 'describe-function)
(define-key h-map (kbd "F") 'describe-face)
(define-key h-map (kbd "c") 'describe-command)
;; t-map
(defalias 't-map (make-sparse-keymap))
(defvar t-map (symbol-function 't-map))
(define-key spc-map (kbd "t") 't-map)
;; SPC t
(define-key t-map (kbd "n") (lambda () (interactive) (if display-line-numbers (setq display-line-numbers nil)
                                                  (setq display-line-numbers t))))
(define-key t-map (kbd "c") 'log/toggle-command-window)
(define-key t-map (kbd "r") 'rainbow-mode)
(define-key t-map (kbd "l") 'toggle-truncate-lines)
(define-key t-map (kbd "h") 'hl-line-mode)
(define-key t-map (kbd "f") 'flyspell-mode)
(define-key t-map (kbd "t") (lambda () (interactive) (find-file "~/.config/emacs/templates")))
;; evil-global-set-key
;; Use visual line motions mesmo fora de buffers no visual-line-mode
(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)
;; evil-insert-state-map
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;; evil-motion-state-map
(define-key evil-motion-state-map (kbd "SPC") 'spc-map)
(define-key evil-motion-state-map "?" (lambda () (interactive) (evil-ex-search-word-forward nil (thing-at-point 'symbol))))
(define-key evil-motion-state-map "|" (lambda () (interactive) (consult-line (thing-at-point 'symbol))))
(define-key evil-motion-state-map (kbd "C-M-i") 'completion-at-point)
(define-key evil-motion-state-map (kbd "K") 'helpful-at-point)
(define-key evil-motion-state-map (kbd "z x") 'marcar-checkbox)
;; evil-normal-state-map
(define-key evil-normal-state-map (kbd "C-.") 'ispell-word)
(define-key evil-normal-state-map (kbd "m") 'evil-execute-macro)
(define-key evil-normal-state-map (kbd "p") 'evil-colar)
(define-key evil-normal-state-map (kbd "P") 'evil-collection-unimpaired-paste-below)
(define-key evil-normal-state-map "\\" 'consult-line)
;; evil-mc
(define-key evil-mc-cursors-map (kbd "ESC") 'evil-mc-undo-all-cursors)
;; minibuffer
(define-key minibuffer-local-map (kbd "C-d") 'embark-act)
(define-key minibuffer-local-map (kbd "C-<tab>") #'vertico-next)
(define-key minibuffer-local-map (kbd "<backtab>") #'vertico-previous)
;; tempel-map
(define-key tempel-map (kbd "<backtab>") 'tempel-next)
;; corfu popups
(define-key corfu-map (kbd "TAB") 'corfu-next)
(define-key corfu-map (kbd "<tab>") 'corfu-next)
(define-key corfu-map (kbd "C-M-i") 'corfu-next)
(define-key corfu-map (kbd "S-TAB") 'corfu-previous)
(define-key corfu-map (kbd "<backtab>") 'corfu-previous)
(define-key corfu-map (kbd "<up>") 'evil-previous-line)
(define-key corfu-map (kbd "<down>") 'evil-next-line)
(define-key corfu-map (kbd "E") 'tempel-expand)
;; global
(fset 'comentar-e-descer-linha
      (kmacro-lambda-form [?, ?c ?i down] 0 "%d"))
(global-set-key (kbd "C-c C-c") 'comentar-e-descer-linha)
(global-set-key (kbd "C-<tab>") 'consult-buffer)
(global-set-key (kbd "C-s") 'evil-mc-make-all-cursors)
(global-set-key (kbd "M-c") 'evil-yank)
(global-set-key (kbd "M-v") 'evil-colar)
(global-set-key (kbd "M-d") 'org-babel-demarcate-block)
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
;; org-mode-map
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "<M-up>") nil)
  (define-key org-mode-map (kbd "<M-down>") nil)
  (define-key org-mode-map (kbd "C-c C-c") nil)
  (define-key org-mode-map (kbd "<S-down>") nil)
  (define-key org-mode-map (kbd "<S-up>") nil)
  (define-key org-mode-map (kbd "<C-S-down>") nil)
  (define-key org-mode-map (kbd "<C-S-up>") nil))

(provide 'mykeys)
;;; mykeys.el ends here
