;(setq default-frame-alist '((scroll-bar-width . 10)))

;; start this asap
(if window-system
    (server-start))


(load-library "functions")
(load-library "hooks")
(load-library "attribute")
(load-library "ui")
(load-library "school")
(load-library "headers")
(load-library "ispell")
(load-library "hippie-exp")


(if (locate-library "tramp")
    (load-library "tramp"))



(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
	try-complete-file-name
	try-expand-list
	try-expand-line
	try-expand-dabbrev-from-kill
	try-expand-list-all-buffers
	try-expand-line-all-buffers
	;try-complete-lisp-symbol
	))

(setq grep-command "egrep -ni ")

(setq comint-input-ring-size 75)

; always process attribute list(?)
(setq enable-local-eval 'query)
;(setq enable-local-eval t)


;; confirm deletions with 'y' or 'n', not 'yes' or 'no'
(setq dired-deletion-confirmer 'y-or-n-p)

;(display-time)


(setq ange-ftp-generate-anonymous-password nil)
(setq initial-scratch-message nil)
(put 'eval-expression 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'scroll-left 'disabled nil)


;(resize-minibuffer-mode)
(column-number-mode t)
(line-number-mode t)
;(host-name-mode t)
(setq inhibit-startup-message t)




;what is this used for, and is it correct?
(setq comint-prompt-regexp "^[1-9]*:.*M:.*>")


(if (file-exists-p "~/.diary")
    (progn
      (require 'calendar)
      (setq mark-diary-entries-in-calendar t)
      (setq number-of-diary-entries [7 7 6 5 4 3 2])
      (setq diary-list-include-blanks t)
      (setq diary-file "~/.diary")
      ;(setq calendar-daylight-time-zone-name "New Orleans, LA")
      (setq calendar-daylight-time-zone-name "EDT")
      (define-key calendar-mode-map "T" 'edit-todo-file)
;      (setq view-diary-entries-initially t)
;      (calendar)
;      (mark-calendar-holidays)
;      (diary 1)
      ))


;print out characters instead of octal codes
;; this is obsolete
;(standard-display-european t)

(setq c-macro-preprocessor "gcc -E -C -")

;this should cause CVS'ed files to be backuped as normal
;(setq vc-make-backup-files t)

;don't bother asking me if i want to edit through the link or not
(setq vc-follow-symlinks t)


; requires host-name-mode.el
(setq frame-title-format '("" hostname ": %b"))
(setq icon-title-format '("" hostname ": %b"))


;make everything fontified
(global-font-lock-mode t)

(setq-default search-highlight t)

;; expansions always respect case
(setq dabbrev-case-fold-search nil)

;so next-line doesn't add newline
(setq next-line-add-newlines nil)

; no help!
(defun no-help (a) nil)
(setq show-help-function 'no-help)


; a file can end with whatever is appropriate, dammit!
(setq require-final-newline nil)

; don't load system init
(setq inhibit-default-init t)




;; set up the mode-line
; put (purecopy '(host-name-mode hostname)) where in the modeline
; you want the information
; (setq-default mode-line-format
;   (list (purecopy "")
;    'mode-line-modified
;    'mode-line-buffer-identification
;    (purecopy "   ")
;    'global-mode-string
;    (purecopy "   %[(")
;    'mode-name 'mode-line-process 'minor-mode-alist
;    (purecopy "%n")
;    (purecopy ")%]--")
;    (purecopy '(host-name-mode hostname))
;    (purecopy '(host-name-mode "--"))
;    (purecopy '(line-number-mode "L%l--"))
;    (purecopy '(column-number-mode "C%c--"))
;    (purecopy '(-3 . "%p--"))
;    (purecopy "-%-")))
; 




;; KEYBINDINGS
(global-set-key "\C-x\C-c" 'verify-exit)

;;;boy is this ugly
(fset 'goto-popper-buffer
   "\C-u\C-xo")

(global-set-key "\C-zo" 'goto-popper-buffer)
(global-set-key "\M-s" 'goto-line)
(global-set-key "\M-,"  'ispell-word)
(global-set-key "\M-j" 'backward-jump-to-char)
(global-set-key "\C-xz" 'calendar)
;(global-set-key "\C-x!" 'shell)
(global-set-key "\C-x!" 'shell-current-directory)
(global-set-key "\C-q" 'base-quoted-insert)
(global-set-key "\C-h\C-m" 'man)

;bindings for customized functions
(define-prefix-command 'craig-prefix 'craig-prefix-map)
(global-set-key "\M-o" 'craig-prefix)

(define-key craig-prefix-map "\C-o" 'better-display-buffer)
(define-key craig-prefix-map "\M-o" 'popper-other-window)
(define-key craig-prefix-map "o" 'switch-to-buffer)
(define-key craig-prefix-map "k" 'kill-other-buffer)
(define-key craig-prefix-map "\M-k" 'kill-current-buffer)
(define-key craig-prefix-map "\M-b" 'sink-buffer)
(define-key craig-prefix-map "q" 'flip-windows)
(define-key craig-prefix-map "p" 'delete-other-windows)
(define-key craig-prefix-map "b" 'switch-to-buffer-other-window)
(define-key craig-prefix-map "d" 'dired-other-window)
(define-key craig-prefix-map "\M-d" 'selectively-delete-lines)
(define-key craig-prefix-map "i" 'delete-window)
(define-key craig-prefix-map "f" 'find-file-other-window)
(define-key craig-prefix-map "\M-j" 'forward-jump-to-char)
(define-key craig-prefix-map "l" 'move-to-window-line)
(define-key craig-prefix-map "h" 'split-window-vertically)
(define-key craig-prefix-map "v" 'split-window-horizontally)
;(define-key craig-prefix-map "u" 'undo-window-config-change)
;(define-key craig-prefix-map "r" 'undo-undo-window-config-change)
(define-key craig-prefix-map "\M-r" 'rename-buffer)
(define-key craig-prefix-map "s" 'switch-to-common-buffer)
(define-key craig-prefix-map "t" 'insert-time-stamp)
(define-key craig-prefix-map "w" 'write-region)
;(define-key craig-prefix-map "n" 'send-region-to-netscape)
(define-key craig-prefix-map "\C-w" 'delete-region)
;(define-key craig-prefix-map "\C-f" 'find-and-display-file)
(define-key craig-prefix-map "\C-d" 'list-and-display-directory)
(define-key craig-prefix-map "\C-a" 'alternate-buffer-in-other-window)
(define-key craig-prefix-map "\C-?" 'kill-to-beginning-of-line)
(define-key craig-prefix-map "a" 'alternate-buffer)
(define-key craig-prefix-map " " 'just-no-space)
(define-key craig-prefix-map "c" 'center-line)
(define-key craig-prefix-map "." 'find-tag-other-window)
;(define-key craig-prefix-map "\M-." 'online-dictionary-lookup)
(define-key craig-prefix-map "]" 'overwrite-mode) ;toggle it!
(define-key craig-prefix-map "\M-e" 'interactively-enlarge-window)
(define-key craig-prefix-map "1" 'make-generic-header)
(define-key craig-prefix-map "2" 'create-attribute-list)
(define-key craig-prefix-map "3" 'executable-set-magic)
(define-key craig-prefix-map "4" 'make-perl-script)
(define-key craig-prefix-map "\M-i" 'imenu)
;(define-key craig-prefix-map "\C-g" 'find-grep-dired)
(define-key craig-prefix-map "\C-f" 'find-dired)
(define-key craig-prefix-map "\M-t" 'toggle-truncate-lines)
(define-key craig-prefix-map "\M-f" 'find-and-display-file)
(define-key craig-prefix-map "\M-c" 'make-tmp-code)
(define-key craig-prefix-map "\M-m" 'make-directory)
;(define-key craig-prefix-map "\C-xh" 'open-file-in-hidden-buffer)
(define-key craig-prefix-map "\C-x1" 'mono-framify)
(define-key craig-prefix-map "\C-x2" 'frame-mitosis)
(define-key craig-prefix-map "\C-x-" 'shrink-other-window-if-larger-than-buffer)
(define-key craig-prefix-map "\M-h" 'hl-line-mode)

;(global-set-key "\C-x\M-q" 'prefix-paragraph)
;(global-set-key "\C-xrv" 'invert-rectangle)

;why would i want to SUSPEND EMACS!  

(global-set-key "\M-\C-z" 'suspend-emacs)

;(global-set-key [M-tab] 'hippie-expand)
(global-set-key "\M-?" 'hippie-expand)

; some redundant keystrokes to bridge gap between linux and mac

(global-set-key "\M-`" 'other-frame)

; this one should be \C-M-/
(global-set-key (quote [201326639]) (quote hippie-expand))



(global-set-key "\M-/" 'dabbrev-expand)

(define-key ctl-x-map ";" 'comment-region)

;for jumping around in a file quicker
(global-set-key "\M-p" 'scroll-down-slow)
(global-set-key "\M-n" 'scroll-up-slow)

(define-key isearch-mode-map "\M-p" 'scroll-down-slow)
(define-key isearch-mode-map "\M-n" 'scroll-up-slow)

(global-set-key "\M-\C-y" 'repeat-complex-command)
(global-set-key "\M-\C-g" 'grep)

(setq visible-bell t)

;(setq kill-whole-line t) ;; ctrl-k also grabs newline at end
;(setq c-auto-newline t)	 ;; auto newline after close-brace, and semicolon


;; UNSET
(global-unset-key "\C-x\C-z")
(global-unset-key "\C-h\C-p")		;gnu manifesto
(global-unset-key "\C-h\C-n")		;emacs news
(global-unset-key "\C-hn")
(global-unset-key "\C-ht")
(global-unset-key [f10])
(global-unset-key [f2])
(global-unset-key [f1])
(global-unset-key [end])
(global-unset-key [home])
;(global-unset-key [insert])
(global-unset-key [prior])
(global-unset-key [next])


;remove an alternate keybinding for undo
;(global-unset-key "\C-/")
(global-unset-key (quote [67108911]))



; don't highlight region
(transient-mark-mode 0)

;(setq x-stretch-cursor t)

; stick all ~ files in one place
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq scroll-preserve-screen-position t) ;; nicer screen scrolling

;;================================================ ============
;; minibuffer space completion
;;================================================ ============

(if (>= emacs-major-version 22)
    (progn
      (define-key minibuffer-local-filename-completion-map (kbd "SPC")
	'minibuffer-complete-word)

      (define-key minibuffer-local-must-match-filename-map (kbd "SPC")
	'minibuffer-complete-word)))


;next/previous line should respect wrapped lines!!
(setq line-move-visual nil)
(transient-mark-mode 0)

(if window-system
    (progn
      (menu-bar-mode nil)
      (tool-bar-mode -1)
      (auto-image-file-mode 1)))


; display buffer will not open a new window if it shows up in another
; frame..  specifically this is for compilations!
(setq-default display-buffer-reuse-frames t)

(defadvice display-buffer (around  display-buffer-return-to-sender activate)
  "displaying a buffer in another frame should not change the frame we are currently in!"
  (let ((f (window-frame (selected-window))))
    ad-do-it
    (raise-frame f)))

;; advise dired to only complete directory names, when done interactively
;; (defadvice dired
;;   (before complete-directories-only activate)
;;   "when called interactively, only tab-complete directory names"
;;   (interactive "DDired (Directory): ")
;; )

;; a wrapper around dired that only completes directory names
;; (defun my-dired (d)
;;   (interactive "DDired (Directory): ")
;;   (dired d))
;; (global-set-key "\C-xd" 'my-dired)


(defun monitor-tex (file)
  (interactive "fRoot Tex File: ")
  (let* ((buf (generate-new-buffer (concat "*monitor-tex: " file "*")))
	 (cmd (concat "latexmk -pdf -pvc " file " &")))
    (save-excursion
      (switch-to-buffer buf)
      (setq default-directory (file-name-directory file))
      (shell-command cmd  buf)
      (display-buffer buf))))

(global-set-key "\C-l" 'recenter)



; don't have to use the mouse to get flymake feedback
(load-library "flycursor")
(define-key craig-prefix-map "\M-p" 'flymake-goto-prev-error)
(define-key craig-prefix-map "\M-n" 'flymake-goto-next-error)


; don't use ls for dired -- use elisp
(setq ls-lisp-use-insert-directory-program nil)
(require 'ls-lisp)


;; case doesn't matter in the minibuffer
(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(defalias 'list-buffers 'ibuffer)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-auto-merge-delay-time 99999);; use M-s to search other work dirs
(setq ido-use-filename-at-point 'guess)
(setq ido-ignore-files '("^ " "^\\*"))
(ido-mode 1)

; ignore certain files in the list
(mapcar (lambda (x) (add-to-list 'completion-ignored-extensions x))
	'(".ctxt" ".DS_Store" ".log"))

; inhibit ffap- in dired mode, expose other controls
(load-library "ffap-")



(defalias 'yes-or-no-p 'y-or-n-p)
(show-paren-mode 1)

(setenv "PAGER" "/bin/cat")

(setq gdb-show-main t)
;(setq gdb-many-windows t)

