;;; mylooks.el -*- lexical-binding: t; -*-
;;; Divisórias
;; tamanho das fringes
(set-fringe-mode 5)
;; Divisórias entre frames
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(set-face-attribute 'window-divider nil :foreground "#fff")
(window-divider-mode 1)

;;; Indicação de espaços e tabs
(use-package whitespace
  :hook (prog-mode . whitespace-mode)
  :init
  (setq whitespace-style '(face tabs spaces space-mark trailing space-before-tab indentation
                                empty space-after-tab tab-mark missing-newline-at-eof))
  :config (set-face-attribute 'whitespace-space nil :background "#000" :foreground "#333"))

;;; Mode-line
;; informações no minibuffer
(use-package awesome-tray
  :straight (awesome-tray :type git :host github :repo "manateelazycat/awesome-tray")
  :init
  (setq awesome-tray-git-format "%s"
        awesome-tray-hide-mode-line nil
        awesome-tray-evil-show-mode nil
        awesome-tray-file-path-show-filename t
        awesome-tray-file-path-full-dirname-levels 1
        awesome-tray-file-path-truncate-dirname-levels 0
        awesome-tray-location-format "L%l"
        awesome-tray-separator "  "
        awesome-tray-second-line t
        awesome-tray-position 'center
        awesome-tray-essential-modules '("github" "buffer-read-only" "evil" "anzu"
                                         "circe" "mode-name" "git" "location" "file-path")
        awesome-tray-active-modules    '("github" "buffer-read-only" "evil" "anzu"
                                         "circe" "mode-name" "git" "location" "file-path"))
  (awesome-tray-mode))

;;; Tema
(use-package gruvbox-theme
  :init
  (load-theme 'gruvbox-dark-hard t)
  :config
  (set-face-attribute 'default nil :background "#000")
  (set-face-attribute 'fringe nil :background "#000")
  (set-face-attribute 'region nil :background "#00f"))

;;; fontes
(set-face-attribute 'default nil :family "Terminus" :height 140)
(set-face-attribute 'font-lock-comment-face nil :slant 'italic :foreground "#009900")
;; símbolos em prog-mode
(add-hook 'prog-mode-hook 'prettify-symbols-mode)

;;; Indica buffers sem foco
(use-package auto-dim-other-buffers
  :init (auto-dim-other-buffers-mode)
  (set-face-attribute 'auto-dim-other-buffers-face nil :background "#101010"))

;;; Indicação visual no cursor
(use-package pulse
  :defer t
  :init
  (defun pulsar-linha (&rest _)
    "Pulsa a linha atual."
    (pulse-momentary-highlight-one-line (point)))
  (dolist (command '(other-window windmove-do-window-select mouse-set-point mouse-select-window))
    (advice-add command :after #'pulsar-linha))
  (dolist (command '(scroll-up-command scroll-down-command
                                       recenter-top-bottom other-window))
    (advice-add command :after #'pulsar-linha))
  :config (set-face-attribute 'pulse-highlight-start-face nil :background "#00f"))

(provide 'mylooks)
;;; mylooks.el ends here
