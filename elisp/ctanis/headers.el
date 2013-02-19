(require 'attribute)

(defvar header-user-name "My name");


(defun c-make-block-comment (begin end)
  "This is a pretty dumb block comment tool for C code" 
  (interactive "r")			;get the region
  (if (> begin end) (let (mid) (setq mid begin begin end end mid)))
  (let ((p (point-marker)))
    (save-excursion
      (goto-char end)
      (search-backward-regexp ".")
      (end-of-line)
      (open-line 1)
      (next-line 1)
      (setq end (point))
      (save-restriction
	(narrow-to-region begin end)
	(goto-char begin)
	(search-forward-regexp ".")
	(beginning-of-line)
	(insert "/*\n")
	(c-indent-line)
	(while (not (eobp))
	  (insert "** ")
	  (c-indent-line)
	  (forward-line 1))
	(insert "*/")
	(c-indent-line)))
    (end-of-line)))

(defun make-generic-header ()

  "this constructs a strange header at the top of the file.)"

  (interactive)
  (save-excursion
    (create-attribute-list)
    (goto-char (point-min))
    (forward-line 1)
    (open-line 1)
    (let ((p1 (point)))
      (insert "\n" header-user-name "\n")
      (insert  user-mail-address "\n")

      (insert "\n" (buffer-name))
      (open-line 2)
      (forward-line 1)
      (comment-region p1 (point)))))

(defun make-c-header ()

  "this constructs a strange header (for C code) at the top of the
file.  Note: this will NOT do anything to the first line of the file,
leaving room for attribute lists or magic cookies"
  
  (interactive)
  (goto-char (point-min))
  (let ((p1 (point)))


    (insert header-user-name "\n")
    (insert  user-mail-address "\n")

    (insert "\n" (buffer-name)"\n\n")
    (open-line 2)
    (forward-line 1)
    (c-make-block-comment p1 (point))

    (goto-char (point-min))
    (end-of-line)
    (insert " -*- Mode: C; -*-\n**")
    (forward-line 5)
    (insert "**\n** \n")
    (backward-char 1)
    ))

