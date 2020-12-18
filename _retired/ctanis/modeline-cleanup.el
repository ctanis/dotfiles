; http://www.masteringemacs.org/articles/2012/09/10/hiding-replacing-modeline-strings/

(defvar mode-line-cleaner-alist
  `(
    (autopair-mode . "Θ")
    (abbrev-mode . "α")
    (company-mode . "¢")
    (yas-minor-mode . " Υ")
    (org-indent-mode . "⇥")
    (orgtbl-mode . "#")
    (orgstruct-mode . "⧇")
    (cwarn-mode . "w")
    (hs-minor-mode . "Σ")
    (folding-mode . "F")
    (eldoc-mode . "")
    )
  "Alist for `clean-mode-line'.
 
When you add a new element to the alist, keep in mind that you
must pass the correct minor/major mode symbol and a string you
want to use in the modeline *in lieu of* the original.")
 
 
(require 'cl-lib)
(defun clean-mode-line ()
  (interactive)
  ;; put a whitespace
  (if (and (stringp mode-name)
	   (not (string= (substring mode-name -1) " ")))
      ;;(setq mode-name2 (string-append mode-name " "))
      nil
    )
  (cl-loop for cleaner in mode-line-cleaner-alist
           do (let* ((mode (car cleaner))
                     (mode-str (cdr cleaner))
                     (old-mode-str (cdr (assq mode minor-mode-alist))))
		(when old-mode-str
                  (setcar old-mode-str mode-str))
		;; major mode
		(when (eq mode major-mode)
		  (setq mode-name mode-str)))))
 
 
(add-hook 'after-change-major-mode-hook 'clean-mode-line)

;; (add-hook 'after-init-hook
;;           '(lambda())
;;           (add-hook 'after-insert-file-functions 'clean-mode-line))
 
(setq flycheck-mode-line-prefix "Φ")
