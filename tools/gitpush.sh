#!/bin/bash

readValue() {
  READ_VALUE_RESULT=
  local value
  echo "$1: " | tr -d '\n'

  local CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"
  if [[ $2 == pass ]]; then
    read -s value
  else
    read -r value
  fi
  if [[ "$value" ]]; then
    echo -e "\\r${CHECK_MARK}\033[K" | tr -d '\d'
  fi
  READ_VALUE_RESULT=${value}
  value=
}



ssh_key_path=$(git config user.ssh.private.key.name) >/dev/null
if [[ -z "$ssh_key_path" ]]; then
  readValue "Use default key? (y/n)"
  if [[ ${READ_VALUE_RESULT} == 'y' ]]; then
    git push $@
    exit 0
  fi
fi

readValue "Enter ssh key file path"
if [[ "$READ_VALUE_RESULT" ]]; then
  git config --replace-all user.ssh.private.key.name "$READ_VALUE_RESULT"
  GIT_SSH_COMMAND="ssh -i $(git config user.ssh.private.key.name)" git push $@
else
  echo "Attempting to use default path..."
  git push all
  exit 0
fi
