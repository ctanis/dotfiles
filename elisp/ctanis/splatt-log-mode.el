(make-face 'splatt-log-face)
(make-face 'splatt-debug-face)
(make-face 'splatt-error-face)
(make-face 'splatt-trace-face)
(defconst splatt-log-face 'splatt-log-face)
(defconst splatt-error-face 'splatt-error-face)
(defconst splatt-debug-face 'splatt-debug-face)
(defconst splatt-trace-face 'splatt-trace-face)

(defconst splatt-log-font-lock-keywords
  '(("^<<.*" . splatt-log-face)
    ("^(.*" . splatt-debug-face)
    ("ERROR.*" . splatt-error-face)
    ("^T(.*" . splatt-trace-face)
    ))

(set-face-background 'splatt-log-face "grey")
(set-face-foreground 'splatt-log-face "grey38")
(set-face-background 'splatt-error-face "red")
(set-face-foreground 'splatt-error-face "yellow")
(set-face-background 'splatt-debug-face "grey90")
(set-face-foreground 'splatt-debug-face "blue")
(set-face-background 'splatt-trace-face "yellow")
(set-face-foreground 'splatt-trace-face "blue")


(defun splatt-log-previous-trace ()
  (interactive)
  (search-backward-regexp "^T\("))

(defun splatt-log-next-trace ()
  (interactive)
  (forward-line)
  (search-forward-regexp "^T\(")
  (beginning-of-line))

(defun splatt-log-bury ()
  (interactive)
  (auto-revert-mode -1)
  (sink-buffer)
  )

(defun splatt-log-restart ()
  (interactive)
  (auto-revert-mode 1)
  )


(define-derived-mode splatt-log-mode fundamental-mode
  "splatt-log" "Color highlighting for Splatter logs. \\{splatt-log-mode-map}"
  (setq font-lock-defaults '((splatt-log-font-lock-keywords
			      )
			     t
			     t))
  
  (toggle-truncate-lines 1)
  (auto-revert-mode)
  (setq auto-revert-verbose nil)
  (setq auto-revert-interval 1)
  (auto-revert-set-timer)
  )


(define-key splatt-log-mode-map "p" 'splatt-log-previous-trace)
(define-key splatt-log-mode-map "n" 'splatt-log-next-trace)
(define-key splatt-log-mode-map "q" 'splatt-log-bury)
(define-key splatt-log-mode-map "r" 'splatt-log-restart)
(define-key splatt-log-mode-map "/" 'isearch-backward)


(provide 'splatt-log-mode)
