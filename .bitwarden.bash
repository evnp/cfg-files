# lock bitwarden every 30 minutes - revoke all existing sessions
( sleep 1800 ; bw lock ) & disown

bwfzf() {
  local items
  local loginOrUnlock

  # lock bitwarden every 10 minutes - revoke all existing sessions
  local now="$(date +%s)"
  if [[ -n "${BW_EXPIRE}" ]] && (( now > BW_EXPIRE )); then
    bw lock
  fi
  export BW_EXPIRE="$(( now + 600 ))"

  # set BW_SESSION env var from keychain if necessary
  if [[ -z "${BW_SESSION}" ]]; then
    export BW_SESSION="$(security find-generic-password -a "${USER}" -s bw -w)"
    if [[ "${BW_SESSION}" == *"could not be found"* ]]; then
      export BW_SESSION=""
    fi
  fi

  # attempt to fetch items list
  items="$(bw list items)"
  if [[ "${items}" == *"not logged in"* ]]; then
    loginOrUnlock="login"
  elif [[ "${items}" == *"locked"* ]]; then
    loginOrUnlock="unlock"
  fi

  # if login or unlock required, update env var and keychain session then re-fetch
  if [[ -n "${loginOrUnlock}" ]]; then
    export BW_SESSION="$(bw "${loginOrUnlock}" --raw)"
    security add-generic-password -a "${USER}" -s bw -w "${BW_SESSION}" -U -T ""
    # -T : revoke access for all applications (set blank "")
    # -U : update if already exists

    # re-fetch items list
    items="$(bw list items)"
  fi

  # invoke fzf on items list, then secure-pbcopy password from selected item
  bw get item "$(
    echo "${items}" \
    | jq -r '.[] | "\(.name) · \(.login.username) \(.id)" ' \
    | fzf-tmux --nth 1..-2 --with-nth 1..-2 \
    | awk '{print $NF}' \
  )" \
  | jq -r '.login.password' \
  | secure-pbcopy
}

bwgenerate() {
  bw generate | secure-pbcopy
}
