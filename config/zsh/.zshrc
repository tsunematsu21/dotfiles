# Sheldon
eval "$(sheldon source)"

# Starship
eval "$(starship init zsh)"

# mise
eval "$(mise activate zsh --shims)"

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# zoxide
eval "$(zoxide init zsh --cmd cd)"

# Environment variables
export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$(go env GOPATH)/bin:$PATH"
export EDITOR="nvim"

# Completion
setopt extendedglob

typeset -g ZCOMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

autoload -Uz compinit
if [[ -n "${ZCOMPDUMP}"(#qN.mh+24) ]]; then
  compinit
  touch "${ZCOMPDUMP}"
else
  compinit -C
fi

autoload -Uz bashcompinit && bashcompinit

complete -C aws_completer aws
source <(mise completion zsh)
source <(npm completion zsh)
source <(pnpm completion zsh)

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
_comp_options+=(globdots)
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:*:make:*' tag-order 'targets'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555,underline"
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history)

# Alias
alias ls='ls -GF'
alias ll='ls -lGF'
alias account='defaults read MobileMeAccounts Accounts | grep AccountID | cut -d \" -f2'

# Suffix alias
alias -s {tar.gz,tgz}='tar -xzvf'
alias -s zip='unzip'
alias -s html='open'
alias history='history -i'

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

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_ignore_all_dups
setopt share_history
setopt extended_history

# Other options
setopt interactive_comments
setopt print_exit_value
