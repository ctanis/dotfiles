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

(defun dired-mark-files-not-matching-regexp (regexp &optional marker-char include-dirs)
  (interactive
   (list (read-regexp (concat (if current-prefix-arg "Unmark" "Mark")
                              " files (regexp): ")
                      ;; Add more suggestions into the default list
                      (cons nil (list (dired-get-filename t t)
                                      (and (dired-get-filename nil t)
                                           (concat (regexp-quote
                                                    (file-name-extension
                                                     (dired-get-filename nil t) t))
                                                   "\\'"))))
                      'dired-regexp-history)
	 (if current-prefix-arg ?\s)))

  (let ((dired-marker-char (or marker-char dired-marker-char)))
    (dired-mark-if
     (and (not (looking-at-p dired-re-dot))
	  (not (eolp))			; empty line
	  (let ((fn (dired-get-filename t t)))
            (and fn
                 (or  include-dirs (not (file-directory-p fn)))
                 (not (string-match-p regexp fn)))))
     "matching file")))


(put 'dired-do-copy-other-window 'ido 'ignore)
(put 'dired-do-rename-other-window 'ido 'ignore)
(put 'dired-do-symlink-other-window 'ido 'ignore)
(put 'dired-do-symlink 'ido 'ignore)
(put 'dired-create-directory 'ido 'ignore)

(define-key dired-mode-map "\C-cc" 'dired-do-copy-other-window)
(define-key dired-mode-map "\C-cr" 'dired-do-rename-other-window)
(define-key dired-mode-map "\C-cs" 'dired-do-symlink-other-window)


(add-hook 'dired-mode-hook
	  #'(lambda ()
	      (toggle-truncate-lines 1)
              (local-set-key "h" 'dired-hide-dotfiles)
	      (local-set-key "\C-c\C-q" 'wdired-change-to-wdired-mode)
	      ))


(put 'dired-find-alternate-file 'disabled nil)
; don't use ls for dired -- use elisp
;; (setq ls-lisp-use-insert-directory-program nil)
;; (require 'ls-lisp)


(define-key dired-mode-map "\M-o" 'craig-prefix)
(defun launch-dired ()
  "launch current marked files in dired buffer"
  (interactive)
                                        ;       (message "in launch-dired")
  (mapcar
   (lambda (x)
     (shell-command (concat os-launcher-cmd " " (shell-quote-argument x))))
   (dired-get-marked-files)))


(defun cleanup-org-dir ()
  "mark all files that are not org-related, subdirectories or dotfiles for deletion"
  (interactive)
  (dired-mark-files-not-matching-regexp
   "^\\(data\\|\\..*\\|.*\\.org\\|.*\\.org_archive\\)$" ?D))
