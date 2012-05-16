;; auto-load
(setq font-lock-maximum-decoration (list (cons t nil)))

(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))
(autoload 'uncompress-while-visiting "uncompress")
(autoload 'tar-mode "tar-mode" "View .tar files" nil nil)

(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))


(add-hook 'markdown-mode-hook
	  '(lambda()
	     (local-set-key "\C-\M-u" 'backward-up-list)
	     (local-set-key "\M-p" 'scroll-down-slow)
	     (local-set-key "\M-n" 'scroll-up-slow)
))


(mapcar '(lambda (a)
	   (add-to-list 'auto-mode-alist a))
	'(("\\.Z$" . uncompress-while-visiting)
	  ("\\.gz$" . uncompress-while-visiting)
	  ("\\.h$" . c-mode)
	  ("\\.m$" . octave-mode)
	  ))



(setq popper-load-hook 
     '(lambda ()
       (setq popper-pop-buffers t)  ; Make popper pop everything temporary
       (setq popper-buffers-to-skip t) 
       (setq popper-use-message-buffer nil)

       ;; Make Webster windows default to 12 lines
       (add-to-list 'popper-min-heights (cons "^\\Webster" 12))
       (add-to-list 'popper-min-heights (cons "^\\*tail" 25))

       ;; Don't skip over *Buffer List*
       (setq popper-buffers-no-skip (cons "*Buffer List*" 
					  popper-buffers-no-skip))))

(if (string-match "^19.34" emacs-version)
    (load "popper-19.34")
  (load "popper"))


;; MODE HOOKS

(autoload 'autopair-mode "autopair.el" "autopair mode" t)
(add-hook 'c-mode-common-hook
	  '(lambda ()
	     ;(setq c-basic-offset 4)
	     (local-set-key "\C-c\C-c" 'compile)
	     (local-set-key "\C-m" 'newline-and-indent)
;	     (autopair-mode)
	     (c-toggle-auto-newline 1)
))


;this is the  c comment-region thing i wrote
(add-hook 'c-mode-hook
	  '(lambda ()
	     (c-set-style "k&r")
	     (local-set-key "\M-o1" 'make-c-header)
;	     (define-key c-mode-map "\C-c;" 'c-make-block-comment)
	     ))

;; do i want this?
(add-hook 'c++-mode-hook
	  '(lambda ()
	     (c-set-style "stroustrup")))
	     

(add-hook 'java-mode-hook
	  '(lambda ()
	     (c-set-style "java")))


(add-hook 'objc-mode-hook
	  '(lambda()
	     (c-set-style "k&r")))

(add-hook 'f90-mode-hook
	  '(lambda()
	     (local-set-key "\C-m" 'newline-and-indent)
	     (local-set-key "\C-c\C-c" 'compile)
	     (setq f90-do-indent 2)
	     (setq f90-if-indent 2)
	     (setq f90-type-indent 2)
	     (setq f90-program-indent 2)
	     ))


(add-hook 'text-mode-hook
	  '(lambda ()
	     (progn
	       (define-key text-mode-map "\M-s" 'goto-line)
	       (visual-line-mode t)
	       (set-fill-column 68)
	       ;(auto-fill-mode 1)
	       (auto-save-mode 1))))



(add-hook 'comint-output-filter-functions
	  'shell-strip-ctrl-m)





;calendar stuff
;(add-hook 'today-visible-calendar-hook 'calendar-mark-today)
(add-hook 'diary-display-hook 'diary-display-todo-file t)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'list-diary-entries-hook 'sort-diary-entries t)


(add-hook 'asm-mode-set-comment-hook '(lambda ()
					(setq asm-comment-char '?!)))

;(add-hook 'sh-mode-hook '(lambda ()
;			   (sh-set-shell "zsh")))

;redefinitions of shell-mode keys
(add-hook 'comint-mode-hook
	  '(lambda ()
	     (setq comint-use-prompt-regexp t)
	     (setq comint-prompt-regexp "^[^\$]+\$ ")
	     (define-key comint-mode-map
	       "\M-p" 'comint-previous-matching-input-from-input)
	     (define-key comint-mode-map
	       "\M-n" 'comint-next-matching-input-from-input)
	     (define-key comint-mode-map "\C-a" 'comint-bol)
	     (define-key comint-mode-map "\M-o\C-?" 'comint-kill-input)))


(add-hook 'octave-mode-hook
	  '(lambda ()
	     (local-set-key "\C-m" 'newline-and-indent)))


(add-hook 'inferior-octave-mode-hook
	  '(lambda ()
	     (local-set-key
	       "\M-p" 'comint-previous-matching-input-from-input)
	     (local-set-key
	       "\M-n" 'comint-next-matching-input-from-input)
	     (local-set-key
	      "\C-a" 'comint-bol)))


(add-hook 'emacs-lisp-mode-hook
	  '(lambda ()
	     (setq comment-start ";; ")
	     (local-set-key "\C-m" 'newline-and-indent)))

(add-hook 'lisp-interaction-mode-hook
	  '(lambda ()
	     (setq comment-start ";; ")
	     (local-set-key "\C-m" 'newline-and-indent)))


(add-hook 'perl-mode-hook
	  '(lambda ()
	     (local-set-key "\C-c\C-c" 'eval-buffer-as-perl-script)
	     (local-set-key "\C-m" 'newline-and-indent)))

(defalias 'perl-mode 'cperl-mode)
(setq cperl-invalid-face (quote off))
;(setq cperl-hairy t)
(add-to-list 'font-lock-maximum-decoration (cons 'cperl-mode 1))


(add-hook 'cperl-mode-hook
	  '(lambda ()
	     (local-set-key "\C-c\C-c" 'eval-buffer-as-perl-script)
	     (local-set-key "\C-m" 'newline-and-indent)
	     (local-set-key "\M-o\M-v" 'cperl-get-help)
	     (local-set-key "\M-o\M-h" 'cperl-perldoc-at-point)
	     (local-set-key "\M-o\C-H" 'cperl-perldoc)
	     (local-set-key "\M-o|" 'cperl-lineup)
	     (set-face-foreground 'cperl-nonoverridable-face "darkblue")
))



(add-hook 'initial-calendar-window-hook
	  (lambda ()
	    (if window-system
		(progn
		  (set-face-background 'holiday-face "darkslategray")
		  (set-face-foreground 'calendar-today-face "yellow")
		  (set-face-foreground 'diary-face "orange")
		  (set-face-foreground 'holiday-face "cyan")))))

(add-hook 'Man-mode-hook '(lambda ()
			    (local-set-key "\M-n" 'scroll-up-slow)
			    (local-set-key "\M-p" 'scroll-down-slow)))


(add-hook 'bookmark-load-hook
	  '(lambda ()
	     (popper-wrap 'bookmark-show-annotation
			  "*Bookmark Annotation*")))

;; (add-hook 'tail-file-hook
;; 	  '(lambda ()
;; 	     (popper-wrap 'tail-file "*tail")
;; 	     (setq tail-display-buffer 'popper-switch)
;; ))

(add-hook 'sgml-mode-hook
	  '(lambda ()
	     (auto-fill-mode nil)))

(add-hook 'dired-mode-hook
	  '(lambda ()
	     (set-face-foreground 'dired-marked "darkgreen")
	     (local-set-key "h" 'dired-hide-dotfiles)
	     (local-set-key "\C-c\C-q" 'wdired-change-to-wdired-mode)))

(add-hook 'octave-mode-hook
	  '(lambda ()
	     (local-set-key " " 'self-insert-command)))

(add-hook 'inferior-octave-mode-hook
	  '(lambda ()
	     (setq comint-prompt-regexp "^[^>]+> ")))

(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
 
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t) 



(add-hook 'inferior-python-mode-hook
	  '(lambda ()
	     (setq comint-prompt-regexp ">>> ")))


(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

