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
  (setq modus-themes-vivendi-color-overrides
        '((bg-main . "#25152a")
          (bg-dim . "#2a1930")
          (bg-alt . "#382443")
          (bg-hl-line . "#332650")
          (bg-active . "#463358")
          (bg-inactive . "#2d1f3a")
          (bg-active-accent . "#50308f")
          (bg-region . "#5d4a67")
          (bg-region-accent . "#60509f")
          (bg-region-accent-subtle . "#3f285f")
          (bg-header . "#3a2543")
          (bg-tab-active . "#26162f")
          (bg-tab-inactive . "#362647")
          (bg-tab-inactive-accent . "#36265a")
          (bg-tab-inactive-alt . "#3e2f5a")
          (bg-tab-inactive-alt-accent . "#3e2f6f")
          (fg-main . "#debfe0")
          (fg-dim . "#d0b0da")
          (fg-alt . "#ae85af")
          (fg-unfocused . "#8e7f9f")
          (fg-active . "#cfbfef")
          (fg-inactive . "#b0a0c0")
          (fg-docstring . "#c8d9f7")
          (fg-comment-yellow . "#cf9a70")
          (fg-escape-char-construct . "#ff75aa")
          (fg-escape-char-backslash . "#dbab40")
          (bg-special-cold . "#2a3f58")
          (bg-special-faint-cold . "#1e283f")
          (bg-special-mild . "#0f3f31")
          (bg-special-faint-mild . "#0f281f")
          (bg-special-warm . "#44331f")
          (bg-special-faint-warm . "#372213")
          (bg-special-calm . "#4a314f")
          (bg-special-faint-calm . "#3a223f")
          (fg-special-cold . "#c0b0ff")
          (fg-special-mild . "#bfe0cf")
          (fg-special-warm . "#edc0a6")
          (fg-special-calm . "#ff9fdf")
          (bg-completion . "#502d70")
          (bg-completion-subtle . "#451d65")
          (red . "#ff5f6f")
          (red-alt . "#ff8f6d")
          (red-alt-other . "#ff6f9d")
          (red-faint . "#ffa0a0")
          (red-alt-faint . "#f5aa80")
          (red-alt-other-faint . "#ff9fbf")
          (green . "#51ca5c")
          (green-alt . "#71ca3c")
          (green-alt-other . "#51ca9c")
          (green-faint . "#78bf78")
          (green-alt-faint . "#99b56f")
          (green-alt-other-faint . "#88bf99")
          (yellow . "#f0b262")
          (yellow-alt . "#f0e242")
          (yellow-alt-other . "#d0a272")
          (yellow-faint . "#d2b580")
          (yellow-alt-faint . "#cabf77")
          (yellow-alt-other-faint . "#d0ba95")
          (blue . "#778cff")
          (blue-alt . "#8f90ff")
          (blue-alt-other . "#8380ff")
          (blue-faint . "#82b0ec")
          (blue-alt-faint . "#a0acef")
          (blue-alt-other-faint . "#80b2f0")
          (magenta . "#ff70cf")
          (magenta-alt . "#ff77f0")
          (magenta-alt-other . "#ca7fff")
          (magenta-faint . "#e0b2d6")
          (magenta-alt-faint . "#ef9fe4")
          (magenta-alt-other-faint . "#cfa6ff")
          (cyan . "#30cacf")
          (cyan-alt . "#60caff")
          (cyan-alt-other . "#40b79f")
          (cyan-faint . "#90c4ed")
          (cyan-alt-faint . "#a0bfdf")
          (cyan-alt-other-faint . "#a4d0bb")
          (red-active . "#ff6059")
          (green-active . "#64dc64")
          (yellow-active . "#ffac80")
          (blue-active . "#4fafff")
          (magenta-active . "#cf88ff")
          (cyan-active . "#50d3d0")
          (red-nuanced-bg . "#440a1f")
          (red-nuanced-fg . "#ffcccc")
          (green-nuanced-bg . "#002904")
          (green-nuanced-fg . "#b8e2b8")
          (yellow-nuanced-bg . "#422000")
          (yellow-nuanced-fg . "#dfdfb0")
          (blue-nuanced-bg . "#1f1f5f")
          (blue-nuanced-fg . "#bfd9ff")
          (magenta-nuanced-bg . "#431641")
          (magenta-nuanced-fg . "#e5cfef")
          (cyan-nuanced-bg . "#042f49")
          (cyan-nuanced-fg . "#a8e5e5")
          (bg-diff-heading . "#304466")
          (fg-diff-heading . "#dae7ff")
          (bg-diff-added . "#0a383a")
          (fg-diff-added . "#94ba94")
          (bg-diff-changed . "#2a2000")
          (fg-diff-changed . "#b0ba9f")
          (bg-diff-removed . "#50163f")
          (fg-diff-removed . "#c6adaa")
          (bg-diff-refine-added . "#006a46")
          (fg-diff-refine-added . "#e0f6e0")
          (bg-diff-refine-changed . "#585800")
          (fg-diff-refine-changed . "#ffffcc")
          (bg-diff-refine-removed . "#952838")
          (fg-diff-refine-removed . "#ffd9eb")
          (bg-diff-focus-added . "#1d4c3f")
          (fg-diff-focus-added . "#b4dfb4")
          (bg-diff-focus-changed . "#424200")
          (fg-diff-focus-changed . "#d0daaf")
          (bg-diff-focus-removed . "#6f0f39")
          (fg-diff-focus-removed . "#eebdba")))
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
