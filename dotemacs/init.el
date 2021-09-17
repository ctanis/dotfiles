(load-library "package-load")
(load-library "functions")
(load-library "hooks")
(load-library "modeline-cleanup")
(define-prefix-command 'craig-prefix 'craig-prefix-map)

;; startup
(setq inhibit-default-init t)
(setq inhibit-startup-message t)               
(setq initial-scratch-message "") ;; was nil, but this broke immortal-scratch

;; enable functionality
(put 'eval-expression 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'scroll-left 'disabled nil)
(setq enable-local-eval 'query)

;; editing interface
(column-number-mode t)
(line-number-mode t)
(global-font-lock-mode t)

(setq visible-bell nil
      ring-bell-function 'flash-mode-line)

(setq-default search-highlight t)
(setq next-line-add-newlines nil)
(setq require-final-newline nil)
(setq split-width-threshold nil)
(setq scroll-preserve-screen-position t) ;; nicer screen scrolling
(setq line-move-visual t)
(set-default 'fill-column 78)
(setq-default indent-tabs-mode nil)
(show-paren-mode 1)


(if window-system
    (progn
      (menu-bar-mode nil)
      (tool-bar-mode -1)
      (auto-image-file-mode 1)))

;; behaviors
(defalias 'yes-or-no-p 'y-or-n-p)
(setq dabbrev-case-fold-search nil) ;; expansions always respect case
(setq vc-make-backup-files t) ;; backup as normal
(setq vc-follow-symlinks t) ;; transparently follow
(transient-mark-mode 0)
(setq set-mark-command-repeat-pop t) ;; c-spc after C-u C-spc pops
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

; skip calc trail windows with next-window
(defadvice calc-trail-display (after skip-trail-window activate)
  "set the no-other-window property on calc trail windows"
  (let ((win (get-buffer-window (get-buffer "*Calc Trail*"))))
    (if win
        (set-window-parameter win
                              'no-other-window t))))


;; comint
(setq comint-move-point-for-matching-input 'end-of-line)
(setq comint-input-ring-size 2000) ;; see matching length in bash_profile

;; minibuffers
(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)


;; ibuffer
(defalias 'list-buffers 'ibuffer)
(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-expert t)


(autoload 'find-file-at-point "ffap" "find file at point"  t)
(autoload 'folding-mode          "folding" "Folding mode" t)
(autoload 'turn-off-folding-mode "folding" "Folding mode" t)
(autoload 'turn-on-folding-mode  "folding" "Folding mode" t)
(autoload 'hs-toggle-hiding "hideshow" "Hideshow mode" t)
(autoload 'grow-buffer-mode "grow-buffer" "grow-buffer mode" t)


(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(load-library "my-ido")


;; mode customizations
(eval-after-load 'dired
  '(load-library "my-dired"))

(autoload 'org-agenda "org")
(autoload 'org-capture "org")
(autoload 'org-store-link "org")
(eval-after-load 'org
  '(load-library "my-org"))
(define-key craig-prefix-map "\C-l" 'org-store-link)
(define-key craig-prefix-map "\M-s" 'org-capture)
(define-key craig-prefix-map "\M-a" 'org-agenda)



;; multiple cursors
(load-library "my-mc")
(define-key craig-prefix-map "\M-." (make-sparse-keymap))
(define-key craig-prefix-map "\M-.\M-j" 'ace-mc-add-multiple-cursors)
(define-key craig-prefix-map "\M-.\M-l" 'mc/edit-lines)
(define-key craig-prefix-map "\M-.\M-." 'mc/mark-more-like-this-extended)

;; (autoload 'ace-mc-add-multiple-cursors "my-mc")
;; (autoload 'mc/edit-lines "my-mc")
;; (autoload 'mc/mark-more-like-this-extended "my-mc")
;; (eval-after-load 'multiple-cursors
;;   '(load-library "my-mc"))

(eval-after-load 'deft
  '(load-library "my-deft"))

(eval-after-load 'rect
  '(define-key rectangle-mark-mode-map (kbd "M-.") 'mc/rect-rectangle-to-multiple-cursors))


;; mode associations
(setq auto-mode-alist
      (remove  (assoc "\\.[1-9]\\'" auto-mode-alist) auto-mode-alist))

;; ignore certain files in the list
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



;; system interactions
(setq grep-command "egrep -ni ")

(eval-after-load 'tramp
  '(add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(when (require-verbose 'exec-path-from-shell)
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize)
  )

(defvar os-launcher-cmd "open")


(defun reveal-in-os ()
  "reveal current file in appropriate browser"
  (interactive)
  (shell-command (concat os-launcher-cmd " .")))

(defun launch (p)
  "launch current file with OS. With prefix-arg, reveal"
  (interactive "p")
  (if (> p 1) (reveal-in-os)
    (if (equal major-mode 'dired-mode)
        (call-interactively 'launch-dired)
      (shell-command (concat os-launcher-cmd " "
			     (shell-quote-argument (buffer-file-name)))))))

(define-key craig-prefix-map "\M-l" 'launch)


;; electric pairs
(electric-pair-mode)
(add-to-list 'minor-mode-alist (list 'electric-pair-mode "Θ"))

(defvar ctanis_epair_ws (cons 0 (string-to-list " )\t\n")))
;; no auto-pair unless we're at the end of the line
(defun ctanis_electric_pair_inhibitor (char)
  (or
   (eq char (char-after))
   ;; (eq (char-syntax (following-char)) ?w)
   ;; (eq (char-syntax (following-char)) ?\()
   (not (member (following-char) ctanis_epair_ws))
   ;; don't add a second quote if this insertion closed a string
   (and (eq char ?\") (save-excursion (backward-char 1) (nth 3 (syntax-ppss))))
   (electric-pair-default-inhibit char)
   ))

(setq electric-pair-inhibit-predicate 'ctanis_electric_pair_inhibitor)

;; don't skip newlines when closing delimiters
(setq electric-pair-skip-whitespace-chars '(9 32))
;(setq electric-pair-skip-self t)

(defun apair-try-expand-list (old)
  (let ((rval (try-expand-list old)))
    (if (and rval electric-pair-mode)
        (backward-delete-char 1))
    rval))

(defun apair-try-expand-list-all-buffers (old)
  (let ((rval (try-expand-list-all-buffers old)))
    (if (and rval electric-pair-mode)
        (backward-delete-char 1))
    rval))




;; tramp
(eval-after-load 'tramp
  '(add-to-list 'tramp-remote-path 'tramp-own-remote-path))
(setq enable-remote-dir-locals t)

;; more optional packages
(when (require-verbose 'operate-on-number)

  (define-key craig-prefix-map "+" 'apply-operation-to-number-at-point)
  (define-key craig-prefix-map "-" 'apply-operation-to-number-at-point)
  (define-key craig-prefix-map "*" 'apply-operation-to-number-at-point)
  (define-key craig-prefix-map "/" 'apply-operation-to-number-at-point)
  (define-key craig-prefix-map "\\" 'apply-operation-to-number-at-point)
  (define-key craig-prefix-map "^" 'apply-operation-to-number-at-point)
;;  (define-key craig-prefix-map "<" 'apply-operation-to-number-at-point)
;;  (define-key craig-prefix-map ">" 'apply-operation-to-number-at-point)
;; these don't work great
;;  (define-key craig-prefix-map "#" 'apply-operation-to-number-at-point)
;;  (define-key craig-prefix-map "%" 'apply-operation-to-number-at-point)
  (define-key craig-prefix-map "'" 'operate-on-number-at-point)
  )

(when (require-verbose 'num3-mode)
  (set-face-attribute 'num3-face-even nil :underline nil :weight 'normal :background "wheat2")
  )

(when (require-verbose 'itail)
  (defalias 'tail-file 'itail))

(when (require-verbose 'immortal-scratch)
  (immortal-scratch-mode))

(when (require-verbose 'dictionary)
  (define-key craig-prefix-map "\C-\M-w" 'dictionary-lookup-definition))




(when (require-verbose 'browse-kill-ring)
  (browse-kill-ring-default-keybindings))

;; advice
;; embarrassing protection against keyboard misfiring
(defadvice downcase-region (around downcase-only-when-active activate)
  (if (region-active-p)
      ad-do-it))

(defadvice upcase-region (around upcase-only-when-active activate)
  (if (region-active-p)
      ad-do-it))


(load-library "coding")
(load-library "my-completions")
(load-library "my-keys")
(load-library "ui")

;; grep-related
(defun find-grep-dispatch (prefix)
  (interactive "P")
  (require 'find-dired)
  ;; default to case-insensitive
  (let ((find-grep-options (if prefix
                               find-grep-options
                             "-qi" )))
    (call-interactively 'find-grep-dired)))

(defun tail-dispatch ()
  (interactive)
  (if (eq major-mode 'dired-mode)
      (tail-file (dired-get-file-for-visit))
    (call-interactively 'tail-file)))


(define-prefix-command 'search-dispatch 'search-dispatch-map)
(define-key craig-prefix-map "\M-g" 'search-dispatch)
(define-key 'search-dispatch "\M-g" 'grep)
(define-key 'search-dispatch "d" 'find-dired)
(define-key 'search-dispatch "f" 'find-grep-dispatch)
(define-key 'search-dispatch "b" 'ddg-search)
(define-key 'search-dispatch "e" 'ediff-buffers)
(define-key 'search-dispatch "t" 'tail-dispatch)


(when (require-verbose 'ace-jump-mode)
  ;;(define-key craig-prefix-map "j" 'ace-jump-mode)
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
  (define-key global-map (kbd "M-J") 'ace-jump-mode)
  ;;(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)
  (setq ace-jump-mode-move-keys (loop for i from ?a to ?z collect i))
  (set-face-foreground 'ace-jump-face-foreground "black")
  (set-face-background 'ace-jump-face-foreground "wheat")
  (setq ace-jump-mode-submode-list
        '(ace-jump-char-mode
          ace-jump-word-mode
          ace-jump-line-mode
          ))

  (when (require-verbose 'ace-window)
    (define-key global-map (kbd "C-x M-o") 'ace-window)
    ;(define-key craig-prefix-map "\M-o" 'aw-flip-window)
    ))


(when (require-verbose 'bash-completion)
  (bash-completion-setup))
