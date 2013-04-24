#expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

#expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable Resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true


# Make ~/Library visible in Finder
chflags nohidden ~/Library/


# allow key repeat
defaults write -g ApplePressAndHoldEnabled -bool false


# turn off application saving window state
defaults write -g NSQuitAlwaysKeepsWindows -bool false

# some exceptions
defaults write com.mindnode.MindNodePro NSQuitAlwaysKeepsWindows -bool true
defaults write com.pixelmatorteam.pixelmator NSQuitAlwaysKeepsWindows -bool true


# defaults write com.apple.Preview NSQuitAlwaysKeepsWindows -bool false
# defaults write com.apple.Terminal NSQuitAlwaysKeepsWindows -bool false


# remove new window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO

# speed up mission control (not space switching)
defaults write com.apple.dock expose-animation-duration -float 0.05

# speed up arrival of Dock
defaults write com.apple.Dock autohide-delay -float 0



# some exceptions
#defaults write -g AppleShowScrollBars -string Automatic
defaults write -g AppleShowScrollBars -string Always
defaults write at.EternalStorms.Yoink AppleShowScrollBars -string WhenScrolling
defaults write com.apple.Terminal AppleShowScrollBars -string WhenScrolling
# defaults write org.gnu.Emacs AppleShowScrollBars -string WhenScrolling
defaults write com.pixelmatorteam.pixelmator AppleShowScrollBars -string WhenScrolling
defaults write com.apple.iCal AppleShowScrollBars -string WhenScrolling
defaults write com.apple.Preview AppleShowScrollBars -string WhenScrolling


# enable airdrop with older macs -- not enabled by default
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
# (see http://www.macsessed.com/posts/how-to-use-airdrop-on-your-older-macs/)


# no DS_Store on network drives!
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# enable selecting text in quick look preview
defaults write -g QLEnableTextSelection -bool TRUE;

# hold window against side for 2 seconds before moving to next workspace
# (better for BetterSnapTool)
defaults write com.apple.dock workspaces-edge-delay -float 2.0


# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false


# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false


# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Don't Group windows by application in Mission Control
defaults write com.apple.dock "expose-group-by-app" -bool false

# Don’t show Dashboard as a Space
defaults write com.apple.dock "dashboard-in-overlay" -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Disable the Ping sidebar in iTunes
defaults write com.apple.iTunes disablePingSidebar -bool true

# Disable all the other Ping stuff in iTunes
defaults write com.apple.iTunes disablePing -bool true

