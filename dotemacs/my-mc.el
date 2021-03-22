(require 'multiple-cursors)
(require 'mc-extras)
(require 'phi-search)
(require 'phi-replace)
(require 'phi-search-mc)
(require 'ace-mc)



(define-key mc/keymap (kbd "C-. #") 'mc/insert-numbers)
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

(add-hook 'isearch-mode-hook 'phi-search-from-isearch-mc/setup-keys)
