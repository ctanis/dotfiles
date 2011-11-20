(defvar hw-path "~/hw")
(defvar dev-path "~/dev")

(defun hw (match)
  (interactive "MName: ")
  (let ((dirs (hw-directories-internal hw-path (string-append "^" match ".*"))))
    (if (> (length dirs) 0)
	(progn
	  (setq file-name-history (cons (car dirs) file-name-history))
	  (dired (car dirs)))
      (message "no match"))))


(defun dv (match)
  (interactive "MName: ")
  (let ((dirs (hw-directories-internal dev-path (string-append ".*" match ".*"))))
    (if (> (length dirs) 0)
	(progn
	  (setq file-name-history (cons (car dirs) file-name-history))
	  (dired (car dirs)))
      (message "no match"))))

(defun hw-directories-internal (dir match)
  (let ((case-fold-search t)
	(current-subdirs
	 (delq nil
	       (mapcar '(lambda(d)
			  (if (and
			       ;; it's a directory
			       (eq (cadr d) t)
			       ;; it isn't a hidden dir
			       (not (equal "."
					   (substring (car d) 0 1)))

			       ;; it's not CVS
			       (not (equal "CVS" (car d))))

			      (car d)
			    nil))
		       (directory-files-and-attributes dir nil nil t)))))

    (apply 'append
     (delq nil
	   ;; matches in current directory
	   (mapcar '(lambda (d)
		      (if (string-match match d)
			  (string-append dir "/" d)
			nil))
		   current-subdirs))

     
     (mapcar '(lambda (d)
		(hw-directories-internal (string-append dir "/" d) match))
	     current-subdirs))))

