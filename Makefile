SHELL=/bin/zsh
.SHELLFLAGS := -eu -o pipefail -c

.ONESHELL:
.PHONY: $(shell cat $(MAKEFILE_LIST) | awk -F':' '/^[a-z0-9_-]+:/ {print $$1}')

help: ## Display help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install nix and run nix-darwin/rebuild
	curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
	$(MAKE) trust-admin
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && \
	sudo -E nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake .#mac

check: ## Check flake outputs without building
	nix flake check --no-build

lint: ## Lint Nix files
	statix check .
	deadnix --fail .

format: ## Format files
	nix fmt

update: update-nix update-brew ## Update flake inputs and Homebrew packages

update-nix: ## Update flake inputs
	nix flake update

update-brew: ## Update Homebrew packages
	brew update
	brew upgrade
	brew upgrade --cask

versions: ## Show Home Manager and Homebrew package versions
	@echo '[home-manager]'
	@user=$$(id -un); \
	hm_path=$$(readlink /etc/profiles/per-user/$$user/bin/rg | grep -o '/nix/store/[^/]*/bin' | sed 's#/bin$$##'); \
	nix-store -q --references "$$hm_path" | sed -E 's#.*/[0-9a-z]{32}-##' | sort
	@echo
	@echo '[homebrew formula]'
	@HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_FROM_API=1 brew list --formula --versions
	@echo
	@echo '[homebrew cask]'
	@HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_FROM_API=1 brew list --cask --versions

trust-admin: ## Trust macOS admin users for Nix
	sudo touch /etc/nix/nix.custom.conf
	grep -qxF 'trusted-users = root @admin' /etc/nix/nix.custom.conf || \
	echo 'trusted-users = root @admin' | sudo tee -a /etc/nix/nix.custom.conf > /dev/null
	sudo launchctl kickstart -k system/org.nixos.nix-daemon

rebuild: ## Run darwin-rebuild
	sudo darwin-rebuild switch --flake .#mac

upgrade: ## Upgrade nix
	sudo -i nix upgrade-nix

uninstall: ## Uninstall nix-darwin and nix
	sudo darwin-uninstaller
	/nix/nix-installer uninstall
