;;; mylooks.el -*- lexical-binding: t; -*-
;; tamanho das fringes
(set-fringe-mode 5)
;; símbolos em prog-mode
(add-hook 'prog-mode-hook 'prettify-symbols-mode)

;;; Divisórias
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
        awesome-tray-git-show-status t
        awesome-tray-evil-show-mode nil
        awesome-tray-file-path-show-filename t
        awesome-tray-file-path-full-dirname-levels 1
        awesome-tray-file-path-truncate-dirname-levels 0
        awesome-tray-location-format "L%l"
        awesome-tray-info-padding-right 0
        awesome-tray-separator "  "
        awesome-tray-essential-modules '("github" "buffer-read-only" "evil" "anzu" "git" "location")
        awesome-tray-active-modules    '("github" "buffer-read-only" "evil" "anzu" "git" "location" "file-path"))
  (awesome-tray-mode))
;; esconde a mode-line
(use-package hide-mode-line
  :init (global-hide-mode-line-mode))

;;; Tema
(use-package modus-themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t
        modus-themes-subtle-line-numbers t
        modus-themes-tabs-accented t
        modus-themes-variable-pitch-ui t
        modus-themes-inhibit-reload nil
        modus-themes-fringes nil
        modus-themes-lang-checkers '(straight-underline text-also)
        modus-themes-mode-line nil
        modus-themes-markup '(bold italic)
        modus-themes-syntax nil
        modus-themes-hl-line nil
        modus-themes-paren-match '(bold intense)
        modus-themes-links '(bold italic)
        modus-themes-box-buttons '(variable-pitch flat faint 0.9)
        modus-themes-prompts '(intense bold)
        modus-themes-completions '((matches . (underline intense))
                                   (selection . (semibold accented intense))
                                   (popup . (accented)))
        modus-themes-region '(bg-only no-extend)
        modus-themes-diffs nil
        modus-themes-org-blocks 'tinted-background
        modus-themes-headings
        '((1 . (bold variable-pitch 1.1))
          (2 . (bold 1.0))
          (3 . (semibold variable-pitch 0.9))
          (4 . (semibold 0.8))
          (5 . (semibold variable-pitch 0.8))
          (t . (semibold))))
  (load-theme 'modus-vivendi t)
  :config
  (set-face-attribute 'default nil :background "#000")
  (set-face-attribute 'region nil :background "#00f"))

;;; fontes
(set-face-attribute 'default nil :family "Terminus" :height 140)
(set-face-attribute 'variable-pitch nil :family "Ubuntu" :weight 'light)
(set-face-attribute 'font-lock-string-face nil :foreground "#ffff00")
(set-face-attribute 'font-lock-comment-face nil :family "SauceCodePro Nerd Font Mono"
                    :slant 'italic :height 130 :foreground "#009900")

;;; Indica buffers sem foco
(use-package auto-dim-other-buffers
  :init (auto-dim-other-buffers-mode)
  (set-face-attribute 'auto-dim-other-buffers-face nil :background "#080808"))

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
