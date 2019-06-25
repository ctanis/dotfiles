;; i love deft mode

(setq deft-auto-save-interval 0)
(setq deft-text-mode 'org-mode)
(setq deft-default-extension "txt")
(setq deft-use-filename-as-title t)
(setq deft-use-filter-string-for-filename t)
(setq deft-file-naming-rules '((noslash . "-")
                               (nospace . "_")
                               (case-fn . downcase)))

(define-key craig-prefix-map "\M-0" 'deft)

(defvar deft-dirs '(("~/Dropbox/notes" "txt") ("~/Dropbox/work_notes" "org")))
                                        ;(rotate-deft-dirs)


(defvar deft_git_folders nil)

;; support multiple deft directories
(defun rotate-deft-dirs ()
  (interactive)
  (let ((mode (car deft-dirs)))
    (setq deft-directory (car mode))
    (setq deft-default-extension (cadr mode)))
  (setq deft-dirs (append (cdr deft-dirs) (list (car deft-dirs))))
  (if (called-interactively-p)
      (let ((deft-filter-regexp "."))
        (deft-filter-clear))
    ))
(define-key deft-mode-map (kbd "C-c [") 'rotate-deft-dirs)


;; experimental deft/git integration


(defun deft_pull_all_git()
  (interactive)
  (dolist (path deft_git_folders)
        (let ((default-directory path))
          (shell-command "git pull")
          (get-buffer "*Messages*")
          (get-buffer "*Messages*")))
  
  (call-interactively 'deft-filter-clear)
  )

(defun deft_push_all_git()
  (interactive)
  (dolist (path deft_git_folders)
        (let ((default-directory path))
          (async-shell-command
           "git add * && git commit --allow-empty-message -m '' && git push -u origin"
           (get-buffer "*Messages*")
           (get-buffer "*Messages*"))))
  )


(defun deft_quit_window()
  (interactive)
  (deft_push_all_git)
  (quit-window))


(define-key deft-mode-map (kbd "C-c C-q") 'deft_quit_window)

(add-hook 'deft-mode-hook 'deft_pull_all_git)



;; (add-hook 'deft-mode-hook
;;           (lambda ()
;;             (hl-line-mode 1)))
(add-hook 'kill-emacs-hook #'deft_push_all_git)
