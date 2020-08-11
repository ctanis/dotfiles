(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
;;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/" ) t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/" ) t)
;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/" ) t)

;; (package-initialize) ;; trigger elpa packages

;; (defun get-updatable-count ()
;;   (let (old-archives new-packages)
;;     ;; Read the locally-cached archive-contents.
;;     (package-read-all-archive-contents)
;;     (setq old-archives package-archive-contents)
;;     ;; Fetch the remote list of packages.
;;     (package-refresh-contents)
;;     ;; Find which packages are new.
;;     (dolist (elt package-archive-contents)
;;       (unless (assq (car elt) old-archives)
;;         (push (car elt) new-packages)))
;;     (let ((buf (get-buffer-create "*Packages*")))
;;       (with-current-buffer buf
;;         (with-current-buffer buf
;;           (package-menu-mode)
;;           (set (make-local-variable 'package-menu--new-package-list)
;;                new-packages)
;;           (package-menu--generate nil t)))))
;;   (with-current-buffer "*Packages*"
;;     (let ((lst (package-menu--find-upgrades)))
;;       (print (apply 'concat
;;                     (append 
;;                      (list (format "%d packages can be updated:\n" (length lst)))
;;                      (mapcar
;;                       (lambda (s) (format "%s\n" (car s)))
;;                       lst)))))))


