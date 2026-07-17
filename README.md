# dotfiles
My macOS dotfiles.

## Setup instructions

### 1. Command line operations

```sh
# Get this repository
git clone https://github.com/tsunematsu21/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install Nix
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes

# Trust macOS admin users for Nix
sudo touch /etc/nix/nix.custom.conf
grep -qxF 'trusted-users = root @admin' /etc/nix/nix.custom.conf || \
  echo 'trusted-users = root @admin' | sudo tee -a /etc/nix/nix.custom.conf > /dev/null
sudo launchctl kickstart -k system/org.nixos.nix-daemon

# Setup system preferences, Install packages, Deploy dotfiles
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
sudo -E nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake .#MacBook-Air

# Refresh shell
exec -l $SHELL

# Update or apply the configuration
dotfiles update
dotfiles rebuild

# Create SSH key with passphrase
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_tsunematsu21

# Add SSH key to ssh-agent with passphrase
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_tsunematsu21

# Login to GitHub using CLI
gh auth login

# Add signing key to GitHub
gh auth refresh -h github.com -s admin:ssh_signing_key
gh ssh-key add ~/.ssh/id_ed25519_tsunematsu21.pub \
  --title tsunematsu21.pub-`date '+%Y%m%d'` \
  --type signing

# Configure both an IAM Identity Center profile and sso-session 
aws configure sso
```

### 2. Manual operations

Configure application settings.

* **Raycast**
  * Settings > Advanced
    * Import / Export: Import the exported `.rayconfig` file

## Uninstall

```sh
sudo darwin-uninstaller
/nix/nix-installer uninstall
```
