(eval-after-load
 "compile"
 '(defun compile-internal (command error-message
				  &optional name-of-mode parser regexp-alist
				  name-function)
   "Run compilation command COMMAND (low level interface).
ERROR-MESSAGE is a string to print if the user asks to see another error
and there are no more errors.  Third argument NAME-OF-MODE is the name
to display as the major mode in the compilation buffer.

Fourth arg PARSER is the error parser function (nil means the default).  Fifth
arg REGEXP-ALIST is the error message regexp alist to use (nil means the
default).  Sixth arg NAME-FUNCTION is a function called to name the buffer (nil
means the default).  The defaults for these variables are the global values of
\`compilation-parse-errors-function', `compilation-error-regexp-alist', and
\`compilation-buffer-name-function', respectively.

Returns the compilation buffer created.

My additions:
If the compilation window is already visible in some frame, then a new window
in the current frame is not additionally made
"
   (let (outbuf)
     (save-excursion
       (or name-of-mode
	   (setq name-of-mode "Compilation"))
       (setq outbuf
	     (get-buffer-create
	      (funcall (or name-function compilation-buffer-name-function
			   (function (lambda (mode)
				       (concat "*" (downcase mode) "*"))))
		       name-of-mode)))
       (set-buffer outbuf)
       (let ((comp-proc (get-buffer-process (current-buffer))))
	 (if comp-proc
	     (if (or (not (eq (process-status comp-proc) 'run))
		     (yes-or-no-p
		      (format "A %s process is running; kill it? "
			      name-of-mode)))
		 (condition-case ()
		     (progn
		       (interrupt-process comp-proc)
		       (sit-for 1)
		       (delete-process comp-proc))
		   (error nil))
	       (error "Cannot have two processes in `%s' at once"
		      (buffer-name))
	       )))
       ;; In case the compilation buffer is current, make sure we get the global
       ;; values of compilation-error-regexp-alist, etc.
       (kill-all-local-variables))
     (let ((regexp-alist (or regexp-alist compilation-error-regexp-alist))
	   (parser (or parser compilation-parse-errors-function))
	   (thisdir default-directory)
	   outwin)
       (save-excursion
	 ;; Clear out the compilation buffer and make it writable.
	 ;; Change its default-directory to the directory where the compilation
	 ;; will happen, and insert a `cd' command to indicate this.
	 (set-buffer outbuf)
	 (setq buffer-read-only nil)
	 (buffer-disable-undo (current-buffer))
	 (erase-buffer)
	 (buffer-enable-undo (current-buffer))
	 (setq default-directory thisdir)
	 (insert "cd " thisdir "\n" command "\n")
	 (set-buffer-modified-p nil))
       ;; If we're already in the compilation buffer, go to the end
       ;; of the buffer, so point will track the compilation output.
       (if (eq outbuf (current-buffer))
	   (goto-char (point-max)))
       ;; Pop up the compilation buffer.
       
       ;; BEGIN -- dont duplicate visible windows
       (setq outwin (or (get-buffer-window (get-buffer outbuf) t)
			(display-buffer outbuf)))
       ;; END -- dont duplicate visible windows
       
       (save-excursion
	 (set-buffer outbuf)
	 (compilation-mode)
	 ;; (setq buffer-read-only t)  ;;; Non-ergonomic.
	 (set (make-local-variable 'compilation-parse-errors-function) parser)
	 (set (make-local-variable 'compilation-error-message) error-message)
	 (set (make-local-variable 'compilation-error-regexp-alist) regexp-alist)
	 (setq default-directory thisdir
	       compilation-directory-stack (list default-directory))
	 (set-window-start outwin (point-min))
	 (setq mode-name name-of-mode)
	 (or (eq outwin (selected-window))
	     
	     ;; BEGIN -- i want to follow along when it is in other window
	     ;;(set-window-point outwin (point-min)))
	     (set-window-point outwin (point-max)))
	     ;; END -- i want to follow along when it is in other window
	 
	 (compilation-set-window-height outwin)
	 ;; Start the compilation.
	 (if (fboundp 'start-process)
	     (let* ((process-environment (cons "EMACS=t" process-environment))
		    (proc (start-process-shell-command (downcase mode-name)
						       outbuf
						       command)))
	       (set-process-sentinel proc 'compilation-sentinel)
	       (set-process-filter proc 'compilation-filter)
	       (set-marker (process-mark proc) (point) outbuf)
	       (setq compilation-in-progress
		     (cons proc compilation-in-progress)))
	   ;; No asynchronous processes available.
	   (message "Executing `%s'..." command)
	   ;; Fake modeline display as if `start-process' were run.
	   (setq mode-line-process ":run")
	   (force-mode-line-update)
	   (sit-for 0)			; Force redisplay
	   (let ((status (call-process shell-file-name nil outbuf nil "-c"
				       command)))
	     (cond ((numberp status)
		    (compilation-handle-exit 'exit status
					     (if (zerop status)
						 "finished\n"
					       (format "\
exited abnormally with code %d\n"
						       status))))
		   ((stringp status)
		    (compilation-handle-exit 'signal status
					     (concat status "\n")))
		   (t
		    (compilation-handle-exit 'bizarre status status))))
	   (message "Executing `%s'...done" command))))
     ;; Make it so the next C-x ` will use this buffer.
     (setq compilation-last-buffer outbuf))))
