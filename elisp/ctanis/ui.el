(defun ctanis_colorfy()
  (interactive)
  (set-cursor-color "red")
  (set-background-color "lightgrey")
  (set-foreground-color "black")
  (set-face-foreground font-lock-comment-face "brown")
  (set-face-foreground font-lock-string-face "darkgreen")
  (set-face-foreground font-lock-function-name-face "blue")
  (set-face-foreground font-lock-keyword-face "darkred")
  )

(defvar frame-mitosis-config '(75  ;; width
			       49  ;; height
			       0   ;; geom-y
			       10  ;; geom-x1
			       640 ;; geom-x2
			       "9x15"
			       ))


(defun frame-mitosis()
  (interactive)

  (let ((width		(nth 0 frame-mitosis-config))
	(height		(nth 1 frame-mitosis-config))
	(geom-y		(nth 2 frame-mitosis-config))
	(geom-x1	(nth 3 frame-mitosis-config))
	(geom-x2	(nth 4 frame-mitosis-config))
	(font		(nth 5 frame-mitosis-config))
	)

    (set-frame-height   last-event-frame height)
    (set-frame-width    last-event-frame width)
    (set-frame-position last-event-frame geom-x2 geom-y)

    (let ((after-make-frame-functions '(lambda (frame)
					 (set-frame-height frame height)
					 (set-frame-width frame width)
					 (set-frame-position frame geom-x1 geom-y)))
	  (default-frame-alist
	    (cons (cons 'font font)
		  default-frame-alist))
	  )
      (set-default-font font)

      (let ((f (new-frame)))
	(select-frame f)
	(ctanis_colorfy)))))


(defun mono-framify()
  (interactive)
  (while (> (length (frame-list)) 1)
  	 (delete-frame))
    
  (let ((f (car (frame-list))))
    (set-frame-height f 42)
    (set-frame-width f 87)
    (set-frame-position f 309 0)))


(if window-system
    (menu-bar-mode t)
    (scroll-bar-mode -1))
