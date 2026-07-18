#!/bin/sh

set -eu

case "$(uname -s)" in
  Darwin) ;;
  *)
    echo "Unsupported operating system: $(uname -s)" >&2
    exit 1
    ;;
esac

if [ "$#" -eq 0 ]; then
  host_name="$(hostname -s)"
elif [ "$#" -eq 2 ] && [ "$1" = "--hostname" ] && [ -n "$2" ]; then
  host_name="$2"
else
  echo "Usage: install.sh [--hostname <hostname>]" >&2
  exit 2
fi

if [ -x /nix/nix-installer ]; then
  echo "Nix is already installed; skipping nix-installer."
elif [ -x /nix/var/nix/profiles/default/bin/nix ]; then
  echo "Nix is already installed, but not by nix-installer." >&2
  exit 1
else
  curl -sSfL https://artifacts.nixos.org/nix-installer | \
    sh -s -- install --enable-flakes \
      --extra-conf 'trusted-users = root masato.tsunematsu'
fi

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

if [ -d "$HOME/dotfiles/.git" ]; then
  echo "Using existing repository at $HOME/dotfiles"
elif [ -e "$HOME/dotfiles" ]; then
  echo "$HOME/dotfiles exists but is not a Git repository." >&2
  exit 1
elif xcode-select -p >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
  git clone https://github.com/tsunematsu21/dotfiles.git "$HOME/dotfiles"
else
  nix shell nixpkgs#git -c \
    git clone https://github.com/tsunematsu21/dotfiles.git "$HOME/dotfiles"
fi

cd "$HOME/dotfiles"

sudo /nix/var/nix/profiles/default/bin/nix run 'nix-darwin/master#darwin-rebuild' -- \
  switch --flake "$HOME/dotfiles#$host_name"

echo "Installation complete. Refresh the shell with:"
echo "  exec -l \"\$SHELL\""
