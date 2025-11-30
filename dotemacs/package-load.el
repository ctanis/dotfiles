;; this is only used on certain machines, and when it's used there's a high
;; likelihood that the default is using a bad trusted certificates file
(setq tls-program '("gnutls-cli -p %p %h"))

(when (eql system-type 'darwin)
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))


(package-initialize)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))


(defun require-verbose (feature)
  (if (require feature nil 'noerror)
       'feature
     (progn
       (message (concat "could not load " (symbol-name feature)))
       nil
       )))

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


