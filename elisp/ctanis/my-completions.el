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

(require-verbose 'company-math)

(defun company-modified-math-symbols-latex (command &optional arg &rest ignored)
  "Company backend for LaTeX mathematical symbols."
  (interactive (list 'interactive))
  (case command
    (interactive (company-begin-backend 'company-math-symbols-latex))
    (prefix (company-math--prefix company-math-allow-latex-symbols-in-faces
				    company-math-disallow-latex-symbols-in-faces))
    (annotation (concat " " (get-text-property 0 :symbol arg)))
    (candidates (all-completions arg company-math--symbols))))




(setq company-backends '(
                         ; company-clang
                         (company-keywords company-dabbrev-code)
                         company-semantic
                         company-files
                         company-modified-math-symbols-latex
                         company-dabbrev
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
                                        ;(global-set-key (read-kbd-macro "s-<return>") 'company-complete)
;(global-set-key (read-kbd-macro "M-C-/") 'company-semantic)
(global-set-key "\M-?" 'company-complete)
(global-set-key "\M-/" 'hippie-expand)


;; semantic



;; (add-hook 'mode-hook
;;           (lambda ()
;;             (setq imenu-create-index-function 'semantic-create-imenu-index)
;;             ))


;; (defvar my-semantic-create-imenu-index 'semantic-create-imenu-index)

;; (defun my-imenu-function (&optional stream)
;;   (funcall my-semantic-create-imenu-index stream)
;;   )

;; (add-hook 'java-mode-hook
;;           (lambda ()
;;             (setq imenu-create-index-function 'my-imenu-function)
;;             ))
;; (add-hook 'c-mode-hook
;;           (lambda ()
;;             (setq imenu-create-index-function 'my-imenu-function)
;;             ))


;; (defun my-semantic-enable()
;;   (interactive)
;;   (semantic-mode 1)
;;   (setq my-semantic-create-imenu-index 'semantic-create-imenu-index)
;;   )

;; (defun my-semantic-disable()
;;   (interactive)
;;   (semantic-mode -1)
;;   (setq my-semantic-create-imenu-index 'imenu-default-create-index-function)
;;   )


;; (my-semantic-enable)


(semantic-mode 1)
(global-semantic-stickyfunc-mode 1)
;(setq global-semantic-mru-bookmark-mode 1)
(global-semantic-mru-bookmark-mode 1)
(define-key craig-prefix-map "\M-." 'semantic-mrub-switch-tags)
(global-set-key "\M-." 'semantic-complete-jump)
(set-default 'semantic-imenu-bucketize-file nil)

