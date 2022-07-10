;;; mylooks.el -*- lexical-binding: t; -*-
;; tamanho das fringes
(set-fringe-mode 1)
;; símbolos em prog-mode
(add-hook 'prog-mode-hook 'prettify-symbols-mode)

;;; Divisórias
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(set-face-attribute 'window-divider nil :foreground "#fff")
(window-divider-mode 1)

;;; Indicação de espaços e tabs
(setq whitespace-style '(face tabs spaces space-mark trailing space-before-tab indentation
                              empty space-after-tab tab-mark missing-newline-at-eof))
(global-whitespace-mode +1)
(set-face-attribute 'whitespace-space nil :background "#000" :foreground "#333")

;;; Mode-line
(use-package awesome-tray
  :straight (awesome-tray :type git :host github :repo "manateelazycat/awesome-tray")
  :init (awesome-tray-mode)
  :config
  (setq awesome-tray-git-format "%b %s"
        awesome-tray-file-path-show-filename t
        awesome-tray-file-path-full-dirname-levels 1
        awesome-tray-info-padding-right 1
        awesome-tray-file-path-truncate-dirname-levels 3
        awesome-tray-separator "  "
        awesome-tray-essential-modules '("buffer-read-only" "git" "location")
        awesome-tray-active-modules    '("buffer-read-only" "git" "location" "file-path")))
(use-package hide-mode-line
  :init (global-hide-mode-line-mode))

;;; Tema
(use-package doom-themes
  :init (load-theme 'doom-outrun-electric t)
  :config
  (set-face-attribute 'default nil :background "#000" :foreground "#fff")
  (set-face-attribute 'region nil :background "#00f")
  ;; fontes
  (set-face-attribute 'default nil :family "Terminus" :height 140)
  (set-face-attribute 'variable-pitch nil :family "Ubuntu" :weight 'light)
  (set-face-attribute 'font-lock-string-face nil :foreground "#ffff00")
  (set-face-attribute 'font-lock-keyword-face nil :family "SauceCodePro Nerd Font Mono" :height 130)
  (set-face-attribute 'font-lock-constant-face nil :family "SauceCodePro Nerd Font Mono" :slant 'italic :height 130)
  (set-face-attribute 'font-lock-comment-face nil :family "SauceCodePro Nerd Font Mono" :slant 'italic
                      :height 130 :foreground "#009900")
  (set-face-attribute 'font-lock-function-name-face nil :family "SauceCodePro Nerd Font Mono" :slant 'italic :height 130)
  (set-face-attribute 'font-lock-variable-name-face nil :family "SauceCodePro Nerd Font Mono" :slant 'italic :height 130)
  (set-face-attribute 'font-lock-builtin-face nil :family "SauceCodePro Nerd Font Mono" :height 130)
  (variable-pitch-mode 1))

;;; Clareia buffer sem foco
(use-package auto-dim-other-buffers
  :init (auto-dim-other-buffers-mode)
  (set-face-attribute 'auto-dim-other-buffers-face nil :background "#080808"))

;;; Indicação visual
(require 'pulse)
(set-face-attribute 'pulse-highlight-start-face nil :background "#00f")
(defun pulsar-linha (&rest _)
  "Pulsa a linha atual."
  (pulse-momentary-highlight-one-line (point)))
(dolist (command '(scroll-up-command scroll-down-command
                                     recenter-top-bottom other-window))
  (advice-add command :after #'pulsar-linha))

(provide 'mylooks)
;;; mylooks.el ends here
