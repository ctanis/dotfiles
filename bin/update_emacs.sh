#! /bin/bash
# run list-packages with a properly configured package manager in an
# otherwise-untouched console emacs session
#emacs -Q -nw -l ~/.dotfiles/elisp/ctanis/package-load.el -e list-packages
emacs -Q -nw -l ~/.dotfiles/scripts/do-update-emacs.el

