;; BUFFER MANAGEMENT

(defun better-display-buffer(arg)
  "a better display buffer"
  (interactive "B")
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
    (message (string-append "Buried " foo))
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
  (save-excursion
    (set-buffer (window-buffer (next-window)))
    (let* ((lst (mapcar (lambda (a)
			  (cons (buffer-name a) a))
			(buffer-list))))
      (kill-buffer
       (let* ((ded-buf (completing-read 
			(string-append
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
		  (string-append "Flip with (" name "): ")
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
			 ("i" . "*info*")
			 ("s" . "*scratch*")
			 ("b" . "*Backtrace*"))
  "This is the alist of codes to buffer names for use in switch-to-common-buffer")


;; tweaked to work with shell-current-directory.el
(defun switch-to-common-buffer (buf-id)
  "Jump-to-existing-buffer with name corresponding to buf-id in
common-buffers alist"
  (interactive "cSwitch to indexed buffer (lisb): ")

  (if (string= (char-to-string buf-id) "l")
      (let ((buff (directory-shell-buffer-name)))
	(if (get-buffer buff)
	    (progn 
	      (message buff)
	      (jump-to-existing-buffer (get-buffer buff))
	      )
	  (if (and shell-last-shell (get-buffer shell-last-shell))
	      (jump-to-existing-buffer shell-last-shell)
	    (error "no shell for current directory"))))
    (let* ((entry (assoc (char-to-string buf-id)
			 (filter '(lambda (i)
				    (get-buffer (cdr i)))
				 common-buffers)))
	   (bufname (and entry (cdr entry))))
      (if bufname
	  (jump-to-existing-buffer bufname)
	(error "Selection not available")))))


(defun jump-to-existing-buffer (bufname)
  "Jump to buffer BUFNAME.  If visible go there.  Otherwise make it visible
and go there."
  (let ((buf (get-buffer bufname)))
    (if buf
	(cond
	 ((equal buf (current-buffer)) t)
	 ((get-buffer-window buf t)
	  (let ((win (select-window (get-buffer-window buf t))))
	    (select-frame (window-frame win))
	    (other-frame 0) ; switch to the selected frame?
	    (select-window win)))
	 ((equal (count-windows) 1)
	  (switch-to-buffer-other-window buf))
	 (t (switch-to-buffer bufname))))))


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
	(jump-to-existing-buffer shell-buffer-name)
      (shell)
      (rename-buffer (directory-shell-buffer-name) t))))





(require 'advice)
;-----------------------------------------------------------------------------
;i stole this stuff from eric beuscher.  i'm sick of creating buffers on
;accident, and then having to kill them!

(defadvice switch-to-buffer 
  (before existing-buffers-only activate)
  "When called interactively switch to existing buffers only, unless 
when called with a prefix argument."
  (interactive 
   (list (read-buffer "Switch to buffer: " (other-buffer) 
                      (null current-prefix-arg)))))

(defadvice switch-to-buffer-other-window 
  (before existing-buffers-only activate)
  "When called interactively switch to existing buffers only, unless 
when called with a prefix argument."
  (interactive 
   (list (read-buffer "Switch to buffer other window: " (other-buffer) 
                      (null current-prefix-arg)))))

(defadvice better-display-buffer 
  (before existing-buffers-only activate)
  "When called interactively display existing buffers only, unless 
when called with a prefix argument."
  (interactive 
   (list (read-buffer "Display buffer: " (other-buffer) 
                      (null current-prefix-arg)))))

(defadvice display-buffer (around  display-buffer-return-to-sender activate)
  "displaying a buffer in another frame should not change the frame we are currently in!"
  (let ((f (window-frame (selected-window))))
    ad-do-it
    (raise-frame f)))


;; EDITING

(defun kill-to-beginning-of-line ()
  (interactive)
  (save-excursion
    (let ((p1 (point)))
      (beginning-of-line)
      (kill-region (point) p1))))

(defun just-no-space ()
  (interactive)
  (just-one-space)
  (delete-backward-char 1))


(defun zap-backwards (arg char)
  (interactive "p\ncZap backwards to char: ")
  (zap-to-char (- (prefix-numeric-value arg)) char))


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

(defun big (how-big)
  (interactive "p")
  "Use a bigger font.  Provide a positive number indicating how big."
  (let ((fonts '(("fixed" . nil)
		 ("7x13" . nil)
		 ("8x13" . nil)
		 ("9x15" . nil)
		 ("10x20" . nil)
		 )))
    (set-default-font (car (nth how-big fonts)))
    (eval (cdr (nth how-big fonts)))))



(defvar frame-mitosis-y 62)
(defvar frame-mitosis-x1 18)
(defvar frame-mitosis-x2 842)

(defun frame-mitosis()
  (interactive )

  (let ((width 88)
	(height 60)
	(geom-y frame-mitosis-y)
	(geom-x1 frame-mitosis-x1)
	(geom-x2 frame-mitosis-x2)
	(font "9x15"))

    (set-frame-height (selected-frame) height)
    (set-frame-width (selected-frame) width)
    (set-frame-position (selected-frame) geom-x2 geom-y)
    (big 3)

    (let ((after-make-frame-functions (cons '(lambda (frame)
					       (set-frame-height frame height)
					       (set-frame-width frame width)
					       (set-frame-position frame geom-x1 geom-y))
					    after-make-frame-functions))
	  (default-frame-alist
	    (cons (cons 'font font)
		  default-frame-alist)))
      (let ((f (new-frame)))
	(select-frame f)
	(big 3)
	(color *color-selection*)))))


(defun mono-framify()
  (interactive)
  (if (> (length (frame-list)) 1)
      (delete-frame))
    
  (let ((f (car (frame-list))))
    (set-frame-height f 60)
    (set-frame-width f 88)
    (set-frame-position f 309 75)))



; have the diary print out the contents of todo file, if the current date is
; selected

(defvar todo-file "~/.todo")

(defun diary-display-todo-file ()
  (save-excursion
    (set-buffer "*Calendar*")
    (if (equal (calendar-current-date)
	       (calendar-cursor-to-date))
	(progn
	  (set-buffer (or (get-buffer fancy-diary-buffer)
			  (make-fancy-diary-buffer)))
	  (goto-char (point-max))
	  (if (file-readable-p todo-file)
	      (progn
		(toggle-read-only)
		(message "Inserting todo-file")
		(insert "\n\nTODO:\n")			  
		(insert-file todo-file)
		(toggle-read-only))))
      t
)))


(defun edit-todo-file ()
  (interactive)
  (if (and todo-file
	   (file-readable-p todo-file))
      (find-file-other-window todo-file)
    (error "What TODO file?!")))


;; (defun prefix-paragraph ()
;;   (interactive)
;;   (let ((fill-prefix (buffer-substring
;; 		      (save-excursion (move-to-left-margin) (point))
;; 		      (point))))
;;     (refill-paragraph)))


(defvar tail-display-buffer 'display-buffer)
(defun tail-file (pre file)
  (interactive "P\nfTail file:")
  (let* ((args (if pre
		   (read-from-minibuffer "Tail switches :" "-f")
		 "-f"))
	 (buf (generate-new-buffer
	       (concat "*tail " file "*"))))
    (shell-command (concat "tail " args " " file " &") buf)
    (run-hooks 'tail-file-hook);
    (funcall tail-display-buffer buf)
))


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


;; hostname mode
(defvar hostname (let ((str (or (getenv "HOSTNAME") "")))
  (substring  str 0 (string-match "\\." str))))

;modified from code for column-number-mode
(defvar host-name-mode nil
  "*Non-nil means display host name in mode line.")

(defun host-name-mode (arg)
  "Toggle Host Name mode.
With arg, turn Host Name  mode on iff arg is positive.
When Host Name mode is enabled, the column number appears
in the mode line."
  (interactive "P")
  (setq host-name-mode
	(if (null arg) (not host-name-mode)
	  (> (prefix-numeric-value arg) 0)))
  (force-mode-line-update))


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
    (mkdir dir)
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
			     (string-match (string-append "^.*" match) c)))
		ido-work-directory-list)))



(setq compilation-last-buffer nil)
(defun compile-again (pfx)
  """Run the same compile as the last time.

If there was no last time, or there is a prefix argument, this acts like
M-x compile.
"""
 (interactive "p")
 (if (and (eq pfx 1)
	  compilation-last-buffer
	  (string= (buffer-name compilation-last-buffer) "*compilation*")
	  )
     (progn
       (set-buffer compilation-last-buffer)
       (save-some-buffers)
       (revert-buffer t t))
   (call-interactively 'compile)))
