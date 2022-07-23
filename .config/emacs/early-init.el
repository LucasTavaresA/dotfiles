;;; early-init.el -*- lexical-binding: t; -*-
;;; aumenta a taxa de coleta de lixo para iniciar mais rápido
;; o padrão são 800 kilobytes, medido em bytes
(setq gc-cons-threshold most-positive-fixnum)

;;; tempo para iniciar
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs carregado em %s."
                     (emacs-init-time))))

;;; Compilação nativa
(when (featurep 'native-compile)
  ;; silencia avisos de compilação
  (setq native-comp-async-report-warnings-errors nil)
  ;; compila de forma asynchrona
  (setq native-comp-deferred-compilation t)
  ;; diretório para cache da compilação
  ;; o metodo muda dependendo da versão do emacs
  (when (fboundp 'startup-redirect-eln-cache)
    (if (version< emacs-version "29")
        (add-to-list 'native-comp-eln-load-path (convert-standard-filename (expand-file-name "var/eln-cache/" user-emacs-directory)))
      (startup-redirect-eln-cache (convert-standard-filename (expand-file-name "var/eln-cache/" user-emacs-directory)))))
  (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory)))

;;; Aparencia
(setq inhibit-startup-message t)
(tooltip-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(push '(mouse-color . "white") default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
;; tema padrão para evitar tela branca ao iniciar
(load-theme 'modus-vivendi t)
;; desativa a modeline
(setq-default mode-line-format nil)
(setq mode-line-format nil)
;; previne flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
;; maximizar janela
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; transparencia - emacs 29
(set-frame-parameter (selected-frame) 'alpha-background 85)
(add-to-list 'default-frame-alist '(alpha-background . 85))
