;; my company / semantic / yasnippet setup

(require 'company)
(require 'company-capf)
(require 'yasnippet)


;; yasnippet
(setq yas-prompt-functions (list 'yas-ido-prompt))
(setq yas-verbosity 1)
(setq yas-snippet-dirs '("~/.emacs.d/snippets" "~/.emacs.d/stock-snippets"))
(setq yas-expand-only-for-last-commands '(self-insert-command org-self-insert-command))

(load-library "yasnippet")
(yas-global-mode 1)
(define-key craig-prefix-map "\M-y" 'yas-insert-snippet)


(when (require-verbose 'auto-yasnippet)

  ;; aya fields are only alphanumeric+underscore (logic in auto-yasnippet.el
  ;; tries to allow for any symbol character but has some funkiness with some
  ;; punctuation like !)
  (setq aya-field-regex "[a-zA-Z0-9_]")

  (defun aya-dispatch (p)
    (interactive "p")
    (if (> p 1)
        (progn
          (message "creating autosnippet")
          (call-interactively 'aya-create))
      (progn
        (message "expand autosnippet")
        (call-interactively 'aya-expand))))
  (define-key craig-prefix-map "y" 'aya-dispatch)
  )


;; company


(setq company-backends '(
                          ;; company-gtags
                          company-keywords
                          ))


(setq company-tooltip-align-annotations t)
(setq company-idle-delay .3)
(setq company-minimum-prefix-length 1)

(when (require-verbose 'company-yasnippet)
  (define-key craig-prefix-map "\M-y" 'company-yasnippet))



;; don't use company in these modes
;;(setq company-global-modes '(not shell-mode gud-mode))


(define-key craig-prefix-map "~"  'company-files)
(global-set-key (kbd "C-M-/") 'company-capf)
(global-set-key "\M-/" 'hippie-expand)
(global-company-mode t)



;; hippie
(setq hippie-expand-try-functions-list
      '(
       
        try-expand-line
        apair-try-expand-list
        try-expand-dabbrev

        try-expand-line-all-buffers
        apair-try-expand-list-all-buffers
        try-expand-dabbrev-from-kill
        try-expand-dabbrev-all-buffers

        try-complete-file-name-partially
        try-complete-file-name
        ))


;; python-capf is totally borked
(add-hook 'python-mode-hook
          #'(lambda ()
              (setq-local completion-at-point-functions nil)))


;; hack of company-files to not require leading relative paths
(require 'company-files)
(defun company-files--grab-existing-name ()
  ;; Grab the file name.
  ;; When surrounded with quotes, it can include spaces.
  (let (file dir)
    (and (cl-dolist (regexp company-files--regexps)
           (when (setq file (company-grab-line regexp 1))
             (cl-return file)))
         (company-files--connected-p file)
         (setq file (if (string-match-p "^[~/]" file) file
                      (concat "./" file)))
         (setq dir (file-name-directory file))
         (not (string-match "//" dir))
         (file-exists-p dir)
         file)))
;(add-to-list 'company-files--regexps "\\(?:[ \t=\[]\\|^\\)\\([^ \t\n]+\\)")
; (add-to-list 'company-files--regexps "\\(?:[ \t\"=\[]\\|^\\)\\([^ \t\n]+\\)")

;; [^a-z...] is used to specify valid filename contents
(add-to-list 'company-files--regexps "\\(?:[ \t\"=\[]\\|^\\)[^a-zA-Z0-9/-_.]*\\([^ \t\n]+\\)")

(defun my-company-continue ()
  (interactive)
  (let ((sel (nth company-selection
                  company-candidates)))
    (message sel)
    (pcase-let ((`(,prefix . ,suffix) (company--boundaries sel)))
      (company--insert-candidate sel (or prefix company-prefix)))))

(define-key company-active-map "\C-e" 'my-company-continue) 
