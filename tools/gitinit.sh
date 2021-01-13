#!/bin/bash

check_added_successfully() {
  if [[ $? == 0 ]]; then
    echo "$1 init was successful"
  else
    echo "Not able to init $1"
  fi
}

check_remote_exists() {
  [[ ! $(git remote -v | grep -v 'fetch' | grep $1 | awk '{print $2}') =~ $2 ]] && echo true
}

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

current_folder_name=${1:-${PWD##*/}}
git init
git config --replace-all user.ssh.private.key.name ~/.ssh/id_rsa

readValue "Update user info?"
if [[ "$READ_VALUE_RESULT" = "y" ]]; then
  if [[ "$GIT_SSH_KEY_PATH" ]]; then
    READ_VALUE_RESULT=$GIT_SSH_KEY_PATH
  else
    readValue "Enter ssh key file path"
  fi
  [[ "$READ_VALUE_RESULT" ]] && git config --replace-all user.ssh.private.key.name "$READ_VALUE_RESULT"
  if [[ "$GIT_DEFAULT_USER_EMAIL" ]]; then
    READ_VALUE_RESULT=$GIT_DEFAULT_USER_EMAIL
  else
    readValue "Enter user.email"
  fi
  [[ "$READ_VALUE_RESULT" ]] && git config user.email "$READ_VALUE_RESULT"
  if [[ "$GIT_DEFAULT_USER_NAME" ]]; then
    READ_VALUE_RESULT=$GIT_DEFAULT_USER_NAME
  else
    readValue "Enter user.name"
  fi
  [[ "$READ_VALUE_RESULT" ]] && git config user.name "$READ_VALUE_RESULT"
fi

# going to hardcode this for now
git config user.signingkey B286731F71468F7BCF4E80F300B9131832CF5F5A
git config commit.gpgsign true

github_repo_url="git@github.com:$GITHUB_USER_NAME/$current_folder_name.git"

git remote -v | awk '{print $1}' | uniq | xargs -n1 git remote remove

if [[ $(check_remote_exists origin "$github_repo_url") ]]; then
  git remote add origin $github_repo_url
fi
if [[ $(check_remote_exists all "$github_repo_url") ]]; then
  git remote add all $github_repo_url
  check_added_successfully "GitHub"
fi

if [[ "$BITBUCKET_USER_NAME" ]]; then
  bitbucket_repo_url="git@bitbucket.org:$BITBUCKET_USER_NAME/$current_folder_name.git"
  if [[ $(check_remote_exists bucket "$bitbucket_repo_url") ]]; then
    git remote add bucket $bitbucket_repo_url
  fi
  if [[ $(check_remote_exists all "$bitbucket_repo_url") ]]; then
    git remote set-url --add --push all $bitbucket_repo_url
    check_added_successfully "Bitbucket"
  fi
fi

if [[ "$GITLAB_USER_NAME" ]]; then
  gitlab_repo_url="git@gitlab.com:$GITLAB_USER_NAME/$current_folder_name.git"
  if [[ $(check_remote_exists gitlab "$gitlab_repo_url") ]]; then
    git remote add gitlab $gitlab_repo_url
  fi
  if [[ $(check_remote_exists all "$gitlab_repo_url") ]]; then
    git remote set-url --add --push all $gitlab_repo_url
    check_added_successfully "Gitlab"
  fi
fi

if [[ "$KEYBASE_USER_NAME" ]]; then
  keybase_repo_url="keybase://private/$KEYBASE_USER_NAME/$current_folder_name"
  if [[ $(check_remote_exists keybase "$keybase_repo_url") ]]; then
    git remote add keybase $keybase_repo_url
  fi
  if [[ $(check_remote_exists all "$keybase_repo_url") ]]; then
    git remote set-url --add --push all $keybase_repo_url
    check_added_successfully "Keybase Git"
  fi
fi

# need to make this last (or at least not first after adding 'all' remote) because first push url setting will override
# automatically created push url
if [[ $(check_remote_exists all "$github_repo_url") ]]; then
  git remote set-url --add --push all "$github_repo_url"
fi

echo
echo "Created remotes listed bellow: "
echo
echo
git remote -v
# test change