# dotfiles
My macOS dotfiles.

## Setup instructions

### 1. Command line operations

```sh
# Select the host configuration
export DOTFILES_HOSTNAME=matcha

# Install Nix, set up the system, and deploy dotfiles
sh -c "$(curl -sSfL https://github.com/tsunematsu21/dotfiles/raw/main/bootstrap.sh)"

# Refresh shell
exec -l "$SHELL"

# Build and compare without applying the configuration
dotfiles diff

# Update flake inputs and compare without applying the configuration
dotfiles update

# Apply the configuration
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

* **Loop**
  * Configure shortcuts and appearance in the app

## Uninstall

```sh
sudo darwin-uninstaller
/nix/nix-installer uninstall
```
