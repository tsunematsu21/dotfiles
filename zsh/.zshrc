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

# Functions
get_ec2_instance_id() {
  aws ec2 describe-instances | \
    jq -r '.[][].Instances[] | [.InstanceId, [.Tags[] | select(.Key == "Name").Value][], .InstanceType, .NetworkInterfaces[].PrivateIpAddress, .State.Name] | @tsv' | \
    column -t | peco | cut -d ' ' -f 1
}

get_ec2_launch_template_id() {
  aws ec2 describe-launch-templates | \
    jq -r '.[][] | [.LaunchTemplateId, .LaunchTemplateName, .CreateTime] | @tsv' | \
    column -t | peco | cut -d ' ' -f 1
}

run_ec2_instance_from_launch_template() {
  local launch_template_id=`get_ec2_launch_template_id`
  if [ -n "$launch_template_id" ]; then
    aws ec2 run-instances --launch-template LaunchTemplateId=$launch_template_id $@
  fi
}
