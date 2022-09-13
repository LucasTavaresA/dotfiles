;;; mystraight.el -*- lexical-binding: t; -*-
;;; boostrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; instala use-package
(straight-use-package 'use-package)

;;; usa :straight t por padrão
(setq straight-use-package-by-default t)

;;; orgmode prescisa ser carregado primeiro
(use-package org :defer t)

(provide 'mystraight)
;;; mystraight.el ends here
