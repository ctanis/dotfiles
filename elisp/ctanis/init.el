;; start this asap
(if window-system
    (server-start))


(load-library "functions")
(load-library "hooks")
(load-library "modeline-cleanup")

; on startup...
(setq inhibit-default-init t)			;; don't load system init
(setq inhibit-startup-message t)               
(setq initial-scratch-message nil)

; enable functionality
(put 'eval-expression 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'scroll-left 'disabled nil)
(setq enable-local-eval 'query)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq dired-deletion-confirmer 'y-or-n-p)

(column-number-mode t)
(line-number-mode t)
(global-font-lock-mode t)
(setq-default search-highlight t)


;; command tweaks
(setq grep-command "egrep -ni ")
(setq vc-make-backup-files t) ;; backup as normal
(setq vc-follow-symlinks t) ;; transparently follow


(setq dabbrev-case-fold-search nil) ;; expansions always respect case

;; be careful at the end of the file
(setq next-line-add-newlines nil)
(setq require-final-newline nil)


; no help!
(defun no-help (a) nil)
(setq show-help-function 'no-help)


;; KEYBINDINGS
(global-set-key "\C-x\C-c" 'verify-exit)

(define-prefix-command 'craig-prefix 'craig-prefix-map)

(define-key global-map "\M-o" 'craig-prefix)
(define-key craig-prefix-map " " 'just-no-space)
(define-key craig-prefix-map "2" 'create-file-mode)
(define-key craig-prefix-map "3" 'executable-set-magic)
(define-key craig-prefix-map "4" 'make-perl-script)
(define-key craig-prefix-map "\C-?" 'kill-to-beginning-of-line)
(define-key craig-prefix-map "\C-a" 'alternate-buffer-in-other-window)
(define-key craig-prefix-map "\C-o" 'better-display-buffer)
(define-key craig-prefix-map "\C-w" 'delete-region)
(define-key craig-prefix-map "\C-x-" 'shrink-other-window-if-larger-than-buffer)
(define-key craig-prefix-map "\C-x1" 'mono-framify)
(define-key craig-prefix-map "\C-x2" 'frame-mitosis)
(define-key craig-prefix-map "\M-b" 'sink-buffer)
(define-key craig-prefix-map "\M-c" 'make-tmp-code)
(define-key craig-prefix-map "\M-d" 'selectively-delete-lines)
(define-key craig-prefix-map "\M-e" 'end-of-defun)
(define-key craig-prefix-map "\M-h" 'hl-line-mode)
(define-key craig-prefix-map "\M-j" 'forward-jump-to-char)
(define-key craig-prefix-map "\M-k" 'kill-current-buffer)
(define-key craig-prefix-map "\M-m" 'make-directory)
;(define-key craig-prefix-map "\M-o" 'other-window)
(define-key craig-prefix-map "\M-o" 'switch-to-previous-window)
(define-key craig-prefix-map "\M-t" 'toggle-truncate-lines)
;(define-key craig-prefix-map "]" 'overwrite-mode) ;toggle it!
(define-key craig-prefix-map "a" 'alternate-buffer)
(define-key craig-prefix-map "b" 'switch-to-buffer-other-window)
;(define-key craig-prefix-map "c" 'center-line)
(define-key craig-prefix-map "d" 'dired-other-window)
(define-key craig-prefix-map "f" 'find-file-other-window)
(define-key craig-prefix-map "h" 'split-window-vertically)
(define-key craig-prefix-map "i" 'delete-window)
(define-key craig-prefix-map "k" 'kill-other-buffer)
(define-key craig-prefix-map "l" 'move-to-window-line)
(define-key craig-prefix-map "o" 'switch-to-buffer)
(define-key craig-prefix-map "p" 'delete-other-windows)
(define-key craig-prefix-map "q" 'flip-windows)
(define-key craig-prefix-map "s" 'switch-to-common-buffer)
(define-key craig-prefix-map "t" 'insert-time-stamp)
(define-key craig-prefix-map "v" 'split-window-horizontally)
(define-key craig-prefix-map "w" 'write-region)
(define-key craig-prefix-map "u" 'revert-buffer)
(define-key craig-prefix-map (read-kbd-macro "<tab>") 'hs-toggle-hiding)
(define-key craig-prefix-map "\M-x" 'compile-again)
(define-key craig-prefix-map "\M-v" 'view-mode)
(define-key craig-prefix-map "-" 'insert-separator)
(define-key craig-prefix-map "[" 'wrap-region-with-char)
(define-key craig-prefix-map "\M-u" 'calc-dispatch)
(define-key craig-prefix-map "\M-r" 'copy-region-for-paste)
(define-key craig-prefix-map "\M-2" 'save-file-local-variable)
(define-key craig-prefix-map "\M-q" 'slide-line-left)

(global-set-key "\M-j" 'backward-jump-to-char)
(global-set-key "\M-,"  'ispell-word)

(global-set-key "\C-xz" 'calendar)
(global-set-key "\C-x!" 'shell-current-directory)
(global-set-key "\C-q" 'base-quoted-insert)

(global-set-key "\C-\M-e" 'up-list)

; some redundant keystrokes to bridge gap between linux and mac
(global-set-key "\M-`" 'other-frame)

(define-key ctl-x-map ";" 'comment-region)

;for jumping around in a file quicker
(global-set-key "\M-p" 'scroll-down-slow)
(global-set-key "\M-n" 'scroll-up-slow)

(define-key isearch-mode-map "\M-p" 'scroll-down-slow)
(define-key isearch-mode-map "\M-n" 'scroll-up-slow)

(global-set-key "\M-\C-y" 'repeat-complex-command)
(global-set-key "\M-\C-g" 'grep)

(global-set-key "\C-l" 'recenter)


;; UNSET
(global-unset-key "\C-z") ;; no more suspend/iconify
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

; visible bell
(setq visible-bell t)

; dired - guess destination when 2 dired windows are visible
(setq dired-dwim-target nil)
(eval-after-load 'dired
  '(progn
     (defun dired-do-copy-other-window ()
       (interactive)
       (let ((dired-dwim-target t))
         (call-interactively 'dired-do-copy)))

     (defun dired-do-rename-other-window ()
       (interactive)
       (let ((dired-dwim-target t))
         (call-interactively 'dired-do-rename)))


     (define-key dired-mode-map "\C-cc" 'dired-do-copy-other-window)
     (define-key dired-mode-map "\C-cr" 'dired-do-rename-other-window)
     )
  )



; don't highlight region
(transient-mark-mode 0)

; c-spc after C-u C-spc pops
(setq set-mark-command-repeat-pop t)

;next/previous line should respect wrapped lines!!
(setq line-move-visual nil)

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




; don't have to use the mouse to get flymake feedback
(eval-after-load 'flymake
'(progn
   (load-library "flycursor")
   (define-key craig-prefix-map "\M-p" 'flymake-goto-prev-error)
   (define-key craig-prefix-map "\M-n" 'flymake-goto-next-error)
   (define-key craig-prefix-map "\M-f" 'flymake-start-syntax-check)
   ;; triggering syntax check with newlines is terrible
   (setq flymake-log-level 0)
   (setq flymake-start-syntax-check-on-newline nil)
   ))

(defun flymake-display-warning (warning) 
  "Display a warning to the user, using lwarn"
  (message warning))

; don't use ls for dired -- use elisp
(setq ls-lisp-use-insert-directory-program nil)
(require 'ls-lisp)


;; case doesn't matter in the minibuffer
(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(defalias 'list-buffers 'ibuffer)
(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-expert t)
(define-key craig-prefix-map "\C-x\C-b" 'ibuffer-other-window)

; inhibit ffap- in dired mode, expose other controls
;(load-library "ffap-")



;; ------------ ido stuff
(setq ido-enable-flex-matching t)
;(setq ido-everywhere t)
(setq ido-auto-merge-delay-time .3)
;(setq ido-auto-merge-delay-time 9999);; use M-s to search other work dirs
(setq ido-auto-merge-work-directories-length 0)
(setq ido-use-filename-at-point nil)
(setq ido-default-buffer-method 'selected-window)
;(setq ido-ignore-buffers '("\\` " "\\*"))


(setq ido-enable-regexp nil) ;; toggle it if you want it
(setq ido-enable-prefix nil) ;; toggle it if you want it
(ido-mode 1)
;; (add-to-list 'ido-ignore-files "`\\.DS_Store")
;; (add-to-list 'ido-ignore-files "`\\.git")
(add-to-list 'ido-ignore-files "`\\.") ;; no dotfiles
(ido-everywhere -1)
(setq imenu-auto-rescan t)

(defun my-buffer-filter (name)
  (with-current-buffer name
    (let ((n (buffer-name)))
      (not (or (string-match "\\*Man" n)
               (string= (format-mode-line mode-name) "Shell")
               (not (string-match "\\*" n)))))))

(setq ido-ignore-buffers '(my-buffer-filter))



(defun ido-dired-other-window ()
  "Call `dired-other-window' the ido way.
The directory is selected interactively by typing a substring.
For details of keybindings, see `ido-find-file'."
  (interactive)
  (let ((ido-report-no-match nil)
	(ido-auto-merge-work-directories-length -1))
    (ido-file-internal 'other-window 'dired-other-window nil "Dired: " 'dir)))

(define-key craig-prefix-map "d" 'ido-dired-other-window)



(load-library "ffap")
(define-key craig-prefix-map "\C-f" 'find-file-at-point)



; ignore certain files in the list
(mapcar (lambda (x) (add-to-list 'completion-ignored-extensions x))
	'(".ctxt"
	  ".DS_Store"
	  ".dSYM/"
	  ".aux"
	  ".fdb_latexmk"
	  ".fls"
	  ".brf"
	  ".nlo"
          ".class"
	  ))





(show-paren-mode 1)

(defadvice show-paren-function
      (after show-matching-paren-offscreen activate)
      "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
      (interactive)
      (let* ((cb (char-before (point)))
             (matching-text (and cb
                                 (char-equal (char-syntax cb) ?\) )
                                 (blink-matching-open))))
        (when matching-text (message matching-text))))


(setenv "PAGER" "/bin/cat")

(setq gdb-show-main t)
;(setq gdb-many-windows t)

(setq compilation-scroll-output t)

;; (require 'sml-modeline)
;; (sml-modeline-mode 1)

;; start this asap
(if window-system
    (cd "~/")	;; assume it was launchd
  (global-font-lock-mode 0)) ;; no colors in the terminal





(setq markdown-command "multimarkdown")


;(setq-default abbrev-mode t)
(setq-default abbrev-mode nil)
(setq save-abbrevs 'silently)


;; remove nroff bindings
;; (while (rassoc 'nroff-mode auto-mode-alist)
;;   (setq auto-mode-alist (remove (rassoc 'nroff-mode auto-mode-alist)
;; 				auto-mode-alist)))

; remove only the *.1 mapping for nroff
(setq auto-mode-alist
      (remove  (assoc "\\.[1-9]\\'" auto-mode-alist) auto-mode-alist))


(autoload 'folding-mode          "folding" "Folding mode" t)
(autoload 'turn-off-folding-mode "folding" "Folding mode" t)
(autoload 'turn-on-folding-mode  "folding" "Folding mode" t)

;; ;; kill the *Compile-Log* buffer
;; (add-hook 'emacs-startup-hook
;;           (lambda ()
;;             (let ((compile-log-buffer (get-buffer "*Compile-Log*")))
;;               (when compile-log-buffer
;;                 (kill-buffer compile-log-buffer)))))


;; this keyboard macro narrows to the region defined by enclosing
;; braces, hs-hides-all and then widens
(fset 'hide-all-this-level
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217749 14 1 67108896 67108896 134217749 134217734 16 5 24 110 110 3 64 134217736 24 110 119 24 24 12] 0 "%d")) arg)))
(define-key craig-prefix-map "\C-\M-h" 'hide-all-this-level)


;; (require 'erlang-start)
;; (require 'erlang-flymake)

(set-default 'fill-column 78)



(setq save-place-file "~/.emacs.d/saved-places")
(require 'saveplace)
(autoload 'toggle-save-place "saveplace" )
(define-key craig-prefix-map "r" 'toggle-save-place)


; skip calc trail windows with next-window
(defadvice calc-trail-display (after skip-trail-window activate)
  "set the no-other-window property on calc trail windows"
  (let ((win (get-buffer-window (get-buffer "*Calc Trail*"))))
    (if win
        (set-window-parameter win
                              'no-other-window t))))



; makes saner names for buffers with same filename in diff. directories
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

; indent will not use tabs
(setq-default indent-tabs-mode nil)



;; from this point on, it may abort if packages are not set up in my standard way

;; expected packages

;; 1. imenu-anywhere
;; 2. num3-mode
;; 3. org
;; 4. vlfi
;; 5. powerline


(defun require-verbose (feature)
  (if (require feature nil 'noerror)
       'feature
     (progn
       (message (concat "could not load " (symbol-name feature)))
       nil
       )))

(setq auto-insert-alist nil)
(auto-insert-mode)


(load-library "package-load.el")

;; (require 'package)
;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/" ))
;; (package-initialize) ;; trigger elpa packages

;; imenu-anywhere
(when (require-verbose 'imenu-anywhere)
  (define-key craig-prefix-map (kbd "M-TAB") 'imenu-anywhere))

; set here since it needs to happen before org is loaded
;; (setq org-emphasis-regexp-components
;;       '(" \t('\"{" "- \t.,:!?;'\")}\\" " \t\r\n,\"'" "." 0))

(eval-after-load 'org
  '(load-library "myorg"))
(autoload 'orgstruct++-mode "org")
(autoload 'orgtbl-mode "org-table.el" "org-table mode" t)
(define-key craig-prefix-map "\C-l" 'org-store-link)
(define-key craig-prefix-map "\M-s" 'org-capture)
(define-key craig-prefix-map "\M-a" 'org-agenda)


;; deft
(when (require-verbose 'deft)
  (setq deft-directory "~/Dropbox/notes")
  (setq deft-text-mode 'org-mode)
  (setq deft-use-filename-as-title t)
  (setq deft-use-filter-string-for-filename t)
  (setq deft-file-naming-rules '((noslash . "-")
                                 (nospace . "_")
                                 (case-fn . downcase)))

  (define-key craig-prefix-map "\M-0" 'deft))


;; browse-kill-ring
(when (require-verbose 'browse-kill-ring)
  (browse-kill-ring-default-keybindings)
  (setq browse-kill-ring-quit-action 'save-and-restore))


;; vc-check-status
(when (require-verbose 'vc-check-status)
  (vc-check-status-activate 1)
  )

;; magit
(setq magit-last-seen-setup-instructions "1.4.0")
(when (require-verbose 'magit)
  (defalias 'magit 'magit-status )
  ; hide mode-line crap
  (setq magit-auto-revert-mode-lighter nil)
  )


(when (require-verbose 'ace-jump-mode)
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
  (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)
  (set-face-foreground 'ace-jump-face-foreground "black")
  (set-face-background 'ace-jump-face-foreground "wheat")
  (setq ace-jump-mode-submode-list
        '(ace-jump-char-mode
          ace-jump-word-mode
          ace-jump-line-mode
          ))
  )

(when (require-verbose 'idomenu)
;  (load-library "idomenu")
  (define-key craig-prefix-map "\M-i" 'idomenu)
  )

(when (require-verbose 'markdown-mode)
  )


(when (require-verbose 'js2-mode)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (define-key js2-mode-map "\C-m" 'newline-and-indent)
  )

;; (when (require-verbose 'js3-mode)
;;   (add-hook 'js3-mode-hook (lambda()
;;                                         ; it's nice for commas to right themselves.
;;                              (setq js3-auto-indent-p t)      
;;                                         ; don't need to push tab before typing
;;                              (setq js3-enter-indents-newline t)
;;                              (setq js3-indent-on-enter-key t)
;;                              )))



;; (setq hippie-expand-try-functions-list
;;       '(
;; 	;yas/hippie-try-expand
;;         try-expand-dabbrev
;; 	try-complete-file-name-partially
;; 	try-complete-file-name
;; 	try-expand-line
;;         try-expand-list
;; 	try-expand-line-all-buffers
;;         try-expand-list-all-buffers
;; 	try-expand-dabbrev-from-kill
;; 	;try-complete-lisp-symbol
;; 	))



(when (require-verbose 'autopair)
  (autopair-global-mode)
  (setq autopair-blink nil)
  (setq autopair-pair-criteria 'help-balance)
  (setq autopair-skip-criteria 'help-balance)
  (setq autopair-skip-whitespace t)
  ; (setq autopair-pair-criteria 'help-balance)
  ; (setq autopair-skip-criteria 'help-balance)


  (defun apair-try-expand-list (old)
    (let ((rval (try-expand-list old)))
      (if (and rval autopair-mode)
          (backward-delete-char 1))
      rval))

  (defun apair-try-expand-list-all-buffers (old)
    (let ((rval (try-expand-list-all-buffers old)))
      (if (and rval autopair-mode)
          (backward-delete-char 1))
      rval))

  (setq hippie-expand-try-functions-list
        '(try-expand-dabbrev
          apair-try-expand-list
          try-expand-line
          
          try-complete-file-name-partially
          try-complete-file-name

          try-expand-dabbrev-all-buffers
          apair-try-expand-list-all-buffers
          try-expand-line-all-buffers

          try-expand-dabbrev-from-kill)))

(when (require-verbose 'num3-mode)
  (set-face-attribute 'num3-face-even nil :underline nil :weight 'normal :background "wheat2")
  )


(when (require-verbose 'exec-path-from-shell)
     (exec-path-from-shell-initialize)
)

(when (require-verbose 'unfill)
                                        ;  (define-key craig-prefix-map "\M-q" 'toggle-fill-unfill)
  )



;; (defun ddg-search (str)
;;   (interactive "MSearch term: ")
;;   (browse-url (concat "https://duckduckgo.com/?q=" str)))

(defun ddg-search (prefix str)
  (interactive "P\nMSearch term: ")
  (let ((arg
         (if (region-active-p)
             (concat str (if prefix " \"" " ")
                     (buffer-substring (region-beginning) (region-end))
                     (if prefix "\""))
           str)))
  (browse-url (concat "https://duckduckgo.com/?q=" (url-hexify-string arg)))))

(define-key 'craig-prefix "\M-g" 'ddg-search)


(load-library "ui")

;; shell should run as a login shell (load rc)
(setq explicit-bash-args '("--noediting" "-il"))

;; do this last since it involve stuff from packages
(load-library "my-completions")


;; embarrassing protection against keyboard misfiring
(defadvice downcase-region (around downcase-only-when-active activate)
  (if (region-active-p)
      ad-do-it))

(defadvice upcase-region (around upcase-only-when-active activate)
  (if (region-active-p)
      ad-do-it))




