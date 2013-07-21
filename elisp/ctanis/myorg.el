;; org-mode
(setq org-log-done 'time)
(setq org-completion-use-ido t)
(setq org-log-into-drawer t)
(setq org-catch-invisible-edits 'smart)

;; revisit this if i ever use an org-clock
;; (setq org-clock-persist t)
;; (org-clock-persistence-insinuate)

(setq org-alphabetical-lists t)
(setq org-hide-emphasis-markers t)
(setq org-use-speed-commands t)

;; the resulting regexp from numlines (the last piece) >0 was breaking
;; certain headline emphases
(setq org-emphasis-regexp-components
      '(" \t('\"{" "- \t.,:!?;'\")}\\" " \t\r\n,\"'" "." 0))

(setq org-cycle-separator-lines 2)

;(setq org-M-RET-may-split-line '((headline . nil) (item . nil) (table . t)))
(setq org-cycle-global-at-bob t)
(setq org-goto-interface 'outline-path-completion)

(setq org-export-with-sub-superscripts nil)
; don't want to see TOC and postamble in my exported html
(setq org-html-postamble nil)
(setq org-export-with-toc nil)
(setq org-export-with-section-numbers nil)

;(setq org-export-html-style "<style type=\"text/css\">#table-of-contents{display:none} #postamble{display:none}</style>")
; original has frame="hside" which  puts bars at the top and bottom
(setq org-export-html-table-tag  "<table border=\"2\" cellspacing=\"0\" cellpadding=\"6\" rules=\"groups\" frame=\"void\">")

;; constants -- org-table uses these
(autoload 'constants-insert "constants" "Insert constants into source." t)
(autoload 'constants-get "constants" "Get the value of a constant." t)
(autoload 'constants-replace "constants" "Replace name of a constant." t)

(define-key craig-prefix-map "\C-l" 'org-store-link)
(define-key craig-prefix-map "\M-s" 'org-capture)
(define-key craig-prefix-map "\M-a" 'org-agenda)


(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets (quote ((nil :maxlevel . 9))))
(setq org-refile-use-outline-path t)

(org-babel-do-load-languages 'org-babel-load-languages '((emacs-lisp . t)
							 (perl . t)
							 (C . t)
							 (java . t)
							 (python . t)
							 (ditaa . t)
							 (dot . t)
							 (gnuplot . t)
							 (octave . t)
							 (calc . t)
							 (sh . t)))

;; (defun org-pass-link-to-system (link)
;;   (if (string-match "^[a-zA-Z0-9]+:" link)
;;       (shell-command (concat "open " link))
;;     nil)
;;   )
(defun org-pass-link-to-system (link)
  (if (string-match "^[a-zA-Z0-9]+:" link)
      (browse-url link)
    nil)
  )


;; if we are in an sexp, jump to enclosing paren, otherwise run
;; org-up-element
;; (defun org-up-list-or-element ()
;;   (interactive)
;;   (condition-case nil
;;       (up-list -1)
;;     (error
;;      (condition-case nil
;; 	 (org-up-element)
;;        (error (message "no parent element"))))))

;; this version won't up-list past the start of the current element
(defun org-up-list-or-element ()
  (interactive)
  (let* ((start (point))
	 (orgparent (progn (org-up-element) (point)))
	 (liststart
	  (progn
	    (goto-char start)
	    (condition-case nil
		(progn
		  (up-list -1)
		  (point))
	      (error 0)))))
    (goto-char (max orgparent liststart))))

(defun org-blindly-eval-babel ()
  (interactive)
  (make-variable-buffer-local 'org-confirm-babel-evaluate)
  (setq org-confirm-babel-evaluate nil))


(add-hook 'org-open-link-functions 'org-pass-link-to-system)
