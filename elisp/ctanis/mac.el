;; mac stuff

;; (setq mac-option-modifier 'super)
;(setq mac-command-modifier 'meta)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'meta)



; we have to comment this or we lose meta-tick!
; use M-H (with shift) to mark paragraph
;avoid hiding with M-h
;(setq mac-pass-command-to-system nil)

; command-capital-H to hide emacs
(global-set-key "\M-H" 'ns-do-hide-emacs)

(global-set-key (quote [C-M-backspace]) 'backward-kill-sexp)
(global-set-key (quote [C-M-delete]) 'backward-kill-sexp)

;(setq latex-run-command "pdflatex")
(defvar tex-last-action nil)
(defadvice tex-file (after choose-output activate)
  (setq tex-last-action nil))
(defadvice tex-buffer (after choose-output activate)
  (setq tex-last-action 'temp))
(defadvice tex-region (after choose-output activate)
  (setq tex-last-action 'temp))
(defun fake-dvi-view()
  (interactive)
  (let ((pdffile
	 (concat (file-name-sans-extension (if tex-last-action
					       tex-last-temp-file
					       (buffer-file-name tex-last-buffer-texed)))
		 ".pdf")))
    (call-process-shell-command "open" nil nil nil pdffile)))
;; (defun fake-dvi-view()
;;   (interactive)
;;   (call-process-shell-command "open" nil nil nil (concat (file-name-sans-extension (buffer-file-name tex-last-buffer-texed)) ".pdf")))

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
  (if (equal major-mode 'dired-mode)
      (call-interactively 'launch-dired)
    (shell-command (concat os-launcher-cmd " "
			 (shell-quote-argument (buffer-file-name))))))
(define-key craig-prefix-map "\M-l" 'launch)

(eval-after-load 'dired
  '(progn
     (define-key dired-mode-map "\M-o" 'craig-prefix)
     (defun launch-dired ()
       "launch current marked files in dired buffer"
       (interactive)
;       (message "in launch-dired")
       (mapcar
        (lambda (x)
          (shell-command (concat os-launcher-cmd " " (shell-quote-argument x))))
        (dired-get-marked-files)))
     ))

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

(defun speak-region (beg end)
  (interactive "r")
  (if (get-process speak-process)
      (stop-speaking)
    (let ((buf (current-buffer))
	  (temp (make-temp-file temporary-file-directory))
	  )

      (with-temp-file temp
	(insert-buffer-substring buf beg end)
    
	(goto-char (point-min))
	(while (search-forward "
" nil t)
	  (replace-match " " nil t))

	(goto-char (point-max))
	(insert "
")
	)

      (start-process speak-process nil "say" (concat "--input-file=" temp))
      )))

(defun stop-speaking ()
  (interactive)
  (kill-process (get-process speak-process)))



;; dash stuff
(autoload 'dash-at-point "dash-at-point"
  "Search the word at point with Dash." t nil)
(define-key craig-prefix-map "\C-d" 'dash-at-point)

;; org stuff
(eval-after-load 'org
  '(progn
     (require 'org-mac-link)
     (setq org-mac-grab-Firefox-app-p nil)
     (setq org-mac-grab-Chrome-app-p nil)
     (add-hook 'org-mode-hook (lambda ()
                                (define-key org-mode-map (kbd "C-c g") 'org-mac-grab-link)))
     ))

; fix mac colors for powerline
(setq ns-use-srgb-colorspace nil)

(defun dired-quick-look()
  (interactive)
  (save-window-excursion
    (let ((max-mini-window-height 0))
      (dired-do-shell-command "qlmanage -p" nil (dired-get-marked-files))
      )))

(define-key dired-mode-map "\M-y" 'dired-quick-look)
