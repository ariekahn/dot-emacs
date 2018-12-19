;;; Package --- Summary

;;; Commentary:
;; Emacs init file responsible for either loading a pre-compiled configuration file
;; or tangling and loading a literate org configuration file.

;;; Code:

;; Don't attempt to find/apply special file handlers to files loaded during startup.
(let ((file-name-handler-alist nil))
  ;; If config is pre-compiled, then load that
  ;; Use org-babel to tangle and load the configuration
  ;; Note that org-babel already checks modification times for us before retangling

  ;; TODO: org-babel-load-file can optionally byte-compile our config,
  ;; but it looks like it doesn't check recency. We could optionally check here
  ;; and optionally compile of the .el file is out of date
  (require 'org)
  (org-babel-load-file (expand-file-name "literateconfig.org" user-emacs-directory)))

;;; init.el ends here
