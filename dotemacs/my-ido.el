(require 'ido)
;; ------------ ido stuff
(setq ido-enable-flex-matching t)

;; obviated for ido-ubiquitous-mode (below)
;;(setq ido-everywhere t)

;; auto-merge
(setq ido-auto-merge-delay-time 0)
(setq ido-auto-merge-work-directories-length 0)
(setq ido-merge-ftp-work-directories nil) ; see ido-merge-remote below

(setq ido-use-filename-at-point nil)
(setq ido-default-buffer-method 'selected-window)
(setq ido-use-virtual-buffers nil)

(setq ido-enable-regexp nil) ;; toggle it if you want it
(setq ido-enable-prefix nil) ;; toggle it if you want it
 
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
  (setq ido-work-directory-list
        (seq-filter (lambda (s) (not (string-match "^/.*:.*:" s))) ido-work-directory-list))
  )


(define-key craig-prefix-map "d" 'ido-dired-other-window)


; clean up ido-work-dirs
(defun remove-ido-work-dirs (match)
  (interactive "MRemove work directories matching: ")
  (setq ido-work-directory-list
	(seq-filter '(lambda(c) (not
			     (string-match (concat "^.*" match) c)))
		ido-work-directory-list)))


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
    (ido-init-completion-maps)
    (add-hook 'minibuffer-setup-hook 'ido-minibuffer-setup)
    (add-hook 'choose-completion-string-functions 'ido-choose-completion-string)
    (add-hook 'kill-emacs-hook 'ido-kill-emacs-hook)
    ;; set up ido completion list
    (let ((index-alist (imenu--make-index-alist))) ;; package takes cdr for some reason..
      (if (equal index-alist '(nil))
          (message "No imenu tags in buffer")
        (imenu (idomenu--read (idomenu--trim-alist index-alist) nil t)))))

  )

(defun ido-magic-slash ()
  (interactive)
  (setq ido-auto-merge-delay-time 999)
  (call-interactively 'self-insert-command))
(define-key ido-file-dir-completion-map "/" 'ido-magic-slash)

(defadvice ido-merge-work-directories (before reset-timers activate)
  (setq ido-auto-merge-delay-time 0))


(ido-mode 1)