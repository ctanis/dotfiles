tell application "Dock"
	activate
end tell
try
	set oldvalue to output muted of (get volume settings)
	set volume output muted 1
	tell application "System Events"
		tell process "Dock"
			set frontmost to true
			activate
			tell list 1
				perform action "AXShowMenu" of UI element "Finder"
				delay 0.25
				repeat 9 times -- count number of items to the one you want
					key code 125 -- down arrow
				end repeat
				delay 0.25
				repeat 1 times
					key code 36 -- return key
				end repeat
			end tell
		end tell
	end tell
	
	
on error
	
end try
delay 5
set volume output muted oldvalue