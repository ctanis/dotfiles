
;; experimental verbal doctor

;; (defvar *doctor-speak* t)
;; (defun *doctor-speak-func* (msg)
;;   (shell-command (string-append "say " msg)))


;; (defun doctor-txtype (ans)
;;   "Output to buffer a list of symbols or strings as a sentence."
;;   (setq *print-upcase* t *print-space* nil)
;;   (mapc 'doctor-type-symbol ans)
  

;;   (insert "\n")

;;   (if *doctor-speak*
;;       (*doctor-speak-func*
;;        (apply 'string-append
;; 	      (mapcar (lambda(a)
;; 			(string-append (doctor-make-string a) " "))
;; 		      ans))))

;;   )





