(setq gdb-many-windows t)
(setq compilation-scroll-output t)
(setq compilation-skip-threshold 2)

(require 'ansi-color)
(require 'cl-lib)

;; ------------------------------
;; General compilation/coloring
;; ------------------------------
(add-hook 'compilation-filter-hook
          (lambda ()
            (let ((inhibit-read-only t))
              (ansi-color-apply-on-region compilation-filter-start (point)))))

;; ------------------------------
;; Treesitter remapping (if available)
;; ------------------------------
(setq treesit-language-source-alist
      '((cpp   "https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.4")
        (c     "https://github.com/tree-sitter/tree-sitter-c"     "v0.23.4")
        (python "https://github.com/tree-sitter/tree-sitter-python" "v0.23.6")
        (bash  "https://github.com/tree-sitter/tree-sitter-bash"   "v0.23.3")
        (json  "https://github.com/tree-sitter/tree-sitter-json"   "v0.24.8")))

(when (and (fboundp 'treesit-available-p) (treesit-available-p))
  (when (treesit-language-available-p 'cpp)    (add-to-list 'major-mode-remap-alist '(c++-mode   . c++-ts-mode)))
  (when (treesit-language-available-p 'c)      (add-to-list 'major-mode-remap-alist '(c-mode     . c-ts-mode)))
  (when (treesit-language-available-p 'python) (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode)))
  (when (treesit-language-available-p 'bash)   (add-to-list 'major-mode-remap-alist '(sh-mode    . bash-ts-mode)))
  (when (treesit-language-available-p 'json)   (add-to-list 'major-mode-remap-alist '(json-mode  . json-ts-mode))))

;; ------------------------------
;; Fortran / F90
;; ------------------------------
(defun fortran-narrow-sub ()
  "Narrow to the current Fortran subroutine/function/block."
  (interactive)
  (save-excursion
    (beginning-of-defun)
    (let ((start (point)))
      (forward-line 1)
      (end-of-defun)
      (narrow-to-region start (point)))))

(defun fortran-up-list-or-block ()
  "Go up to the containing list or Fortran block (combines up-list and f90-beginning-of-block)."
  (interactive)
  (let* ((start (point))
         (block (condition-case nil
                    (progn
                      (f90-beginning-of-block)
                      (point))
                  (error nil)))
         (liststart
          (condition-case nil
              (progn
                (goto-char start)
                (up-list -1)
                (point))
            (error nil))))
    (goto-char
     (cond
      ((and (not block) liststart) liststart)
      ((and (not liststart) block) block)
      ((and liststart block) (max block liststart))
      (t (progn
           (message "no containing list or element")
           (point)))))))

(with-eval-after-load 'fortran
  (add-hook 'fortran-mode-hook
            (lambda ()
              (auto-fill-mode 1)
              (local-set-key (kbd "C-M-u") 'fortran-up-list-or-block)
              (local-set-key (kbd "RET") 'align-newline-and-indent)
              (electric-indent-mode -1))))

(with-eval-after-load 'f90
  (define-key f90-mode-map (kbd "C-x n d") 'fortran-narrow-sub)
  (add-hook 'f90-mode-hook
            (lambda ()
              (local-set-key (kbd "C-M-u") 'fortran-up-list-or-block)
              (local-set-key (kbd "RET") 'align-newline-and-indent)
              (local-set-key (kbd "C-c C-c") 'compile)
              (setq f90-do-indent 2
                    f90-if-indent 2
                    f90-type-indent 2
                    f90-program-indent 2))))


;; ------------------------------
;; Perl
;; ------------------------------
(defun eval-buffer-as-perl-script (pre)
  "Send the current buffer to a perl interpreter for syntax checking.
With prefix PRE, run the script (optionally collecting command-line args)."
  (interactive "P")
  (unless buffer-file-name
    (error "No file for current buffer"))
  (save-some-buffers t)
  (let* ((line-args (if pre (read-from-minibuffer "Command-line args: ") ""))
         (perl-buffer-file-name (concat "*Perl: " buffer-file-name))
         (buf (and pre (or (get-buffer perl-buffer-file-name)
                           (generate-new-buffer perl-buffer-file-name)))))
    (shell-command
     (concat "perl " (if pre "" "-c ") buffer-file-name " " line-args (if pre " &" ""))
     (if pre buf nil))
    (when pre
      (display-buffer buf))))

(defun make-perl-script ()
  "Mark the current buffer as a perl script and set executable magic."
  (interactive)
  (executable-set-magic "perl" "-w")
  (perl-mode))


;; ------------------------------
;; Python
;; ------------------------------
(setq python-shell-interpreter "python3")
(setq python-shell-completion-native-enable nil)


;; ------------------------------
;; C / C++
;; ------------------------------
(defun c-semi,no-newline-amidst-content ()
  "Control newline insertion after semicolons.
If a comma was inserted, no determination is made. If a semicolon was
inserted and we are not at the end of a block, no newline is inserted.
Otherwise, no determination is made."
  (if (= (c-last-command-char) ?\;)
      (if (save-excursion
            (skip-syntax-forward "->")
            (or (= (point-max) (point))
                (= (char-syntax (char-after)) ?\) )))
          t
        'stop)
    nil))

(c-add-style
 "ctanis"
 '("ellemtel"
   (c-basic-offset . 4)
   (c-offsets-alist
    (case-label . 1)
    (access-label . -)
    (innamespace . [0]))
   (c-hanging-braces-alist
    (substatement-open . before)
    (class-open . before)
    (defun-open . before)
    (block-open . before)
    (brace-list-open)
    (brace-entry-open)
    (statement-case-open . before)
    (extern-lang-open . before)
    (namespace-open . after)
    (namespace-close)
    (inline-open)
    (class-close))
   (c-hanging-semi,criteria .
                        (c-semi,no-newlines-before-nonblanks
                         c-semi,no-newline-amidst-content
                         c-semi,no-newlines-for-oneline-inliners
                         c-semi,inside-parenlist))))

(setq c-default-style "ctanis")

(defvar ctanis-dflt-c-compiler "gcc -Wall ")
(defvar ctanis-dflt-cpp-compiler "g++ -std=c++20 -Wall ")

(defun ctanis-choose-compiler (mode)
  "Return the default compile command prefix for MODE."
  (if (eq mode 'c-mode) ctanis-dflt-c-compiler ctanis-dflt-cpp-compiler))

(with-eval-after-load 'flycheck
  (setq-default flycheck-clang-language-standard "c++20"))

(add-hook 'prog-mode-hook
          #'(lambda ()
              (local-set-key (kbd "C-c C-c") 'compile)))


(add-hook 'c-ts-base-mode-hook
          #'(lambda()
              (c-ts-mode-set-style 'bsd)
              (when (and buffer-file-name
                         (not (locate-dominating-file default-directory "Makefile")))
                (set (make-local-variable 'compile-command)
                     (concat (ctanis-choose-compiler major-mode)
                             (file-name-nondirectory buffer-file-name))))))

(add-hook 'c-mode-common-hook
          (lambda ()
            (local-set-key (kbd "C-c C-c") 'compile)
            (local-set-key (kbd "C-m") 'newline-and-indent)
            (c-toggle-auto-newline -1)
            (c-toggle-hungry-state -1)
            (abbrev-mode -1)
            (cwarn-mode 1)
            (local-set-key (kbd "C-c C-g") 'c-toggle-hungry-state)
            (local-set-key (kbd "C-M-e") 'up-list)
            (local-set-key (kbd "M-o M-e") 'c-end-of-defun)
            ))

(defun indent-omp-pragmas ()
  "Insert file-local cookie to enable zero offset for cpp-macro and set it."
  (interactive)
  (c-set-offset 'cpp-macro 0)
  (save-excursion
    (goto-char (point-min))
    (insert comment-start " -*- mode: "
            (downcase (car (split-string mode-name "/")))
            "; eval: (c-set-offset (quote cpp-macro) 0) -*- " comment-end "\n")))

;; ------------------------------
;; Flycheck: java-single checker and keybindings
;; ------------------------------
(define-key (or (bound-and-true-p craig-prefix-map) (make-sparse-keymap)) (kbd "M-f") 'flycheck-mode)
(define-key (or (bound-and-true-p craig-prefix-map) (make-sparse-keymap)) (kbd "M-p") 'flycheck-previous-error)
(define-key (or (bound-and-true-p craig-prefix-map) (make-sparse-keymap)) (kbd "M-n") 'flycheck-next-error)

(with-eval-after-load 'flycheck
  (flycheck-define-checker java-single
    "Simple single-file checker using javac."
    :command ("javac" "-Xlint" source)
    :error-patterns
    ((error line-start (file-name) ":" line ": error:" (message) line-end)
     (warning line-start (file-name) ":" line ": warning:" (message) line-end))
    :modes java-mode)
  (add-to-list 'flycheck-checkers 'java-single))


;; ------------------------------
;; VC diff tweak (vc-ediff)
;; ------------------------------
(with-eval-after-load 'vc
  (defun vc-diff-build-argument-list-internal (&optional fileset)
    "Build argument list for calling internal diff functions."
    (let* ((vc-fileset (or fileset (vc-deduce-fileset t)))
           (files (cadr vc-fileset))
           (backend (car vc-fileset))
           (first (car files))
           (rev1-default nil))
      (cond
       ((/= (length files) 1) nil)
       ((file-directory-p first) nil)
       ((not (vc-up-to-date-p first))
        (setq rev1-default (vc-working-revision first)))
       (t
        (setq rev1-default (ignore-errors
                             (vc-call-backend backend 'previous-revision first
                                              (vc-working-revision first))))
        (when (string= rev1-default "") (setq rev1-default nil))))
      (let* ((rev1-prompt (format-prompt "Older revision" rev1-default))
             (rev2-prompt (format-prompt "Newer revision" "current source"))
             (rev1 (vc-read-revision rev1-prompt files backend rev1-default))
             (rev2 (vc-read-revision rev2-prompt files backend "<current source>")))
        (when (string= rev1 "") (setq rev1 nil))
        (when (or (string= rev2 "") (string= rev2 "<current source>")) (setq rev2 nil))
        (list files rev1 rev2)))))

;; ------------------------------
;; Tags / xref helpers
;; ------------------------------
(defun etag-xref ()
  "Always show the list of xref definitions, even if only one match."
  (interactive)
  (cl-letf (((symbol-function #'xref--show-xrefs)
             (lambda (xrefs _alist) (xref--show-xrefs xrefs nil))))
    (call-interactively #'xref-find-definitions)))

(setq xref-show-definitions-function #'xref-show-definitions-completing-read)
(when (boundp 'craig-prefix-map)
  (define-key craig-prefix-map "." 'etag-xref))
