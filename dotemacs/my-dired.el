;; dired customizations

(setq dired-deletion-confirmer 'y-or-n-p)
; dired - guess destination when 2 dired windows are visible
(setq dired-dwim-target nil)
(defun dired-do-copy-other-window ()
       (interactive)
       (let ((dired-dwim-target t))
         (call-interactively 'dired-do-copy)))

(defun dired-do-rename-other-window ()
  (interactive)
  (let ((dired-dwim-target t))
    (call-interactively 'dired-do-rename)))

(defun dired-do-symlink-other-window ()
  (interactive)
  (let ((dired-dwim-target t))
    (call-interactively 'dired-do-symlink)))

(defun dired-hide-dotfiles()
  "reload current dired buffer, hiding dotfiles"
  (interactive)
  (dired-unmark-all-marks)
  (dired-mark-files-regexp "^\\.")
  (dired-do-kill-lines))


(put 'dired-do-copy-other-window 'ido 'ignore)
(put 'dired-do-rename-other-window 'ido 'ignore)
(put 'dired-do-symlink-other-window 'ido 'ignore)
(put 'dired-do-symlink 'ido 'ignore)
(put 'dired-create-directory 'ido 'ignore)

(define-key dired-mode-map "\C-cc" 'dired-do-copy-other-window)
(define-key dired-mode-map "\C-cr" 'dired-do-rename-other-window)
(define-key dired-mode-map "\C-cs" 'dired-do-symlink-other-window)


(add-hook 'dired-mode-hook
	  '(lambda ()
	     (toggle-truncate-lines 1)
             (local-set-key "h" 'dired-hide-dotfiles)
	     (local-set-key "\C-c\C-q" 'wdired-change-to-wdired-mode)
	     ))


(put 'dired-find-alternate-file 'disabled nil)
; don't use ls for dired -- use elisp
(setq ls-lisp-use-insert-directory-program nil)
(require 'ls-lisp)


(define-key dired-mode-map "\M-o" 'craig-prefix)
(defun launch-dired ()
  "launch current marked files in dired buffer"
  (interactive)
                                        ;       (message "in launch-dired")
  (mapcar
   (lambda (x)
     (shell-command (concat os-launcher-cmd " " (shell-quote-argument x))))
   (dired-get-marked-files)))
