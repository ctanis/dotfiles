

(when (require-verbose 'vertico)
  (vertico-mode))
(when (require-verbose 'consult)
  (define-key craig-prefix-map (kbd "M-i") 'consult-imenu)
  )
(when (require-verbose 'orderless)
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))
(when (require-verbose 'embark)
  (load-library "embark")
  (global-set-key (kbd "C-.") #'embark-act)
  )
(when (require-verbose 'embark-consult)
  (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)
  )
(when (require-verbose 'marginalia)
  (marginalia-mode))

(recentf-mode 1)
(savehist-mode 1)

(setq embark-prompter 'embark-completing-read-prompter)
(setq embark-indicators '(embark--vertico-indicator embark-minimal-indicator embark-highlight-indicator embark-isearch-highlight-indicator))
