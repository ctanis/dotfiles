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

  (require 'mc-extras)
  (require 'phi-search)
  (require 'phi-replace)
  (require 'phi-search-mc)
  ;; (require 'phi-search-dired)

  ; (global-set-key "\M-%" 'phi-replace-query)

  ;; (global-set-key (kbd "C-s") 'phi-search)
  ;; (global-set-key (kbd "C-r") 'phi-search-backward)

                                        ; (define-key dired-mode-map (kbd "/") 'phi-search-dired)
  
  (define-key craig-prefix-map "\M-." (make-sparse-keymap))
  (define-key craig-prefix-map "\M-.\M-l" 'mc/edit-lines)
  (define-key craig-prefix-map "\M-.\M-." 'mc/mark-next-like-this)
  (define-key craig-prefix-map "\M-.!" 'mc/mark-all-dwim)
  (define-key craig-prefix-map "\M-.@" 'mc/mark-more-like-this-extended)
  (define-key craig-prefix-map "\M-.<" 'mc/mark-sgml-tag-pair)

  (define-key mc/keymap (kbd "M-.") 'mc/mark-next-like-this)
  (define-key mc/keymap (kbd "M-.") 'mc/mark-previous-like-this)
  (define-key mc/keymap (kbd "C-*") 'mc/mark-all-like-this)
  (define-key mc/keymap (kbd "C-. C-d") 'mc/remove-current-cursor)
  (define-key mc/keymap (kbd "C-. d")   'mc/remove-duplicated-cursors)
  (define-key mc/keymap (kbd "C-. =")   'mc/compare-chars)
  (define-key mc/keymap (kbd "C-. #") 'mc/insert-numbers)
  (define-key mc/keymap (kbd "C-. C-r") 'mc/reverse-regions)
  (define-key mc/keymap (kbd "C-. C-s") 'mc/sort-regions)
  (define-key mc/keymap (kbd "M-j") 'mc/backward-jump-to-char)

(defun mc/backward-jump-to-char (arg char)
  "jump backward to ARGth previous CHAR (mc edition).  doesn't
prompt when ran multiple times in a row"
  (interactive "p\ncBackward jump to char: ")
  
  (setq last-jumped-to-char char)
  (backward-jump-to-char arg char)
  (mc/for-each-fake-cursor
     (save-excursion
       (mc/execute-command-for-fake-cursor
        (lambda ()
          (interactive)
          (search-forward (char-to-string char) nil t (- arg)))
        cursor))))



  (defvar phi-search-from-isearch-mc/ctl-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "M-.")   'phi-search-from-isearch-mc/mark-next)
      (define-key map (kbd "M-,")   'phi-search-from-isearch-mc/mark-previous)
      (define-key map (kbd "M-!") 'phi-search-from-isearch-mc/mark-all)
      map))



  (defadvice phi-search-from-isearch-mc/setup-keys
      (after for-terminal activate)
    (define-key isearch-mode-map (kbd "M-!") 'phi-search-from-isearch-mc/mark-all)
    (define-key isearch-mode-map (kbd "M-.") 'phi-search-from-isearch-mc/mark-next))
  

  (define-key phi-search-default-map (kbd "M-.") 'phi-search-mc/mark-next)
  (define-key phi-search-default-map (kbd "M-,") 'phi-search-mc/mark-previous)
  (define-key phi-search-default-map (kbd "M-!") 'phi-search-mc/mark-all)

  ; (phi-search-mc/setup-keys)
  (add-hook 'isearch-mode-hook 'phi-search-from-isearch-mc/setup-keys)


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


