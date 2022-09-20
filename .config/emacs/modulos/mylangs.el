;;; mylangs.el -*- lexical-binding: t; -*-
;;; compile
(use-package compile
  :config
  (setq compilation-scroll-output t)
  (require 'ansi-color)
  (defun colorize-compilation-buffer ()
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max))))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer))

;;; lSP
(use-package eglot
  :hook
  (html-mode . eglot-ensure)
  (csharp-mode . eglot-ensure)
  (c-mode . eglot-ensure)
  (c++-mode . eglot-ensure)
  (lisp-mode . eglot-ensure)
  (go-mode . eglot-ensure)
  (scheme-mode . eglot-ensure)
  (clojure-mode . eglot-ensure)
  (python-mode . eglot-ensure)
  (js-mode . eglot-ensure)
  :config (setq eglot-autoshutdown t))

;;; common lisp
(use-package sly-asdf)
(use-package sly-quicklisp)
(use-package sly-repl-ansi-color)
(use-package sly
  :init (add-hook 'lisp-mode-hook #'sly-editing-mode)
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (require 'sly-quicklisp)
  (require 'sly-repl-ansi-color)
  (require 'sly-asdf))

;;; elisp
(use-package eros
  :hook (emacs-lisp-mode . eros-mode))

;;; csharp
(use-package csharp-mode
  :config (add-to-list 'aggressive-indent-excluded-modes 'csharp-mode)
  :mode ("\\.cs\\'" . csharp-mode))
(use-package csproj-mode
  :mode ("\\.csproj\\'" . csproj-mode))
(use-package sln-mode
  :mode ("\\.sln\\'" . sln-mode))

;;; go
(use-package go-mode
  :mode ("\\.go\\'" . go-mode))

;;; css
(use-package css-eldoc
  :hook (css-mode . turn-on-css-eldoc))

;;; fish
(use-package fish-mode
  :mode ("\\.fish\\'" . fish-mode))

;;; funções
(defun aval-buffer ()
  "Avalia buffer dependendo do major-mode."
  (interactive)
  (cond ((string= major-mode "sh-mode") (shell-command (buffer-string)))
        (t (eval-buffer))))

(defun aval-region (start end)
  "Avalia região dependendo do major-mode."
  (interactive "r")
  (if (use-region-p)
      (let ((regionp (buffer-substring start end)))
        (cond ((string= major-mode "sh-mode") (shell-command regionp))
              (t (eval-region start end t))))))

;;; flycheck
(use-package flycheck)

(provide 'mylangs)
;;; mylangs.el ends here
