;;; init.el -*- lexical-binding: t; -*-
(toggle-debug-on-error)
;;; módulos
(add-to-list 'load-path (expand-file-name "modulos/" user-emacs-directory))
(require 'mystraight)
(require 'mylooks)
(require 'myedit)
(require 'mymisc)
(require 'mygit)
(require 'mymarkup)
(require 'mycompletion)
(require 'mylangs)
(require 'myspell)
(require 'mykeys)

;;; coleta de lixo
;; acelerar a coleta de lixo quando inativo
(use-package gcmh
  :init (gcmh-mode))

;; aumenta pausas para coleta de lixo
(setq gc-cons-threshold (* 2 1000 1000))
