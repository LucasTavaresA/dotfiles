;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Abre terminal externo
(package! terminal-here)

;; Popups
(package! posframe)

;; Log de comandos
(package! command-log-mode)

(package! vimrc-mode)

;; Cria sumarios em org
(package! org-make-toc)

;; Mostra marcação em org
(package! org-appear)

;; Meu fork do doom-themes-solarized-dark
;; (package! doom-themes
  ;; :recipe (:local-repo "~/.config/doom/themes/"))

;; Meu fork do yasnippet-snippets
(package! yasnippet-snippets
  :recipe (:local-repo "~/.config/doom/yasnippet-snippets"))

;; Arvore de undos
(package! undo-tree)

;; Correção ortográfica
(package! flyspell)
(package! flyspell-popup)

(package! spaceway-theme
  :recipe (:local-repo "~/.config/doom/spaceway-theme"))
