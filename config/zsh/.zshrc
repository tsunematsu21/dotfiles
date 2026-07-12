# zmodload zsh/zprof

# Environment variables
export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export PATH="${GOPATH:-$HOME/go}/bin:$PATH"
export PATH="$HOME/.safe-chain/shims:$PATH"

# Sheldon
eval "$(sheldon source)"

# Completion
setopt extendedglob

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:*:make:*' tag-order 'targets'

typeset -g ZCOMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

autoload -Uz compinit
if [[ -n "${ZCOMPDUMP}"(#qN.mh+24) ]]; then
  compinit
  touch "${ZCOMPDUMP}"
else
  compinit -C
fi

autoload -Uz bashcompinit
bashcompinit
complete -C aws_completer aws

# Lazy completions
_mise() {
  unfunction "$0"
  eval "$(mise completion zsh)"
  _mise "$@"
}
compdef _mise mise

_npm() {
  unfunction "$0"
  eval "$(npm completion zsh)"
  compdef _npm_completion npm
  _npm_completion "$@"
}
compdef _npm npm

_pnpm() {
  unfunction "$0"
  # pnpm's generated script calls _pnpm_completion when eval'd from a function.
  eval "$(pnpm completion zsh)"
}
compdef _pnpm pnpm

_comp_options+=(globdots)

# Tools
eval "$(mise activate zsh --shims)"
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
eval "$(zoxide init zsh --cmd cd)"

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

function ghq-fzf() {
  local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*"
)
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}

zle -N ghq-fzf
bindkey '^g' ghq-fzf

function hw() {
  local cwd label workspaces workspace_id

  cwd=$(git rev-parse --show-toplevel 2>/dev/null) || cwd="$PWD"
  label="${cwd:t}"

  if ! workspaces=$(herdr workspace list 2>/dev/null); then
    command herdr
    return
  fi

  workspace_id=$(
    jq -r --arg label "$label" '
      first(
        .result.workspaces[]
        | select(.label == $label)
        | .workspace_id
      ) // empty
    ' <<<"$workspaces"
  )

  if [[ -n "$workspace_id" ]]; then
    herdr workspace focus "$workspace_id" >/dev/null
  else
    herdr workspace create --cwd "$cwd" --label "$label" --focus >/dev/null
  fi

  [[ "${HERDR_ENV:-}" == 1 ]] || command herdr
}

# Prompt
eval "$(starship init zsh)"

# zprof
