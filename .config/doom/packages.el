;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Examples ;;
;; Install a package named "example" from ELPA, MELPA, or Emacsmirror
;;(package! example)

;; Install it directly from a github repository. For this to work, the package
;; must have an appropriate PACKAGENAME.el file which must contain at least a
;; Package-Version or Version line in its header.
;; (package! example
  ;; :recipe (:host github :repo "username/my-example-fork"))

;; If the source files for a package are in a subdirectory in said repo, use
;; `:files' to target them.
;; (package! example :recipe
  ;; (:host github
   ;; :repo "username/my-example-fork"
   ;; :files ("*.el" "src/lisp/*.el")))

;; To grab a particular branch or tag:
;; (package! example :recipe
  ;; (:host gitlab
   ;; :repo "username/my-example-fork"
   ;; :branch "develop"))

;; If a package has a default recipe on MELPA or emacsmirror, you may omit
;; keywords and the recipe will inherit the rest of the recipe from their
;; original.
;; (package! example :recipe (:branch "develop"))

;; If the repo pulls in many unneeded submodules, you can disable recursive cloning
;; (package! example :recipe (:nonrecursive t))

;; A package can be installed straight from a git repo by setting :host to nil:
;; (package! example
  ;; :recipe (:host nil :repo "https://some/git/repo"))

;; Popups
(package! posframe)
;; Miscelânea
(package! terminal-here)
(package! command-log-mode)
;; Code
(package! vimrc-mode)
;; Tema
(package! blinding-dark-theme
  :recipe (:host github :repo "lucastavaresa/blinding-dark-theme"))
;; Orgmode
(package! org-make-toc)
(package! org-auto-tangle)
;; Correção ortográfica
(package! flyspell)
(package! flyspell-popup)
;; Local ;;
;; (package! blinding-dark-theme
  ;; :recipe (:local-repo "~/.config/doom/blinding-dark-theme"))

;; Desativado ;;
(package! evil-snipe :disable t)
(package! spell-fu :disable t)
