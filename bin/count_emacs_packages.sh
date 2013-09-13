#emacs -Q -batch -l ~/.dotfiles/elisp/ctanis/package-load.el -e get-updatable-count 2>/dev/null |sed -e s/\"//g |terminal-notifier -title "Emacs Updates" -open "osascript -e 'tell application \"Terminal\" to do script with command \"update_emacs.sh\"'"
emacs -Q -batch -l ~/.dotfiles/elisp/ctanis/package-load.el -e get-updatable-count 2>/dev/null |sed -e s/\"//g 
