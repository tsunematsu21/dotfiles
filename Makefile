SHELL=/bin/zsh
.SHELLFLAGS := -eu -o pipefail -c

SETUP_TARGETS := $(shell awk -F':' '/^[a-z0-9_]+:/ && $$1 != "all" {print $$1}' $(MAKEFILE_LIST))
DEFAULTS_TARGETS := $(shell awk -F':' '/^defaults-[a-z0-9_-]+:/ {print $$1}' $(MAKEFILE_LIST))

.ONESHELL:
.PHONY: $(shell cat $(MAKEFILE_LIST) | awk -F':' '/^[a-z0-9_-]+:/ {print $$1}')

# Run all setup tasks.
all: $(SETUP_TARGETS)

# Configure macOS system preferences.
# See: https://macos-defaults.com/
defaults: $(DEFAULTS_TARGETS)

defaults-dock:
	defaults write com.apple.dock "orientation" -string "bottom" # Position
	defaults write com.apple.dock "tilesize" -int "56" # Icon size
	defaults write com.apple.dock "autohide" -bool true # Auto hide
	defaults write com.apple.dock "autohide-time-modifier" -float "1" # Autohide animation time
	defaults write com.apple.dock "autohide-delay" -float "0" # Autohide delay
	defaults write com.apple.dock "show-recents" -bool false # Show recents
	defaults write com.apple.dock "mineffect" -string "suck" # Minimize animation effect
	defaults write com.apple.dock "scroll-to-open" -bool "true" # Scroll to Exposé app
	# Hot corners
	defaults write com.apple.dock wvous-tl-corner -int 2 # Mission Control
	defaults write com.apple.dock wvous-tl-modifier -int 0
	defaults write com.apple.dock wvous-tr-corner -int 12 # Notification Center
	defaults write com.apple.dock wvous-tr-modifier -int 262144 # Controll key
	defaults write com.apple.dock wvous-bl-corner -int 3 # Show application windows
	defaults write com.apple.dock wvous-bl-modifier -int 0
	defaults write com.apple.dock wvous-br-corner -int 13 # Lock Screen
	defaults write com.apple.dock wvous-br-modifier -int 262144 # Control Key
	killall Dock

defaults-screenshots:
	defaults write com.apple.screencapture "disable-shadow" -bool true
	defaults write com.apple.screencapture "include-date" -bool true
	defaults write com.apple.screencapture "location" -string "~/Pictures" && killall SystemUIServer
	defaults write com.apple.screencapture "show-thumbnail" -bool true
	defaults write com.apple.screencapture "type" -string "png"

defaults-finder:
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
	defaults write com.apple.finder _FXSortFoldersFirst -bool true
	defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
	defaults write com.apple.finder AppleShowAllFiles -bool true
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
	defaults write com.apple.finder FXRemoveOldTrashItems -bool true
	defaults write com.apple.finder ShowStatusBar -bool true
	defaults write com.apple.finder ShowPathbar -bool true
	killall Finder

defaults-other:
	defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -int 1
	defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
	defaults write NSGlobalDomain InitialKeyRepeat -int 15
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
	defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0
	defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
	defaults write NSGlobalDomain com.apple.mouse.scaling -float 3
	defaults write NSGlobalDomain com.apple.trackpad.scaling -int 3
	defaults write com.apple.ActivityMonitor IconType -int 5
	defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
	defaults write com.apple.desktopservices DSDontWriteNetworkStores true
	defaults write com.apple.HIToolbox AppleFnUsageType -int 1

# Install Rosetta 2.
	pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto > /dev/null 2>&1 || \
		sudo softwareupdate --install-rosetta --agree-to-license

# Install Homebrew and packages from the Brewfile.
brew:
	which brew > /dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew analytics off
	brew bundle install --file=./Brewfile --no-upgrade

# Update Homebrew and installed packages.
brew-update: brew
	brew update
	brew upgrade
	brew bundle --file=./Brewfile
	brew cleanup

brew-cleanup:
	brew bundle cleanup --file=./Brewfile --force

# Install the AWS Session Manager plugin.
aws: brew
	curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/session-manager-plugin.pkg" -o "/tmp/session-manager-plugin.pkg"
	sudo installer -pkg /tmp/session-manager-plugin.pkg -target /
	sudo ln -sfn /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/session-manager-plugin

mise:
	mise install

rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
