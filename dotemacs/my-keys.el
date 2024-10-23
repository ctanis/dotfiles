(global-set-key "\C-x\C-c" 'verify-exit)


(define-key global-map "\M-o" 'craig-prefix)
(define-key craig-prefix-map " " 'just-no-space)
(define-key craig-prefix-map "2" 'create-file-mode)
(define-key craig-prefix-map "3" 'executable-set-magic)
(define-key craig-prefix-map "4" 'make-perl-script)
(define-key craig-prefix-map "\C-?" 'kill-to-beginning-of-line)
(define-key craig-prefix-map "\C-a" 'alternate-buffer-in-other-window)
(define-key craig-prefix-map "\C-o" 'better-display-buffer)
(define-key craig-prefix-map "\C-w" 'delete-region)
(define-key craig-prefix-map "\C-x-" 'shrink-other-window-if-larger-than-buffer)
;(define-key craig-prefix-map "\C-x1" 'mono-framify)
(define-key craig-prefix-map "\C-x2" 'frame-mitosis-toggle)
(define-key craig-prefix-map "\M-b" 'sink-buffer)
(define-key craig-prefix-map "\M-c" 'make-tmp-code)
(define-key craig-prefix-map "\M-d" 'selectively-delete-lines)
(define-key craig-prefix-map "\M-e" 'end-of-defun)
(define-key craig-prefix-map "\M-h" 'hl-line-mode)
(define-key craig-prefix-map "\M-j" 'forward-jump-to-char)
(define-key craig-prefix-map "\M-k" 'kill-current-buffer)
(define-key craig-prefix-map "\M-m" 'make-directory)
(define-key craig-prefix-map "\C-s" 'clone-indirect-in-place)
;(define-key craig-prefix-map "\M-o" 'other-window)
(define-key craig-prefix-map "\M-o" 'switch-to-previous-window)
(define-key craig-prefix-map "\M-t" 'toggle-truncate-lines)
;(define-key craig-prefix-map "]" 'overwrite-mode) ;toggle it!
(define-key craig-prefix-map "a" 'alternate-buffer)
(define-key craig-prefix-map "b" 'switch-to-buffer-other-window)
;(define-key craig-prefix-map "c" 'center-line)
(define-key craig-prefix-map "d" 'dired-other-window)
(define-key craig-prefix-map "f" 'find-file-other-window)
(define-key craig-prefix-map "h" 'split-window-vertically)
(define-key craig-prefix-map "i" 'delete-window)
(define-key craig-prefix-map "k" 'kill-other-buffer)
(define-key craig-prefix-map "l" 'move-to-window-line)
(define-key craig-prefix-map "o" 'switch-to-buffer)
(define-key craig-prefix-map "p" 'delete-other-windows)
(define-key craig-prefix-map "q" 'flip-windows)
(define-key craig-prefix-map "s" 'switch-to-common-buffer)
(define-key craig-prefix-map "t" 'insert-time-stamp)
(define-key craig-prefix-map "v" 'split-window-horizontally)
(define-key craig-prefix-map "w" 'write-region)
(define-key craig-prefix-map "u" 'revert-buffer)
(define-key craig-prefix-map "\M-$" 'hs-toggle-hiding)
;(define-key craig-prefix-map "\M-x" 'compile-again)
(define-key craig-prefix-map "\M-v" 'view-mode)
(define-key craig-prefix-map "-" 'insert-separator)
(define-key craig-prefix-map "[" 'wrap-region-with-char)
(define-key craig-prefix-map "\M-u" 'calc-dispatch)
(define-key craig-prefix-map "\C-r" 'copy-region-for-paste)
(define-key craig-prefix-map "\M-2" 'save-file-local-variable)
(define-key craig-prefix-map "\M-q" 'slide-line-left)
(define-key craig-prefix-map "\M-w" 'winner-undo)
(define-key craig-prefix-map "\C-\M-w" 'winner-redo)
(define-key craig-prefix-map "c" 'copy-buffer-file-name)
(define-key craig-prefix-map "r" 'auto-revert-mode)

(global-set-key "\C-x-" 'shrink-window-to-selection)

(global-set-key "\M-j" 'backward-jump-to-char)
(global-set-key "\M-,"  'ispell-word)

(global-set-key "\C-xz" 'calendar)
(global-set-key "\C-x!" 'shell-current-directory)
(global-set-key "\C-q" 'base-quoted-insert)

(global-set-key "\C-\M-e" 'up-list)

; some redundant keystrokes to bridge gap between linux and mac
(global-set-key "\M-`" 'other-frame)

(define-key ctl-x-map ";" 'comment-region)

;for jumping around in a file quicker
(global-set-key "\M-p" 'scroll-down-slow)
(global-set-key "\M-n" 'scroll-up-slow)

(define-key isearch-mode-map "\M-p" 'scroll-down-slow)
(define-key isearch-mode-map "\M-n" 'scroll-up-slow)

(global-set-key "\M-\C-y" 'repeat-complex-command)
(global-set-key "\M-\C-g" 'grep)

(global-set-key "\C-l" 'recenter)

;(global-set-key (kbd "M-S-SPC") 'cycle-spacing)

;; UNSET
(global-unset-key "\C-z") ;; no more suspend/iconify
(global-unset-key "\C-x\C-z")
(global-unset-key "\C-h\C-p")		;gnu manifesto
(global-unset-key "\C-h\C-n")		;emacs news
(global-unset-key "\C-hn")
(global-unset-key "\C-ht")
(global-unset-key [f10])
(global-unset-key [f2])
(global-unset-key [f1])
(global-unset-key [end])
(global-unset-key [home])
;(global-unset-key [insert])
(global-unset-key [prior])
(global-unset-key [next])

;remove an alternate keybinding for undo
;(global-unset-key "\C-/")
(global-unset-key (quote [67108911]))

(define-key craig-prefix-map "\C-xb" 'ibuffer-other-window)

(define-key craig-prefix-map "\C-f" 'ffap-other-window)
(define-key craig-prefix-map "\C-\M-f" 'find-and-display-file)

(define-key craig-prefix-map "\M-r" 'active-mark-rectangle)

(define-key craig-prefix-map "\M-0" 'deft)
(define-key craig-prefix-map (kbd "<tab>") 'imenu-anywhere)
