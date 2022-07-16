;;; mygit.el -*- lexical-binding: t; -*-
;;; Misc
(use-package git-link
  :config (setq git-link-open-in-browser t))

;;; Magit
(use-package magit
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
(use-package magit-todos
  :after (magit)
  :init (magit-todos-mode))
(use-package magit-delta
  :hook (magit-mode . magit-delta-mode))

;;; Github
(use-package forge
  :after (magit)
  :config (setq auth-sources '("~/.gnupg/authinfo")))
(use-package code-review
  :after (forge)
  :init (add-hook 'code-review-mode-hook #'emojify-mode)
  :config (setq code-review-auth-login-marker 'forge))

;;; Indica diffs
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
