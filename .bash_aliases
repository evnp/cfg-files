#!/bin/bash

# alias ls='exa --long --git'

alias s='ssh dev'
alias m='mosh dev'
alias t='tmux new-session -AD -s'
alias st='ssh dev -t tmux new-session -AD -s'
alias mt='mosh dev -- tmux new-session -AD -s'

# make ack respect .gitignore (with better fd)
alias ak="fd -tf | ack -x"

alias brew-skip-update="HOMEBREW_NO_AUTO_UPDATE=1 brew"

# Git aliases
alias gs='git status'
alias gst='git stash'
alias gsl='git stash list'
gss() {
  if [[ $1 ]]; then
    git stash show -p stash@{$1}
  else
    git stash show -p
  fi
}
gsa() {
  if [[ $1 ]]; then
    git stash apply stash@{$1}
  else
    git stash apply
  fi
}
gsp() {
  if [[ $1 ]]; then
    git stash pop stash@{$1}
  else
    git stash pop
  fi
}
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gp='git push'
alias gpo='git push origin HEAD'
alias gpfo='git push -f origin HEAD'
alias gb='git branch'
alias gbd='git branch -D'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull'
alias gps='git push'
alias gm='git merge'
alias gf='git fetch'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -5"
alias gll="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -10"
alias glll="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -50"
alias gd='git diff'
alias gdc='git diff --cached'
alias gcp='git cherry-pick'
alias gr='git rebase'
alias grm='git rebase master'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias grh='git reset HEAD'
alias gundo='git reset --soft HEAD~1 && git reset' # undo last commit and unstage changes

alias la='ls -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Source alias
alias src="source ~/.bash_profile"

# how2 (cli stackoverflow) aliases
alias hjs='how2 -l javascript'
alias hpy='how2 -l python'
alias hgit='how2 -l git'

alias python="/opt/homebrew/bin/python3"
alias py="python -m ptpython"

alias nps="TIPS=0 npm start"
