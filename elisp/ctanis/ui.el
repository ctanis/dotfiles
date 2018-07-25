
(require 'hl-line)
;(require 'sml-modeline)
;(require 'flymake)

(setq frame-title-format '("" hostname ": %b"))
(setq icon-title-format '("" hostname ": %b"))



(setq font-lock-maximum-decoration (list (cons t nil)))
(defvar last_colorfy nil)
(defvar ctanis_code_font "courier")

(defun ctanis_colorfy()
  (interactive)

  (set-foreground-color "black")
  (set-background-color "wheat3")

  (set-face-background 'header-line "wheat2")

  ;(set-cursor-color "wheat4")
  ;(set-cursor-color "black")
  (set-cursor-color "red")
  ;(set-default 'cursor-type 'hbar)
  (set-face-background 'region "darkgrey")
  (set-face-background 'hl-line "khaki")

  (set-face-background 'fringe "burlywood3")
  (set-face-foreground 'fringe "darkslateblue")

  (set-face-foreground 'mode-line-inactive "khaki2")
  (set-face-background 'mode-line-inactive "wheat4")
  (set-face-background 'mode-line "darkgreen")
  (set-face-foreground 'mode-line "khaki2")

  
  ;; (set-face-background 'sml-modeline-end-face "wheat4")
  ;; (set-face-background 'sml-modeline-vis-face "black")
  ;; (set-face-foreground 'sml-modeline-end-face "wheat3")
  ;; (set-face-foreground 'sml-modeline-vis-face "wheat3")


  (set-face-foreground 'ido-first-match "cyan4")
  (set-face-background 'ido-first-match  "wheat2")
  (set-face-foreground 'ido-only-match  "yellow")
  (set-face-background 'ido-only-match  "green4")
  (set-face-foreground 'ido-subdir  "orangered4")
  (set-face-foreground 'ido-virtual "red")

  ;(set-face-background 'show-paren-match "wheat2")
  (set-face-background 'show-paren-match "green3")
  (set-face-foreground 'show-paren-match "black")
  (set-face-background 'show-paren-mismatch "red")

  (set-face-foreground font-lock-doc-face "grey25")
  (set-face-foreground font-lock-comment-face "grey25")
  (set-face-foreground font-lock-string-face "darkgreen")
  (set-face-background font-lock-string-face "wheat2")
  (set-face-foreground font-lock-constant-face "black")
  (set-face-foreground font-lock-type-face "black")
  (set-face-foreground font-lock-preprocessor-face "magenta4")
  (set-face-foreground font-lock-keyword-face "brown4")
  (set-face-foreground font-lock-builtin-face "goldenrod4")
  (set-face-foreground font-lock-function-name-face "blue3")
  (set-face-foreground font-lock-variable-name-face "red4")

  (set-face-background 'isearch "orange")
  (set-face-foreground 'isearch "black")

  (set-face-background 'error "red")
  (set-face-foreground 'error "white")
  (set-face-foreground 'warning "darkslateblue")
  (set-face-background 'warning "wheat1")


  (set-face-attribute 'modeline-inactive nil :box '(:line-width 1 :color "black"))
  (set-face-attribute 'mode-line nil :box '(:line-width 1 :color "black"))



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


  (eval-after-load 'compile
    '(progn
       (set-face-foreground 'compilation-info "white")
       ;; (set-face-background 'compilation-mode-line-fail "yellow1")
       ;; (set-face-foreground 'compilation-mode-line-fail "red")
       
       ))

  (eval-after-load 'js2-mode
    '(progn
       (set-face-foreground 'js2-external-variable "purple")
       ))


  (eval-after-load 'flymake
    '(progn
       (set-face-background 'flymake-errline "pink")
       (set-face-foreground 'flymake-errline "red")
       (set-face-background 'flymake-warnline "lightblue")
       (set-face-foreground 'flymake-warnline "cyan4")
       ))


  (eval-after-load 'org
    '(progn
					;	    (set-face-foreground 'org-hide "wheat3")
       (set-face-foreground 'org-todo "purple")
       (set-face-background 'org-todo "wheat2")
       (set-face-background 'org-done "gray")
       (set-face-background 'org-warning "orange")
       (set-face-background 'org-block "wheat2")
       (set-face-foreground 'org-block "black")

       (set-face-foreground 'org-archived "burlywood1")

       (set-face-foreground 'org-checkbox-statistics-todo "darkgreen")
       (set-face-background 'org-checkbox-statistics-todo "darkgray")

       (set-face-foreground 'org-level-1 "blue4")
       ;(set-face-background 'org-level-1 "wheat3")
       (set-face-foreground 'org-level-2 "red4")
       ;(set-face-background 'org-level-2 "wheat3")
       (set-face-foreground 'org-level-3 "darkgreen")
       ;(set-face-background 'org-level-3 "wheat3")
       (set-face-foreground 'org-level-4 "gray20")
       ;(set-face-background 'org-level-4 "wheat3")
       (set-face-foreground 'org-level-5 "gray35")
       ;(set-face-background 'org-level-5 "wheat3")
       (set-face-foreground 'org-level-6 "gray40")
       ;(set-face-background 'org-level-6 "wheat3")
       (set-face-foreground 'org-level-7 "gray45")
       ;(set-face-background 'org-level-7 "wheat3")
       (set-face-foreground 'org-level-8 "gray50")
       ;(set-face-background 'org-level-8 "wheat3")
       ;;(set-face-attribute 'org-code nil :font "courier")
       (set-face-attribute 'org-code nil :font ctanis_code_font)
       (set-face-attribute 'org-code nil :height 1.2)
       (set-face-foreground 'org-code "royalblue4")
       (set-face-foreground 'org-verbatim "royalblue4")
       ;; (set-face-attribute 'org-verbatim nil :font "courier")
       (set-face-attribute 'org-verbatim nil :font ctanis_code_font)
       ;; (set-face-attribute 'org-verbatim nil :height 1.1)
       ;;(set-face-attribute 'org-block nil :font "courier")
       (set-face-attribute 'org-block nil :font ctanis_code_font)
       (set-face-attribute 'org-block nil :height 1.2)

       (set-face-foreground 'org-meta-line "cyan4")
       (set-face-foreground 'org-document-info-keyword "cyan4")


       (set-face-attribute 'org-document-title nil :height 1.44)
       (set-face-foreground 'org-document-title "black")

       (set-face-background 'org-agenda-date-today "wheat2")

       ))

  (add-hook 'sh-mode-hook
	    '(lambda()
	       (set-face-foreground 'sh-quoted-exec "purple")
	       (set-face-foreground 'sh-heredoc "purple3")
	       ))

  (add-hook 'dired-mode-hook
	    '(lambda ()
	       (set-face-foreground 'dired-marked "darkslateblue")
               (set-face-background 'dired-marked "wheat1")
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

  
  (setq ansi-color-names-vector ["black" "red" "green4" "gold4" "blue" "magenta" "cyan4" "white"])
  (setq ansi-color-map (ansi-color-make-color-map))

  )



;; (defun ctanis_colorfy_dark()
;;   (interactive)

;;   (set-foreground-color "lightyellow3")
;;   (set-background-color "gray12")

;;   (set-cursor-color "olivedrab3")
;;   (set-face-background 'region "gray17")
;;   (set-face-background 'hl-line "gray20")

;;   (set-face-background 'fringe "gray10")
;;   (set-face-foreground 'fringe "yellow")

;;   (set-face-foreground 'mode-line-inactive "goldenrod4")
;;   (set-face-background 'mode-line-inactive "darkslategrey")
;;   (set-face-background 'mode-line "royalblue4")
;;   (set-face-foreground 'mode-line "goldenrod2")

  
;;   ;; (set-face-background 'sml-modeline-end-face "royalblue3")
;;   ;; (set-face-background 'sml-modeline-vis-face "black")
;;   ;; (set-face-foreground 'sml-modeline-end-face "goldenrod2")
;;   ;; (set-face-foreground 'sml-modeline-vis-face "goldenrod3")


;;   (set-face-foreground 'ido-first-match "cyan4")
;;   (set-face-background 'ido-first-match  "wheat2")
;;   (set-face-foreground 'ido-only-match  "black")
;;   (set-face-background 'ido-only-match  "green")
;;   (set-face-foreground 'ido-subdir  "orangered4")

;;   (set-face-background 'flymake-errline "magenta4")
;;   (set-face-foreground 'flymake-errline "yellow")
;;   (set-face-background 'flymake-warnline "cyan4")
;;   (set-face-foreground 'flymake-warnline "yellow")

;;   (set-face-background 'show-paren-match "olivedrab1")
;;   (set-face-foreground 'show-paren-match "purple")
;;   (set-face-background 'show-paren-mismatch "red")

;;   (set-face-foreground font-lock-doc-face "grey45")
;;   (set-face-foreground font-lock-comment-face "grey45")
;;   (set-face-foreground font-lock-string-face "lightyellow4")
;;   (set-face-background font-lock-string-face "gray20")
;;   (set-face-foreground font-lock-constant-face "dodgerblue3")
;;   (set-face-foreground font-lock-type-face "azure4")
;;   (set-face-foreground font-lock-preprocessor-face "magenta4")
;;   (set-face-foreground font-lock-keyword-face "goldenrod4")
;;   (set-face-foreground font-lock-builtin-face "goldenrod4")
;;   (set-face-foreground font-lock-function-name-face "slateblue3")
;;   (set-face-foreground font-lock-variable-name-face "red4")

;;   (set-face-foreground 'compilation-info "white")

;;   (set-face-background 'error "red")
;;   (set-face-foreground 'error "white")
;;   (set-face-background 'compilation-mode-line-fail "yellow1")
;;   (set-face-foreground 'compilation-mode-line-fail "red")
;;   (set-face-foreground 'warning "cyan3")
;;   (set-face-background 'warning "wheat2")

;;   (set-face-background 'isearch "orange")
;;   (set-face-foreground 'isearch "black")

;;   ;;   (set-face-foreground font-lock-doc-face "grey40")
;;   ;; (set-face-foreground font-lock-comment-face "grey40")
;;   ;; (set-face-foreground font-lock-string-face "darkgreen")
;;   ;; (set-face-foreground font-lock-constant-face "blue4")
;;   ;; (set-face-foreground font-lock-type-face "darkcyan")
;;   ;; (set-face-foreground font-lock-preprocessor-face "chartreuse4")
;;   ;; (set-face-foreground font-lock-keyword-face "firebrick4")
;;   ;; (set-face-foreground font-lock-builtin-face "blue3")
;;   ;; (set-face-foreground font-lock-function-name-face "blue3")
;;   ;; (set-face-foreground font-lock-variable-name-face "deepskyblue4")


;;   (add-hook 'org-mode-hook
;; 	    (lambda()
;; 	      (set-face-foreground 'org-todo "purple")
;; 	      (set-face-background 'org-todo "wheat2")
;; 	      (set-face-background 'org-warning "orange")
;; 	      (set-face-background 'org-block "darkgray")
;; 	      (set-face-foreground 'org-block "darkred")
;; 	      (set-face-foreground 'org-level-1 "green4")
;; 	      (set-face-foreground 'org-level-2 "firebrick")
;; 	      (set-face-foreground 'org-level-3 "grey60")
;; 	      (set-face-foreground 'org-level-4 "goldenrod4")
;; 	      (set-face-foreground 'org-level-5 "grey43")
;; 	      (set-face-foreground 'org-document-title "dodgerblue2")
;; 	      (set-face-foreground 'org-document-info-keyword "slateblue3")
;; 	      (set-face-foreground 'org-link "dodgerblue2")

;; 	      (set-face-attribute 'org-document-title nil :height 1.44)
;; 	      ))

;;   (add-hook 'sh-mode-hook
;; 	    '(lambda()
;; 	       (set-face-foreground 'sh-quoted-exec "purple")
;; 	       (set-face-foreground 'sh-heredoc "purple3")
;; 	       ))

  
;;   (add-hook 'dired-mode-hook
;; 	    '(lambda ()
;; 	       (set-face-foreground 'dired-directory "dodgerblue2")
;; 	       (set-face-foreground 'dired-header "dodgerblue2")
;; 	       (set-face-background 'dired-marked "gray20")
;; 	       (set-face-foreground 'dired-marked "green1")
;; 	       ))

;;   (add-hook 'initial-calendar-window-hook
;; 	    (lambda ()
;; 	      (set-face-background 'holiday-face "darkslategray")
;; 	      (set-face-foreground 'calendar-today-face "yellow")
;; 	      (set-face-foreground 'diary-face "orange")
;; 	      (set-face-foreground 'holiday-face "cyan")))


;;   (add-hook 'cperl-mode-hook
;; 	    '(lambda ()
;; 	       (set-face-foreground 'cperl-nonoverridable-face "darkblue")
;; 	       ))


;;   (setq last_colorfy 'ctanis_colorfy_dark)
;;   )


  

;; put tick marks in the fringe at the end of the file content
(setq-default indicate-empty-lines t)


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
  (ctanis_colorfy))

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
        (funcall last_colorfy)))))


(defun mono-framify()
  (interactive)
  (while (> (length (frame-list)) 1)
  	 (delete-frame))
    
  (reset-window nil))




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




;; powerline
;(powerline-default-theme)
(if window-system
    (when (require 'powerline nil 'noerror)
      (set-face-background 'powerline-active1 "wheat4")
      (set-face-foreground 'powerline-active1 "khaki2")
      (set-face-foreground 'powerline-active2 "lightblue3")
      (defun powerline-ctanis-theme ()
        "Setup the default mode-line."
        (interactive)
        (setq-default mode-line-format
                      '("%e"
                        (:eval
                         (let* ((active (powerline-selected-window-active))
                                (mode-line (if active 'mode-line 'mode-line-inactive))
                                (face1 (if active 'powerline-active1 'powerline-inactive1))
                                (face2 (if active 'powerline-active2 'powerline-inactive2))
                                (separator-left (intern (format "powerline-%s-%s"
                                                                powerline-default-separator
                                                                (car powerline-default-separator-dir))))
                                (separator-right (intern (format "powerline-%s-%s"
                                                                 powerline-default-separator
                                                                 (cdr powerline-default-separator-dir))))
                                (lhs (list (powerline-raw "%*" nil 'l)
                                           (powerline-buffer-size nil 'l)
                                           (powerline-raw mode-line-mule-info nil 'l)
                                           (powerline-buffer-id nil 'l)
                                           (when (and (boundp 'which-func-mode) which-func-mode)
                                             (powerline-raw which-func-format nil 'l))
                                           (powerline-raw " ")
                                        ;                                     (funcall separator-left mode-line face1)
                                           (when (boundp 'erc-modified-channels-object)
                                             (powerline-raw erc-modified-channels-object face1 'l))
                                           (powerline-major-mode face1 'l)
                                           (powerline-process face1)
                                           (powerline-minor-modes face1 'l)
                                           (powerline-narrow face1 'l)
                                           (powerline-raw " " face1)
                                           (funcall separator-left face1 face2)
                                           (powerline-vc face2 'r)))
                                (rhs (list (powerline-raw global-mode-string face2 'r)
                                           (funcall separator-right face2 face1)
                                           (powerline-raw "%4l" face1 'l)
                                           (powerline-raw ":" face1 'l)
                                           (powerline-raw "%3c" face1 'r)
                                        ;(funcall separator-right face1 mode-line)
                                           (powerline-raw " ")
                                           (powerline-raw "%6p" nil 'r)
                                           (powerline-hud face2 face1))))
                           (concat (powerline-render lhs)
                                   (powerline-fill face2 (powerline-width rhs))
                                   (powerline-render rhs)))))))
      (powerline-ctanis-theme)
      (message nil)))



