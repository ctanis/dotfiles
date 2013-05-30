
(require 'hl-line)
(require 'sml-modeline)
(require 'flymake)

(setq frame-title-format '("" hostname ": %b"))
(setq icon-title-format '("" hostname ": %b"))



(setq font-lock-maximum-decoration (list (cons t nil)))
(defvar last_colorfy nil)

(defun ctanis_colorfy()
  (interactive)

  (set-foreground-color "black")
  (set-background-color "wheat3")

  ;(set-cursor-color "wheat4")
  (set-cursor-color "yellow")
  ;(set-default 'cursor-type 'hbar)
  (set-face-background 'region "darkgrey")
  (set-face-background 'hl-line "darkgrey")

  (set-face-background 'fringe "burlywood3")
  (set-face-foreground 'fringe "darkslateblue")

  (set-face-foreground 'mode-line-inactive "wheat3")
  (set-face-background 'mode-line-inactive "darkslategrey")
  (set-face-background 'mode-line "darkred")
  (set-face-foreground 'mode-line "goldenrod")

  
  (set-face-background 'sml-modeline-end-face "wheat4")
  (set-face-background 'sml-modeline-vis-face "black")
  (set-face-foreground 'sml-modeline-end-face "wheat3")
  (set-face-foreground 'sml-modeline-vis-face "wheat3")


  (set-face-foreground 'ido-first-match "cyan4")
  (set-face-background 'ido-first-match  "wheat2")
  (set-face-foreground 'ido-only-match  "black")
  (set-face-background 'ido-only-match  "green")
  (set-face-foreground 'ido-subdir  "orangered4")

  (set-face-background 'flymake-errline "magenta3")
  (set-face-foreground 'flymake-errline "yellow")
  (set-face-background 'flymake-warnline "cyan4")
  (set-face-foreground 'flymake-warnline "yellow")

  ;(set-face-background 'show-paren-match "wheat2")
  (set-face-background 'show-paren-match "orange")
  (set-face-foreground 'show-paren-match "purple")
  (set-face-background 'show-paren-mismatch "red")

  (set-face-foreground font-lock-doc-face "grey25")
  (set-face-foreground font-lock-comment-face "grey25")
  (set-face-foreground font-lock-string-face "darkgreen")
  (set-face-background font-lock-string-face "wheat2")
  (set-face-foreground font-lock-constant-face "black")
  (set-face-foreground font-lock-type-face "black")
  (set-face-foreground font-lock-preprocessor-face "magenta4")
  (set-face-foreground font-lock-keyword-face "goldenrod4")
  (set-face-foreground font-lock-builtin-face "goldenrod4")
  (set-face-foreground font-lock-function-name-face "blue3")
  (set-face-foreground font-lock-variable-name-face "red4")

  (set-face-foreground 'compilation-info "white")

  (set-face-background 'error "red")
  (set-face-foreground 'error "white")
  (set-face-background 'compilation-mode-line-fail "yellow1")
  (set-face-foreground 'compilation-mode-line-fail "red")
  (set-face-foreground 'warning "cyan3")
  (set-face-background 'warning "wheat2")

  (set-face-background 'isearch "orange")
  (set-face-foreground 'isearch "black")

  ;;   (set-face-foreground font-lock-doc-face "grey40")
  ;; (set-face-foreground font-lock-comment-face "grey40")
  ;; (set-face-foreground font-lock-string-face "darkgreen")
  ;; (set-face-foreground font-lock-constant-face "blue4")
  ;; (set-face-foreground font-lock-type-face "darkcyan")
  ;; (set-face-foreground font-lock-preprocessor-face "chartreuse4")
  ;; (set-face-foreground font-lock-keyword-face "firebrick4")
  ;; (set-face-foreground font-lock-builtin-face "blue3")
  ;; (set-face-foreground font-lock-function-name-face "blue3")
  ;; (set-face-foreground font-lock-variable-name-face "deepskyblue4")


  (add-hook 'org-mode-hook
	    (lambda()
					;	    (set-face-foreground 'org-hide "wheat3")
	      (set-face-foreground 'org-todo "purple")
	      (set-face-background 'org-todo "wheat2")
	      (set-face-background 'org-done "wheat2")
	      (set-face-background 'org-warning "orange")
	      (set-face-background 'org-block "darkgray")
	      (set-face-foreground 'org-block "darkred")
	      (set-face-foreground 'org-level-1 "darkgreen")
	      (set-face-foreground 'org-level-2 "red4")
	      (set-face-foreground 'org-level-3 "slateblue4")
	      (set-face-foreground 'org-level-4 "darkcyan")
	      (set-face-foreground 'org-level-5 "grey28")
	      (set-face-foreground 'org-level-6 "grey43")
	      (set-face-foreground 'org-verbatim "gray30")
	      (set-face-foreground 'org-document-info-keyword "gray50")
	      (set-face-foreground 'org-meta-line "gray50")
	      (set-face-foreground 'org-archived "burlywood1")

	      (set-face-attribute 'org-document-title nil :height 1.44)
	      ))

  (add-hook 'sh-mode-hook
	    '(lambda()
	       (set-face-foreground 'sh-quoted-exec "purple")
	       (set-face-foreground 'sh-heredoc "purple3")
	       ))

  (add-hook 'dired-mode-hook
	    '(lambda ()
	       (set-face-foreground 'dired-marked "darkgreen")
	       ))

  (add-hook 'initial-calendar-window-hook
	    (lambda ()
	      (set-face-background 'holiday-face "darkslategray")
	      (set-face-foreground 'calendar-today-face "yellow")
	      (set-face-foreground 'diary-face "orange")
	      (set-face-foreground 'holiday-face "cyan")))


  (add-hook 'cperl-mode-hook
	    '(lambda ()
	       (set-face-foreground 'cperl-nonoverridable-face "darkblue")
	       ))
  
  (setq last_colorfy 'ctanis_colorfy)
  )


(defun ctanis_colorfy_dark()
  (interactive)

  (set-foreground-color "lightyellow3")
  (set-background-color "gray12")

  (set-cursor-color "olivedrab3")
  (set-face-background 'region "gray17")
  (set-face-background 'hl-line "gray20")

  (set-face-background 'fringe "gray10")
  (set-face-foreground 'fringe "yellow")

  (set-face-foreground 'mode-line-inactive "goldenrod4")
  (set-face-background 'mode-line-inactive "darkslategrey")
  (set-face-background 'mode-line "royalblue4")
  (set-face-foreground 'mode-line "goldenrod2")

  
  (set-face-background 'sml-modeline-end-face "royalblue3")
  (set-face-background 'sml-modeline-vis-face "black")
  (set-face-foreground 'sml-modeline-end-face "goldenrod2")
  (set-face-foreground 'sml-modeline-vis-face "goldenrod3")


  (set-face-foreground 'ido-first-match "cyan4")
  (set-face-background 'ido-first-match  "wheat2")
  (set-face-foreground 'ido-only-match  "black")
  (set-face-background 'ido-only-match  "green")
  (set-face-foreground 'ido-subdir  "orangered4")

  (set-face-background 'flymake-errline "magenta4")
  (set-face-foreground 'flymake-errline "yellow")
  (set-face-background 'flymake-warnline "cyan4")
  (set-face-foreground 'flymake-warnline "yellow")

  (set-face-background 'show-paren-match "olivedrab1")
  (set-face-foreground 'show-paren-match "purple")
  (set-face-background 'show-paren-mismatch "red")

  (set-face-foreground font-lock-doc-face "grey45")
  (set-face-foreground font-lock-comment-face "grey45")
  (set-face-foreground font-lock-string-face "lightyellow4")
  (set-face-background font-lock-string-face "gray20")
  (set-face-foreground font-lock-constant-face "dodgerblue3")
  (set-face-foreground font-lock-type-face "azure4")
  (set-face-foreground font-lock-preprocessor-face "magenta4")
  (set-face-foreground font-lock-keyword-face "goldenrod4")
  (set-face-foreground font-lock-builtin-face "goldenrod4")
  (set-face-foreground font-lock-function-name-face "slateblue3")
  (set-face-foreground font-lock-variable-name-face "red4")

  (set-face-foreground 'compilation-info "white")

  (set-face-background 'error "red")
  (set-face-foreground 'error "white")
  (set-face-background 'compilation-mode-line-fail "yellow1")
  (set-face-foreground 'compilation-mode-line-fail "red")
  (set-face-foreground 'warning "cyan3")
  (set-face-background 'warning "wheat2")

  (set-face-background 'isearch "orange")
  (set-face-foreground 'isearch "black")

  ;;   (set-face-foreground font-lock-doc-face "grey40")
  ;; (set-face-foreground font-lock-comment-face "grey40")
  ;; (set-face-foreground font-lock-string-face "darkgreen")
  ;; (set-face-foreground font-lock-constant-face "blue4")
  ;; (set-face-foreground font-lock-type-face "darkcyan")
  ;; (set-face-foreground font-lock-preprocessor-face "chartreuse4")
  ;; (set-face-foreground font-lock-keyword-face "firebrick4")
  ;; (set-face-foreground font-lock-builtin-face "blue3")
  ;; (set-face-foreground font-lock-function-name-face "blue3")
  ;; (set-face-foreground font-lock-variable-name-face "deepskyblue4")


  (add-hook 'org-mode-hook
	    (lambda()
	      (set-face-foreground 'org-todo "purple")
	      (set-face-background 'org-todo "wheat2")
	      (set-face-background 'org-warning "orange")
	      (set-face-background 'org-block "darkgray")
	      (set-face-foreground 'org-block "darkred")
	      (set-face-foreground 'org-level-1 "green4")
	      (set-face-foreground 'org-level-2 "firebrick")
	      (set-face-foreground 'org-level-3 "grey60")
	      (set-face-foreground 'org-level-4 "goldenrod4")
	      (set-face-foreground 'org-level-5 "grey43")
	      (set-face-foreground 'org-document-title "dodgerblue2")
	      (set-face-foreground 'org-document-info-keyword "slateblue3")
	      (set-face-foreground 'org-link "dodgerblue2")

	      (set-face-attribute 'org-document-title nil :height 1.44)
	      ))

  (add-hook 'sh-mode-hook
	    '(lambda()
	       (set-face-foreground 'sh-quoted-exec "purple")
	       (set-face-foreground 'sh-heredoc "purple3")
	       ))

  
  (add-hook 'dired-mode-hook
	    '(lambda ()
	       (set-face-foreground 'dired-directory "dodgerblue2")
	       (set-face-foreground 'dired-header "dodgerblue2")
	       (set-face-background 'dired-marked "gray20")
	       (set-face-foreground 'dired-marked "green1")
	       ))

  (add-hook 'initial-calendar-window-hook
	    (lambda ()
	      (set-face-background 'holiday-face "darkslategray")
	      (set-face-foreground 'calendar-today-face "yellow")
	      (set-face-foreground 'diary-face "orange")
	      (set-face-foreground 'holiday-face "cyan")))


  (add-hook 'cperl-mode-hook
	    '(lambda ()
	       (set-face-foreground 'cperl-nonoverridable-face "darkblue")
	       ))


  (setq last_colorfy 'ctanis_colorfy_dark)
  )


  

;; put tick marks in the fringe at the end of the file content
(setq-default indicate-empty-lines t)


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
	(funcall last_colorfy)))))


(defun mono-framify()
  (interactive)
  (while (> (length (frame-list)) 1)
  	 (delete-frame))
    
  (let ((f (car (frame-list))))
    (set-frame-height f 42)
    (set-frame-width f 87)
    (set-frame-position f 309 0)))




(set-fringe-style 5)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; ;; disable the mouse/trackpad as much as possible

;; (global-set-key '[wheel-up] 'ignore)
;; (global-set-key '[double-wheel-up] 'ignore)
;; (global-set-key '[triple-wheel-up] 'ignore)
;; (global-set-key '[wheel-down] 'ignore)
;; (global-set-key '[double-wheel-down] 'ignore)
;; (global-set-key '[triple-wheel-down] 'ignore)

;; (global-set-key '[down-mouse-1] 'ignore)
;; (global-set-key '[mouse-1] 'ignore)
;; (global-set-key '[drag-mouse-1] 'ignore)
;; (global-set-key '[double-mouse-1] 'ignore)
;; (global-set-key '[triple-mouse-1] 'ignore)

;; (global-set-key '[down-mouse-2] 'ignore)
;; (global-set-key '[mouse-2] 'ignore)
;; (global-set-key '[drag-mouse-2] 'ignore)
;; (global-set-key '[double-mouse-2] 'ignore)
;; (global-set-key '[triple-mouse-2] 'ignore)

;; (global-set-key '[down-mouse-3] 'ignore)
;; (global-set-key '[mouse-3] 'ignore)
;; (global-set-key '[drag-mouse-3] 'ignore)
;; (global-set-key '[double-mouse-3] 'ignore)
;; (global-set-key '[triple-mouse-3] 'ignore)


;; put this in .emacs-local if you want
;; ;; refuse the OS's advances
;; (defun handle-switch-frame (event)
;;   (interactive "e")
;;   (other-frame 0)
;;   )

