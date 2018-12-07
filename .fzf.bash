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

_fzf_find_files="rg --files"
_fzf_find_directories="fd --type d --follow --exclude '.git' ."

# fzf+ripgrep - fast & respects .gitignore
# ---------------------------
export FZF_DEFAULT_COMMAND=$_fzf_find_files

# Run fzf and open file in default editor on enter
# create iterm2 hotkey mapped to [Send text: ":FZF \n"]
# note: named ":FZF" so that same hotkey can activate fzf in vim
:FZF() {
  local out file
  IFS=$'\n' out=($(fzf --height 40% --query="$1" --exit-0))
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    ${EDITOR:-vim} $file
  fi
}

# Run fzf on directory list and open directory on enter
fzfd() {
  local out dir
  IFS=$'\n' out=($(FZF_DEFAULT_COMMAND=$_fzf_find_directories fzf --height 40% --query="$1" --exit-0))
  dir=$(head -2 <<< "$out" | tail -1)
  if [ -n "$dir" ]; then
    cd $dir
  fi
}
