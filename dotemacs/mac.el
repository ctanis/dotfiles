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

(setq latex-run-command "pdflatex")
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
    ;;(call-process-shell-command "open" nil nil nil pdffile)
    (shell-command (concat os-launcher-cmd " "
                           (shell-quote-argument pdffile)))))
;; (defun fake-dvi-view()
;;   (interactive)
;;   (call-process-shell-command "open" nil nil nil (concat (file-name-sans-extension (buffer-file-name tex-last-buffer-texed)) ".pdf")))

(add-hook 'latex-mode-hook
	  #'(lambda ()
	      (local-set-key "\C-c\C-v" 'fake-dvi-view)))
      

; xcode stuff
;(load-library "xcode")
(autoload 'xcode-mode "xcode" "xcode minor mode" t)


(setq sql-sqlite-program "sqlite3")
(setq-default ispell-program-name "aspell")


(defun dirshell ()
  "launch a Terminal.app in the current directory"
  (interactive)
  ;(shell-command "term \"`pwd`\"")
  (shell-command "open -a iterm \"`pwd`\"")
  )
;;(define-key craig-prefix-map "\C-s" 'dirshell)
(define-key craig-prefix-map "\C-x!" 'dirshell)






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
     (setq org-mac-grab-devonthink-app-p nil)
     (setq org-mac-grab-Brave-app-p nil)
     ;; (setq org-mac-grab-Firefox-app-p nil)
     ;; (setq org-mac-grab-Chrome-app-p nil)
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

(eval-after-load 'dired
    '(define-key dired-mode-map "\M-y" 'dired-quick-look))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . nil))

;; org sort hack Sat Jun 28 18:44:40 2025
;; collate not working on laptop
(defun ctanis/collation-simplify (s)
  "Return a simplified version of string S for naive collation.
Handles ligatures, strips diacritics, and downcases."
  (let* ((s (replace-regexp-in-string "[Ææ]" "ae" s))
         (s (replace-regexp-in-string "[Œœ]" "oe" s))
         (s (ucs-normalize-NFD-string s)) ; Canonical decomposition
         (s (replace-regexp-in-string "[\u0300-\u036F]" "" s))) ; Strip diacritics
    (downcase s)))

(defun ctanis/string-lessp-ignore-locale (s1 s2 _locale ignore-case)
  "Case-insensitive (if IGNORE-CASE) comparison ignoring locale.
S1 and S2 are the strings to compare.
_LOCALE is ignored completely."
  (if ignore-case
      (string-lessp (ctanis/collation-simplify s1) (ctanis/collation-simplify s2))
    (string-lessp s1 s2)))
(setq org-sort-function #'ctanis/string-lessp-ignore-locale)

(defun macos-unfreeze()
  (interactive)
  (let ((params (frame-parameters)))
    (modify-frame-parameters nil '((parent-id . nil))) ;; avoid terminal parent reference
    (let ((new-frame (make-frame params)))
      (select-frame-set-input-focus new-frame)
      (sit-for 0.1)
      (redraw-frame new-frame)
      (delete-frame (selected-frame)))))
(define-key craig-prefix-map (kbd "C-<escape>") #'macos-unfreeze)
