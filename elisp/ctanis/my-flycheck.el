
(define-key craig-prefix-map "\M-f" 'flycheck-mode)
(define-key craig-prefix-map "\M-p" 'flycheck-previous-error)
(define-key craig-prefix-map "\M-n" 'flycheck-next-error)

(eval-after-load 'flycheck
  '(progn
     (flycheck-define-checker java-single
       "simple single-file checker using javac."
       :command ("javac" "-Xlint" source)
       :error-patterns
       ((error line-start (file-name) ":" line ": error:" (message) line-end))
       :modes java-mode
       )

     (add-to-list 'flycheck-checkers 'java-single))
)
