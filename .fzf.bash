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
_fzf_dirs="fd --type d --follow --exclude '.git' ."
_fzf_text="ag --nobreak --noheading ."

export FZF_DEFAULT_COMMAND=$_fzf_files
export FZF_DEFAULT_OPTS="--height 40% --exit-0"

# Provided with "files"|"dirs"|"text", return corresponding command to
# search file names, directory paths, or file text
_get_fzf_command() {
  [ "$1" = "files" ] && echo "$_fzf_files"
  [ "$1" = "dirs" ] && echo "$_fzf_dirs"
  [ "$1" = "text" ] && echo "$_fzf_text"
}

# Run fzf and return output after selection is made
_get_fzf_output() {
  local out
  IFS=$'\n' out=($(FZF_DEFAULT_COMMAND=$(_get_fzf_command "$2") fzf --query="$1"))
  echo "$out"
}

# Parse fzf output and return the target (file name or directory path)
_get_fzf_target() {
  local out
  IFS=$':' read -ra out <<< "$1"
  echo "${out[0]}"
}

# Parse fzf output and return the match line number (if not present, return 0)
_get_fzf_line() {
  local out
  IFS=$':' read -ra out <<< "$1"
  out="${out[1]}"
  if [ -n "$out" ]; then
    echo "$out"
  else
    echo "0"
  fi
}

# Run fzf and open file in default editor on enter
# create iterm2 hotkey mapped to [Send text: ":FZF \n"]
# note: named ":FZF" so that same hotkey can activate fzf in vim
:FZF() {
  local out=$(_get_fzf_output "$1" "files")
  local file=$(_get_fzf_target "$out")
  [ -n "$file" ] && vim "$file"
}

# Run fzf on directory list and open all files in directory on enter
# create iterm2 hotkey mapped to [Send text: ":FZFDir \n"]
:FZFDir() {
  local out=$(_get_fzf_output "$1" "dirs")
  local dir=$(_get_fzf_target "$out")
  [ -n "$dir" ] && cd "$dir" && vim *
}

# Grep file contents and open file at matching line on enter
# create iterm2 hotkey mapped to [Send text: ":Ag \n"]
# note: named ":Ag" so that same hotkey can activate fzf in vim
:Ag() {
  local out=$(_get_fzf_output "$1" "text")
  local file=$(_get_fzf_target "$out")
  local line=$(_get_fzf_line "$out")
  [ -n "$file" ] && vim +"$line" "$file"
}

# Run fzf and navigate to directory containing matching file on enter
# create iterm2 hotkey mapped to [Send text: ":FZFCd \n"]
:FZFCd() {
  local out=$(_get_fzf_output "$1" "files")
  local file=$(_get_fzf_target "$out")
  [ -n "$file" ] && cd $(dirname "$file")
}

# Run fzf on directory list and navigate to directory on enter
# create iterm2 hotkey mapped to [Send text: ":FZFDirCd \n"]
:FZFDirCd() {
  local out=$(_get_fzf_output "$1" "dirs")
  local dir=$(_get_fzf_target "$out")
  [ -n "$dir" ] && cd "$dir"
}

# Grep file contents and navigate to directory containing matching file on enter
# create iterm2 hotkey mapped to [Send text: ":AgCd \n"]
:AgCd() {
  local out=$(_get_fzf_output "$1" "text")
  local file=$(_get_fzf_target "$out")
  [ -n "$file" ] && cd $(dirname "$file")
}
