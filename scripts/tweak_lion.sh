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


# defaults write com.apple.Preview NSQuitAlwaysKeepsWindows -bool false
# defaults write com.apple.Terminal NSQuitAlwaysKeepsWindows -bool false


# remove new window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO

# speed up mission control (not space switching)
defaults write com.apple.dock expose-animation-duration -float 0.1

#always show scroll bars
defaults write -g AppleShowScrollBars -string Always

# some exceptions
defaults write at.EternalStorms.Yoink AppleShowScrollBars -string WhenScrolling
defaults write com.apple.Terminal AppleShowScrollBars -string WhenScrolling
defaults write org.gnu.Emacs AppleShowScrollBars -string WhenScrolling


# enable airdrop with older macs -- not enabled by default
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
# (see http://www.macsessed.com/posts/how-to-use-airdrop-on-your-older-macs/)


# no DS_Store on network drives!
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# enable selecting text in quick look preview
defaults write com.apple.finder QLEnableTextSelection -bool TRUE;


# hold window against side for 2 seconds before moving to next workspace
# (better for BetterSnapTool)
defaults write com.apple.dock workspaces-edge-delay 2
