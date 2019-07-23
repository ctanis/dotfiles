
(require 'hl-line)
;(require 'sml-modeline)
;(require 'flymake)

(setq frame-title-format '("" hostname ": %b"))
(setq icon-title-format '("" hostname ": %b"))

(setq font-lock-maximum-decoration (list (cons t nil)))


  

;; put tick marks in the fringe at the end of the file content
(setq-default indicate-empty-lines t)


(defun frame-mitosis-toggle ()
  (interactive)
  (if (< 1 (length (frame-list)))
      (call-interactively 'mono-framify)
    (call-interactively 'frame-mitosis)))


(defvar frame-mitosis-config '(75  ;; width
			       49  ;; height
			       0   ;; geom-y
			       10  ;; geom-x1
			       640 ;; geom-x2
			       "9x15"
			       ))

(defun reset-window (num)
  (interactive "P")
  (set-frame-font ctanis_font)
  (set-frame-width (selected-frame) (car frame-mitosis-config))
  (set-frame-height (selected-frame) (cadr frame-mitosis-config))
  (set-frame-position (selected-frame)
                      (nth (if num 3 4) frame-mitosis-config)
                      (nth 2 frame-mitosis-config))
  ;(ctanis_colorfy)
  )

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
	;(sleep-for 5)
        (select-frame f)
	(reset-window t)
        ;; (funcall last_colorfy)
                              ))))


(defun mono-framify()
  (interactive)
  (while (> (length (frame-list)) 1)
  	 (delete-frame))
    
  (reset-window nil))



(if window-system
    (progn
	(set-fringe-style 5)
	(menu-bar-mode -1)
	(scroll-bar-mode -1)))




;; solarized theme setup..
;; make the fringe stand out from the background
(setq solarized-distinct-fringe-background t)

;; Don't change the font for some headings and titles
(setq solarized-use-variable-pitch nil)

;; make the modeline high contrast
(setq solarized-high-contrast-mode-line t)

;; Don't change size of org-mode headlines (but keep other size-changes)
(setq solarized-scale-org-headlines nil)

(setq solarized-distinct-doc-face t)

;; Avoid all font-size changes
(setq solarized-height-minus-1 1.0)
(setq solarized-height-plus-1 1.0)
(setq solarized-height-plus-2 1.0)
(setq solarized-height-plus-3 1.0)
(setq solarized-height-plus-4 1.0)

(defvar ctanis_code_font "Courier New")

(when (require-verbose 'solarized)

  (defun  ctanis_theme_tweak (style theme)
    (load-theme theme t)
    (solarized-with-color-variables style
      (custom-theme-set-faces
       theme
       `(hl-line ((,class (:background ,blue :foreground ,base03))))
       `(bold ((,class (:foreground ,base2 "gray40" :weight bold))))
       `(comint-highlight-prompt ((,class (:foreground ,base2 :weight bold))))
       `(dired-flagged ((,class (:background ,red :foreground "black"))))
       `(dired-marked ((,class (:background ,blue :foreground "black"))))
       `(show-paren-match ((,class (:foreground ,base3))))
       `(cursor ((,class (:foreground ,base0 :background ,base2))))
       `(org-code ((,class (:font ,ctanis_code_font :height 1.1))))
       `(org-block ((,class (:font ,ctanis_code_font :height 1.1 :foreground ,base1))))
       `(org-checkbox ((,class (:background ,base03 :foreground ,base0 :weight bold))))
       `(deft-title-face ((,class (:inherit deft-date-face :weight bold))))
       `(company-tooltip-selection ((,class (:weight bold :background ,base2))))
       )
      )
    )


  (defun light()
    (interactive)
    (ctanis_theme_tweak 'light 'solarized-light)
    )

  (defun dark()
    (interactive)
    (ctanis_theme_tweak 'dark 'solarized-dark)
    )
  )

(setq visible-bell nil)

