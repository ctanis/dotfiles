;; minor mode that causes lines to grow when we go right and down



(defun forward-char-grow-line ()
  (interactive)
  (if (or (looking-at "\n")
          (equal (point) (buffer-end 1)))
      (insert " ")
    (forward-char)))

(defun right-char-grow-line ()
  (interactive)
  (if (or (looking-at "\n")
          (equal (point) (buffer-end 1)))
      (insert " ")
    (right-char)))



(defalias 'next-line-grow-buffer 'next-line)
(defadvice next-line-grow-buffer (around grow-line activate)
  "next line with newline fixed"
  (let ((next-line-add-newlines t))
    ad-do-it))



;;;###autoload
(define-minor-mode grow-buffer-mode "commands cause lines to grow, rather than wrap"
  :lighter " Grow"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-f") 'forward-char-grow-line)
            (define-key map (kbd "C-n") 'next-line-grow-buffer)
            (define-key map (read-kbd-macro "<right>") 'right-char-grow-line)
            (define-key map (read-kbd-macro "<down>") 'next-line-grow-buffer)
            map)

  )




(provide 'grow-buffer-mode)
