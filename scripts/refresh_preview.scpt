tell application "System Events" 
     set appname to name of the first process whose frontmost is true
end tell
tell application "Preview" to activate
tell application appname to activate
