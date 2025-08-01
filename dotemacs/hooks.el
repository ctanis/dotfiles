(mapcar #'(lambda (a)
	    (add-to-list 'auto-mode-alist a))
	'(
	  ("\\.h$" . c++-mode)
	  ("\\.m$" . octave-mode)
	  ("\\.md$" . markdown-mode)
	  ))


;; (add-hook 'scheme-mode-hook
;;           #'(lambda ()
;;               (setq autopair-dont-activate t)
;;               (set (make-local-variable 'autopair-skip-whitespace) 'chomp)
;;               ;;(autopair-mode -1)
;;               ))

(add-hook 'geiser-repl-mode-hook
          #'(lambda ()
              (define-key geiser-repl-mode-map "\M-`" nil)
              ;; (setq autopair-dont-activate t)
              ;(add-to-list 'common-buffers '("g" . "* Guile REPL *"))
              ;;(set (make-local-variable 'is-common-buffer) t)
              ;;(set (make-local-variable 'autopair-skip-whitespace) 'chomp)
              ;;(autopair-mode -1)
          ))

(add-hook 'geiser-mode-hook
          #'(lambda ()
              (define-key geiser-mode-map "\M-`" nil))
          )


(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)



(add-hook 'markdown-mode-hook
	  #'(lambda()
	      (local-set-key "\C-\M-u" 'backward-up-list)
	      (local-set-key "\M-p" 'scroll-down-slow)
	      (local-set-key "\M-n" 'scroll-up-slow)
	      (local-set-key "\C-\M-f" 'forward-sexp)
	      (local-set-key "\C-\M-b" 'backward-sexp)
	      (local-set-key [S-tab] 'markdown-shifttab)
	      ))

(add-hook 'occur-mode-hook
          #'(lambda()
              (toggle-truncate-lines 1)))


;; ; open-line between curlies when autopair & auto-newline are enabled
;; (defun autopair-cleanup-closing-brace (action pair pos-before)
;;   (when (and (eq pair ?}) c-auto-newline)
;;     (save-excursion
;;       (open-line 1)
;;       (next-line)
;;       (c-indent-line)
;;       )
;;   ))

;; (defun autopair-cleanup-closing-brace (action pair pos-before)
;;   (cond ((and (eq action 'opening)(eq pair ?}) c-auto-newline)
;; 	 (save-excursion
;; 	   (open-line 1)
;; 	   (next-line)
;; 	   (c-indent-line)
;; 	   ))
;; 	; jump to next closing brace and cleanup all these auto
;; 	; behaviors
;; 	((and (eq action 'closing) (eq pair ?{) c-auto-newline)
;; 	 (if (looking-at "\\($\\| $\\|\t\\| \\|\n\\)*}")
;; 	     (progn 
;; 	       (zap-to-char -1 ?})
;; 	       (if c-electric-flag
;; 		   (kill-line))
;; 	       (forward-jump-to-char 1 ?})
;; 	       (c-indent-line)
;; 	       (forward-char))))))







(add-hook 'text-mode-hook
          #'(lambda ()
              (modify-syntax-entry ?\" "\"")))

(add-hook 'comint-mode-hook
	  #'(lambda ()
	      ;; (setq comint-use-prompt-regexp t)
	      ;; (setq comint-prompt-regexp "^[^\$]+\$ ")
					; (setq comint-prompt-read-only t)
	      (define-key comint-mode-map
	        "\M-p" 'comint-previous-matching-input-from-input)
	      (define-key comint-mode-map
	        "\M-n" 'comint-next-matching-input-from-input)
	      (define-key comint-mode-map "\C-a" 'comint-bol)
              (define-key comint-mode-map "\M-\C-r" 'comint-history-isearch-backward)
	      (define-key comint-mode-map "\M-o\C-?" 'comint-kill-input)
	      (define-key comint-mode-map "\M-{" 'comint-previous-prompt)
	      (define-key comint-mode-map "\M-}" 'comint-next-prompt)

              ;; can't remember why I had this disabled...
              ;; (setq autopair-dont-activate t)
              ;; (autopair-mode -1)
	      ))

(add-hook 'shell-mode-hook 
	  #'(lambda ()
              (toggle-truncate-lines 0)))

(add-hook 'shell-mode-hook
          #'(lambda ()
              (when (file-remote-p default-directory)
                (let ((parts (split-string  default-directory ":")))
                  (setq comint-input-ring-file-name
                        (concat (car parts) ":" (cadr parts) ":~/.bash_history"))
                  (comint-read-input-ring)
                  ;; (set-process-sentinel (get-buffer-process (current-buffer))
		  ;; #'shell-write-history-on-exit)
                  (set-process-sentinel (get-buffer-process (current-buffer))
                                        #'(lambda (process event)
                                            (let ((buf (process-buffer process)))
                                              (when (buffer-live-p buf)
                                                (with-current-buffer buf
                                                  (insert (format "\nProcess %s %s\n" process event)))))))
                  ))))

(setq shell-font-lock-keywords
      `(
	("\#.*" . font-lock-comment-face)
	))



(add-hook 'octave-mode-hook
	  #'(lambda ()
	      (local-set-key "\C-m" 'newline-and-indent)))


(add-hook 'inferior-octave-mode-hook
	  #'(lambda ()
	      (local-set-key
	       "\M-p" 'comint-previous-matching-input-from-input)
	      (local-set-key
	       "\M-n" 'comint-next-matching-input-from-input)
	      (local-set-key
	       "\C-a" 'comint-bol)))


(add-hook 'emacs-lisp-mode-hook
	  #'(lambda ()
	      (setq comment-start ";; ")
	      ;; (set (make-local-variable 'autopair-skip-whitespace) 'chomp)
              (local-set-key "\C-m" 'newline-and-indent)))

(add-hook 'lisp-interaction-mode-hook
	  #'(lambda ()
	      (setq comment-start ";; ")
	      (local-set-key "\C-m" 'newline-and-indent)))


(add-hook 'perl-mode-hook
	  #'(lambda ()

              (local-set-key "\C-c\C-c" 'eval-buffer-as-perl-script)
	      (local-set-key "\C-m" 'newline-and-indent)))

;; (add-hook 'cperl-mode-hook
;;           '(lambda ()
;;              (make-local-variable autopair-skip-criteria)
;;              (setq autopair-skip-criteria 'always)
;;              ))



(defalias 'perl-mode 'cperl-mode)
(setq cperl-invalid-face (quote off))
;;(setq cperl-hairy t)
;;(add-to-list 'font-lock-maximum-decoration (cons 'cperl-mode 1))


(add-hook 'cperl-mode-hook
	  #'(lambda ()
	      (local-set-key "\C-c\C-c" 'eval-buffer-as-perl-script)
	      (local-set-key "\C-m" 'newline-and-indent)
	      (local-set-key "\M-o\M-v" 'cperl-get-help)
	      (local-set-key "\M-o\M-h" 'cperl-perldoc-at-point)
	      (local-set-key "\M-o\C-H" 'cperl-perldoc)
	      (local-set-key "\M-o|" 'cperl-lineup)
	      ))





(add-hook 'Man-mode-hook
          #'(lambda ()
	      (local-set-key "\M-n" 'scroll-up-slow)
	      (local-set-key "\M-p" 'scroll-down-slow)))




(add-hook 'sgml-mode-hook
	  #'(lambda ()
	      (auto-fill-mode -1)))

(add-hook 'html-mode-hook
          #'(lambda()
              (local-set-key "\M-o" 'craig-prefix)
              (auto-fill-mode -1)))



(add-hook 'octave-mode-hook
	  #'(lambda ()
	      (local-set-key " " 'self-insert-command)))

(add-hook 'inferior-octave-mode-hook
	  #'(lambda ()
	      (setq comint-prompt-regexp "^[^>]+> ")))

(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)

(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t) 


(add-hook 'inferior-python-mode-hook
          #'(lambda()
              ;;(add-to-list 'common-buffers '("p" . "*Python*"))
              ;;(set (make-local-variable 'is-common-buffer) t)
              ))


;; (add-hook 'inferior-python-mode-hook
;; 	  '(lambda ()
;; 	     (setq comint-prompt-regexp ">>> ")))


(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))


(add-hook 'ibuffer-mode-hook
	  #'(lambda ()
	      (ibuffer-auto-mode 1)
;	     (add-to-list 'ibuffer-never-show-predicates "^\\*")
	      (local-unset-key "\M-o")))


(add-hook 'org-mode-hook
	  #'(lambda()
	      (local-set-key "\C-\M-p" 'org-backward-element)
	      (local-set-key "\C-\M-n" 'org-forward-element)
	      (local-set-key "\M-{" 'backward-paragraph)
	      (local-set-key "\M-}" 'forward-paragraph)

					;(local-set-key "\C-\M-u" 'org-up-element)
	      (local-set-key "\C-\M-u" 'org-up-list-or-element)
	      (local-set-key "\C-\M-d" 'org-down-element)
              (local-set-key "\C-\M-e" 'org-end-of-item-list)

	      (local-set-key "\C-c\M-w" 'org-refile-fullpath)
	      ;; rebound since yasnippet eats the previous shortcut
	      (local-set-key "\C-c\M-b" 'org-mark-ring-goto)
             

	      (local-set-key "\C-c\M-n" 'org-next-block)
	      (local-set-key "\C-c\M-p" 'org-previous-block)

	      (auto-fill-mode 1)
              (toggle-truncate-lines -1)

              (local-set-key (kbd "C-c SPC") 'ace-jump-mode)
              ))

(add-hook 'org-agenda-mode-hook
          #'(lambda ()
              (local-set-key "\C-c\M-w" 'org-agenda-refile-fullpath)))

(add-hook 'org-agenda-finalize-hook
          #'(lambda()
              (hl-line-mode nil)))



;; redefine local autopair emulation
;; list to ignore autopair-newline, when in org-mode
;; (defadvice autopair--set-emulation-bindings (after autopair-org-no-return activate)
;;   "remove autopair-newline in org-mode"
;;   (if (eq major-mode 'org-mode)
;;       (setq autopair--emulation-alist
;;             (list (delq (assoc '13 (car autopair--emulation-alist))
;;                         (car autopair--emulation-alist)
;;                         )))
;;     )
;;   )


;; yasnippet and org-mode
(defun yas/org-very-safe-expand ()
  (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))

(add-hook 'org-mode-hook
          #'(lambda ()
              ;; yasnippet (using the new org-cycle hooks)
              (make-variable-buffer-local 'yas/trigger-key)
              (setq yas/trigger-key [tab])
              (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
                                        ;(define-key yas/keymap [tab] 'yas/next-field)
              (define-key yas/keymap [tab] 'yas-next-field)
              ))






(add-hook 'erlang-shell-mode-hook
          #'(lambda()
              ;;(set (make-local-variable 'is-common-buffer) t)
              ;;(add-to-list 'common-buffers '("e" . "*erlang*"))
	      (setq comint-process-echoes t)))


(add-hook 'erlang-mode-hook
	  #'(lambda()
              (local-set-key "\C-m" 'newline-and-indent)))

(add-hook 'Info-mode-hook
	  #'(lambda()
	      (local-set-key "\M-n" 'scroll-up-slow)
	      (local-set-key "\M-p" 'scroll-down-slow)))

(add-hook 'latex-mode-hook
          #'(lambda ()
	      (add-to-list 'tex-verbatim-environments "lstlisting")
	      ;; (set (make-local-variable 'autopair-skip-criteria) 'always)
              ;; (set (make-local-variable 'autopair-handle-action-fns)
	      ;;      (list 'autopair-default-handle-action
	      ;;            'autopair-latex-mode-paired-delimiter-action))
              ))



;; 					; these characters don't autopair right
;; (eval-after-load "text-mode" '(modify-syntax-entry ?\" "\"" text-mode-syntax-table))
;; (eval-after-load "markdown-mode" '(modify-syntax-entry ?\" "\"" markdown-mode-syntax-table))
;; (eval-after-load "markdown-mode" '(modify-syntax-entry ?` "\"" markdown-mode-syntax-table))
;; 					;(eval-after-load "tex-mode" '(modify-syntax-entry ?$ "\"" latex-mode-syntax-table))



(add-hook 'folding-mode-hook
	  #'(lambda ()
	      (local-set-key "\C-\M-n" 'folding-next-visible-heading)
	      (local-set-key "\C-\M-p" 'folding-previous-visible-heading)
	      (local-set-key (read-kbd-macro "M-o <tab>") 'folding-toggle-show-hide)))

(eval-after-load "hideshow"
  #'(progn
      (defadvice goto-line (after expand-after-goto-line
				  activate compile)
        "hideshow-expand affected block when using goto-line in a collapsed buffer"
        (save-excursion
	  (hs-show-block)))
      ))


(add-hook 'diff-mode-hook
	  #'(lambda ()
	      (local-set-key "\M-o" 'craig-prefix)))


(add-hook 'calc-mode-hook
	  #'(lambda ()
	      (yas-minor-mode -1)))

(eval-after-load "calc"
  #'(define-key calc-dispatch-map "\M-u" 'calc-same-interface)
  )




;; choose an appropriate compile-command
(add-hook 'java-mode-hook
          #'(lambda ()
              (if (locate-dominating-file default-directory "build.xml")
                  (set (make-local-variable 'compile-command)
                       "ant -emacs -s build.xml -e ")
                (if buffer-file-name
                    (set (make-local-variable 'compile-command)
                         (concat "javac -Xlint " (file-name-nondirectory buffer-file-name)))))))

;; ibuffer -- group dired buffers with filenames
(eval-after-load "ibuf-ext"
      #'(define-ibuffer-filter filename
            "Toggle current view to buffers with file or directory name matching QUALIFIER."
          (:description "filename"
                        :reader (read-from-minibuffer "Filter by file/directory name (regexp): "))
          (ibuffer-awhen (or (buffer-local-value 'buffer-file-name buf)
                             (buffer-local-value 'dired-directory buf))
                         (string-match qualifier it))))


(add-hook 'js2-mode-hook
          #'(lambda()
              ;;(make-local-variable 'autopair-skip-criteria)
              ;;(setq autopair-skip-criteria 'always)
              ;;(make-local-variable 'autopair-skip-whitespace)
              ;;(setq autopair-skip-whitespace nil)
              (define-key js2-mode-map "\M-j" 'backward-jump-to-char)
	      ;; (electric-layout-mode 1)
              ))


(add-hook 'cuda-mode-hook
          #'(lambda()
              (yas-activate-extra-mode 'c-mode)
              (setq imenu-generic-expression cc-imenu-c++-generic-expression)
              ))

(add-hook 'compilation-mode-hook
          #'(lambda()
              (add-to-list 'common-buffers '("c" . "*compilation*"))
              (set (make-local-variable 'is-common-buffer) t)))

(add-hook 'ggtags-mode-hook
          #'(lambda()
              (define-key ggtags-navigation-map "\M-o" nil)
              (define-key ggtags-mode-prefix-map "\M-o" nil)))
