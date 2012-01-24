#!/bin/bash

## change the theme (color settings) of the frontmost terminal window

if [ "$1" != "" ]; then
  osascript -e 'tell application "Terminal" to set current settings of first window to settings set named "'"$1"'"'
  else
  osascript -e 'tell application "Terminal" to set current settings of first window to (settings set (random number from 1 to count of settings set))'
fi

