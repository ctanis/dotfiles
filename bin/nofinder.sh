if [ $1 ]; then
 sleep $1
fi

osascript ~/.dotfiles/scripts/finder-undock.applescript

## assumes that Path Finder has been used to enable the Finder's
## remove menu item in the dock
