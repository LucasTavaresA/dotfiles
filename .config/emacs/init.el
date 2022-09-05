;;; init.el -*- lexical-binding: t; -*-
(toggle-debug-on-error)

;;; prefere versões mais recentes de pacotes
(setq load-prefer-newer t)

;;; adiciona pasta módulos ao load-path
(add-to-list 'load-path (expand-file-name "modulos/" user-emacs-directory))

;;; módulos
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

;;; acelerar a coleta de lixo
(use-package gcmh
  :init (gcmh-mode))

;;; aumenta pausas para coleta de lixo
(setq gc-cons-threshold (* 2 1000 1000))
