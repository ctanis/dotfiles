(defgroup mode-line-note nil
  "Show a short note in the mode-line.
The variable `mode-line-note' may be a string to display directly, or a
symbol whose value will be displayed.  If the value (or the variable)
is nil, nothing is shown."
  :group 'convenience)

(defcustom mode-line-note nil
  "Value to display in the mode-line when `mode-line-note-mode' is on.

This may be either a string, which is shown directly, or a symbol;
when a symbol is given, the symbol's value is used for display.  If
the value to display is nil, nothing is printed in the mode-line."
  :type '(choice string symbol)
  :group 'mode-line-note)

(defvar mode-line-note--watched-ref nil
  "Symbol of the variable currently watched for changes (if any).")

(defun mode-line-note--resolve-value (val)
  "Resolve VAL to the value that should be displayed.
If VAL is a symbol, return its value (or nil if unbound or nil).
If VAL is a string, return it.  For other non-nil values, return
their printed representation as a string.  Return nil if there is
nothing to display."
  (cond
   ((null val) nil)
   ((symbolp val)
    (when (boundp val)
      (let ((v (symbol-value val)))
        (when v
          (if (stringp v) v (format "%s" v))))))
   ((stringp val) val)
   (t (format "%s" val))))

(defun mode-line-note--format (val)
  "Format VAL for display in the mode-line, or return nil if nothing."
  (let ((s (mode-line-note--resolve-value val)))
    (when s
      (concat " [" s "]"))))

(defvar mode-line-note--mode-line
  '(:eval (when mode-line-note-mode
            (mode-line-note--format mode-line-note)))
  "Mode-line element that shows `mode-line-note' when the mode is active.")

(defun mode-line-note--watcher (var newval _op _where)
  "Variable watcher used to refresh the mode-line.

If VAR is `mode-line-note', update any watcher on the referenced
symbol and force a mode-line update.  For other variables (i.e.
a referenced variable changing), simply force a mode-line update."
  (cond
   ((eq var 'mode-line-note)
    ;; Update watcher on referenced symbol to reflect new value
    (when mode-line-note-mode
      (when (and (fboundp 'remove-variable-watcher)
                 mode-line-note--watched-ref)
        (condition-case nil
            (remove-variable-watcher mode-line-note--watched-ref
                                     #'mode-line-note--watcher)
          (error nil))
        (setq mode-line-note--watched-ref nil))
      (when (and (symbolp newval)
                 (fboundp 'add-variable-watcher))
        (condition-case nil
            (progn
              (add-variable-watcher newval #'mode-line-note--watcher)
              (setq mode-line-note--watched-ref newval))
          (error nil))))
    (when mode-line-note-mode
      (force-mode-line-update t)))
   (t
    ;; Some other watched variable changed; refresh if mode is active.
    (when mode-line-note-mode
      (force-mode-line-update t)))))

(defun mode-line-note-set (val)
  "Set `mode-line-note' to VAL.
VAL may be a string or a symbol.  Use nil to disable display."
  (setq mode-line-note val)
  ;; Ensure mode-line updates immediately if the mode is active.
  (when mode-line-note-mode
    (force-mode-line-update t)))

(define-minor-mode mode-line-note-mode
  "Global minor mode that shows `mode-line-note' in the mode-line.

When enabled, the value of `mode-line-note' (a string or a symbol)
is displayed.  If the value to display is nil, nothing is shown."
  :global t
  :group 'mode-line-note
  :lighter nil
  (if mode-line-note-mode
      ;; enable: add element and watchers
      (progn
        (unless (boundp 'global-mode-string)
          (setq global-mode-string nil))
        (unless (memq mode-line-note--mode-line global-mode-string)
          (push mode-line-note--mode-line global-mode-string))
        (when (fboundp 'add-variable-watcher)
          ;; Watch changes to mode-line-note itself
          (add-variable-watcher 'mode-line-note #'mode-line-note--watcher)
          ;; If mode-line-note is a symbol, also watch that referenced variable
          (when (symbolp mode-line-note)
            (condition-case nil
                (progn
                  (add-variable-watcher mode-line-note #'mode-line-note--watcher)
                  (setq mode-line-note--watched-ref mode-line-note))
              (error nil)))))
    ;; disable: remove element and watchers
    (when (boundp 'global-mode-string)
      (setq global-mode-string
            (delq mode-line-note--mode-line global-mode-string)))
    (when (fboundp 'remove-variable-watcher)
      (condition-case nil
          (remove-variable-watcher 'mode-line-note #'mode-line-note--watcher)
        (error nil))
      (when mode-line-note--watched-ref
        (condition-case nil
            (remove-variable-watcher mode-line-note--watched-ref
                                     #'mode-line-note--watcher)
          (error nil))
        (setq mode-line-note--watched-ref nil)))
    (force-mode-line-update t)))

(provide 'mode-line-note)
