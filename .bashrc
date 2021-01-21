#!/usr/bin/env bash

set +H # turn off !!-style history expansion (security risk)

source ~/cryptopals/solutions.sh

source ~/.fzf.bash
source ~/.aliases
source ~/.tools
source ~/.gcloudrc

source ~/homerow-bash/shell/homerow
source ~/homerow-bash/shell/shortcuts

# update iterm2 git metatdata while on remote machines
function iterm2_print_user_vars() {
  it2git
  local pythonVersion="$( python --version 2>&1 )"
  local pythonEnv="${VIRTUAL_ENV:-no active env}"
  [[ "${pythonEnv}" =~ ^"$HOME"(/|$) ]] && pythonEnv="~${pythonEnv#$HOME}"
  iterm2_set_user_var pythonVersion "${pythonVersion}"
  iterm2_set_user_var pythonEnv "${pythonEnv}"
}

export BASH_SILENCE_DEPRECATION_WARNING=1

export PATH=$PATH:$HOME/bin # Add ~/bin to PATH for scripting
export PATH=$PATH:$HOME/.bin # Add ~/.bin to PATH for scripting
export PATH=$PATH:$HOME/cfg-bin # Add ~/cfg-bin to PATH for scripting
export PATH=$PATH:/opt/node/bin # Add Node to PATH
export PATH=$PATH:/usr/local/mysql/bin # Add MySQL to PATH
export PATH=$PATH:$HOME/.gem/ruby/2.6.0/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/gitorg/bin
export PATH=$PATH:$HOME/.fzf/bin

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
export ESC_BLUE_BOLD="\\[\\033[1;34m\\]"
export CYAN='\[\e[0;36m\]'
export PURPLE='\[\e[0;35m\]'
export GREEN="\[\033[0;32m\]"
export YELLOW="\[\033[0;33m\]"
export BLACK="\[\033[0;38m\]"
export NO_COLOUR="\[\033[0m\]"
export RESET='\[\e[0m\]'
export ESC_RESET='\\[\\e[0m\\]'

# open man pages in vim
export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu' -c 'nnoremap i <nop>' -c 'normal zR' -"

# Prompt

PROMPT_COMMAND=prompt_command
prompt_command() {
  local DOT_COLOR="${BLUE_BOLD}"
  if [ -n "${SSH_CLIENT:-}" ] || [ -n "${SSH_TTY:-}" ]; then
    local DOT_COLOR="${RED_BOLD}"
  fi
  local dir=""
  local color="${BLUE}"
  local colors=()
  dir="$( dirs +0 )"

  if [[ "${dir}" =~ ~\/ ]]; then
    dir="${dir#"~/"}"
    dir="$( tr '[:upper:]' '[:lower:]' <<< "${dir}" )"
    #dir="$( sed -E 's/([a-z])[a-z]*/\1/g' <<< "${dir}" )"
    dir="$( sed 's/\// /g' <<< "${dir}" )"
    local lowercase="abcdefghijklmnopqrstuvwxyz"
    local smallcaps="abcdefghijklmnopqrstuvwxyz"
    #local smallcaps="ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ"
    #local smallcaps="αႦƈԃҽϝɠԋιʝƙʅɱɳσρϙɾʂƚυʋɯxყȥ"
    local i=0
    local lower=""
    local small=""
    for ((; i < ${#lowercase}; i++ )); do
      lower="${lowercase:${i}:1}"
      small="${smallcaps:${i}:1}"
      dir="${dir//${lower}/${small}}"
    done
    # colorize different directory levels:
    #colors=( "${CYAN}" "${PURPLE}" "${YELLOW}" )
    #color="${colors[$(( ( ${#dir} / 2 ) % ${#colors[@]} ))]}"
  fi

  # display any TODO items found in new directory:
  if [[ "${PREV_DIR:-}" != "$( pwd )" ]]; then
    export PREV_DIR="$( pwd )"
    todo # list todos
  fi

  export PS1=" ${color}${dir} ${DOT_COLOR}●${RESET} "
}

# todo utility - create and display todos
# Usage:
#   $ todo         # list todos
#   $ todo foo bar # create todo with message "foo bar"
#   $ todo 4       # remove todo at line 4
function todo() {
  local message="${@}"

  # remove todo by index:
  if [[ "${message}" =~ ^[0-9]+$ ]]; then
    for file in TODO*; do
      if [[ -f "${file}" ]]; then
        sed -i '' "${message}d" "${file}"
      fi
    done

  # create todo (if message provided):
  elif [[ -n "${message}" ]]; then
    local todofile
    for file in TODO*; do
      if [[ -f "${file}" ]]; then
        todofile="${file}"
        break
      fi
    done
    if ! [[ -f "${todofile}" ]]; then
      todofile="TODO.md" # default to markdown file extension
    fi
    echo "${message}" >> "${todofile}"
  fi

  # list todos
  for file in TODO*; do
    if [[ -f "${file}" ]]; then
      echo "${file}" && cat -n "${file}"
    fi
  done
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
