(setq gdb-many-windows t)
(setq compilation-scroll-output t)


;; FORTRAN

(defun fortran_narrow_sub()
  (interactive)
  (save-excursion
    (beginning-of-defun)
    (let ((start (point)))
      (next-line)
      (end-of-defun)
      (narrow-to-region start (point)))))

(eval-after-load 'fortran
  (add-hook 'fortran-mode-hook
            #'(lambda()
                (auto-fill-mode 1)
                (local-set-key "\C-\M-u" 'fortran-beginning-of-block)
                (electric-indent-mode -1))))

(eval-after-load 'f90
  '(progn
     (define-key f90-mode-map (kbd "\C-x n d") 'fortran_narrow_sub)

     (add-hook 'f90-mode-hook
               #'(lambda()
                   (local-set-key "\C-m" 'newline-and-indent)
                   (local-set-key "\C-c\C-c" 'compile)
                   (setq f90-do-indent 2)
                   (setq f90-if-indent 2)
                   (setq f90-type-indent 2)
                   (setq f90-program-indent 2)
                   ))
     ))




;; perl
;; eval-buffer-as-perl-script caveats:


;;  one thing to note is that perl is run under bash under emacs.
;;  If the command line args you specify don't work in the shell, then
;;  you get a bash error in the perl output buffer..

;;  if the perl script is expecting input from the user, it will just
;;  hang if you run it. ( but it hangs in the background, so it won't
;;  slow you down)-- you have to manually kill it (or exit emacs.. but
;;  why would you want to do that?)

;;  syntax checking works fine however....


(defun eval-buffer-as-perl-script (pre)
  "Send the current buffer to a perl interpreter for syntax checking.  With
a prefix arg, run it in another window"
  (interactive "P")
  
  (if (not buffer-file-name)
      (error "No file for current buffer"))
  (save-some-buffers)

  (let* ((line-args (if pre (read-from-minibuffer "Command-line args: ")
		      ""))
	 (perl-buffer-file-name  (concat
				  "*Perl: "
				  buffer-file-name))
	 (buf (and pre (or (get-buffer perl-buffer-file-name)
			   (generate-new-buffer perl-buffer-file-name)))))

    (shell-command (concat "perl "
			   (if pre
			       ""
			     "-c ")
			   buffer-file-name
			   " " line-args " "
			   (if pre " &" ""))
		   (if pre buf nil))
    (if pre
	(display-buffer buf))))


(defun make-perl-script ()
  (interactive)
  (executable-set-magic "perl" "-w")
  (perl-mode))


;; C/C++



;; python
(setq python-shell-interpreter "python3")
(setq python-shell-completion-native-enable nil)



;; flycheck

(defun c-semi&comma-no-newline-amidst-content ()
  "Controls newline insertion after semicolons.
If a comma was inserted, no determination is made.  If a semicolon was
inserted, and we are not at the end of a block, no newline is inserted.
Otherwise, no determination is made."
  (if (= (c-last-command-char) ?\;)
      (if (save-excursion
            (skip-syntax-forward "->")
            (or (= (point-max) (point))
                (= (char-syntax (char-after)) ?\) )))
            t
        'stop)
    nil))

(c-add-style "ctanis" '("ellemtel"
			(c-basic-offset . 4)
			(c-offsets-alist
			 (case-label . 1)
			 (access-label . -)
                                        ; (cpp-macro . 0)
					; (cpp-macro . -)
                         (innamespace . [0])
			 )
			(c-hanging-braces-alist
			 (substatement-open . 'before)
			 (class-open . 'before)
			 (defun-open . 'before)
			 (block-open . 'before)
			 (brace-list-open)
			 (brace-entry-open)
			 (statement-case-open . 'before)
			 (extern-lang-open . 'before)
			 (namespace-open . 'after)
                         (namespace-close)
			 (inline-open)
			 (class-close)
			 )
			(c-hanging-semi&comma-criteria .
						       (
                                                        c-semi&comma-no-newlines-before-nonblanks
                                                        c-semi&comma-no-newline-amidst-content
                                                        c-semi&comma-no-newlines-for-oneline-inliners
							c-semi&comma-inside-parenlist))
                        ;(c-hanging-semi&comma-criteria . nil)
			))
(setq c-default-style "ctanis")

(defvar ctanis-dflt-c-compiler "gcc -Wall ")
(defvar ctanis-dflt-cpp-compiler "g++ -Wall ")


(defun ctanis-choose-compiler (mode)
  (cond
   ((eq mode 'c-mode) ctanis-dflt-c-compiler)
   (t ctanis-dflt-cpp-compiler)))

(add-hook 'c-mode-common-hook
	  #'(lambda ()
	      (local-set-key "\C-c\C-c" 'compile)
	      (local-set-key "\C-m" 'newline-and-indent)
	      (c-toggle-auto-newline 1)
	      (c-toggle-hungry-state -1)
	      (abbrev-mode -1)
	      (cwarn-mode 1)
					; (local-set-key "}" 'self-insert-command)
	      (local-set-key "\C-c\C-g" 'c-toggle-hungry-state)
	      (local-set-key "\C-\M-e" 'up-list)
	      (local-set-key "\M-o\M-e" 'c-end-of-defun)

             
              (if (not (locate-dominating-file default-directory "Makefile"))
                  (if buffer-file-name
                      (set (make-local-variable 'compile-command)
                           (concat (ctanis-choose-compiler major-mode)
                                   (file-name-nondirectory buffer-file-name)))))

	      ;; so autopair works with electric braces and auto newline
	      ;; (make-variable-buffer-local 'autopair-pair-criteria)
	      ;; (setq autopair-pair-criteria 'always)
	      ;; (setq autopair-handle-action-fns
	      ;; 	   (list 'autopair-default-handle-action
	      ;; 		 'autopair-cleanup-closing-brace))

              ;; (local-set-key "}" 'self-insert-command) ;; electric-brace
              ;;                                          ;; doesn't play well
              ;;                                          ;; with autopair

	      ))


(defun indent-omp-pragmas ()
  (interactive)
  (c-set-offset (quote cpp-macro) 0)
  (save-excursion
    (goto-char (point-min))
    (insert comment-start " -*- mode: "
	    (downcase (car (split-string mode-name "/"))) ;; ctanis -- remove minor modes
	    "; eval: (c-set-offset (quote cpp-macro) 0)-*- " comment-end "\n")

    ))


(define-key craig-prefix-map "\M-f" 'flycheck-mode)
(define-key craig-prefix-map "\M-p" 'flycheck-previous-error)
(define-key craig-prefix-map "\M-n" 'flycheck-next-error)

(eval-after-load 'flycheck
  #'(progn
      (flycheck-define-checker java-single
        "simple single-file checker using javac."
        :command ("javac" "-Xlint" source)
        :error-patterns
        ((error line-start (file-name) ":" line ": error:" (message) line-end)
         (warning line-start (file-name) ":" line ": warning:" (message) line-end))
        :modes java-mode
        )

      (add-to-list 'flycheck-checkers 'java-single))
  )



					; C style
;; (setq c-default-style '((c-mode  . "k&r")
;; 			(c++-mode . "stroustrup")
;; 			(objc-mode . "k&r")
;; 			(other . "ellemtel")))

;; this should be somewhere other than hooks.el

(defun c-semi&comma-no-newline-amidst-content ()
  "Controls newline insertion after semicolons.
If a comma was inserted, no determination is made.  If a semicolon was
inserted, and we are not at the end of a block, no newline is inserted.
Otherwise, no determination is made."
  (if (= (c-last-command-char) ?\;)
      (if (save-excursion
            (skip-syntax-forward "->")
            (or (= (point-max) (point))
                (= (char-syntax (char-after)) ?\) )))
            t
        'stop)
    nil))

(c-add-style "ctanis" '("ellemtel"
			(c-basic-offset . 4)
			(c-offsets-alist
			 (case-label . 1)
			 (access-label . -)
                                        ; (cpp-macro . 0)
					; (cpp-macro . -)
                         (innamespace . [0])
			 )
			(c-hanging-braces-alist
			 (substatement-open . 'before)
			 (class-open . 'before)
			 (defun-open . 'before)
			 (block-open . 'before)
			 (brace-list-open)
			 (brace-entry-open)
			 (statement-case-open . 'before)
			 (extern-lang-open . 'before)
			 (namespace-open . 'after)
                         (namespace-close)
			 (inline-open)
			 (class-close)
			 )
			(c-hanging-semi&comma-criteria .
						       (
                                                        c-semi&comma-no-newlines-before-nonblanks
                                                        c-semi&comma-no-newline-amidst-content
                                                        c-semi&comma-no-newlines-for-oneline-inliners
							c-semi&comma-inside-parenlist))
                        ;(c-hanging-semi&comma-criteria . nil)
			))
(setq c-default-style "ctanis")
