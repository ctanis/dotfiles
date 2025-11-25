

(when (require-verbose 'vertico)
  (vertico-mode))
(when (require-verbose 'consult)
  (define-key craig-prefix-map (kbd "M-i") 'consult-imenu)
  )
(when (require-verbose 'orderless)
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion)))))
  (setq orderless-matching-styles '(orderless-flex))
  )
(when (require-verbose 'embark)
  (load-library "embark")
  (global-set-key (kbd "C-\\") #'embark-act)
  )
(when (require-verbose 'embark-consult)
  (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)
  )
(when (require-verbose 'consult-dir)
  (define-key embark-become-file+buffer-map "d" #'consult-dir)
  )
(when (require-verbose 'marginalia)
  (marginalia-mode))

(recentf-mode 1)
(savehist-mode 1)

(setq embark-prompter 'embark-keymap-prompter)
(setq embark-indicators
      '(embark--vertico-indicator
        embark-minimal-indicator
        embark-highlight-indicator
        embark-isearch-highlight-indicator))

;; to get it to stop completing
(define-key vertico-map (kbd "C-j") #'vertico-exit-input)
(global-set-key "\C-x\C-r" 'consult-recent-file)
;; i want "become" to be "b" not "B"
(mapcar (lambda (p) (let ((sym (cadr p)))
                      (if (and (boundp sym) (keymapp (symbol-value sym)))
                          (define-key (symbol-value sym)
                                      "b" #'embark-become))))
        embark-keymap-alist)

(defun crt/bounce-to-recent (s)
  (interactive "F")
  (call-interactively #'consult-recent-file))
(define-key embark-file-map "r" #'crt/bounce-to-recent)
(define-key embark-buffer-map "r" #'crt/bounce-to-recent)
(define-key embark-file-map "g" #'magit-status)


; don't close the minibuffer after executing an action (unless it's
; consult-recent-file...)
(setq embark-quit-after-action '((consult-recent-file . t)
                                 (crt/bounce-to-recent . t)
                                 (consult-dir . t)
                                 (consult-buffer .t)
                                 nil))
