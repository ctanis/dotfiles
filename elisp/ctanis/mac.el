;; mac stuff

(setq mac-option-modifier 'none)
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
;(load-library "xcode")
(autoload 'xcode-mode "xcode" "xcode minor mode" t)


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
(define-key craig-prefix-map "\C-s" 'dirshell)


(defvar os-launcher-cmd "open")

(defun launch ()
  "launch current file with OS"
  (interactive)
  (shell-command (concat os-launcher-cmd " "
			 (shell-quote-argument (buffer-file-name)))))
(define-key craig-prefix-map "\M-l" 'launch)

(require 'dired)
(defun launch-dired ()
  "launch current marked files in dired buffer"
  (interactive)
  (mapcar
   (lambda (x)
     (shell-command (concat os-launcher-cmd " " (shell-quote-argument x))))
   (dired-get-marked-files)))

(add-hook 'dired-mode-hook
	   '(lambda ()
	      (local-set-key "\M-o\M-l" 'launch-dired)))


;; ;; some stuff for dealing with Dash.app
;; (define-derived-mode dash-snippet-mode fundamental-mode
;;   "enter dash snippet here"
;;   )



;; (defvar dash-snippet-mode-return-buffer nil)
;; (defvar dash-snippet-mode-win-config nil)

;; (defun dash-snippet-returntosender()
;;   (interactive)
;;   ; kill whole buffer
;;   (yank)
;;   (let ((offset (- (buffer-end 1) (point))))
;;     (kill-region (buffer-end -1) (buffer-end 1))
;;     (kill-buffer-and-window)
;;     (switch-to-buffer dash-snippet-mode-return-buffer)
;;     (yank)
;;     (backward-char offset)
;;     (set-window-configuration dash-snippet-mode-win-config)
;;     ))

;; (defun dash-snippet-abort()
;;   (interactive)
;;   ; kill whole buffer
;;   (kill-buffer-and-window)
;;   (set-window-configuration dash-snippet-mode-win-config)
;;   (switch-to-buffer dash-snippet-mode-return-buffer)
;;   )


;; (defun dash-snippet-get ()
;;   (interactive)
;;   (setq dash-snippet-mode-return-buffer (buffer-name))
;;   (setq dash-snippet-mode-win-config (current-window-configuration))
;;   (switch-to-buffer-other-window "*dash-snippet-buffer*")
;;   (delete-region (buffer-end -1) (buffer-end 1))
;;   (shrink-window-if-larger-than-buffer)
;;   (dash-snippet-mode))

;; (define-key dash-snippet-mode-map "\C-c\C-c" 'dash-snippet-abort)
;; (define-key dash-snippet-mode-map "\M-v" 'dash-snippet-returntosender)
;; (define-key dash-snippet-mode-map "\C-y" 'dash-snippet-returntosender)
;; ;(define-key craig-prefix-map "x" 'dash-snippet-get)


(defvar speak-process "speech")
(defvar speak-buffer "*speech*")
;; (defun speak-region (beg end)
;;   (interactive "r")
;;   (let ((proc (or (get-process speak-process)
;; 		  (start-process speak-process "*speech*" "say")
;; 		  )))
;;     (send-region proc beg end)))

(defun speak-region (beg end)
  (interactive "r")
  (let ((proc (or (get-process speak-process)
		  (start-process speak-process speak-buffer "say")
		  ))
	(buf (current-buffer))
	)

    (set-buffer speak-buffer)
    (delete-region (point-min) (point-max))
    (insert-buffer-substring buf beg end)
    
    (goto-char (point-min))
    (while (search-forward "
" nil t)
      (replace-match " " nil t))

    (goto-char (point-max))
    (insert "
")
    (process-send-region proc (point-min) (point-max))
    (process-send-eof proc)
    ))

(defun stop-speaking ()
  (interactive)
  (kill-process speak-process)
;  (kill-buffer speak-buffer)
  )
