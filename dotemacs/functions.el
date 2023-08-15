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


(defun kill-current-buffer (prefix)
  (interactive "P")
  (if (and (buffer-modified-p) (not prefix))
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
                         )
  "This is the alist of codes to buffer names for use in switch-to-common-buffer")


(defvar is-common-buffer nil)

;; how to use this for the switch-to-common-buffer prompt
;;(apply (function concat) (mapcar (function car) common-buffers))

(defun get-all-shell-buffers()
  (seq-filter (lambda (c)
                (with-current-buffer c
                  (eq major-mode 'shell-mode)))
              (buffer-list)))

(defun add-current-to-common-buffers (k)
  (interactive "cWhich quick key?")
  (let ((b (buffer-name)))
    (set (make-local-variable 'is-common-buffer) t)
    (unless (seq-filter (lambda (c)
                          (equal (cdr c) b)) common-buffers)
      (add-to-list 'common-buffers (cons (char-to-string k) (buffer-name) )))))

(defun active-common-buffers ()
  (cons '("l" . "SHELL_PLACEHOLDER")
        (seq-filter (lambda (c) (get-buffer (cdr c))) common-buffers)))

(defun remove-current-from-common-buffers (doit)
  (interactive "cAre you sure?")
  (if (equal (char-to-string doit) "y")
      (progn
        (set (make-local-variable 'is-common-buffer) nil)
        (setq common-buffers
              (seq-filter (lambda (b)
                            (not (equal (cdr b) (buffer-name)))) common-buffers)))))


;; tweaked to work with shell-current-directory.el
(defun switch-to-common-buffer (buf-id)
  "do-jump-to-common-buffer with name corresponding to buf-id in
common-buffers alist"

  ;; (interactive "cSwitch to indexed buffer (lsc): ")
  ;; (interactive "cSwitch to indexed buffer: ")

  ;; prompt now includes options
  (interactive (list (read-char (concat "Switch to indexed buffer ("
                                        (apply (function concat)
                                               (mapcar (function car) (active-common-buffers)))
                                        "): "
                                        )
                                )))

  (if (string= (char-to-string buf-id) "!")
      (call-interactively 'add-current-to-common-buffers)
    (if (string= (char-to-string buf-id) "\t")
        (call-interactively 'remove-current-from-common-buffers)
      (if (string= (char-to-string buf-id) "l")
          ;; get the most relevant shell, or create one if necessary
          (if (eq major-mode 'shell-mode)
              (let ((next-shell  (car (reverse (get-all-shell-buffers)))))
                (if current-prefix-arg
                    (switch-to-buffer-other-window next-shell)
                  (switch-to-buffer next-shell)))
                                                                        
            (let* ((buff (directory-shell-buffer-name))
                   (shells (mapcar (lambda (z)
                                     (let ((n (buffer-name z)))
                                       (cons (longest-prefix buff n) z)))
                                   (get-all-shell-buffers))))
              (message (buffer-name (cdar shells)))
              (if shells
                  (do-jump-to-common-buffer
                   (cdar (sort shells (lambda (a b) (> (car a) (car b))))))
                (shell-current-directory))))

        (let* ((entry (assoc (char-to-string buf-id)
                             (seq-filter (lambda (i)
                                           (get-buffer (cdr i)))
                                         (active-common-buffers))))
               (bufname (and entry (cdr entry))))
          (if bufname
              (do-jump-to-common-buffer bufname)
            (error (concat "Selection not available" bufname)))
          (set (make-local-variable 'is-common-buffer) t))))))


(defun replace-visible-common-buffer (buffer)
  (if is-common-buffer
      (switch-to-buffer buffer)
    (let ((win 
           (save-excursion
             (get-window-with-predicate (lambda (win)
                                          (select-window win)
                                          is-common-buffer)))))
      (if win
          (progn
            (select-window win)
            (switch-to-buffer buffer)
            t)
        nil))))


(defun do-jump-to-common-buffer (bufname)
  "Jump to buffer BUFNAME.  If visible go there.  Otherwise make
it visible (prioritizing the replacement of a different
common-buffer) and go there."
  (if current-prefix-arg ;; always open in other window
      ;; if we are in a common buffer, a prefix means "flip" the expected behavior
      (switch-to-buffer-other-window bufname)
    (let ((buf (get-buffer bufname)))
      (if buf
          (cond
           ((equal buf (current-buffer)) t)
           ((get-buffer-window buf t)
            (let ((win (select-window (get-buffer-window buf t))))
              (select-frame (window-frame win))
              (other-frame 0)           ; switch to the selected frame?
              (select-window win)))
           ((eq (count-windows) 1) (switch-to-buffer-other-window bufname)) ;; always split a window
           ;((replace-visible-common-buffer buf) t)
           (t (if current-prefix-arg
                  (switch-to-buffer-other-window bufname)
                (switch-to-buffer bufname)))))))) ;; in this case, simply reuse current window


;; modifications of shell-current-directory.el by Daniel Polani
(defun directory-shell-buffer-name ()
  "The name of a shell buffer pertaining to DIR."
  (interactive)
  (concat "*"
          (let ((dn
                 (directory-file-name (expand-file-name default-directory))))
            (if (string-prefix-p "/scp:" dn)
                (substring dn 1)
              dn))
	  "-shell*"))

(defvar shell-last-shell nil)

(defun shell-current-directory ()

  "Create a shell pertaining to the current directory."

  (interactive)
  (let ((shell-buffer-name (directory-shell-buffer-name)))
    (setq shell-last-shell shell-buffer-name)
    (if (get-buffer shell-buffer-name)
	(do-jump-to-common-buffer shell-buffer-name)
      (progn (save-window-excursion
               (let ((explicit-shell-file-name (getenv "SHELL"))) (shell))
               (rename-buffer (directory-shell-buffer-name) t)
               (set (make-local-variable 'is-common-buffer) t)
               )
             (do-jump-to-common-buffer shell-buffer-name)
             ))))





(require 'advice)

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
       (call-interactively (lambda (arg char)
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
       (call-interactively (lambda (arg char)
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






(defun base-quoted-insert (prefix)
  "Replacement for quoted-insert.  It defaults to base-16, but uses prefix argument as the radix"
  (interactive "P")
  (let* ((numprefix (prefix-numeric-value prefix))
	(read-quoted-char-radix (if (and prefix (> numprefix 0))
				    numprefix
				  16)))
    (command-execute 'quoted-insert)))




(defvar tmp-code-dir (concat (getenv "HOME") "/Desktop"))
(defun make-tmp-code (fname)
  "create file arg in a random  directory"
  (interactive "sfilename: ")
  (let* ((str (file-name-sans-extension fname))
	 (dir (concat tmp-code-dir "/" str))
	 (file (concat dir "/" fname)))
    (ignore-errors
      (mkdir dir))
    (ignore-errors
      (ido-record-work-file file)
      (ido-record-work-directory dir))
    (find-file file)))


;a little latex convenience
(defun latex_verbify()
  (interactive)
  (save-excursion
    (kill-region (point) (mark))
    (insert "\\verb|")
    (yank)
    (insert "|")))


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


(defun tildefy-path (path)
  "replace home directory with tilde in path, for platform
agnostic agenda-file management"
  (let* ((h (getenv "HOME"))
        (term (if (string-suffix-p "/" h)
                  "/" ""                  )))
    (if (string-prefix-p h path)
        (concat "~" term (substring path (length h)))
      path)))

;; x-windows clipboard
(defun system-yank ()
  (interactive)
  (insert (gui-get-primary-selection)))


;; kinda useful for macos
(defun fs-all ()
  (interactive)
  (mapcar (lambda (f)
            (select-frame f t)
            (toggle-frame-fullscreen))
          (frame-list)))


;; replace region with ch copied as necessary
(defun replace-region (start end ch)
  (interactive "r\nc Fill with char: ")
  (message (format "%d -- %d" start end))
  (delete-region start end)
  (dotimes (_ (- end start)) (insert ch)))

(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))


(defun ddg-search (prefix str)
  (interactive "P\nMSearch term: ")
  (let ((arg
         (if (region-active-p)
             (concat str (if prefix " \"" " ")
                     (buffer-substring (region-beginning) (region-end))
                     (if prefix "\""))
           str)))
  (browse-url (concat "https://duckduckgo.com/?q=" (url-hexify-string arg)))))

(defun active-mark-rectangle()
  (interactive)
  ;(setq transient-mark-mode 'lambda) ;; set it temporarily
  (activate-mark)
  (rectangle-mark-mode)
  )

;; run cmd with output to buffer bname, running optional hook
(defun capture-cmd (cmd bname &optional hook)
  (let ((buf (get-buffer-create bname)))
    (save-current-buffer
      (set-buffer buf)
      (erase-buffer)
      (shell-command cmd (current-buffer))
      (if hook
          (funcall hook))
      )
    buf))


;; figure out how many leading characters s1 and s2 share
(defun longest-prefix (s1 s2)
  (if (or (string-empty-p s1) (string-empty-p s2))
      0
    (if (char-equal (string-to-char s1) (string-to-char s2))
        (+ 1 (longest-prefix (substring s1 1)
                             (substring s2 1)))
      0)))


;; selective invisibilty
(defun crt-hide-matches (regexp)
  (add-to-invisibility-spec 'crt-hideme)
  (let ((inhibit-read-only t))
    (save-excursion
     (goto-char (point-min))
     (while (search-forward-regexp regexp nil 'noerror)
       (put-text-property (match-beginning 0) (match-end 0)
                          'invisible 'crt-hideme)))))

(defun crt-show-all ()
  (interactive)
  (remove-from-invisibility-spec 'crt-hideme))
