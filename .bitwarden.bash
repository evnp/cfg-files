bwfzf() {
  local items="$(bw list items)"
  local session

  if [[ "${items}" == *"not logged in"* ]]; then
    session="$(bw login --raw)"
  elif [[ "${items}" == *"locked"* ]]; then
    session="$(bw unlock --raw)"
  fi

  if [[ -n "${session}" ]]; then
    export BW_SESSION="${session}"
    items="$(bw list items)"
  fi

  bw get item "$(
    echo "${items}" \
    | jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' \
    | fzf-tmux \
    | awk '{print $(NF -0)}' \
    | sed 's/\"//g' \
  )" \
  | jq '.login.password' \
  | sed 's/\"//g' \
  | secure-pbcopy
}

bwgenerate() {
  bw generate | secure-pbcopy
}
