(setq user-full-name "Ari Kahn"
      user-mail-address "ariekahn@gmail.com")

(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))

(eval-when-compile
  (require 'package)

  (unless (assoc-default "melpa" package-archives)
    (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t))
  (unless (assoc-default "org" package-archives)
    (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))

  ;(package-initialize)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (require 'use-package)
  (setq use-package-always-ensure t))

(when window-system
  (blink-cursor-mode 0)                           ; Disable the cursor blinking
  (scroll-bar-mode 0)                             ; Disable the scroll bar
  (tool-bar-mode 0)                               ; Disable the tool bar
  (tooltip-mode 0))                               ; Disable the tooltips

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; And modify how emacs names and holds onto them
(setq
   backup-by-copying t      ; don't clobber symlinks
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(setq-default custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(use-package org
 :ensure org-plus-contrib
 :pin org
 :defer t)

;; Ensure ELPA org is prioritized above built-in org.
(require 'cl)
(setq load-path (remove-if (lambda (x) (string-match-p "org$" x)) load-path))

(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)
;; Org-agenda
(setq org-agenda-files (list
                    "~/Dropbox/org/weekly-plan.org"
                    "~/Dropbox/org/meetings-dani.org"
                    "~/Dropbox/org/todo.org"))
;; org-agenda messes up window setups. Have it keep the same window.
(setq org-agenda-window-setup 'current-window)

;; Indent based on header level
(setq org-indent-mode t)

(setq org-M-RET-may-split-line nil)

(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
	 ((agenda "")
	  (alltodo "")))))

;; Create a ‘CLOSED: [timestamp]’ line when we finish an item
(setq org-log-done 'time)

(use-package toc-org
  :after org
  :ensure t
  :init (add-hook 'org-mode-hook #'toc-org-enable))

(setq reftex-default-bibliography '("/Users/ari/Dropbox/Mendeley/library.bib"))
(setq org-ref-default-bibliography '("/Users/ari/Dropbox/Mendeley/library.bib")
      org-ref-pdf-directory "/Users/ari/Dropbox/Papers/"
      org-ref-bibliography-notes "/Users/ari/Dropbox/org/notes.org")

;; For helm
(setq bibtex-completion-bibliography "/Users/ari/Dropbox/Mendeley/library.bib"
      bibtex-completion-library-path "/Users/ari/Dropbox/Papers"
      bibtex-completion-notes-path "/Users/ari/Dropbox/org/notes.org")

;; Tell it to use the field Mendeley is populating
(setq bibtex-completion-pdf-field "file")
;; open pdf with system pdf viewer (works on mac)
;; (setq bibtex-completion-pdf-open-function
;;   (lambda (fpath)
;;     (start-process "open" "*open*" "open" fpath)))

;; Set org-ref to use a function that can get the right field, in this case helm-bibtex
(setq org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex)

;; Specify the backend we want to use out of helm/ivy/reftex
(setq org-ref-completion-library 'org-ref-helm-bibtex)

(use-package org-ref
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode) ; Git-flavor
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package evil
  :ensure t ;; install the evil package if not installed
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config ;; tweak evil after loading it
  (evil-mode)
  )

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package helm
    :ensure t
    )

(use-package helm-org-rifle
  :ensure t
  )

(use-package dashboard
    :ensure t
    :config
    (dashboard-setup-startup-hook))

(use-package projectile
  :demand t)

;(use-package window-purpose
;  :ensure t)
;(purpose-mode 1)
;(setq purpose-mode-user-purposes
;      '((term-mode . terminal)

(use-package winner
  :ensure nil
  :defer 1
  :config (winner-mode 1))

(defun my-split-root-window (size direction)
  (split-window (frame-root-window)
		(and size (prefix-numeric-value size))
		direction))

(defun my-split-root-window-below (&optional size)
  (interactive "P")0
  (my-split-root-window size 'below))

(defun my-split-root-window-right (&optional size)
  (interactive "P")
  (my-split-root-window size 'right))

(defun my-split-root-window-dwim (&optional size)
  (interactive "P")
  ;; Are we currently in a vertical split?
  (if (window-combined-p nil nil)
      (my-split-root-window-right)
    (my-split-root-window-below)))

(global-set-key (kbd "C-x 6") 'my-split-root-window-dwim)

(use-package magit
  :ensure t)

(use-package leuven-theme
  :ensure t
  :config
  (setq leuven-scale-outline-headlines nil) 
  (setq leuven-scale-org-agenda-structure nil))

(load-theme 'leuven t)

(global-set-key [remap move-beginning-of-line] #'me/beginning-of-line-dwim)

(defun me/beginning-of-line-dwim ()
  "Move point to first non-whitespace character, or beginning of line."
  (interactive "^")
  (let ((origin (point)))
    (beginning-of-line)
    (and (= origin (point))
	 (back-to-indentation))))

(defun my\dnd-func (event)
  (interactive "e")
  (goto-char (nth 1 (event-start event)))
  (x-focus-frame nil)
  (let* ((payload (car (last event)))
	 (type (car payload))
	 (fname (cadr payload))
	 (img-regexp "\\(png\\|jp[e]?g\\)\\>"))
    (cond
     ;; insert image link
     ((and  (eq 'drag-n-drop (car event))
	    (eq 'file type)
	    (string-match img-regexp fname))
      (insert (format "[[%s]]" fname))
      (org-display-inline-images t t))
     ;; insert image link with caption
     ((and  (eq 'C-drag-n-drop (car event))
	    (eq 'file type)
	    (string-match img-regexp fname))
      (insert "#+ATTR_ORG: :width 300\n")
      (insert (concat  "#+CAPTION: " (read-input "Caption: ") "\n"))
      (insert (format "[[%s]]" fname))
      (org-display-inline-images t t))
     ;; C-drag-n-drop to open a file
     ((and  (eq 'C-drag-n-drop (car event))
	    (eq 'file type))
      (find-file fname))
     ((and (eq 'M-drag-n-drop (car event))
	   (eq 'file type))
      (insert (format "[[attachfile:%s]]" fname)))
     ;; regular drag and drop on file
     ((eq 'file type)
      (insert (format "[[%s]]\n" fname)))
     (t
      (error "I am not equipped for dnd on %s" payload)))))
(define-key org-mode-map (kbd "<drag-n-drop>") 'my\dnd-func)
(define-key org-mode-map (kbd "<C-drag-n-drop>") 'my\dnd-func)
(define-key org-mode-map (kbd "<M-drag-n-drop>") 'my\dnd-func)

;; Helm find-files dialog
(global-set-key (kbd "C-x C-f") #'helm-find-files)

;; Definitely want easy access to recent files
(global-set-key (kbd "C-x C-r") #'helm-recentf)

;; The helm buffer list is significantly better
(global-set-key (kbd "C-x b") #'helm-buffers-list)

;; Helm meta
(global-set-key (kbd "M-x") #'helm-M-x)

;; Helm bookmarks
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)

(helm-mode 1)
