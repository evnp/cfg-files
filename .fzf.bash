# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="$PATH:$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"

_fzf_files="fd --type f"
_fzf_directories="fd --type d --follow --exclude '.git' ."
_fzf_contents="ag --nobreak --noheading ."

# fzf+ripgrep - fast & respects .gitignore
# ---------------------------
export FZF_DEFAULT_COMMAND=$_fzf_files

# Run fzf and open file in default editor on enter
# create iterm2 hotkey mapped to [Send text: ":FZF \n"]
# note: named ":FZF" so that same hotkey can activate fzf in vim
:FZF() {
  local out file
  IFS=$'\n' out=($(fzf --height 40% --query="$1" --exit-0))
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    vim $file
  fi
}

# Run fzf on directory list and open directory on enter
:Cd() {
  local out dir
  IFS=$'\n' out=($(FZF_DEFAULT_COMMAND=$_fzf_directories fzf --height 40% --query="$1" --exit-0))
  dir=$(head -2 <<< "$out" | tail -1)
  if [ -n "$dir" ]; then
    cd $dir
  fi
}

# Grep file contents and open file at matching line on enter
:Ag() {
  local out file line
  IFS=$'\n' out=($(FZF_DEFAULT_COMMAND=$_fzf_contents fzf --height 40% --query="$1" --exit-0))
  IFS=$':' read -ra out <<< "$out"
  file=${out[0]}
  line=${out[1]}
  if [ -n "$file" ]; then
    vim +$line $file
  fi
}
