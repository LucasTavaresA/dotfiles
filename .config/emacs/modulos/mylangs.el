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

;;; Fish
(use-package fish-mode)

;;; Funções
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

(provide 'mylangs)
;;; mylangs.el ends here
