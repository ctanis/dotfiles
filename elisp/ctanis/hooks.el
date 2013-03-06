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
	     (local-set-key [S-tab] 'markdown-shifttab)
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



; C style
;; (setq c-default-style '((c-mode  . "k&r")
;; 			(c++-mode . "stroustrup")
;; 			(objc-mode . "k&r")
;; 			(other . "ellemtel")))



(c-add-style "ctanis" '("ellemtel"
			(c-basic-offset . 4)
			(c-offsets-alist
			 (case-label . 1)
			 (access-label . -)
			 (cpp-macro . 0))
			(c-hanging-braces-alist
			 (substatement-open . 'before)
			 (class-open . 'before)
			 (defun-open . 'before)
			 (class-close)
			 )
			(c-hanging-semi&comma-criteria .
						       (c-semi&comma-no-newlines-before-nonblanks
							c-semi&comma-inside-parenlist))
			))
(setq c-default-style "ctanis")

;; ; open-line between curlies when autopair & auto-newline are enabled
;; (defun autopair-cleanup-closing-brace (action pair pos-before)
;;   (when (and (eq pair ?}) c-auto-newline)
;;     (save-excursion
;;       (open-line 1)
;;       (next-line)
;;       (c-indent-line)
;;       )
;;   ))

(defun autopair-cleanup-closing-brace (action pair pos-before)
  (cond ((and (eq action 'opening)(eq pair ?}) c-auto-newline)
	 (save-excursion
	   (open-line 1)
	   (next-line)
	   (c-indent-line)
	   ))
	; jump to next closing brace and cleanup all these auto
	; behaviors
	((and (eq action 'closing) (eq pair ?{) c-auto-newline)
	 (if (looking-at "\\($\\| $\\|\t\\| \\|\n\\)*}")
	     (progn 
	       (zap-to-char -1 ?})
	       (if c-electric-flag
		   (kill-line))
	       (forward-jump-to-char 1 ?})
	       (c-indent-line)
	       (forward-char))))))



(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (local-set-key "\C-c\C-c" 'compile)
	     (local-set-key "\C-m" 'newline-and-indent)
	     (c-toggle-auto-newline 1)
	     (c-toggle-hungry-state 1)
	     (abbrev-mode -1)
	     (local-set-key "\C-c\C-g" 'c-toggle-hungry-state)
	     (local-set-key "\C-\M-e" 'up-list)
	     (local-set-key "\M-o\M-e" 'c-end-of-defun)

	     ;; so autopair works with electric braces and auto newline
	     ;; (make-variable-buffer-local 'autopair-pair-criteria)
	     ;; (setq autopair-pair-criteria 'always)
	     ;; (setq autopair-handle-action-fns
	     ;; 	   (list 'autopair-default-handle-action
	     ;; 		 'autopair-cleanup-closing-brace))
))


;this is the  c comment-region thing i wrote
(add-hook 'c-mode-hook
	  '(lambda ()
	     (local-set-key "\M-o1" 'make-c-header)
	     ))

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
	       (toggle-word-wrap 1)
	       ;(visual-line-mode t)
	       ; (set-fill-column 68)
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
	     ;; (setq comint-use-prompt-regexp t)
	     ;; (setq comint-prompt-regexp "^[^\$]+\$ ")
	     ; (setq comint-prompt-read-only t)
	     (define-key comint-mode-map
	       "\M-p" 'comint-previous-matching-input-from-input)
	     (define-key comint-mode-map
	       "\M-n" 'comint-next-matching-input-from-input)
	     (define-key comint-mode-map "\C-a" 'comint-bol)
	     (define-key comint-mode-map "\M-o\C-?" 'comint-kill-input)
	     (define-key comint-mode-map "\M-{" 'comint-previous-prompt)
	     (define-key comint-mode-map "\M-}" 'comint-next-prompt)
	     ))


(add-hook 'shell-mode-hook 
     '(lambda ()
	; allow the killing of this buffer without prompting
	(process-kill-without-query (get-buffer-process (current-buffer)))
	(toggle-truncate-lines 1)))

(setq shell-font-lock-keywords
      `(
	("\#.*" . font-lock-comment-face)
	))



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
))





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
	     (local-set-key "h" 'dired-hide-dotfiles)
	     (local-set-key "\C-c\C-q" 'wdired-change-to-wdired-mode)
	     ))

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


(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (local-set-key "\C-x\C-f" 'ido-find-file)
	     (local-unset-key "\M-o")))


(add-hook 'org-mode-hook
	  '(lambda()
;	     (org-indent-mode t)
	     (auto-fill-mode 1)))



(add-hook 'ido-minibuffer-setup-hook
	  (lambda()
	    (define-key ido-file-completion-map "\C-t" 'transpose-chars)
	    (define-key ido-buffer-completion-map "\C-t" 'transpose-chars)
	    (define-key ido-file-dir-completion-map "\C-t" 'transpose-chars)

	    (define-key ido-file-completion-map "\M-b" 'backward-word)
	    (define-key ido-buffer-completion-map "\M-b" 'backword-word)
	    (define-key ido-file-dir-completion-map "\M-b" 'backword-word)

	    (define-key ido-buffer-completion-map "\M-s" 'ido-enter-find-file)
	    ))



