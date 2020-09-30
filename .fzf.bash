# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.bash"

if ! hash fd 2>/dev/null; then
	echo "You need to install fd: brew install fd"
fi

if ! hash ag 2>/dev/null; then
	echo "You need to install ag: brew install the_silver_searcher"
fi

_fzf_files="fd --type f"
_fzf_dirs="fd --type d --follow --exclude '.git' ."
_fzf_text="ag --nobreak --noheading ."

function util-colorscheme() {
	local bg="${1}"
	local fg="${2}"
	local em="${3}"
	local hlbg="${4:-${em}}"
	local hlfg="${5:-${hlbg}}"

	local choices="fg"
	local selection="fg+"
	local choicesmatch="hl"
	local selectionmatch="hl+"

	echo "bg+:-1,border:${bg},pointer:${fg},prompt:${em},${choices}:${bg},${selection}:${fg},${choicesmatch}:${hlbg},${selectionmatch}:${hlfg}"
}

function util-random-colorscheme() {
	local cyan="#0bc7e3"
	local magenta="#ff00ff"
	local yellow="#feaf3c"
	local blue="#0000ff"
	local teal="#1d485f"
	local orange="#db662d"
	local pinkorange="#ef2b63"
	local purple="#541388"

	local cssubmariner="$( util-colorscheme "${teal}" "${cyan}" "${orange}" )"
	local csoutrun="$( util-colorscheme "${purple}" "${pinkorange}" "${cyan}" )"
	local cscmyk="$( util-colorscheme "${blue}" "${cyan}" "${yellow}" "${magenta}" )"

	local schemes=(
		"${cssubmariner}"
		"${csoutrun}"
		"${cscmyk}"
	)

	echo "${schemes[$(( RANDOM % ${#schemes[@]} ))]}"
}

export FZF_DEFAULT_COMMAND=$_fzf_files
export FZF_DEFAULT_OPTS=""
FZF_DEFAULT_OPTS+=" --height 40%"
FZF_DEFAULT_OPTS+=" --exit-0"
FZF_DEFAULT_OPTS+=" --no-info"
FZF_DEFAULT_OPTS+=" --bind=tab:down"
FZF_DEFAULT_OPTS+=" --bind=shift-tab:up"
FZF_DEFAULT_OPTS+=" --bind=left-click:accept"
FZF_DEFAULT_OPTS+=" --pointer=·"
FZF_DEFAULT_OPTS+=" --prompt='· '"
FZF_DEFAULT_OPTS+=" --margin=1,2"
FZF_DEFAULT_OPTS+=" --color=$( util-random-colorscheme )"

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

# Open all files in cwd an a four-way split (or fewer splits if there are fewer files in dir)
vimdir() {
  local files
  IFS=$'\n' read -ra files -d ''
  local numfiles=${#files[@]}
  if [[ "$numfiles" == 0 ]]; then
    echo 'Directory is empty'
  elif [[ "$numfiles" == 1 ]]; then
    xargs bash -c '</dev/tty vim "$@"' zero <<< "${files[@]}"
  elif [[ "$numfiles" == 2 ]]; then
    xargs bash -c '</dev/tty vim -c "vsp|winc l|bn|winc h" "$@"' zero <<< "${files[@]}"
  elif [[ "$numfiles" == 3 ]]; then
    xargs bash -c '</dev/tty vim -c "vsp|bn|winc l|sp|winc j|bn|bn|winc h" "$@"' zero <<< "${files[@]}"
  else
    xargs bash -c '</dev/tty vim -c "sp|vsp|bn|winc j|vsp|bn|bn|winc l|bn|bn|bn|winc h|winc k" "$@"' zero <<< "${files[@]}"
  fi
  # Note: "zero" string necessary in commands above; otherwise "$@" will expand inappropriately
  # and chop off first file. "xargs bash -c '</dev/tty..." necessary to preserve shell tty
  # instead of destroying it and losing normal shell interation.
  # See: https://vi.stackexchange.com/a/17813/26128
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
  [ -n "$dir" ] && cd "$dir" && ls | vimdir
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
  [ -n "$file" ] && cd $(dirname "$file") && clear
}

# Run fzf on directory list and navigate to directory on enter
# create iterm2 hotkey mapped to [Send text: ":FZFDirCd \n"]
:FZFDirCd() {
  local out=$(_get_fzf_output "$1" "dirs")
  local dir=$(_get_fzf_target "$out")
  [ -n "$dir" ] && cd "$dir" && clear
}

# Grep file contents and navigate to directory containing matching file on enter
# create iterm2 hotkey mapped to [Send text: ":AgCd \n"]
:AgCd() {
  local out=$(_get_fzf_output "$1" "text")
  local file=$(_get_fzf_target "$out")
  [ -n "$file" ] && cd $(dirname "$file") && clear
}

# alias since iterm2 "send-text" sometimes omits leading colon
alias FZF=":FZF"
alias FZFDir=":FZFDir"
alias Ag=":Ag"
alias FZFCd=":FZFCd"
alias FZFDirCd=":FZFDirCd"
alias AgCd=":AgCd"
