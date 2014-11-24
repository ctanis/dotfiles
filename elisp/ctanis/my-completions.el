;; my company / semantic / yasnippet setup

(require 'company)
(require 'semantic)
(require 'yasnippet)


;; yasnippet
(setq yas-prompt-functions (list 'yas-ido-prompt))
(setq yas-verbosity 1)
(setq yas-snippet-dirs '("~/.emacs.d/snippets" "~/.emacs.d/stock-snippets"))
(load-library "yasnippet")
(setq yas-expand-only-for-last-commands '(self-insert-command org-self-insert-command))
(yas-global-mode 1)
(define-key craig-prefix-map "\M-y" 'yas-insert-snippet)

;; company


;; (defun latex-company-mode-setup ()
;;   (setq-local company-backends
;;               (append '(company-math-symbols-latex)
;;                       company-backends)))

;; (defun org-company-mode-setup ()
;;   (setq-local company-backends
;;               (append '(company-math-symbols-unicode)
;;                       company-backends)))

;; (add-hook 'latex-mode-hook 'latex-company-mode-setup)
;; (add-hook 'org-mode-hook 'org-company-mode-setup)


(setq company-backends '(company-semantic
                         company-clang
                         company-dabbrev-code
                         company-keywords
                         company-math-symbols-latex
                         ))


(setq company-tooltip-align-annotations t)
(setq company-idle-delay .3)
(setq company-minimum-prefix-length 1)

(when (require-verbose 'company-yasnippet)
  (define-key craig-prefix-map "\M-y" 'company-yasnippet))

(eval-after-load "company.el"
  '(progn

     (set-face-background 'company-preview "wheat1") ;; shoudl be in ui.el

     ))



;; semantic / cedet



;; eclim -- run start-eclim in the appropriate workspace
(defun eclim-go ()
  (interactive)
  (require 'eclimd)
  (require 'company-emacs-eclim)
  (company-emacs-eclim-setup)
  (if (not (eclimd--running-p))
         (call-interactively 'start-eclimd)
    )
  (eclim-mode))

(global-company-mode t)
(global-set-key (read-kbd-macro "S-<tab>") 'company-complete)
