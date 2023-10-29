# starship
eval "$(starship init zsh)"

# asdf
. "$(brew --prefix asdf)/libexec/asdf.sh"

# direnv
eval "$(direnv hook zsh)"

# Environment variables
export LANG=ja_JP.UTF-8

# Auto load
autoload -Uz compinit && compinit

# Alias
alias ls='ls -GF'
alias ll='ls -lGF'
alias cdk='npx aws-cdk'
alias cdk-init='npx aws-cdk init --language typescript'
alias account='defaults read MobileMeAccounts Accounts | grep AccountID | cut -d \" -f2'

# Suffix alias
alias -s {tar.gz,tgz}='tar -xzvf'
alias -s zip='unzip'
alias -s html='open'

# Global alias
alias -g A='| awk'
alias -g C='| wc -l'
alias -g G='| grep --color=auto'
alias -g H='| head'
alias -g J='| jq'
alias -g L='| less -R'
alias -g T='| tail'

# Change directory
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
cdpath=(.. ~ ~/Developments)

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_reduce_blanks
setopt hist_verify
setopt share_history

# Other options
setopt print_exit_value
