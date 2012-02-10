;; mac stuff

(setq mac-command-modifier 'meta)


; we have to comment this or we lose meta-tick!
; use M-H (with shift) to mark paragraph
;avoid hiding with M-h
;(setq mac-pass-command-to-system nil)

(global-set-key (quote [C-M-backspace]) 'backward-kill-sexp)
(global-set-key (quote [C-M-delete]) 'backward-kill-sexp)

(setq latex-run-command "pdflatex")
(defun fake-dvi-view()
  (interactive)
  (call-process-shell-command "open" nil nil nil (concat (file-name-sans-extension (buffer-file-name tex-last-buffer-texed)) ".pdf")))

(add-hook 'latex-mode-hook
	  '(lambda ()
	     (local-set-key "\C-c\C-v" 'fake-dvi-view)))
      

; xcode stuff
(load-library "xcode")

; need this in case xcode invoked us
(cd "~/")


;(add-to-list 'popper-no-pop-buffers "*Completions*")

(setq sql-sqlite-program "sqlite3")
(setq-default ispell-program-name "aspell")


(defun open-in-finder ()
  (interactive)
  (shell-command "open ."))
(define-key craig-prefix-map "\M-w" 'open-in-finder)



(defun dirshell ()
  "launch a Terminal.app in the current directory"
  (interactive)
  (shell-command "term \"`pwd`\""))
(define-key craig-prefix-map "\M-s" 'dirshell)


;; some stuff for dealing with Dash.app
(define-derived-mode dash-snippet-mode fundamental-mode
  "enter dash snippet here"
  )

(define-key dash-snippet-mode-map "\M-v" 'yank)
(define-key dash-snippet-mode-map "\C-c\C-c" 'returntosender)

(defvar dash-snippet-mode-return-buffer nil)

(defun returntosender()
  (interactive)
  ; kill whole buffer
  (kill-region (buffer-end -1) (buffer-end 1))
  (switch-to-buffer dash-snippet-mode-return-buffer)
  (yank))

(defun dash-snippet-get ()
  (interactive)
  (setq dash-snippet-mode-return-buffer (buffer-name))
  (switch-to-buffer "*dash-snippet-buffer*")
  (delete-region (buffer-end -1) (buffer-end 1))
  (dash-snippet-mode))

(define-key craig-prefix-map "x" 'dash-snippet-get)
