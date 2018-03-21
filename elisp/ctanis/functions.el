;; BUFFER MANAGEMENT

(defun better-display-buffer(arg)
  "a better display buffer"
  (interactive (list (ido-read-buffer "Buffer: ")))
  (let ((b (current-buffer)))
    (switch-to-buffer-other-window arg)
    (switch-to-buffer-other-window b)))


(defun find-and-display-file (FILENAME)
  "this finds file and displays it in other window without selecting it"
  (interactive "FFind and display file: ")
  (let ((buf (find-file-noselect FILENAME)))
    (better-display-buffer buf)))


(defun list-and-display-directory (dirname &optional switches)
  "this finds dired listing and displays it in other window without selecting it"
  (interactive (progn (require 'dired)	;; why doesn't autoload work?
		      (dired-read-dir-and-switches "")))
  (better-display-buffer (dired-noselect dirname switches)))


(defun sink-buffer()
"bury the current buffer, and delete the window!"
  (interactive)
  (let ((foo (buffer-name)))
    (bury-buffer)
    (message (concat "Buried " foo))
    (if (not (= (count-windows) 1))
	(delete-window))))


(defun kill-current-buffer ()
  (interactive)
  (if (buffer-modified-p)
      (error "Can't kill current buffer, buffer modified.")
    (kill-buffer (current-buffer))))


(defun kill-other-buffer ()
  "kill a buffer other than the current one, and stay in current buffer"
  (interactive)
  (with-current-buffer (window-buffer (next-window))
    (let* ((lst (mapcar (lambda (a)
			  (cons (buffer-name a) a))
			(buffer-list))))
      (kill-buffer
       (let* ((ded-buf (completing-read 
			(concat
			 "Kill (" (buffer-name) "):")
			lst nil t nil))
	      (real-ded (if (equal "" ded-buf)
			    (buffer-name)
			  ded-buf)))
	 real-ded)))))



(defun switch-windows-with-buffer (to)
  "switches current buffer position with 'to'.  this doesn't work right if
more than 2 windows are currently displayed."
  (let ((buf (current-buffer)))
    (switch-to-buffer to)
    (switch-to-buffer-other-window buf)))



(defun flip-windows ()
  "flip positions of this window and the next-window"
  (interactive)
  "flip the current buffer and another's placement in the window"
  (let* ((nextw (next-window))
	 (tot (count-windows)))
    (cond
     ((< tot 2) (error "%s" "Not enough windows to flip"))
     ((= tot 2) (funcall 'switch-windows-with-buffer (window-buffer (next-window))))
     (t (switch-windows-with-buffer
	 (let* ((buf (window-buffer nextw))
		(name (buffer-name buf))
		(ded-buf
		 (completing-read 
		  (concat "Flip with (" name "): ")
		  (mapcar (lambda (a)
			 (cons (buffer-name a) a))
		       (buffer-list))
		  nil t nil)))
	   (if (equal "" ded-buf)
	       name
	     ded-buf)))))))


(defun alternate-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer)))

(defun alternate-buffer-in-other-window ()
  (interactive)
  (better-display-buffer (other-buffer)))


;--------------------------------------------------
; This is for jumping easily to commonly used buffers.


(defvar common-buffers '(("l" . "*shell*")
			 ("s" . "*scratch*")
			 ("c" . "*compilation*")
                         ("g" . "* Guile REPL *")
                         )
  "This is the alist of codes to buffer names for use in switch-to-common-buffer")


(defvar is-common-buffer nil)

