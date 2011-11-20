(setq auto-mode-alist
      (cons '("\\.m$" . objc-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("\\.mm$" . objc-mode) auto-mode-alist))


(defun switch-to-xcode()
  (interactive)
  (shell-command "osascript -e 'tell application \"Xcode\" to activate'"))


; this is not quite right, since turning off the mode also runs the hook
;; (add-hook 'xcode-mode-hook
;; 	  '(lambda()
;; 	     (set (make-local-variable 'compile-command)
;; 		  "xcodebuild -configuration Debug")))
(add-hook 'xcode-mode-hook
	  '(lambda()
	     (set 'compile-command
		  "xcodebuild -configuration Debug")))

(define-minor-mode xcode-mode
  "Toggle xcode minor mode."
  ;; initial value
  nil
  ;; indicator for Mode line
  " Xcode"
  ;; minor mode bindings
; '(("\C-c\C-c" . xcode-compile))
  '(("\C-co" . switch-to-xcode))
  nil
  ;; last stuff
  nil
  )

(define-global-minor-mode xcode-global-mode xcode-mode xcode-mode)
