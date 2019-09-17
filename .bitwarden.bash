# lock bitwarden every 30 minutes - revoke all existing sessions
( sleep 1800 ; bw lock ) & disown

bwfzf() {
  local bwItems
  local currentTime
  local keyPressed
  local lastAction
  local loginOrUnlock
  local nextField

  # lock bitwarden every 10 minutes - revoke all existing sessions
  currentTime="$(date +%s)"
  if [[ -n "${BW_SESSION_EXPIRY}" ]] && (( currentTime > BW_SESSION_EXPIRY )); then
    bw lock
  fi
  export BW_SESSION_EXPIRY="$(( currentTime + 600 ))"

  # set BW_SESSION env var from keychain if necessary
  if [[ -z "${BW_SESSION}" ]]; then
    export BW_SESSION="$(security find-generic-password -a "${USER}" -s bw -w)"
    if [[ "${BW_SESSION}" == *"could not be found"* ]]; then
      export BW_SESSION=""
    fi
  fi

  # attempt to fetch items list
  bwItems="$(bw list items)"
  if [[ "${bwItems}" == *"not logged in"* ]]; then
    loginOrUnlock="login"
  elif [[ "${bwItems}" == *"locked"* ]]; then
    loginOrUnlock="unlock"
  fi

  # if login or unlock required, update env var and keychain session then re-fetch
  if [[ -n "${loginOrUnlock}" ]]; then
    export BW_SESSION="$(bw "${loginOrUnlock}" --raw)"
    security add-generic-password -a "${USER}" -s bw -w "${BW_SESSION}" -U -T ""
    # -T : revoke access for all applications (set blank "")
    # -U : update if already exists

    # re-fetch items list
    bwItems="$(bw list items)"
  fi

  # invoke fzf on items list
  bwItem="$(
    bw get item "$(
      echo "${bwItems}" \
      | jq -r '.[] | "\(.name) · \(.login.username) \(.id)" ' \
      | fzf-tmux --nth 1..-2 --with-nth 1..-2 \
      | awk '{print $NF}' \
    )"
  )"

  # perform an action (e.g. copy password to clipboard) then ask the user
  # whether to perform another action or exit
  while true; do

    # p key - print full entry
    if [[ "${keyPressed}" == "p" ]]; then
      lastAction=""
      echo "${bwItem//$(echo "${bwItem}" | jq -r '.login.password')/*****}" | jq .

    # enter key - copy password, username, uri, etc.
    elif [[ -z "${keyPressed}" ]]; then
      if [[ "${nextField}" == "username" ]]; then
        echo "${bwItem}" | jq -r '.login.username' | secure-pbcopy
        lastAction="Username copied!"
        nextField="uri"
      elif [[ "${nextField}" == "uri" ]]; then
        echo "${bwItem}" | jq -r '.login.uri' | secure-pbcopy
        lastAction="URI copied!"
        nextField="password"
      else
        echo "${bwItem}" | jq -r '.login.password' | secure-pbcopy
        lastAction="Password copied!"
        nextField="username"
      fi

    # any other key - exit
    else
      break
    fi

    read -rsn1 -p "
${lastAction}
  enter -> copy ${nextField}
  p key -> print full entry (password redacted)
  other -> exit
" keyPressed
  done
}

bwgenerate() {
  bw generate | secure-pbcopy
}
