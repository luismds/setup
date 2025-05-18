# My minimal terminal in ZSH
# History
HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=100000
setopt inc_append_history
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

autoload -U colors && colors

# Bind keys
# alt+<- | alt+->
bindkey "^[f" forward-word
bindkey "^[b" backward-word

# ctrl+<- | ctrl+->
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Aliases
alias v='nvim'
alias o='xdg-open'
alias g='git'
alias gs='git status'

alias ls='ls --color=auto -hv'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -c=auto'

alias cat='batcat'

alias l='ls -a'
alias ll='ls -l'
alias la='ls -lA'

alias mv='mv -i'

# Servidor AWS EC2
alias aws='ssh -i /home/luis/.aws-ec2.pem ec2-user@18.231.168.68'

# Completion
autoload -U compinit && compinit
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# . "$HOME/.cargo/env"


# enable command-substitution inside PS1
setopt prompt_subst

git_branch_name() {
  # only run inside a git repo
  local branch git_status
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return

  # check for any changes (staged, unstaged, or untracked)
  git_status=$(git status --porcelain 2>/dev/null)
  if [[ -n $git_status ]]; then
    # dirty: show branch with asterisk
    echo " git:(%F{red}%B${branch}*%b%f)"
  else
    # clean: show branch normally
    echo " git:(%F{red}%B${branch}%b%f)"
  fi
}

# prompt icon
USER_SHELL_ICON=$'\uf061'

# final PS1
PS1="%F{blue}%B%1~%b%f\$(git_branch_name) %F{green}%B$USER_SHELL_ICON %b%f "

###-begin-pm2-completion-###
### credits to npm for the completion file model
#
# Installation: pm2 completion >> ~/.bashrc  (or ~/.zshrc)
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _pm2_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           pm2 completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _pm2_completion pm2
elif type compctl &>/dev/null; then
  _pm2_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       pm2 completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _pm2_completion + -f + pm2
fi
###-end-pm2-completion-###