;; tweaked to work with shell-current-directory.el
(defun switch-to-common-buffer (buf-id)
  "do-jump-to-common-buffer with name corresponding to buf-id in
common-buffers alist"
  ;; TODO: build the string of options from the items in common-buffers
  (interactive "cSwitch to indexed buffer (lsc): ")

  (if (string= (char-to-string buf-id) "l")
      (let ((buff (directory-shell-buffer-name)))
	(if (get-buffer buff)
	    (progn 
	      (message buff)
	      (setq shell-last-shell buff)
	      (do-jump-to-common-buffer (get-buffer buff))
	      )
	  (if (and shell-last-shell (get-buffer shell-last-shell))
	      (do-jump-to-common-buffer shell-last-shell)
	    (error "no shell for current directory"))))
    (let* ((entry (assoc (char-to-string buf-id)
			 (filter '(lambda (i)
				    (get-buffer (cdr i)))
				 common-buffers)))
	   (bufname (and entry (cdr entry))))
      (if bufname
	  (do-jump-to-common-buffer bufname)
	(error "Selection not available"))
      (set (make-local-variable 'is-common-buffer) t)
                                          )))


;; (defun jump-to-existing-buffer (bufname)
;;   "Jump to buffer BUFNAME.  If visible go there.  Otherwise make it visible
;; and go there."
;;   (let ((buf (get-buffer bufname)))
;;     (if buf
;; 	(cond
;; 	 ((equal buf (current-buffer)) t)
;; 	 ((get-buffer-window buf t)
;; 	  (let ((win (select-window (get-buffer-window buf t))))
;; 	    (select-frame (window-frame win))
;; 	    (other-frame 0) ; switch to the selected frame?
;; 	    (select-window win)))
;; 	 ((equal (count-windows) 1)
;; 	  (switch-to-buffer-other-window buf))
;; 	 (t (switch-to-buffer bufname))))))

;; this version always jumps to it in another window
(defun do-jump-to-common-buffer (bufname)
  "Jump to buffer BUFNAME.  If visible go there.  Otherwise make it visible
and go there."
  (let ((buf (get-buffer bufname)))
    (if buf
	(cond
	 ((equal buf (current-buffer)) t)
	 ((get-buffer-window buf t)
	  (let ((win (select-window (get-buffer-window buf t))))
	    (select-frame (window-frame win))
	    (other-frame 0)             ; switch to the selected frame?
	    (select-window win)))
	 (t (if (and is-common-buffer (> (count-windows) 1))
                (switch-to-buffer bufname)
              (switch-to-buffer-other-window bufname)))))))


;; modifications of shell-current-directory.el by Daniel Polani
(defun directory-shell-buffer-name ()
  "The name of a shell buffer pertaining to DIR."
  (interactive)
  (concat "*"
	  (directory-file-name (expand-file-name default-directory))
	  "-shell*"))

(defvar shell-last-shell nil)

(defun shell-current-directory ()

  "Create a shell pertaining to the current directory."

  (interactive)
  (let ((shell-buffer-name (directory-shell-buffer-name)))
    (setq shell-last-shell shell-buffer-name)
    (if (get-buffer shell-buffer-name)
	(do-jump-to-common-buffer shell-buffer-name)
      (shell)
      (set (make-local-variable 'is-common-buffer) t)
      (rename-buffer (directory-shell-buffer-name) t))))





(require 'advice)
;-----------------------------------------------------------------------------
;; ;i stole this stuff from eric beuscher.  i'm sick of creating buffers on
;; ;accident, and then having to kill them!

;; (defadvice switch-to-buffer 
;;   (before existing-buffers-only activate)
;;   "When called interactively switch to existing buffers only, unless 
;; when called with a prefix argument."
;;   (interactive 
;;    (list (read-buffer "Switch to buffer: " (other-buffer) 
;;                       (null current-prefix-arg)))))

;; (defadvice switch-to-buffer-other-window 
;;   (before existing-buffers-only activate)
;;   "When called interactively switch to existing buffers only, unless 
;; when called with a prefix argument."
;;   (interactive 
;;    (list (read-buffer "Switch to buffer other window: " (other-buffer) 
;;                       (null current-prefix-arg)))))

;; ;; (defadvice better-display-buffer 
;; ;;   (before existing-buffers-only activate)
;; ;;   "When called interactively display existing buffers only, unless 
;; ;; when called with a prefix argument."
;; ;;   (interactive 
;; ;;    (list (read-buffer "Display buffer: " (other-buffer) 
;; ;;                       (null current-prefix-arg)))))

;; (defadvice display-buffer (around  display-buffer-return-to-sender activate)
;;   "displaying a buffer in another frame should not change the frame we are currently in!"
;;   (let ((f (window-frame (selected-window))))
;;     ad-do-it
;;     (raise-frame f)))


;; EDITING

(defun kill-to-beginning-of-line ()
  (interactive)
  (save-excursion
    (let ((p1 (point)))
      (beginning-of-line)
      (kill-region (point) p1))))

(defun just-no-space (arg)
  (interactive "P")
  (if arg
      (just-one-space -1)
    (just-one-space 1))
  (delete-char -1))


(defun zap-backwards (arg char)
  (interactive "p\ncZap backwards to char: ")
  (zap-to-char (- (prefix-numeric-value arg)) char))

(defun slide-line-left ()
  (interactive)
  (push-mark)
  (beginning-of-line)
  (just-no-space nil)
  (goto-char (mark))
  (pop-mark)
  )


;; MOVEMENT

(defvar last-jumped-to-char nil
  "This is the last character jumped to by jump-to-char")
 

(defun forward-jump-to-char (arg char)
  "jump forward to ARGth previous CHAR.  doesn't prompt when ran multiple times
in a row"
  (interactive
   (if (or (eq last-command 'forward-jump-to-char)
	   (eq last-command 'backward-jump-to-char))
       (list (or current-prefix-arg 1)
	     last-jumped-to-char)
     (progn
       (call-interactively '(lambda (arg char)
			      (interactive "p\ncJump to char: ")
			      (push-mark) ;save the current position
			      (list arg char))))))
  (setq last-jumped-to-char char)
  (forward-char 1)
  (search-forward (char-to-string char)
		  nil t arg)
  (backward-char 1))



(defun backward-jump-to-char (arg char)
  "jump backward to ARGth previous CHAR.  doesn't prompt when ran
multiple times in a row"
  (interactive
   (if (or (eq last-command 'backward-jump-to-char)
	   (eq last-command 'forward-jump-to-char))
       (list (or current-prefix-arg 1)
	     last-jumped-to-char)
     (progn
       (call-interactively '(lambda (arg char)
			      (interactive "p\ncJump to char: ")
			      (push-mark) ;save the current position
			      (list arg char))))))
  (setq last-jumped-to-char char)
  (search-forward (char-to-string char)
		  nil t (- arg)))
    


;--- scrolling made slower

(defalias 'scroll-down-slow 'scroll-down)
(defalias 'scroll-up-slow 'scroll-up)

(defadvice scroll-down-slow (before slowly activate)
  (interactive "p"))

(defadvice scroll-up-slow (before slowly activate)
  (interactive "p"))


;; MISC

(defun verify-exit (arg)
  (interactive "cDo you want to leave Emacs?")
  (if (or (equal arg 121) (equal arg 89))
      (save-buffers-kill-emacs)))


(defun insert-time-stamp (arg)
  "insert time stamp. with prefix argument, make it a comment "
  (interactive "P")
  (let ((comment-start (if arg comment-start nil))
	(comment-end (if arg comment-end nil)))
    (insert (or comment-start "")
	    (current-time-string)
	    (or comment-end ""))))

(defun insert-separator ()
  (interactive)
  (beginning-of-line)
  (open-line 1)
  (if comment-start
      (insert comment-start))
  (let ((colend (if comment-end comment-end "")))
    (dotimes (x (- fill-column (+ (current-column) (length colend))))
      (insert "-"))
    (insert colend)))


;; (defun big (how-big)
;;   (interactive "p")
;;   "Use a bigger font.  Provide a positive number indicating how big."
;;   (let ((fonts '(("fixed" . nil)
;; 		 ("7x13" . nil)
;; 		 ("8x13" . nil)
;; 		 ("9x15" . nil)
;; 		 ("10x20" . nil)
;; 		 )))
;;     (set-default-font (car (nth how-big fonts)))
;;     (eval (cdr (nth how-big fonts)))))



; have the diary print out the contents of todo file, if the current date is
; selected

;; (defvar todo-file "~/.todo")

;; (defun diary-display-todo-file ()
;;   (save-excursion
;;     (set-buffer "*Calendar*")
;;     (if (equal (calendar-current-date)
;; 	       (calendar-cursor-to-date))
;; 	(progn
;; 	  (set-buffer (or (get-buffer fancy-diary-buffer)
;; 			  (make-fancy-diary-buffer)))
;; 	  (goto-char (point-max))
;; 	  (if (file-readable-p todo-file)
;; 	      (progn
;; 		(toggle-read-only)
;; 		(message "Inserting todo-file")
;; 		(insert "\n\nTODO:\n")			  
;; 		(insert-file todo-file)
;; 		(toggle-read-only))))
;;       t
;; )))


;; (defun edit-todo-file ()
;;   (interactive)
;;   (if (and todo-file
;; 	   (file-readable-p todo-file))
;;       (find-file-other-window todo-file)
;;     (error "What TODO file?!")))


;; (defun prefix-paragraph ()
;;   (interactive)
;;   (let ((fill-prefix (buffer-substring
;; 		      (save-excursion (move-to-left-margin) (point))
;; 		      (point))))
;;     (refill-paragraph)))


;; (defvar tail-display-buffer 'display-buffer)
;; (defun tail-file (pre file)
;;   (interactive "P\nfTail file:")
;;   (let* ((args (if pre
;; 		   (read-from-minibuffer "Tail switches :" "-F")
;; 		 "-F"))
;; 	 (buf (generate-new-buffer
;; 	       (concat "*tail " file "*"))))
;;     (shell-command (concat "tail " args " " file " &") buf)
;;     (run-hooks 'tail-file-hook);
;;     (funcall tail-display-buffer buf)
;; ))


(defun shrink-other-window-if-larger-than-buffer ()
  (interactive)
  (shrink-window-if-larger-than-buffer (next-window)))

(defun interactively-enlarge-window (arg)
  (interactive "nHow much: ")
  (enlarge-window arg))

(defun selectively-delete-lines (arg)
  (interactive "P")
  (call-interactively (or (and arg
			       'delete-non-matching-lines)
			  'delete-matching-lines)))

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


;; ;; hostname mode
;; (defvar ctanis/hostname (let ((str (or (getenv "HOSTNAME") "")))
;;   (substring  str 0 (string-match "\\." str))))

;; ;modified from code for column-number-mode
;; (defvar host-name-mode nil
;;   "*Non-nil means display host name in mode line.")

;; (defun host-name-mode (arg)
;;   "Toggle Host Name mode.
;; With arg, turn Host Name  mode on iff arg is positive.
;; When Host Name mode is enabled, the column number appears
;; in the mode line."
;;   (interactive "P")
;;   (setq host-name-mode
;; 	(if (null arg) (not host-name-mode)
;; 	  (> (prefix-numeric-value arg) 0)))
;;   (force-mode-line-update))


(defun filter (pred ls)
  "filter PRED LS   returns new list of elts for which PRED is true"
  (if ls
      (if (funcall pred (car ls))
	  (cons (car ls) (filter pred (cdr ls)))
	(filter pred (cdr ls)))
    '()))

;; a better filter?
;; (defun my-filter (condp lst)
;;     (delq nil
;; 	  (mapcar (lambda (x) (and (funcall condp x) x)) lst)))




(defun base-quoted-insert (prefix)
  "Replacement for quoted-insert.  It defaults to base-16, but uses prefix argument as the radix"
  (interactive "P")
  (let* ((numprefix (prefix-numeric-value prefix))
	(read-quoted-char-radix (if (and prefix (> numprefix 0))
				    numprefix
				  16)))
    (command-execute 'quoted-insert)))


(defun dired-hide-dotfiles()
  "reload current dired buffer, hiding dotfiles"
  (interactive)
  (dired-unmark-all-marks)
  (dired-mark-files-regexp "^\\.")
  (dired-do-kill-lines))




(defvar tmp-code-dir "~/Desktop")
(defun make-tmp-code (fname)
  "create file arg in a random  directory"
  (interactive "sfilename: ")
  (let* ((str (file-name-sans-extension fname))
	 (dir (concat tmp-code-dir "/" str))
	 (file (concat dir "/" fname)))
    (ignore-errors
      (mkdir dir))
    (find-file file)))


;a little latex convenience
(defun latex_verbify()
  (interactive)
  (save-excursion
    (kill-region (point) (mark))
    (insert "\\verb|")
    (yank)
    (insert "|")))


; clean up ido-work-dirs
(defun remove-ido-work-dirs (match)
  (interactive "MRemove work directories matching: ")
  (setq ido-work-directory-list
	(filter '(lambda(c) (not
			     (string-match (concat "^.*" match) c)))
		ido-work-directory-list)))



;; (defun compile-again (pfx)
;;   """Run the same compile as the last time.

;; If there was no last time, or there is a prefix argument, this acts like
;; M-x compile.
;; """
;;  (interactive "p")
;;  (if (and (eq pfx 1)
;; 	  compilation-last-buffer
;; 	  (string= (buffer-name compilation-last-buffer) "*compilation*")
;; 	  )
;;      (progn
;;        (set-buffer compilation-last-buffer)
;;        (save-some-buffers)
;;        (revert-buffer t t))
;;    (call-interactively 'compile)))

(defun compile-again (pfx)
  "Run the same compile as the last time.

If there was no last time, or there is a prefix argument, this acts like
M-x compile."
 (interactive "p")
 (let ((oldbuf (get-buffer "*compilation*")))
   (if (and oldbuf (eq pfx 1))
       (progn
         (set-buffer oldbuf)
         (save-some-buffers)
         (revert-buffer t t))
     (call-interactively 'compile))))


;; from jennings
(defun create-file-mode ()
  "Puts an attribute list at the top of the current buffer.  The
initial entry is Mode: with the current buffer mode inserted."
  (interactive nil)
  (let ((comment-start (or comment-start "") )
	(comment-end (or comment-end "") ))
  (save-excursion
    (goto-char (point-min))
    (if (looking-at "#!")
	(progn
	  (end-of-line)
	  (insert "\n")))
    (insert comment-start " -*- mode: "
	    (downcase (car (split-string mode-name "/"))) ;; ctanis -- remove minor modes
	    "; -*- " comment-end "\n"))))


(defun monitor-tex (file)
  (interactive "fRoot Tex File: ")
  (let* ((buf (generate-new-buffer (concat "*monitor-tex: " file "*")))
	 (cmd (concat "latexmk -pdf -pvc " file " &")))
    (save-excursion
      (switch-to-buffer buf)
      (setq default-directory (file-name-directory file))
      (shell-command cmd  buf)
      (display-buffer buf))))

(defvar wrap-nice-pairs
  '((?\" . ?\") (?\( . ?\) ) (?{ . ?})  (?\< . ?\>)))

(defun wrap-nice-input-pair (c)
  (assoc c wrap-nice-pairs))

(defun wrap-nice ()
  (interactive)
  (if (region-active-p)
      (progn (save-excursion
               (let ((start (min (region-beginning) (region-end)))
                     (end (max (region-beginning) (region-end)))
                     (pair (wrap-nice-input-pair last-input-event)))
                 (setq deactivate-mark nil)
                 (goto-char end)
                 (insert (cdr pair))
                 (goto-char start)
                 (insert (car pair))))
             (forward-char 1))
    (insert last-input-event)))
        

(defun wrap-region-with-char (c)
  (interactive "cWrap with character: ")
  (if (region-active-p)
      (progn (save-excursion
               (let ((start (min (region-beginning) (region-end)))
                     (end (max (region-beginning) (region-end))))
                 (setq deactivate-mark nil)
                 (goto-char end)
                 (insert c)
                 (goto-char start)
                 (insert c)))
             (forward-char))
    (insert c)))

(defun ca-with-comment (s)
  (insert comment-start s comment-end)
  )

;; (defun switch-to-previous-window ()
;;       (interactive)
;;       (switch-to-buffer-other-window (other-buffer (current-buffer) 1)))



(defvar **other-window-mult** -1)
(defun switch-to-previous-window ()
      (interactive)
      (setq **other-window-mult** (* **other-window-mult** -1))
      (other-window **other-window-mult**))


(defun copy-region-for-paste (prefix start end)
  "save the region without formatting.  with prefix arg, also delete blank lines"
  (interactive "P\nr")
  (let ((orig (current-buffer)))
    (with-temp-buffer
      (insert-buffer-substring orig start end)
      (let ((fill-column most-positive-fixnum))
        (fill-region (point-min) (point-max)))
      (indent-rigidly (point-min) (point-max) -10000000)
      (if prefix
          (delete-non-matching-lines "." (point-min) (point-max)))
      
      (copy-region-as-kill (point-min) (point-max))
      (message "processed region is now in clipboard")
      )))


(defun save-file-local-variable (v)
  "put current value of variable v in local variable list at end of buffer"
  (interactive "vVariable: ")
  (add-file-local-variable v (symbol-value v)))

(defun clone-indirect-in-place ()
  "clone current buffer and move to current point"
  (interactive)
  (let ((pt (point))
        (m (mark))
        (n (clone-indirect-buffer nil nil)))
    (switch-to-buffer n)
    (set-mark m)
    (goto-char pt)
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
