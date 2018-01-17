;;; we need environment at first
(load "~/.emacs.d/init.el") 
;;; then we do action
(require 'ox-publish)
(org-publish-project "site")
