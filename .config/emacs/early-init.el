;; -*- lexical-binding: t; -*-

;; Diminui a coleta de lixo
(setq gc-cons-threshold (* 50 1000 1000))

;; Desativa package.el
(setq package-enable-at-startup nil
      ;; não adicionar `custom-set-variables' no seu init.el
      package--init-file-ensured t)

;; Tema original do emacs
(load-theme 'wombat)

;; Compilação nativa
(when (featurep 'native-compile)
  ;; Silencia os avisos de compilação nativa
  (setq native-comp-async-report-warnings-errors nil)
  ;; Ajusta o diretório correto para salvar o cache de compilação
  (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory)))
