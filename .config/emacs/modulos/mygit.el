;;; mygit.el -*- lexical-binding: t; -*-
;;; miscelânea
(use-package git-modes)
(use-package git-link
  :config (setq git-link-open-in-browser t))

;;; magit
(use-package magit
  :config
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-modules
                          'magit-insert-stashes
                          'append)
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :bind (:map magit-section-mode-map
              ("<normal-state> C-<tab>" . nil)
              ("C-<tab>" . nil)))
(use-package magit-todos
  :after (magit)
  :init (magit-todos-mode))
(use-package magit-delta
  :hook (magit-mode . magit-delta-mode))

(defun magit-dotfiles (env)
  "Adiciona GIT_DIR e GIT_WORK_TREE ao ENV quando na $HOME.
https://github.com/magit/magit/issues/460 (@cpitclaudel)."
  (let ((default (file-name-as-directory (expand-file-name default-directory)))
        (home (expand-file-name "~/")))
    (when (string= default home)
      (let ((gitdir (expand-file-name "~/.dotfiles/")))
        (push (format "GIT_WORK_TREE=%s" home) env)
        (push (format "GIT_DIR=%s" gitdir) env))))
  env)

(advice-add 'magit-process-environment :filter-return #'magit-dotfiles)

;;; github
(use-package forge
  :after (magit))
(use-package code-review
  :after (forge)
  :init (add-hook 'code-review-mode-hook #'emojify-mode)
  :config (setq code-review-auth-login-marker 'forge))

;;; indica diffs
(use-package diff-hl
  :init (global-diff-hl-mode)
  :config
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (set-face-attribute 'diff-hl-change nil :background "#ffff00" :foreground "#ffff00")
  (set-face-attribute 'diff-hl-delete nil :background "#ff0000" :foreground "#ff0000")
  (set-face-attribute 'diff-hl-insert nil :background "#009900" :foreground "#009900")
  (diff-hl-flydiff-mode))

(provide 'mygit)
;;; mygit.el ends here
