#!/usr/bin/env bash

source ~/.fzf.bash
source ~/.aliases

# update iterm2 git metatdata while on remote machines
function iterm2_print_user_vars() {
  it2git
}

export BASH_SILENCE_DEPRECATION_WARNING=1

export PATH=$PATH:$HOME/bin # Add ~/bin to PATH for scripting
export PATH=$PATH:$HOME/.bin # Add ~/.bin to PATH for scripting
export PATH=$PATH:$HOME/cfg-bin # Add ~/cfg-bin to PATH for scripting
export PATH=$PATH:/opt/node/bin # Add Node to PATH
export PATH=$PATH:/usr/local/mysql/bin # Add MySQL to PATH

# Editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Fix vim colors in Tmux
export TERM="xterm-256color"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Colors

export RED="\[\033[0;31m\]"
export RED_BOLD="\[\033[1;31m\]"
export BLUE="\[\033[0;34m\]"
export BLUE_BOLD="\[\033[1;34m\]"
export CYAN='\[\e[0;36m\]'
export PURPLE='\[\e[0;35m\]'
export GREEN="\[\033[0;32m\]"
export YELLOW="\[\033[0;33m\]"
export BLACK="\[\033[0;38m\]"
export NO_COLOUR="\[\033[0m\]"
export RESET='\[\e[0m\]'

# open man pages in vim
export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu' -c 'nnoremap i <nop>' -c 'normal zR' -"

# Prompt

PROMPT_COMMAND=prompt_command
prompt_command() {
  local DOT_COLOR=$BLUE_BOLD
  if [ -n "${SSH_CLIENT:-}" ] || [ -n "${SSH_TTY:-}" ]; then
    local DOT_COLOR=$RED_BOLD
  fi
  export PS1=" ${PURPLE}\A ${YELLOW}\W ${DOT_COLOR}●${RESET} "
  echo -ne "\033]0;${PWD}\007"
}

# History Management
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it
# Save and reload the history after each command finishes to share history between terminals
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Add to ~/.inputrc for history-searching up/down arrows
# "\e[A": history-search-backward
# "\e[B": history-search-forward
# set show-all-if-ambiguous on
# set completion-ignore-case on

# Make sure ssh agent is always running
ssh-add -K &>/dev/null
if [ "$?" == 2 ]; then
  test -r ~/.ssh-agent && \
    eval "$(<~/.ssh-agent)" >/dev/null

  ssh-add -K &>/dev/null
  if [ "$?" == 2 ]; then
    (umask 066; ssh-agent > ~/.ssh-agent)
    eval "$(<~/.ssh-agent)" >/dev/null
    ssh-add -K
  fi
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/evnp/google-cloud-sdk/path.bash.inc' ]; then source '/home/evnp/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/evnp/google-cloud-sdk/completion.bash.inc' ]; then source '/home/evnp/google-cloud-sdk/completion.bash.inc'; fi
