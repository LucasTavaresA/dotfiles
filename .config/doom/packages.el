;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Popups
(package! posframe)
(package! terminal-here)
(package! command-log-mode)
(package! vimrc-mode)
(package! org-make-toc)
;; Correção ortográfica
(package! flyspell)
(package! flyspell-popup)

;; Local ;;
;; Meu fork do doom-themes-solarized-dark
;; (package! doom-themes
  ;; :recipe (:local-repo "~/.config/doom/themes/"))
;; Meu fork do yasnippet-snippets
(package! yasnippet-snippets
  :recipe (:local-repo "~/.config/doom/yasnippet-snippets"))
(package! spaceway-theme
  :recipe (:local-repo "~/.config/doom/spaceway-theme"))

;; Desativado ;;
(package! evil-snipe :disable t)
(package! spell-fu :disable t)
