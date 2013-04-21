#!/bin/bash
latexmk -pdf -pvc $@

## requirements:
##
## ~/.latexmkrc
## $pdf_previewer = 'start open %S';
## $pdf_update_method = 4;
## $pdf_update_command = 'refresh_preview.sh';
##
##
## ~/bin/refresh_preview.sh
## arch -i386 osascript  -e 'tell application "Preview" to activate'
## arch -i386 osascript  -e 'tell application "Emacs" to activate'
