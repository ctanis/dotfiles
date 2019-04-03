;; org-mode
(require 'org)
(require 'org-agenda)
(setq org-log-done 'time)
(setq org-completion-use-ido t)
(setq org-log-into-drawer t)
(setq org-catch-invisible-edits 'smart)
(setq org-image-actual-width nil)
(setq org-archive-default-command 'org-toggle-archive-tag)
(setq org-yank-folded-subtrees nil)
(setq org-yank-adjusted-subtrees nil)
(setq org-startup-folded nil)
;;(setq org-src-fontify-natively nil)
(setq org-src-fontify-natively t)

;; ctrl-a/e on heading defaults to text
(setq org-special-ctrl-a/e 'reversed)

(setq org-alphabetical-lists t)
;(setq org-hide-emphasis-markers t)
(setq org-use-speed-commands nil)

;; is this fixed??
;; ;; the resulting regexp from numlines (the last piece) >0 was breaking
;; ;; certain headline emphases
;; (setq org-emphasis-regexp-components
;;       '(" \t('\"{" "- \t.,:!?;'\")}\\" " \t\r\n,\"'" "." 0))


(setq org-cycle-separator-lines 2)

;(setq org-M-RET-may-split-line '((headline . nil) (item . nil) (table . t)))
(setq org-cycle-global-at-bob t)
(setq org-goto-interface 'outline-path-completion)

(setq org-export-with-sub-superscripts nil) ;; flip with ^:t
; don't want to see TOC and postamble in my exported html
(setq org-html-postamble nil)
(setq org-export-with-toc nil)
(setq org-export-with-section-numbers nil)
(setq org-export-with-archived-trees nil)
(setq org-export-with-smart-quotes t) ;; flip with ':nil

;(setq org-export-html-style "<style type=\"text/css\">#table-of-contents{display:none} #postamble{display:none}</style>")
; original has frame="hside" which  puts bars at the top and bottom
;(setq org-export-html-table-tag  "<table border=\"2\" cellspacing=\"0\" cellpadding=\"6\" rules=\"groups\" frame=\"void\">")

;; constants -- org-table uses these
(autoload 'constants-insert "constants" "Insert constants into source." t)
(autoload 'constants-get "constants" "Get the value of a constant." t)
(autoload 'constants-replace "constants" "Replace name of a constant." t)



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
							 (shell . t)
                                                         (scheme .t)
                                                                 ))

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
;; (defun org-up-list-or-element ()
;;   (interactive)
;;   (let* ((start (point))
;; 	 (orgparent (progn (org-up-element) (point)))
;; 	 (liststart
;; 	  (progn
;; 	    (goto-char start)
;; 	    (condition-case nil
;; 		(progn
;; 		  (up-list -1)
;; 		  (point))
;; 	      (error 0)))))
;;     (goto-char (max orgparent liststart))))

;; (defun org-up-list-or-element ()
;;   "combination of backward-up-list and org-up-element, doing the
;; most localized thing"
;;   (interactive)
;;   (let* ((start (point))
;; 	 (orgparent (condition-case nil
;;                         (progn 
;;                           (org-up-element)
;;                           (point))
;;                       (error (point))))
;; 	 (liststart
;;           (condition-case nil
;;               (progn
;;                 (goto-char start)
;;                 (up-list -1)
;;                 (point))
;;             (error 0))))

;;     (goto-char (max orgparent liststart))))

(defun org-up-list-or-element ()
  "combination of backward-up-list and org-up-element, doing the
most localized thing"
  (interactive)
  (let* ((start (point))
	 (orgparent (condition-case nil
                        (progn 
                          (org-up-element)
                          (point))
                      (error nil)))
	 (liststart
          (condition-case nil
              (progn
                (goto-char start)
                (up-list -1)
                (point))
            (error nil))))

    (goto-char
     (cond
      ((and (not orgparent) liststart) liststart)
      ((and (not liststart) orgparent) orgparent)
      ((and liststart orgparent) (max orgparent liststart))
      (t (progn
           (message "no containing list or element")
           (point)))))))


(defun org-blindly-eval-babel ()
  (interactive)
  (make-variable-buffer-local 'org-confirm-babel-evaluate)
  (setq org-confirm-babel-evaluate nil))


(add-hook 'org-open-link-functions 'org-pass-link-to-system)


;; promoting and demoting multiple subtrees keeps the region active
(defadvice org-do-promote (after dont-deactivate-region activate)
  "org-do-promote keeps region intact"
  (setq deactivate-mark nil))

(defadvice org-do-demote (after dont-deactivate-region activate)
  "org-do-demote keeps region intact"
  (setq deactivate-mark nil))

(defun org-wrap-with-self ()
  (interactive)
  (if (region-active-p)
      (wrap-region-with-char last-input-event)
    (call-interactively 'org-self-insert-command)))

;; wrap-with-self defined in functions.el
(dolist (ch (mapcar 'car org-emphasis-alist))
  (define-key org-mode-map ch 'org-wrap-with-self))
(define-key org-mode-map "$" 'org-wrap-with-self)

                                        ;(define-key org-mode-map (kbd "C-c C-SPC") 'org-table-blank-field)
(define-key org-mode-map (read-kbd-macro "<C-backspace>") 'org-table-blank-field)
(define-key org-mode-map "\C-m" 'org-return-indent)

(define-key org-mode-map (kbd "C-,") 'org-occur-in-agenda-files)

; ignore this aspect of agenda files
;;(define-key org-mode-map (kbd "C-'") nil)
;;(define-key org-mode-map (kbd "C-c '") 'org-cycle-agenda-files)
;; (define-key org-mode-map (kbd "C-c [") nil)
;; (define-key org-mode-map (kbd "C-c ]") nil)

; to tag TODO's in capture mode
(eval-after-load "org-capture" '(define-key org-capture-mode-map "\C-c\C-t" 'org-ctrl-c-ctrl-c))

;(require 'ox-odt)
;(require 'ox-beamer)
;(require 'ox-md)
;(require 'ox-koma-letter)

;; ob-scheme has a tendency of spontaneously opening windows when not run in session mode

(defadvice org-babel-execute:scheme
    (around leave-windows-alone activate)
  (let ((cfg (current-window-configuration)))
    ad-do-it
    (set-window-configuration cfg)))

;; listings config for when (setq org-latex-listings t)
;; see also (setq org-latex-caption-above '(table))
;; see also #+LATEX_HEADER:\usepackage[labelformat=empty]{caption}
(setq org-latex-listings t)
(setq org-latex-prefer-user-labels t)
(add-to-list 'org-latex-packages-alist '("" "listings"))
(setq org-latex-listings-options
      '(("numbers" "none")
        ("frame" "single")
        ("basicstyle" "\\ttfamily")
        ("showspaces" "false")
        ("showstringspaces" "false")
        ("aboveskip" ".5in")
        ("belowskip" ".5in")
        ("belowcaptionskip" ".5in")
        ))


;; links in pdfs should have no boxes around them...
(setq org-latex-hyperref-template
  "\\hypersetup{\n pdfauthor={%a},\n pdftitle={%t},\n pdfkeywords={%k},
 pdfsubject={%d},\n pdfcreator={%c}, \n pdflang={%L}, \n pdfborder={0 0 0} }\n")

;; note, you may need an org block like the following
;;
;; #+BEGIN_LaTeX
;; \lstdefinelanguage{text}{}
;; \lstdefinelanguage{scheme}{}
;; #+END_LaTeX
;;
;; if you are using cross-referencing, since undefined languages interrupt the
;; pdf build process


;; bigger latex fragment
(plist-put org-format-latex-options :scale 1.7)



(eval-after-load "ox-latex"
  '(progn
     (add-to-list 'org-latex-classes
                  '("IEEEtran"
                    "\\documentclass{IEEEtran}"
                    ("\\section{%s}" . "\\section*{%s}")
                    ("\\subsection{%s}" . "\\subsection*{%s}")
                    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                    ("\\paragraph{%s}" . "\\paragraph*{%s}")
                    ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
                  )
     (add-to-list 'org-latex-classes
                  '("acmart"
                    "\\documentclass{acmart}"
                    ("\\section{%s}" . "\\section*{%s}")
                    ("\\subsection{%s}" . "\\subsection*{%s}")
                    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                    ("\\paragraph{%s}" . "\\paragraph*{%s}")
                    ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))

                    )
     ))


(eval-after-load "org"
  '(progn
     (defalias 'org-refile-fullpath 'org-refile)
     (defalias 'org-agenda-refile-fullpath 'org-agenda-refile)

     ;; this one is for refiling to other files in the org-agenda-files
     (defadvice org-refile-fullpath (around use-full-path activate)
       (let ((org-completion-use-ido nil)
	     (org-outline-path-complete-in-steps t)
	     (org-refile-use-outline-path 'file)
	     (org-refile-targets (quote ((nil :maxlevel . 9)
					 (org-agenda-files :maxlevel . 9)))))
	 ad-do-it
	 ))

     ;; this one is for refiling to other files in the org-agenda-files
     (defadvice org-agenda-refile-fullpath (around use-full-path activate)
       (let ((org-completion-use-ido nil)
	     (org-outline-path-complete-in-steps t)
	     (org-refile-use-outline-path 'file)
	     (org-refile-targets (quote ((nil :maxlevel . 9)
					 (org-agenda-files :maxlevel . 9)))))
	 ad-do-it
	 ))

     ;; ; Targets include this file and any file contributing to the agenda -
     ;; ; up to 9 levels deep
     ;; (setq org-refile-targets (quote ((nil :maxlevel . 9)
     ;;                                  (org-agenda-files :maxlevel . 9))))
     ;; (setq org-refile-use-outline-path 'file)



					; don't use so much room...
     (defadvice org-agenda-redo (after shrink-after-redoing
				       activate compile)
       "minimize buffer after rebuilding agenda"
       (shrink-window-if-larger-than-buffer))

     ))

(require-verbose 'org-bookmark-heading)

(when (require-verbose 'org-rich-yank)
  (define-key craig-prefix-map "\C-y" 'org-rich-yank))

(setq org-pomodoro-play-sounds nil)
(setq org-pomodoro-format "P.%s")
(setq org-pomodoro-time-format "%.2m")

;; this may be undesirable if I ever start using org-clock for non-pomodoro
;; purposes
;;(defun org-clock-get-clock-string () "")
(setq org-clock-persist t)
(org-clock-persistence-insinuate)
(org-clock-load)

(defun org-pomodoro-protect-modeline (original)
       (if (org-pomodoro-active-p)
           ""
         (funcall original))
       )

(advice-add 'org-clock-get-clock-string :around #'org-pomodoro-protect-modeline)
(advice-add 'org-pomodoro :after #'org-clock-update-mode-line)


