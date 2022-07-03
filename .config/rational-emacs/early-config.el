;;; early-config.el --- My early rational init       -*- lexical-binding: t; -*-
;;; Straight
;; desabilitar package.el
(setq package-enable-at-startup nil)

;;; Aparencia
;; desativa a modeline
(setq-default mode-line-format nil)
(setq mode-line-format nil)
;; fontes
(set-face-attribute 'default nil :family "Terminus" :height 140)
(set-face-attribute 'variable-pitch nil :family "Ubuntu" :weight 'light)
(set-face-attribute 'font-lock-comment-face nil :family "SauceCodePro Nerd Font Mono" :slant 'italic)
(set-face-attribute 'font-lock-function-name-face nil :family "SauceCodePro Nerd Font Mono" :slant 'italic)
(set-face-attribute 'font-lock-variable-name-face nil :family "SauceCodePro Nerd Font Mono" :slant 'italic)
(with-eval-after-load 'doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
;; markdown headers variam de tamanho
(custom-set-faces
 '(markdown-header-face ((t (:inherit variable-pitch :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.1))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.0))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 0.9))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 0.9)))))
;; previne flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
;; maximizar janela
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; transparencia - emacs 29
;;(set-frame-parameter (selected-frame) 'alpha-background 85)
;;(add-to-list 'default-frame-alist '(alpha-background . 85))
