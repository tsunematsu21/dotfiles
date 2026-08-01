# dotfiles

My macOS dotfiles.

## Install

Use the name of a host configuration in `flake.nix`. This installs Nix, clones this repository, and
applies the configuration.

```sh
# Choose a host
export DOTFILES_HOSTNAME=matcha

# Install and apply
sh -c "$(curl -sSfL https://github.com/tsunematsu21/dotfiles/raw/main/bootstrap.sh)"

# Restart the shell
exec -l "$SHELL"
```

## Set up accounts

These steps are optional. Run them only when you use the service.

### GitHub

Create an SSH key, add it to the macOS keychain, and use it for GitHub commit signing.

```sh
# Create an SSH key
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_tsunematsu21

# Add the key to the macOS keychain
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_tsunematsu21

# Log in to GitHub
gh auth login

# Add the signing key to GitHub
gh auth refresh -h github.com -s admin:ssh_signing_key
gh ssh-key add ~/.ssh/id_ed25519_tsunematsu21.pub \
  --title tsunematsu21.pub-`date '+%Y%m%d'` \
  --type signing
```

### AWS

Configure an IAM Identity Center profile and SSO session.

```sh
aws configure sso
```

## Configure apps manually

### [OmniWM](https://github.com/BarutSRB/OmniWM)

- Allow OmniWM in **System Settings > Privacy & Security > Accessibility**.
- Turn off **Displays have separate Spaces** in **System Settings > Desktop & Dock > Mission Control**.
- Log out and log back in.

### [Tuna](https://tunaformac.com/)

- Launch Tuna once to finish onboarding.
- Confirm that the managed hotkeys work.

## Daily commands

### See pending changes

Build the configuration and compare it with the current system. This does not apply changes.

```sh
dotfiles diff
```

### Apply changes

Build and apply the current configuration.

```sh
dotfiles rebuild
```

### Update dependencies

Update `flake.lock`, then show the system changes. This modifies the working tree.

```sh
dotfiles update
```

### Update Homebrew packages

Homebrew packages are not updated by `dotfiles rebuild`. Update them explicitly,
review any application-generated configuration changes, then rebuild to restore
the declarative links.

```sh
brew update
brew outdated
brew upgrade
dotfiles rebuild
git diff
```

## Uninstall

```sh
sudo darwin-uninstaller
/nix/nix-installer uninstall
```
