#!/bin/bash

## change the theme (color settings) of the frontmost terminal window

if [ "$1" != "" ]; then
  osascript -e 'tell application "Terminal" to set current settings of first window to settings set '$1
  else
  osascript -e 'tell application "Terminal" to set current settings of first window to default settings'
fi

osascript -e 'tell application "Terminal" to name of current settings of first window'
