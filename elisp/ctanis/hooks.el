(mapcar #'(lambda (a)
	    (add-to-list 'auto-mode-alist a))
	'(
	  ("\\.h$" . c++-mode)
	  ("\\.m$" . octave-mode)
	  ("\\.md$" . markdown-mode)
	  ))



(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)



(add-hook 'markdown-mode-hook
	  '(lambda()
	     (local-set-key "\C-\M-u" 'backward-up-list)
	     (local-set-key "\M-p" 'scroll-down-slow)
	     (local-set-key "\M-n" 'scroll-up-slow)
	     (local-set-key "\C-\M-f" 'forward-sexp)
	     (local-set-key "\C-\M-b" 'backward-sexp)
	     (local-set-key [S-tab] 'markdown-shifttab)
	     ))








					; C style
;; (setq c-default-style '((c-mode  . "k&r")
;; 			(c++-mode . "stroustrup")
;; 			(objc-mode . "k&r")
;; 			(other . "ellemtel")))



(c-add-style "ctanis" '("ellemtel"
			(c-basic-offset . 4)
			(c-offsets-alist
			 (case-label . 1)
			 (access-label . -)
					;			 (cpp-macro . 0)
					;			 (cpp-macro . -)
			 )
			(c-hanging-braces-alist
			 (substatement-open . 'before)
			 (class-open . 'before)
			 (defun-open . 'before)
			 (block-open . 'before)
			 (brace-list-open . 'before)
			 (brace-entry-open . 'before)
			 (statement-case-open . 'before)
			 (extern-lang-open . 'before)
			 (namespace-open . 'before)
			 (inline-open)
			 (class-close)
			 )
			(c-hanging-semi&comma-criteria .
						       (c-semi&comma-no-newlines-before-nonblanks
							c-semi&comma-inside-parenlist))
			))
(setq c-default-style "ctanis")

;; ; open-line between curlies when autopair & auto-newline are enabled
;; (defun autopair-cleanup-closing-brace (action pair pos-before)
;;   (when (and (eq pair ?}) c-auto-newline)
;;     (save-excursion
;;       (open-line 1)
;;       (next-line)
;;       (c-indent-line)
;;       )
;;   ))

;; (defun autopair-cleanup-closing-brace (action pair pos-before)
;;   (cond ((and (eq action 'opening)(eq pair ?}) c-auto-newline)
;; 	 (save-excursion
;; 	   (open-line 1)
;; 	   (next-line)
;; 	   (c-indent-line)
;; 	   ))
;; 	; jump to next closing brace and cleanup all these auto
;; 	; behaviors
;; 	((and (eq action 'closing) (eq pair ?{) c-auto-newline)
;; 	 (if (looking-at "\\($\\| $\\|\t\\| \\|\n\\)*}")
;; 	     (progn 
;; 	       (zap-to-char -1 ?})
;; 	       (if c-electric-flag
;; 		   (kill-line))
;; 	       (forward-jump-to-char 1 ?})
;; 	       (c-indent-line)
;; 	       (forward-char))))))


(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (local-set-key "\C-c\C-c" 'compile)
	     (local-set-key "\C-m" 'newline-and-indent)
	     (c-toggle-auto-newline 1)
	     (c-toggle-hungry-state 1)
	     (abbrev-mode -1)
	     (cwarn-mode 1)
					; (local-set-key "}" 'self-insert-command)
	     (local-set-key "\C-c\C-g" 'c-toggle-hungry-state)
	     (local-set-key "\C-\M-e" 'up-list)
	     (local-set-key "\M-o\M-e" 'c-end-of-defun)

	     ;; so autopair works with electric braces and auto newline
	     ;; (make-variable-buffer-local 'autopair-pair-criteria)
	     ;; (setq autopair-pair-criteria 'always)
	     ;; (setq autopair-handle-action-fns
	     ;; 	   (list 'autopair-default-handle-action
	     ;; 		 'autopair-cleanup-closing-brace))
	     ))


					;this is the  c comment-region thing i wrote
;; (add-hook 'c-mode-hook
;; 	  '(lambda ()
;; 	     (local-set-key "\M-o1" 'make-c-header)
;; 	     ))


(add-hook 'f90-mode-hook
	  '(lambda()
	     (local-set-key "\C-m" 'newline-and-indent)
	     (local-set-key "\C-c\C-c" 'compile)
	     (setq f90-do-indent 2)
	     (setq f90-if-indent 2)
	     (setq f90-type-indent 2)
	     (setq f90-program-indent 2)
	     ))


;; (add-hook 'text-mode-hook
;; 	  '(lambda ()
;; 	     (progn
;; 	       (define-key text-mode-map "\M-s" 'goto-line)
;; 	       (toggle-word-wrap 1)
;; 	       ;(visual-line-mode t)
;; 	       ; (set-fill-column 68)
;; 	       ;(auto-fill-mode 1)
;; 	       (auto-save-mode 1))))



;; (add-hook 'comint-output-filter-functions
;; 	  'shell-strip-ctrl-m)



					;calendar stuff
					;(add-hook 'today-visible-calendar-hook 'calendar-mark-today)
					;(add-hook 'diary-display-hook 'diary-display-todo-file t)
					;(add-hook 'diary-display-hook 'fancy-diary-display)
					;(add-hook 'list-diary-entries-hook 'sort-diary-entries t)


;; (add-hook 'asm-mode-set-comment-hook '(lambda ()
;; 					(setq asm-comment-char '?!)))

					;(add-hook 'sh-mode-hook '(lambda ()
					;			   (sh-set-shell "zsh")))

					;redefinitions of shell-mode keys
(add-hook 'comint-mode-hook
	  '(lambda ()
	     ;; (setq comint-use-prompt-regexp t)
	     ;; (setq comint-prompt-regexp "^[^\$]+\$ ")
					; (setq comint-prompt-read-only t)
	     (define-key comint-mode-map
	       "\M-p" 'comint-previous-matching-input-from-input)
	     (define-key comint-mode-map
	       "\M-n" 'comint-next-matching-input-from-input)
	     (define-key comint-mode-map "\C-a" 'comint-bol)
	     (define-key comint-mode-map "\M-o\C-?" 'comint-kill-input)
	     (define-key comint-mode-map "\M-{" 'comint-previous-prompt)
	     (define-key comint-mode-map "\M-}" 'comint-next-prompt)
	     ))

;what is this used for, and is it correct?
;; (setq comint-prompt-regexp "^[1-9]*:.*M:.*>")
;; (setq comint-input-ring-size 1000)


(add-hook 'shell-mode-hook 
	  '(lambda ()
					; allow the killing of this buffer without prompting
	     (process-kill-without-query (get-buffer-process (current-buffer)))
	     (toggle-truncate-lines 1)))

(setq shell-font-lock-keywords
      `(
	("\#.*" . font-lock-comment-face)
	))



(add-hook 'octave-mode-hook
	  '(lambda ()
	     (local-set-key "\C-m" 'newline-and-indent)))


(add-hook 'inferior-octave-mode-hook
	  '(lambda ()
	     (local-set-key
	      "\M-p" 'comint-previous-matching-input-from-input)
	     (local-set-key
	      "\M-n" 'comint-next-matching-input-from-input)
	     (local-set-key
	      "\C-a" 'comint-bol)))


(add-hook 'emacs-lisp-mode-hook
	  '(lambda ()
	     (setq comment-start ";; ")
	     (local-set-key "\C-m" 'newline-and-indent)))

(add-hook 'lisp-interaction-mode-hook
	  '(lambda ()
	     (setq comment-start ";; ")
	     (local-set-key "\C-m" 'newline-and-indent)))


(add-hook 'perl-mode-hook
	  '(lambda ()
	     (local-set-key "\C-c\C-c" 'eval-buffer-as-perl-script)
	     (local-set-key "\C-m" 'newline-and-indent)))

(defalias 'perl-mode 'cperl-mode)
(setq cperl-invalid-face (quote off))
					;(setq cperl-hairy t)
(add-to-list 'font-lock-maximum-decoration (cons 'cperl-mode 1))


(add-hook 'cperl-mode-hook
	  '(lambda ()
	     (local-set-key "\C-c\C-c" 'eval-buffer-as-perl-script)
	     (local-set-key "\C-m" 'newline-and-indent)
	     (local-set-key "\M-o\M-v" 'cperl-get-help)
	     (local-set-key "\M-o\M-h" 'cperl-perldoc-at-point)
	     (local-set-key "\M-o\C-H" 'cperl-perldoc)
	     (local-set-key "\M-o|" 'cperl-lineup)
	     ))





(add-hook 'Man-mode-hook '(lambda ()
			    (local-set-key "\M-n" 'scroll-up-slow)
			    (local-set-key "\M-p" 'scroll-down-slow)))




(add-hook 'sgml-mode-hook
	  '(lambda ()
	     (auto-fill-mode nil)))

(add-hook 'dired-mode-hook
	  '(lambda ()
	     (local-set-key "h" 'dired-hide-dotfiles)
	     (local-set-key "\C-c\C-q" 'wdired-change-to-wdired-mode)
	     ))

(add-hook 'octave-mode-hook
	  '(lambda ()
	     (local-set-key " " 'self-insert-command)))

(add-hook 'inferior-octave-mode-hook
	  '(lambda ()
	     (setq comint-prompt-regexp "^[^>]+> ")))

(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)

(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t) 



(add-hook 'inferior-python-mode-hook
	  '(lambda ()
	     (setq comint-prompt-regexp ">>> ")))


(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))


(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (local-set-key "\C-x\C-f" 'ido-find-file)
					;	     (add-to-list 'ibuffer-never-show-predicates "^\\*")
	     (local-unset-key "\M-o")))


(add-hook 'org-mode-hook
	  '(lambda()
	     (local-set-key "\C-\M-p" 'org-backward-element)
	     (local-set-key "\C-\M-n" 'org-forward-element)
	     (local-set-key "\M-{" 'backward-paragraph)
	     (local-set-key "\M-}" 'forward-paragraph)

					;(local-set-key "\C-\M-u" 'org-up-element)
	     (local-set-key "\C-\M-u" 'org-up-list-or-element)
	     (local-set-key "\C-\M-d" 'org-down-element)
	     (local-set-key "\C-c\M-w" 'org-refile-fullpath)
	     ;; rebound since yasnippet eats the previous shortcut
	     (local-set-key "\C-c\M-b" 'org-mark-ring-goto)

	     (local-set-key "\C-c\M-n" 'org-next-block)
	     (local-set-key "\C-c\M-p" 'org-previous-block)

	     (auto-fill-mode 1)

             (local-set-key (kbd "C-c SPC") 'ace-jump-mode)
             ))

;; yasnippet and org-mode
(defun yas/org-very-safe-expand ()
  (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))

(add-hook 'org-mode-hook
          (lambda ()
            ;; yasnippet (using the new org-cycle hooks)
            (make-variable-buffer-local 'yas/trigger-key)
            (setq yas/trigger-key [tab])
            (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
            (define-key yas/keymap [tab] 'yas/next-field)))



(add-hook 'ido-minibuffer-setup-hook
	  (lambda()
	    (define-key ido-file-completion-map "\C-t" 'transpose-chars)
	    (define-key ido-buffer-completion-map "\C-t" 'transpose-chars)
	    (define-key ido-file-dir-completion-map "\C-t" 'transpose-chars)

	    (define-key ido-file-completion-map "\M-t" 'ido-toggle-regexp)
	    (define-key ido-buffer-completion-map "\M-t" 'ido-toggle-regexp)
	    (define-key ido-file-dir-completion-map "\M-t" 'ido-toggle-regexp)


	    (define-key ido-file-completion-map "\M-b" 'backward-word)
	    (define-key ido-buffer-completion-map "\M-b" 'backward-word)
	    (define-key ido-file-dir-completion-map "\M-b" 'backward-word)

	    (define-key ido-buffer-completion-map "\M-s" 'ido-enter-find-file)
	    (local-unset-key "\M-r")
            ))



(add-hook 'erlang-mode-hook
	  (lambda()
	    (local-set-key "\C-m" 'newline-and-indent)))

(add-hook 'Info-mode-hook
	  (lambda()
	    (local-set-key "\M-n" 'scroll-up-slow)
	    (local-set-key "\M-p" 'scroll-down-slow)))

(add-hook 'latex-mode-hook
          (lambda ()
	    (add-to-list 'tex-verbatim-environments "lstlisting")
	    (set (make-local-variable 'autopair-handle-action-fns)
		 (list 'autopair-default-handle-action
		       'autopair-latex-mode-paired-delimiter-action))))



					; these characters don't autopair right
(eval-after-load "text-mode" '(modify-syntax-entry ?\" "\"" text-mode-syntax-table))
(eval-after-load "markdown-mode" '(modify-syntax-entry ?\" "\"" markdown-mode-syntax-table))
(eval-after-load "markdown-mode" '(modify-syntax-entry ?` "\"" markdown-mode-syntax-table))
					;(eval-after-load "tex-mode" '(modify-syntax-entry ?$ "\"" latex-mode-syntax-table))

(eval-after-load "org"
  '(progn
     (defalias 'org-refile-fullpath 'org-refile)

     ;; this one is for refiling to other files in the org-agenda-files
     (defadvice org-refile-fullpath (around use-full-path activate)
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



(add-hook 'folding-mode-hook
	  (lambda ()
	    (local-set-key "\C-\M-n" 'folding-next-visible-heading)
	    (local-set-key "\C-\M-p" 'folding-previous-visible-heading)
	    (local-set-key (read-kbd-macro "M-o <tab>") 'folding-toggle-show-hide)))

(eval-after-load "hideshow"
  '(progn
     (defadvice goto-line (after expand-after-goto-line
				 activate compile)
       "hideshow-expand affected block when using goto-line in a collapsed buffer"
       (save-excursion
	 (hs-show-block)))


     (defadvice idomenu (after expand-after-goto-line
			       activate compile)
       "hideshow-expand affected subroutine when using idomenu"
       (if hs-block-start-regexp
	   (save-excursion
	     (search-forward-regexp hs-block-start-regexp)
	     (hs-show-block))))
     
     (defadvice imenu-anywhere (after expand-after-goto-line
				      activate compile)
       "hideshow-expand affected subroutine when using idomenu"
       (if hs-block-start-regexp
	   (save-excursion
	     (search-forward-regexp hs-block-start-regexp)
	     (hs-show-block))))
     ))


(add-hook 'diff-mode-hook
	  (lambda ()
	    (local-set-key "\M-o" 'craig-prefix)))


(add-hook 'calc-mode-hook
	  (lambda ()
	    (yas-minor-mode -1)))

(eval-after-load "calc"
  '(define-key calc-dispatch-map "\M-u" 'calc-same-interface)
  )



;; java flymake
(require 'flymake)
(defun my-java-flymake-init ()
  (list "javac" (list (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-with-folder-structure))))

;(add-hook 'java-mode-hook 'flymake-mode-on)

(add-to-list 'flymake-allowed-file-name-masks '("\\.java$" my-java-flymake-init flymake-simple-cleanup))

(add-hook 'java-mode-hook
          (lambda ()
            (if (locate-dominating-file default-directory "build.xml")
                (set (make-local-variable 'compile-command)
                     "ant -s build.xml -e "))))

;; ibuffer -- group dired buffers with filenames
(eval-after-load "ibuf-ext"
      '(define-ibuffer-filter filename
         "Toggle current view to buffers with file or directory name matching QUALIFIER."
         (:description "filename"
          :reader (read-from-minibuffer "Filter by file/directory name (regexp): "))
         (ibuffer-awhen (or (buffer-local-value 'buffer-file-name buf)
                            (buffer-local-value 'dired-directory buf))
           (string-match qualifier it))))
