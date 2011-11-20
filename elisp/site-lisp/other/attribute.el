;; -*- Mode: Emacs-lisp;  -*-
;;
;; attribute.el
;;
;; JSJ 3/92
;;
;; functions to parse the attribute list.


;;; This should be in emacs, but it isn't.
(defun comint-mem (item list &optional elt=)
  "Test to see if ITEM is equal to an item in LIST.
Option comparison function ELT= defaults to equal."
  (let ((elt= (or elt= (function equal)))
	(done nil))
    (while (and list (not done))
      (if (funcall elt= item (car list))
	  (setq done list)
	  (setq list (cdr list))))
    done))

(defun string-append (&rest strings)
  (let ((s (make-string (apply '+ (mapcar 'length strings)) 0))
	(i 0) (j 0))
    (while strings
      (setq j 0)
      (while (< j (length (car strings)))
	(aset s i (aref (car strings) j))
	(setq j (+ j 1))
	(setq i (+ i 1)))
      (setq strings (cdr strings)))
    s))


(defun get-attribute-position (name)
  "Look for an attribute in the -*- attribute list of current buffer.
Returns a pair (beg . end) of positions if attribute NAME:FOO occurs
between -*-'s in the first lineof the file, otherwise returns nil."
  (let (beg end val)
    (save-excursion
      (goto-char (point-min))
      (skip-chars-forward " \t\n")
      (if (and (search-forward "-*-"
			       (save-excursion (end-of-line) (point))
			       t)
	       (progn
		 (skip-chars-forward " \t")
		 (setq beg (point))
		 (search-forward "-*-"
				 (save-excursion (end-of-line) (point))
				 t))
	       (progn
		 (forward-char -3)
		 (skip-chars-backward " \t")
		 (setq end (point))
		 (goto-char beg)
		 (if (search-forward ":" end t)
		     (progn
		       (goto-char beg)
		       (if (let ((case-fold-search t))
			     (search-forward (string-append name ":") end t))
			   (progn
			     (skip-chars-forward " \t")
			     (setq beg (point))
			     (if (search-forward ";" end t)
				 (forward-char -1)
				 (goto-char end))
			     (skip-chars-backward " \t")
			     (setq end (point))
			     t)))
		   (equal name "mode"))))
	  (cons beg end)
	nil))))


(defun set-in-attribute-list (attrib value)
  "Sets an attribute to a value in the attribute list of the current
buffer.  Asks if it should create the entry if it doesn't exist."
  (interactive "sAttribute name: \nsValue: ")
  (let ((p (get-attribute-position attrib)))
    (if p
	(save-excursion 
	  (delete-region (car p) (cdr p))
	  (goto-char (car p))
	  (insert value))
	(let ((answer (yes-or-no-p
		       "Entry not in attribute list.  Create it? ")))
	  (if answer
	      (insert-in-attribute-list attrib value)
	      (error "No attribute list entry with that attribute name."))))))


(defun get-attribute-list-position ()
  "Looks for an attribute list at the top of the buffer.
Returns a pair (beg . end) of positions, where beg is inside the first
-*- in the first (nonempty) line of the file, and end is inside the 
last -*- on the line.   If there's no attribute list,  returns nil."
  (interactive nil)
  (let (beg end)
    (save-excursion
      (goto-char (point-min))
      (skip-chars-forward " \t\n")
      (if (and (search-forward "-*-"
			       (save-excursion (end-of-line) (point))
			       t)
	       (progn
		 (skip-chars-forward " \t")
		 (setq beg (point))
		 (search-forward "-*-"
				 (save-excursion (end-of-line) (point))
				 t)))
	  (progn 
	    (forward-char -3)
	    (skip-chars-backward " \t")
	    (setq end (point))
	    (cons beg end))
	  nil))))



(defun insert-in-attribute-list (attrib value)
  "Inserts the attrib and value as the last entry in the attribute
list, creating one if need be.   Does not check to see if the entry
already exists.   Use get-attribute-position for that."
  (let ((pos (get-attribute-list-position)))
    (if (not pos)
	(progn 
	  (create-attribute-list)
	  (setq pos (get-attribute-list-position)))) ; we assume it will work now!
    (let ((beg (car pos))
	  (end (cdr pos)))
      (save-excursion
	(goto-char end)
	(insert " " attrib ": " value ";")))))


(defun create-attribute-list ()
  "Puts an attribute list at the top of the current buffer.  The
initial entry is Mode: with the current buffer mode inserted."
  (interactive nil)
  (save-excursion
    (goto-char (point-min))
    (if (looking-at "#!")
	(progn
	  (end-of-line)
	  (insert "  ")))
    (insert comment-start " -*- Mode: " mode-name "; -*- " comment-end "\n")))


(defun reparse-attribute-list ()
  (interactive nil)
  (run-hooks 'parse-attribute-list-hooks))

;; (normal-mode) is already called by find-file, so it's inefficient for
;; find-file to call (reparse-atttribute-list), but we do it anyway.

;;;;;;; I took this out because it screws up RMAIL when you read in a
;;;;;;; mail file that has been updated on disk by someone else.
;;;;;;;(add-hook 'parse-attribute-list-hooks 'normal-mode)

(add-hook 'find-file-hooks 'reparse-attribute-list)

(provide 'attribute)

