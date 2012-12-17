;; -*- Mode: Emacs-Lisp; -*- 
;;
;; colors.el
;;
;; James S. Jennings
;; Dept. of Computer Science
;; Tulane University
;;


; Snazzy colors and stuff stolen from whelan@cs.cmu.edu

; Use:  "M-x color" with a prefix arg


(defun set-colors (n)
  "Greg's color setup... Choose a small number as prefix arg. "
  (setq font-lock-no-comments nil)
  (if (turn-on-font-lock-mode)
      (cond
       ((= 7 n)
	(set-background-color "LightGrey")
	(set-foreground-color "Black")
	(set-cursor-color "blue")
	(set-mouse-color "blue")
	(set-face-foreground font-lock-comment-face "darkblue")
	(set-face-foreground font-lock-string-face "darkgreen")
	(set-face-foreground font-lock-function-name-face "darkred")
	(set-face-foreground font-lock-keyword-face "Blue"))
       ((= 8 n)
	(set-background-color "black")
	(set-foreground-color "white")
	(set-cursor-color "red")
	(set-mouse-color "red")
	(set-face-foreground font-lock-comment-face "plum4")
	(set-face-foreground font-lock-keyword-face "#9382db")
	(set-face-foreground font-lock-function-name-face "SeaGreen")
	(set-face-foreground font-lock-string-face "SteelBlue"))
       ((= 9 n)
	(set-background-color "darkslateblue")
	(set-foreground-color "white")
	(set-cursor-color "red")
	(set-mouse-color "red")
	(set-face-foreground font-lock-comment-face "gold")
	(set-face-foreground font-lock-variable-name-face "black")
	(set-face-foreground font-lock-string-face "green")
	(set-face-foreground font-lock-function-name-face "red")
	(set-face-foreground font-lock-keyword-face "gold"))
       ((= 10 n)
	(set-background-color "DarkSlateGray")
	(set-foreground-color "Wheat")
	(set-cursor-color "Orchid")
	(set-mouse-color "Orchid")
	(set-face-foreground font-lock-comment-face "gold")
	(set-face-foreground font-lock-variable-name-face "black")
	(set-face-foreground font-lock-string-face "green")
	(set-face-foreground font-lock-function-name-face "red")
	(set-face-foreground font-lock-keyword-face "gold"))

       ((= 11 n)
	(set-background-color "darkred")
	(set-foreground-color "yellow")
	(set-cursor-color "white")
	(set-mouse-color "white")	
	(set-face-foreground font-lock-comment-face "greenyellow")
	(set-face-foreground font-lock-string-face "lightblue") 
	(set-face-foreground font-lock-keyword-face "orange")
	(set-face-foreground font-lock-function-name-face "white")
	(set-face-foreground font-lock-variable-name-face "lightgrey")
	(set-face-foreground font-lock-reference-face "white")
	(set-face-foreground font-lock-type-face "lightgreen")
	(set-face-background 'highlight "black")
	(set-face-foreground 'modeline "yellow")
	(set-face-background 'modeline "black"))
       
       ((= 12 n)
	(set-background-color "black")	;was darkblue
	(set-foreground-color "khaki")
	(set-cursor-color "white")
;	(setq x-pointer-shape x-pointer-circle)
	(set-mouse-color "magenta")	;this is a comment
	(set-face-foreground font-lock-comment-face "greenyellow")
	(set-face-foreground font-lock-string-face "yellow")
	(set-face-foreground font-lock-keyword-face "cyan")
	(set-face-foreground font-lock-function-name-face "coral")
	(set-face-foreground font-lock-variable-name-face "gold")
	(set-face-foreground font-lock-reference-face "lightgray")
	(set-face-foreground font-lock-type-face "palegreen")
	(set-face-background 'highlight "black")
	(set-face-foreground 'highlight "white")
	(set-face-foreground 'modeline "black")
	(set-face-background 'modeline "khaki")
	(set-face-foreground 'region "black")
	(set-face-background 'region "green"))

       ((= 13 n)
	(set-background-color "darkslateblue")
	(set-foreground-color "khaki")
	(set-cursor-color "green")
	(set-mouse-color "greenyellow")	;this is a comment
	(set-face-foreground font-lock-comment-face "greenyellow")
	(set-face-foreground font-lock-string-face "yellow")
	(set-face-foreground font-lock-keyword-face "cyan")
	(set-face-foreground font-lock-function-name-face "coral")
	(set-face-foreground font-lock-variable-name-face "gold")
	(set-face-foreground font-lock-reference-face "lightgray")
	(set-face-foreground font-lock-type-face "palegreen")
	(set-face-background 'highlight "black")
	(set-face-foreground 'modeline "black")
	(set-face-background 'modeline "khaki")
	(set-face-foreground 'region "black")
	(set-face-background 'region "green"))
       
       ((= 14 n)
	(set-background-color "darkslategray")	;was darkblue
	(set-foreground-color "white")
	(set-cursor-color "orange")
	; (setq x-pointer-shape x-pointer-circle)
	(set-mouse-color "yellow")	;this is a comment
	(set-face-foreground font-lock-comment-face "cyan")
	(set-face-foreground font-lock-string-face "khaki")
	(set-face-foreground font-lock-keyword-face "magenta")
	(set-face-foreground font-lock-function-name-face "red")
	(set-face-foreground font-lock-variable-name-face "yellow")
	(set-face-foreground font-lock-reference-face "orange")
	(set-face-foreground font-lock-type-face "greenyellow")
	(set-face-background 'highlight "darkslategray")
	(set-face-foreground 'highlight "khaki")
	(set-face-foreground 'modeline "black")
	(set-face-background 'modeline "khaki")
	(set-face-foreground 'region "black")
	(set-face-background 'region "green"))


       ((= 6 n)
	(set-background-color "darkgrey")
	(set-foreground-color "black")
	(set-cursor-color "white")
	(set-mouse-color "white")
	(set-face-foreground font-lock-comment-face "blue")
	(set-face-foreground font-lock-variable-name-face "black")
	(set-face-foreground font-lock-string-face "Black")
	(set-face-foreground font-lock-function-name-face "Gold")
	(set-face-foreground font-lock-keyword-face "darkred"))
       ((= 5 n)
	(set-background-color "darkgreen")
	(set-foreground-color "white")
	(set-cursor-color "white")
	(set-mouse-color "white")
	(set-face-foreground font-lock-comment-face "MediumSpringGreen")
	(set-face-foreground font-lock-variable-name-face "black")
	(set-face-foreground font-lock-string-face "SteelBlue1")
	(set-face-foreground font-lock-function-name-face "Gold")
	(set-face-foreground font-lock-keyword-face "LightSalmon"))
       ((= 4 n)
	(set-background-color "navyblue")
	(set-foreground-color "white")
	(set-cursor-color "white")
	(set-mouse-color "white")
	(set-face-foreground font-lock-comment-face "MediumSpringGreen")
	(set-face-foreground font-lock-string-face "PaleTurquoise")
	(set-face-foreground font-lock-variable-name-face "LightSalmon")
	(set-face-foreground font-lock-keyword-face "LightSalmon")
	(set-face-foreground font-lock-function-name-face "Orange"))
       ((= 3 n)
	(set-background-color "darkslategrey")
	(set-foreground-color "white")
	(set-cursor-color "white")
	(set-mouse-color "white")
	(set-face-foreground font-lock-comment-face "MediumSpringGreen")
	(set-face-foreground font-lock-string-face "PaleTurquoise")
	(set-face-foreground font-lock-variable-name-face "DarkSalmon")
	(set-face-foreground font-lock-keyword-face "LightSalmon")
	(set-face-foreground font-lock-function-name-face "Orange"))
       ((= 2 n)
	(set-background-color "black")
	(set-foreground-color "white")
	(set-cursor-color "white")
	(set-mouse-color "white")
	(set-face-foreground font-lock-comment-face "white")
	(set-face-foreground font-lock-string-face "white")
	(set-face-foreground font-lock-variable-name-face "black")
	(set-face-foreground font-lock-function-name-face "white")
	(set-face-foreground font-lock-keyword-face "white"))
       ((= 1 n)				; Nominal settings
	(set-background-color "white")
	(set-foreground-color "black")
	(set-cursor-color "black")
	(set-mouse-color "black")
	(set-face-foreground font-lock-comment-face "black")
	(set-face-foreground font-lock-string-face "black")
	(set-face-foreground font-lock-function-name-face "black")
	(set-face-foreground font-lock-variable-name-face "black")
	(set-face-foreground font-lock-keyword-face "black"))
       ((= 0 n)				; Black and White
	(set-background-color "white")
	(set-foreground-color "black")
	(set-cursor-color "black")
	(set-mouse-color "black")
	(setq font-lock-comment-face 'bold)
;	(setq font-lock-function-name-face nil)
;	(setq font-lock-variable-name-face nil)
	(setq font-lock-keyword-face 'bold))
       ((= 15 n)
	(set-background-color "midnightblue")
	(set-foreground-color "khaki")
	(set-cursor-color "green")
	(set-mouse-color "greenyellow")	;this is a comment
	(set-face-foreground font-lock-comment-face "greenyellow")
	(set-face-foreground font-lock-string-face "yellow")
	(set-face-foreground font-lock-keyword-face "cyan")
	(set-face-foreground font-lock-function-name-face "coral")
	(set-face-foreground font-lock-variable-name-face "gold")
	(set-face-foreground font-lock-reference-face "lightgray")
	(set-face-foreground font-lock-type-face "palegreen")
	(set-face-background 'highlight "black")
	(set-face-foreground 'modeline "black")
	(set-face-background 'modeline "khaki")
	(set-face-foreground 'region "black")
	(set-face-background 'region "green"))

       ((= 16 n)
	(set-background-color "#223012")
	(set-foreground-color "white")
	(set-cursor-color "orange")
	(set-mouse-color "yellow")	;this is a comment
	(set-face-foreground font-lock-comment-face "#FB8285")
	(set-face-foreground font-lock-string-face "lightgreen")
	(set-face-foreground font-lock-keyword-face "gold")
	(set-face-foreground font-lock-function-name-face "red")
	(set-face-foreground font-lock-variable-name-face "white")
	(set-face-foreground font-lock-reference-face "lightgray")
	(set-face-foreground font-lock-type-face "gold")
	(set-face-background 'highlight "orange")
	(set-face-foreground 'highlight "black")
	(set-face-foreground 'modeline "black")
	(set-face-background 'modeline "khaki")
	(set-face-foreground 'region "black")
	(set-face-background 'region "lightgreen"))
   
       ((= 17 n)
	(set-background-color "antiquewhite")
	(set-foreground-color "darkred")
	(set-cursor-color "darkred")
	(set-mouse-color "darkred")
	(set-face-foreground font-lock-comment-face "darkslategrey")
	(set-face-foreground font-lock-string-face "navyblue")
	(set-face-foreground font-lock-keyword-face "black")
	(set-face-foreground font-lock-function-name-face "blue")
	(set-face-foreground font-lock-variable-name-face "blue")
	(set-face-foreground font-lock-reference-face "red")
	(set-face-foreground font-lock-type-face "black")
	(set-face-foreground font-lock-preprocessor-face "darkgreen")
	(set-face-background 'modeline "darkred")
	(set-face-foreground 'modeline "antiquewhite")
	(set-face-background 'modeline-inactive "antiquewhite")
	(set-face-foreground 'modeline-inactive "darkred")
	(set-face-background 'isearch "blue")
	)

       ((= 18 n)
	(set-cursor-color "orange")
	(set-background-color "#191919")
	(set-foreground-color "antiquewhite")
	(set-face-background 'modeline "orange")
	(set-face-background 'modeline-inactive "#505050")
	(set-face-foreground 'modeline "black")
	(set-face-foreground 'modeline-inactive "black")

	(set-face-foreground font-lock-string-face "lightblue")
	(set-face-foreground font-lock-comment-face "darkgrey")

	(set-face-foreground font-lock-function-name-face "gold")
	(set-face-foreground font-lock-constant-face "orange")
	(set-face-foreground font-lock-variable-name-face "red")
	(set-face-foreground font-lock-reference-face "magenta")

	(set-face-foreground font-lock-keyword-face "darkkhaki")
	(set-face-foreground font-lock-preprocessor-face "tomato")
	(set-face-foreground font-lock-type-face "darkkhaki")
  

	(set-face-background 'match "#606050")
	(set-face-background 'isearch-lazy-highlight-face "#606050")

	(set-face-background 'fringe "#202020")
	(set-face-foreground 'fringe "darkred")

;	(set-face-foreground 'dired-marked "lightblue")
	(set-face-background 'isearch "darkred")
	(set-face-foreground 'isearch "antiquewhite")
	(set-face-background 'highlight "darkred")

	(set-face-foreground 'comint-highlight-prompt "cyan")
	(set-face-foreground 'comint-highlight-input "yellow")

	)


       (t (error "Invalid selection")))))



(defvar *color-selection* 0)


;(defun turn-on-font-lock-mode ()
;  (interactive)
;  (let ((terminal (getenv "TERM")))
;    (cond 
;     ((not (or (string= terminal "vt100")
;               (string= terminal "vt220")
;               (string= terminal "xterm")
;               (string= terminal "xterms")
;               (string= terminal "vt320")))
;      (font-lock-mode 1)
;      t)
;     (t (message "Not fontifying on ascii terminal...")
;        nil))))

(defun turn-on-font-lock-mode ()
  (interactive)
  (cond (window-system
	 (font-lock-mode 1)
	 t)
	(t (message "Not fontifying on ascii terminal...")
	   nil)))

(defun color (n)
  (interactive "p")
  (setq *color-selection* n)
  (set-colors *color-selection*))


(defvar default-to-fill-mode nil)
(make-variable-buffer-local 'default-to-fill-mode)

(defun auto-fill-and-color ()
  (if default-to-fill-mode (turn-on-auto-fill))
  (color *color-selection*))		; turns on font-lock-mode if possible


;; this highlights very little
(defvar scheme-font-lock-keywords       ; the newline, tabs, and spaces are important!
  '(("(def[-a-z]+\\s +\\([^	    
)]+\\)" 1 font-lock-function-name-face) ("\\s :\\(\\(\\sw\\|\\s_\\)+\\)\\>" . 1)))


;; this highlights a lot
(defvar scheme-font-lock-keywords-1	; the newline, tabs, and spaces are important!
  '(("^(def[-a-z]+\\s +\\([^ 	
)]+\\)" 1 font-lock-function-name-face)
("\\s :\\(\\(\\sw\\|\\s_\\)+\\)\\>" . 1)
("(\\(cond\\|if\\|lambda\\|begin\\)[ 	
]" . 1)
 ("(\\(while\\|do\\|let\\|let\\*\\|letrec\\)[ 	
]" . 1)
 ("(\\(call-with-current-continuation\\)[ 	
]" . 1)
 ("(\\(and\\|or\\|not\\)[ 	
]" . 1)
("(\\(dynamic-wind\\|set!\\)[	 	
]" . 1)
 ("\\\\\\\\\\[\\([^]\\
]+\\)]" 1 font-lock-keyword-face t)
 ("`\\([-a-zA-Z0-9_][-a-zA-Z0-9_][-a-zA-Z0-9_.]+\\)'" 1 font-lock-keyword-face t)))


(defun auto-fill-and-color-for-tex ()
  (cond ((turn-on-font-lock-mode)
	 (setq font-lock-keywords tex-font-lock-keywords)
	 (auto-fill-and-color))))

(defun auto-fill-and-color-for-lisp ()
  (setq font-lock-keywords lisp-font-lock-keywords-2)
  (auto-fill-and-color))

(defun auto-fill-and-color-for-scheme ()
  (setq font-lock-keywords scheme-font-lock-keywords)
  (auto-fill-and-color))

;what the hell is this?

;(defun fix-gdb-keys ()
;  (font-lock-mode 1)
;  (global-set-key '[?\M-c]' gud-cont)
;  (global-set-key '[?\M-n]' gud-next)
;  (global-set-key '[?\M-s]' gud-step)
;  (global-set-key '[?\M-s]' gud-up))

;;; Set the mode hooks for some common modes
(add-hook 'lisp-mode-hook	'auto-fill-and-color)
(add-hook 'emacs-lisp-mode-hook 'auto-fill-and-color-for-lisp)
(add-hook 'scheme-mode-hook	'auto-fill-and-color-for-scheme)
(add-hook 'inferior-scheme-mode-hook 'auto-fill-and-color-for-scheme)
;(add-hook 'text-mode-hook	'auto-fill-and-color)
(add-hook 'c++-mode-hook	'auto-fill-and-color)
(add-hook 'c-mode-hook		'auto-fill-and-color)
(add-hook 'c-mode-common-hook   'auto-fill-and-color)
(add-hook 'shell-mode-hook	'auto-fill-and-color)
(add-hook 'sh-mode-hook         'auto-fill-and-color)
(add-hook 'tcl-mode-hook	'auto-fill-and-color)
(add-hook 'tex-mode-hook	'auto-fill-and-color-for-tex)
(add-hook 'latex-mode-hook	'auto-fill-and-color-for-tex)
(add-hook 'asm-mode-hook        'auto-fill-and-color)
(add-hook 'perl-mode-hook       'auto-fill-and-color)
(add-hook 'awk-mode-hook        'auto-fill-and-color)
;(add-hook 'gdb-mode-hook	'fix-gdb-keys)



(defvar scheme-font-lock-keywords
  (eval-when-compile
    (list
     ;;
     ;; Declarations.  Hannes Haug <hannes.haug@student.uni-tuebingen.de> says
     ;; this works for SOS, STklos, SCOOPS, Meroon and Tiny CLOS.
     (list (concat "(\\(define\\("
		   ;; Function names.
		   "\\(\\|-\\(generic\\(\\|-procedure\\)\\|method\\)\\)\\|"
		   ;; Macro names, as variable names.  A bit dubious, this.
		   "\\(-syntax\\)\\|"
		   ;; Record names
		   "\\(-record-type\\)\\|"
		   ;; Class names.
		   "\\(-class\\|-structure\\|-package\\|-interface\\)"
		   "\\)\\)\\>"
		   ;; Any whitespace and declared object.
		   "[ \t]*(?"
		   "\\(\\sw+\\)?")
	   '(1 font-lock-keyword-face)
	   '(9 (cond ((match-beginning 3) font-lock-function-name-face)
		     ((match-beginning 6) font-lock-variable-name-face)
		     ;(t font-lock-type-face))
		     (t font-lock-type-face))
	       nil t))
     ;;
     ;; Control structures.
;(make-regexp '("begin" "call-with-current-continuation" "call/cc"
;	       "call-with-input-file" "call-with-output-file" "case" "cond"
;	       "do" "else" "for-each" "if" "lambda"
;	       "let\\*?" "let-syntax" "letrec" "letrec-syntax"
;	       ;; Hannes Haug <hannes.haug@student.uni-tuebingen.de> wants:
;	       "and" "or" "delay"
;	       ;; Stefan Monnier <stefan.monnier@epfl.ch> says don't bother:
;	       ;;"quasiquote" "quote" "unquote" "unquote-splicing"
;	       "map" "syntax" "syntax-rules"))
     (cons
      (concat "(\\("
	      "and\\|begin\\|c\\(a\\(ll\\(-with-\\(current-continuation\\|"
	      "input-file\\|output-file\\)\\|/cc\\)\\|se\\)\\|ond\\)\\|"
	      "d\\(elay\\|o\\)\\|else\\|for-each\\|if\\|"
	      "l\\(ambda\\|et\\(-syntax\\|\\*?\\|rec\\(\\|-syntax\\)\\)\\)\\|"
	      "map\\|or\\|syntax\\(\\|-rules\\)"
	      "\\)\\>") 1)
     ;;
     ;; David Fox <fox@graphics.cs.nyu.edu> for SOS/STklos class specifiers.
     '("\\<<\\sw+>\\>" . font-lock-type-face)
     ;;
     ;; Scheme `:' keywords as references.
     '("\\<:\\sw+\\>" . font-lock-reference-face)
     '("(\\(access\\|export\\|files\\|open\\)\\>" . font-lock-reference-face)
     ))
"Default expressions to highlight in Scheme modes.")

