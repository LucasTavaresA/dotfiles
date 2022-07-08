;;; mylangs.el -*- lexical-binding: t; -*-
;;; Indentação
(use-package aggressive-indent
  :init (global-aggressive-indent-mode))

;;; LSP
(use-package eglot
  :hook
  (html-mode . eglot-ensure)
  (csharp-mode . eglot-ensure)
  (c-mode . eglot-ensure)
  (lisp-mode . eglot-ensure)
  (scheme-mode . eglot-ensure)
  (clojure-mode . eglot-ensure)
  (python-mode . eglot-ensure)
  (js-mode . eglot-ensure)
  :config (setq eglot-autoshutdown t))

;;; Common lisp
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

;;; CSharp
(use-package csharp-mode
  :config (add-to-list 'aggressive-indent-excluded-modes 'csharp-mode)
  :mode ("\\.cs\\'" . csharp-mode))
(use-package csproj-mode
  :mode ("\\.csproj\\'" . csproj-mode))
(use-package sln-mode
  :mode ("\\.sln\\'" . sln-mode))

;;; CSS
(use-package css-eldoc
  :hook (css-mode . turn-on-css-eldoc))

(provide 'mylangs)
;;; mylangs.el ends here
