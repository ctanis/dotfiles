(make-face 'splatt-log-face)
(make-face 'splatt-debug-face)
(make-face 'splatt-error-face)
(defconst splatt-log-face 'splatt-log-face)
(defconst splatt-error-face 'splatt-error-face)
(defconst splatt-debug-face 'splatt-debug-face)

(defconst splatt-log-font-lock-keywords
  '(("^<<.*" . splatt-log-face)
    ("^(.*" . splatt-debug-face)
    ("ERROR.*" . splatt-error-face)
    ))

(set-face-background 'splatt-log-face "grey")
(set-face-foreground 'splatt-log-face "grey38")
(set-face-background 'splatt-error-face "red")
(set-face-foreground 'splatt-error-face "yellow")
(set-face-background 'splatt-debug-face "grey90")
(set-face-foreground 'splatt-debug-face "blue")



(define-derived-mode splatt-log-mode fundamental-mode
  "splatt-log" "Color highlighting for Splatter logs. \\{splatt-log-mode-map}"
  (setq font-lock-defaults '((splatt-log-font-lock-keywords
			      )
			     t
			     t))
  
  (toggle-truncate-lines 1)
  (auto-revert-mode)
  )

