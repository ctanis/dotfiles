;;  -*- Mode: Emacs-Lisp; -*- 

;; not useful as a mode, but good to remember how to do this kind of
;; thing...


;;  Copyright 2001, Advance Internet

;;  Craig Tanis
;;  Advance Internet

;;  ata-mode.el

;; Emacs major mode for editing ATA templates


(make-face 'ata-font-lock-control-face)
(make-face 'ata-font-lock-variable-face)
(make-face 'ata-font-lock-assignment-face)
(make-face 'ata-font-lock-comment-face)
(defconst ata-font-lock-control-face 'ata-font-lock-control-face)
(defconst ata-font-lock-variable-face 'ata-font-lock-variable-face)
(defconst ata-font-lock-assignment-face 'ata-font-lock-assignment-face)
(defconst ata-font-lock-comment-face 'ata-font-lock-comment-face)

(defconst ata-font-lock-keywords-1
      '(("<\\([!?][a-z][-.a-z0-9]*\\)" 1 font-lock-keyword-face)
	("<\\(/?[a-z][-.a-z0-9]*\\)" 1 font-lock-function-name-face)
  	("[&%][a-z][-.a-z0-9]*;?" . font-lock-variable-name-face)
	("<! *--.*-- *>" . font-lock-comment-face)
	("\$\$[0-9a-zA-Z_]+[ \t\n]*:?=[ \t\n]*\"\\(\\(\\\\\\\"\\)\\|\\([^\"]\\)\\)*\"" 0 ata-font-lock-assignment-face t nil)
	("<%[^!].*[^!]%>"  0 ata-font-lock-control-face t nil)
	("\$\$~?[0-9a-zA-Z_]+" 0 ata-font-lock-variable-face t nil)
;	("<%!\\(.\\|\n\\)*?!%>" 0 ata-font-lock-comment-face t nil)
	("<%!\\(.\\|\\[\n\\]\\)*?!%>" 0 ata-font-lock-comment-face t nil)
	))


(defvar ata-font-lock-keywords ata-font-lock-keywords-1)


(defvar ata-control-function-pairs-alist
  '(("if" . "endif")
    ("foreach" . "endforeach")
    ))

(define-derived-mode ata-mode html-mode
  "ATA" "Major mode for ATA templates. \\{ata-mode-map}"
  (setq font-lock-defaults '((ata-font-lock-keywords
			      )
			     nil
			     t))  
  (ata-set-colors)
  )


(defun ata-set-colors ()
  (set-face-background ata-font-lock-control-face "slateblue")
  (set-face-foreground ata-font-lock-control-face "yellow")
  (set-face-background ata-font-lock-variable-face "blue")
  (set-face-foreground ata-font-lock-variable-face "white")
  (set-face-background ata-font-lock-assignment-face "slateblue")
  (set-face-foreground ata-font-lock-assignment-face "lightgreen")
  (set-face-background ata-font-lock-comment-face "darkblue")
  (set-face-foreground ata-font-lock-comment-face "darkgray")
  )


(defun ata-looking-at-control-structure ()
  "return the bounds of the ATA control structure currently containing point"
  (save-excursion
    (let* ((p (point))
	    (a1 (progn (search-backward "<%")
		       (point)))
	    (b1 (progn (search-forward "%>")
		       (point)))
	    (b2 (progn (goto-char p)
		       (search-forward "%>")
		       (point)))
	    (a2 (progn (search-backward "<%")
		       (point))))
      (if (and (< p b1) (>= p a1))
	  (list a1 b1)
	(if (and (< p b2) (>= p a2))
	    (list a2 b2)
	  nil)))))


(defun ata-control-structure-keyword (bounds)
  "return the function name of the control structure defined by bounds"
  (if bounds
      (save-excursion
	(goto-char (car bounds))
	(while (and (< (point) (cadr bounds))
		    (not (looking-at "[a-zA-Z_0-9]+")))
	  (forward-char 1))
	(if (looking-at "[a-zA-Z_0-9]+")
	    (current-word)
	  nil))))


(defun ata-next-control-structure ()
  "jump to the next ATA control structure"
  (interactive)
  (if (looking-at "<%") (forward-char 1))
  (search-forward "<%" nil t)
  (backward-char 2))


(defun ata-prev-control-structure ()
  "jump to the previous ATA control structure"
  (interactive)
  (let ((p (ata-looking-at-control-structure)))
    (if (not p)
	(search-backward "<%" nil t)
      (if (= (point) (car p))
	  (progn (backward-char 1)
		 (search-backward "<%"))
	(goto-char (car p))))))


(defun ata-find-control-end-pair ()
  (interactive)
  (let ((b (ata-looking-at-control-structure))
	(go nil)
	(stack nil))
    (if (not b)
	nil
      (let* ((func (ata-control-structure-keyword b))
	     (match (cdr (or (assoc func ata-control-function-pairs-alist)
			     (assoc func (mapcar '(lambda (a) (cons (cdr a) (car a)))
						 ata-control-function-pairs-alist)))))
	     (forward  (assoc func ata-control-function-pairs-alist)))
	(message (concat "have " func " looking for " match))
	(sleep-for 2)
	(if forward
	    (while (and (ata-next-control-structure)  go)
	      (if (string= func
			   (ata-control-structure-keyword
			    (ata-looking-at-control-structure)))
		  (setq stack (cons func stack))
		(if (string= match
			     (ata-control-structure-keyword
			      (ata-looking-at-control-structure)))
		    (if stack
			(setq stack (cdr stack))
		      (setq go nil))
		  )))
	  (error "backward not implemented"))))))
		
	      
		   
(defun ata-refresh-fonts ()
  (interactive)
  (font-lock-mode nil)
  (font-lock-mode t))



(define-key ata-mode-map "\M-{" 'ata-prev-control-structure)
(define-key ata-mode-map "\M-}" 'ata-next-control-structure)
(define-key ata-mode-map "\C-c\C-f" 'ata-refresh-fonts)


;(setq auto-mode-alist (cons '("\\.ata$" . ata-mode) auto-mode-alist))
