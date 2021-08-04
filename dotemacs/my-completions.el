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

  (defun aya-dispatch (p)
    (interactive "p")
    (if (> p 1)
        (progn
          (message "creating autosnippet")
          (call-interactively 'aya-create))
      (progn
        (message "expand autosnippet")
        (call-interactively 'aya-expand))))
  )


;; company


(setq company-backends '(
                          company-gtags
                          company-keywords
                          ))


(setq company-tooltip-align-annotations t)
(setq company-idle-delay .3)
(setq company-minimum-prefix-length 1)

(when (require-verbose 'company-yasnippet)
  (define-key craig-prefix-map "\M-y" 'company-yasnippet))

(eval-after-load "company.el"
  '(progn
     (set-face-background 'company-preview "wheat1") ;; should be in ui.el
     ))

;; don't use company in these modes
;;(setq company-global-modes '(not shell-mode gud-mode))


(define-key craig-prefix-map "~"  'company-files)
(global-set-key (kbd "C-M-/") 'company-capf)
(global-set-key "\M-/" 'hippie-expand)
(global-company-mode t)



;; hippie
(setq hippie-expand-try-functions-list
      '(
        apair-try-expand-list

        try-expand-line
        try-expand-line-all-buffers
        apair-try-expand-list-all-buffers
        
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill

        try-complete-file-name-partially
        try-complete-file-name
        ))


;; python-capf is totally borked
(add-hook 'python-mode-hook
          #'(lambda ()
              (setq-local completion-at-point-functions nil)))
