# dotfiles
My macOS dotfiles.

## Setup instructions
### 1. Command line operations
Most operations are performed automatically by Makefile, but some operations must be performed manually.
```sh
# Get this repository
git clone https://github.com/tsunematsu21/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Setup system preferences, Install packages, Deploy dotfiles
make

# Refresh shell
exec -l $SHELL

# Install global tools by mise
mise install

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
* **Warp**
  * Settings > Appearance
    * Prompt: Shell prompt (PS1)
    * Text > Terminal font: FiraCode Nerd Font Mono
* **Raycast**
  * Settings > Advanced
    * Import / Export: Import the exported `.rayconfig` file


## Useful commands
```sh
# Unstow(-D)/Restow(-R) the dotfiles.
stow -v -t ~ -D aws gh git ssh starship zsh ghostty sheldon mise
stow -v -t ~ -R aws gh git ssh starship zsh ghostty sheldon mise

# List/Uninstall(--force) all dependencies not listed from the Brewfile.
brew bundle cleanup --file=./Brewfile
brew bundle cleanup --file=./Brewfile --force

# Install only
brew bundle install --file=./Brewfile --no-upgrade
```
