(defun active-mark-rectangle()
  (interactive)
  ;(setq transient-mark-mode 'lambda) ;; set it temporarily
  (activate-mark)
  (rectangle-mark-mode)
  )


;; (defun my-mc-mark-all-smart()
;;   (interactive)
;;   (if (region-active-p)
;;       (call-interactively 'mc/mark-all-like-this)
;;     (call-interactively 'mc/mark-next-word-like-this))
;; )


(when (require-verbose 'multiple-cursors)
  ;; (require 'phi-search)
  ;; (require 'phi-search-dired)
  (require 'mc-extras)

  ;; (global-set-key (kbd "C-s") 'phi-search)
  ;; (global-set-key (kbd "C-r") 'phi-search-backward)

  ; (define-key dired-mode-map (kbd "/") 'phi-search-dired)
  
  (define-key craig-prefix-map "\M-.\M-l" 'mc/edit-lines)
  (define-key craig-prefix-map "\M-.\M-." 'mc/mark-next-like-this)
  (define-key craig-prefix-map "\M-.*" 'mc/mark-all-dwim)
  (define-key craig-prefix-map "\M-.@" 'mc/mark-more-like-this-extended)
  (define-key craig-prefix-map "\M-.<" 'mc/mark-sgml-tag-pair)

  (define-key mc/keymap (kbd "M-.") 'mc/mark-next-like-this)
  (define-key mc/keymap (kbd "C-*") 'mc/mark-all-like-this)
  (define-key mc/keymap (kbd "C-. C-d") 'mc/remove-current-cursor)
  (define-key mc/keymap (kbd "C-. d")   'mc/remove-duplicated-cursors)
  (define-key mc/keymap (kbd "C-. =")   'mc/compare-chars)
  (define-key mc/keymap (kbd "C-. #") 'mc/insert-numbers)
  (define-key mc/keymap (kbd "C-. C-r") 'mc/reverse-regions)
  (define-key mc/keymap (kbd "C-. C-s") 'mc/sort-regions)


  ; (phi-search-mc/setup-keys)

  (if (>= emacs-major-version 24)
      (progn
        (define-key craig-prefix-map "\M-r" 'active-mark-rectangle)
        
        ;; Emacs 24.4+ comes with rectangle-mark-mode.
        (define-key rectangle-mark-mode-map (kbd "M-.")
          'mc/rect-rectangle-to-multiple-cursors)
        )
    )
  )


