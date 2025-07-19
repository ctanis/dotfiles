(require 'ido)
;; ------------ ido stuff
(setq ido-enable-flex-matching t)

;; obviated for ido-ubiquitous-mode (below)
;;(setq ido-everywhere t)

(setq ido-use-filename-at-point nil)
(setq ido-default-buffer-method 'selected-window)
(setq ido-use-virtual-buffers nil)

(setq ido-enable-regexp nil) ;; toggle it if you want it
(setq ido-enable-prefix nil) ;; toggle it if you don't want it
;;(setq ido-enable-tramp-completion nil) ;; overwrite in a .emacs-local for appropariate systems
 
(add-to-list 'ido-ignore-files "`\\.") ;; no dotfiles
(add-to-list 'ido-ignore-files "\\.webloc")
(add-to-list 'ido-ignore-files "\\.pdf")
(add-to-list 'ido-ignore-files "\\.mp.")
(add-to-list 'ido-ignore-files "\\.[0-9]+$") ;; no files with numeric extensions

(setq imenu-auto-rescan t)

(setq ido-file-extensions-order '(".org" ".html" ".tex" ".log"))

;; redefinition of this to respect file extensions
;; see ido-file-extensions-order if I ever care about this again...

;; (defun ido-sort-merged-list (items promote)
;;   ;; Input is list of ("file" . "dir") cons cells.
;;   ;; Output is sorted list of ("file "dir" ...) lists
;;   (let ((l (sort items (lambda (a b) (ido-file-extension-lessp (car b) (car a)))))
;; 	res a cur)
;;     (while l
;;       (setq a (car l)
;; 	    l (cdr l))
;;       (if (and res (string-equal (car (car res)) (car a)))
;; 	  (progn
;; 	    (setcdr (car (if cur (cdr res) res)) (cons (cdr a) (cdr (car res))))
;; 	    (if (and promote (string-equal ido-current-directory (cdr a)))
;; 		(setq cur t)))
;; 	(setq res (cons (list (car a) (cdr a)) res)
;; 	      cur nil)))
;;     res))



(defun ido-toggle-merge-remote ()
  ;; toggle merging remote directories
  (interactive)
  (setq ido-use-merged-list t ido-try-merged-list t)
  (setq ido-exit 'refresh)
  (setq ido-text-init ido-text)
  (setq ido-rotate-temp t)
  (setq ido-merge-ftp-work-directories (not ido-merge-ftp-work-directories))
  (exit-minibuffer)
  )
(define-key ido-file-dir-completion-map [(meta control ?s)] 'ido-toggle-merge-remote)

(defun purge-ido-tramp ()
  (interactive)
  (setq ido-dir-file-cache
        (seq-filter (lambda (s) (not (string-match "^/.*:.*:" s))) ido-work-directory-list))
  (setq ido-work-directory-list
        (seq-filter (lambda (s) (not (string-match "^/.*:.*:" s))) ido-work-directory-list))
  )

; clean up ido-work-dirs
(defun cleanup-ido(str)
  (interactive "MRemove work directories matching: ")
  (setq ido-work-directory-list
        (seq-filter (lambda (s) (not (string-match str s)))
                    ido-work-directory-list)))


(defun ido-kill-emacs-hook ()
;  (purge-ido-tramp)
  (ido-save-history))


(define-key craig-prefix-map "d" 'ido-dired-other-window)



(when (require-verbose 'ido-completing-read+)
  (ido-ubiquitous-mode 1)
  (add-to-list 'ido-cr+-function-blacklist 'org-refile-fullpath)
  (add-to-list 'ido-cr+-function-blacklist 'org-agenda-refile-fullpath)
  (add-to-list 'ido-cr+-function-blacklist 'execute-extended-command)
  (add-to-list 'ido-cr+-function-blacklist 'describe-function)
  (add-to-list 'ido-cr+-function-blacklist 'describe-variable)
  )

(when (require-verbose 'idomenu)
  (define-key craig-prefix-map "\M-i" 'idomenu)

  (defun idomenu ()
    "Switch to a buffer-local tag from Imenu via Ido."
    (interactive)
    ;; ido initialization
    ;; (ido-init-completion-maps)
    ;; (add-hook 'minibuffer-setup-hook 'ido-minibuffer-setup)
    ;; (add-hook 'choose-completion-string-functions 'ido-choose-completion-string)
    ;; (add-hook 'kill-emacs-hook 'ido-kill-emacs-hook)
    ;; set up ido completion list
    (let ((index-alist (imenu--make-index-alist))) ;; package takes cdr for some reason..
      (if (equal index-alist '(nil))
          (message "No imenu tags in buffer")
        (imenu (idomenu--read (idomenu--trim-alist index-alist) nil t)))))

  )

;; auto-merge
(setq ido-auto-merge-delay-time 0)
(setq ido-auto-merge-work-directories-length 0)
(setq ido-merge-ftp-work-directories nil) ; see ido-merge-remote below


;; disable auto merge as soon as a specific folder is hinted at (via slash)
(setq ctanis-dflt-ido-merge-time 0.7)
(defun ido-magic-slash ()
  (interactive)
  (setq ido-auto-merge-delay-time 9999)
  (call-interactively 'self-insert-command))
(define-key ido-file-dir-completion-map "/" 'ido-magic-slash)

(defadvice ido-find-file (before reset-timers activate)
  (setq ido-auto-merge-delay-time ctanis-dflt-ido-merge-time))
(defadvice ido-find-file-other-window (before reset-timers activate)
  (setq ido-auto-merge-delay-time ctanis-dflt-ido-merge-time))
(defadvice ido-merge-work-directories (before reset-timers activate)
  (setq ido-auto-merge-delay-time ctanis-dflt-ido-merge-time))

(setq ido-show-dot-for-dired t)


(defun crt-ido-record-current-file ( &optional ignore)
  (if (buffer-file-name)
      (progn
        (ido-record-work-file (file-name-nondirectory (buffer-file-name)))
        (ido-record-work-directory (file-name-directory (buffer-file-name))))))

(advice-add 'dired-find-file :after #'crt-ido-record-current-file)



(ido-mode 1)

;; function.el
(defun better-display-buffer(arg)
  "a better display buffer"
  (interactive (list (ido-read-buffer "Buffer: ")))
  (let ((b (current-buffer)))
    (switch-to-buffer-other-window arg)
    (switch-to-buffer-other-window b)))

;; hooks
(add-hook 'ibuffer-mode-hook
	  #'(lambda ()
	      (local-set-key "\C-x\C-f" 'ido-find-file)))


(add-hook 'ido-minibuffer-setup-hook
	  #'(lambda()
	      (define-key ido-file-completion-map "\C-t" 'transpose-chars)
	      (define-key ido-buffer-completion-map "\C-t" 'transpose-chars)
	      (define-key ido-file-dir-completion-map "\C-t" 'transpose-chars)

	      (define-key ido-file-completion-map "\M-t" 'ido-toggle-regexp)
	      (define-key ido-buffer-completion-map "\M-t" 'ido-toggle-regexp)
	      (define-key ido-file-dir-completion-map "\M-t" 'ido-toggle-regexp)


	      (define-key ido-file-completion-map "\M-b" 'backward-word)
	      (define-key ido-buffer-completion-map "\M-b" 'backward-word)
	      (define-key ido-file-dir-completion-map "\M-b" 'backward-word)
	      (define-key ido-file-completion-map "\M-f" 'forward-word)
	      (define-key ido-buffer-completion-map "\M-f" 'forward-word)
	      (define-key ido-file-dir-completion-map "\M-f" 'forward-word)

	      (define-key ido-buffer-completion-map "\M-s" 'ido-enter-find-file)
	      (local-unset-key "\M-r")
              ))

(eval-after-load "hideshow"
  #'(progn
      (defadvice idomenu (after expand-after-goto-line
			        activate compile)
        "hideshow-expand affected subroutine when using idomenu"
        (if hs-block-start-regexp
	    (save-excursion
	      (search-forward-regexp hs-block-start-regexp)
	      (hs-show-block))))

      (defadvice imenu-anywhere (after expand-after-goto-line
				       activate compile)
        "hideshow-expand affected subroutine when using idomenu"
        (if hs-block-start-regexp
	    (save-excursion
	      (search-forward-regexp hs-block-start-regexp)
	      (hs-show-block))))
      ))



;; my-completions
(setq yas-prompt-functions (list 'yas-ido-prompt))


;; dired.el
(put 'dired-do-copy-other-window 'ido 'ignore)
(put 'dired-do-rename-other-window 'ido 'ignore)
(put 'dired-do-symlink-other-window 'ido 'ignore)
(put 'dired-do-symlink 'ido 'ignore)
(put 'dired-create-directory 'ido 'ignore)

