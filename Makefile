SHELL=/bin/zsh

.ONESHELL:
.PHONY: $(shell cat $(MAKEFILE_LIST) | awk -F':' '/^[a-z0-9_-]+:/ {print $$1}')

all: $(shell cat $(MAKEFILE_LIST) | awk -F':' '/^[a-z0-9_-]+:/ && !/^all:/ {print $$1}' )

defaults:
	defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -int 1
	defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
	defaults write NSGlobalDomain InitialKeyRepeat -int 15
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain com.apple.trackpad.scaling -int 3

	defaults write com.apple.screencapture disable-shadow -bool true
	defaults write com.apple.desktopservices DSDontWriteNetworkStores true

	defaults write com.apple.finder AppleShowAllFiles -bool true
	defaults write com.apple.finder ShowStatusBar -bool true
	defaults write com.apple.finder ShowPathbar -bool true
	killall Finder

	defaults write com.apple.dock mru-spaces -bool false
	killall Dock

rosetta:
	sudo softwareupdate --install-rosetta --agree-to-license

brew:
	which brew > /dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew analytics off
	brew update
	brew upgrade
	brew cleanup
	brew bundle --file=./Brewfile

aws: brew
	curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/session-manager-plugin.pkg" -o "/tmp/session-manager-plugin.pkg"
	sudo installer -pkg /tmp/session-manager-plugin.pkg -target /
	sudo ln -s /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/session-manager-plugin

dotfiles: brew
	mkdir -p ~/.config
	mkdir -p ~/Developments
	stow -v -t ~ -S aws gh git ssh starship zsh
