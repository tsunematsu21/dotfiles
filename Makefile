SHELL=/bin/zsh
.SHELLFLAGS := -eu -o pipefail -c

.ONESHELL:
.PHONY: $(shell cat $(MAKEFILE_LIST) | awk -F':' '/^[a-z0-9_-]+:/ {print $$1}')

help: ## Display help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install nix and run nix-darwin/rebuild
	curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && \
	sudo -E nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake .#mac

check: ## Check flake outputs without building
	nix flake check --no-build

rebuild: ## Run darwin-rebuild
	sudo darwin-rebuild switch --flake .#mac

upgrade: ## Upgrade nix
	sudo -i nix upgrade-nix

uninstall: ## Uninstall nix-darwin and nix
	sudo darwin-uninstaller
	/nix/nix-installer uninstall
