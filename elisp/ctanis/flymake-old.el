;; (add-hook 'python-mode-hook
;; 	  '(lambda()
;;              (when (require-verbose 'flymake-python-pyflakes)
;;                (flymake-python-pyflakes-load))))

;; java flymake
;;(require 'flymake)

;; flymake requires something like this in the build.xml:
  ;; <target name="check-syntax" depends="init" description="check for errors">
  ;;   <javac destdir="${build}" 
  ;;          classpathref="project.class.path" 
  ;;          includeantruntime="false">
  ;;     <src path="${CHK_SOURCES}" />
  ;;     <compilerarg value="-Xlint" />
  ;;   </javac>
    
  ;; </target>


;; (defun flymake-fixed-get-ant-cmdline (source base-dir)
;;   (list "ant"
;; 	(list "-file"
;; 	      (concat base-dir "/" "build.xml")

;;               ;; scan the whole directory. fix this??
;; 	      (concat "-DCHK_SOURCES=" (file-name-directory source)) 

;; 	      "check-syntax")))

;; (defun my-java-flymake-init ()
;;   "flymake using build.xml if there is one, otherwise javac with lint"
;;   (if (locate-dominating-file default-directory "build.xml")
;;       (flymake-simple-make-init-impl 'flymake-create-temp-with-folder-structure
;;                                      t nil "build.xml" 'flymake-fixed-get-ant-cmdline)
;;     (list "javac"  (list "-Xlint:unchecked"
;; 			 (flymake-init-create-temp-buffer-copy
;; 			  'flymake-create-temp-with-folder-structure)))))


;; (add-to-list 'flymake-allowed-file-name-masks
;;              '("\\.java$" my-java-flymake-init flymake-simple-cleanup))



; don't have to use the mouse to get flymake feedback
;; (eval-after-load 'flymake
;; '(progn
;;    ;; (load-library "flycursor")
;;    ;;(require-verbose 'flymake-curosr)
;;    (define-key craig-prefix-map "\M-p" 'flymake-goto-prev-error)
;;    (define-key craig-prefix-map "\M-n" 'flymake-goto-next-error)
;;    (define-key craig-prefix-map "\M-f" 'flymake-start-syntax-check)
;;    ;; triggering syntax check with newlines is terrible
;;    (setq flymake-log-level 0)
;;    (setq flymake-start-syntax-check-on-newline nil)
;;    ))


  ;; flymake-css        
  ;; flymake-cursor     
  ;; flymake-easy       
  ;; flymake-perlcritic
  ;; flymake-python-...
  ;; flymake-ruby
  ;; flymake-shell


;; (defun flymake-display-warning (warning) 
;;   "Display a warning to the user, using lwarn"
;;   (message warning))

(add-hook 'java-mode-hook
          (lambda ()
            ;;(add-hook 'java-mode-hook 'flymake-mode-on)
            ;;(flymake-mode-on)
            (if (locate-dominating-file default-directory "build.xml")
                (set (make-local-variable 'compile-command)
                     "ant -emacs -s build.xml -e ")
              (if buffer-file-name
                  (set (make-local-variable 'compile-command)
                       (concat "javac -Xlint " (file-name-nondirectory buffer-file-name)))))))


;;; alias the new `flymake-report-status-slim' to
;;; `flymake-report-status'

;; (eval-after-load 'flymake
;;   '(progn
;;      (defalias 'flymake-report-status 'flymake-report-status-slim)
;;      (defun flymake-report-status-slim (e-w &optional status)
;;        "Show \"slim\" flymake status in mode line."
;;        (when e-w
;;          (setq flymake-mode-line-e-w e-w))
;;        (when status
;;          (setq flymake-mode-line-status status))
;;        (let* ((mode-line " Φ"))
;;          (when (> (length flymake-mode-line-e-w) 0)
;;            (setq mode-line (concat mode-line ":" flymake-mode-line-e-w)))
;;          (setq mode-line (concat mode-line flymake-mode-line-status))
;;          (setq flymake-mode-line mode-line)
;;          (force-mode-line-update)))
;;      ))
