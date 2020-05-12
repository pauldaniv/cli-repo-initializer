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

current_folder_name=${PWD##*/}
git init
git config --replace-all user.ssh.private.key.name ~/.ssh/id_rsa

readValue "Update user info?"
if [[ "$READ_VALUE_RESULT" ]]; then
  readValue "Enter ssh key file path"
  [[ "$READ_VALUE_RESULT" ]] && git config --replace-all user.ssh.private.key.name "$READ_VALUE_RESULT"
  readValue "Enter user.email"
  [[ "$READ_VALUE_RESULT" ]] && git config user.email "$READ_VALUE_RESULT"
  readValue "Enter user.name"
  [[ "$READ_VALUE_RESULT" ]] && git config user.name "$READ_VALUE_RESULT"
fi

git config user.signingkey ''
git config commit.gpgsign ''

bitbucket_repo_url="git@bitbucket.org:miamibeach87/$current_folder_name.git"
github_repo_url="git@github.com:pauldaniv/$current_folder_name.git"
gitlab_repo_url="git@gitlab.com:miamibeach87/$current_folder_name.git"

git remote -v | awk '{print $1}' | uniq | xargs -n1 git remote remove

if [[ $(check_remote_exists origin "$bitbucket_repo_url") ]]; then
  git remote add origin $bitbucket_repo_url
fi
if [[ $(check_remote_exists all "$bitbucket_repo_url") ]]; then
  git remote add all $bitbucket_repo_url
  check_added_successfully "Bitbucket"
fi

if [[ $(check_remote_exists github "$github_repo_url") ]]; then
  git remote add github $github_repo_url
fi
if [[ $(check_remote_exists all "$github_repo_url") ]]; then
  git remote set-url --add --push all $github_repo_url
  check_added_successfully "Github"
fi

if [[ $(check_remote_exists gitlab "$gitlab_repo_url") ]]; then
  git remote add gitlab $gitlab_repo_url
fi
if [[ $(check_remote_exists all "$gitlab_repo_url") ]]; then
  git remote set-url --add --push all $gitlab_repo_url
  check_added_successfully "Gitlab"
fi

# need to make this last (or at least not first after adding 'all' remote) becouse first push url setting will override
# automatically created push url
if [[ $(check_remote_exists all "$bitbucket_repo_url") ]]; then
  git remote set-url --add --push all $bitbucket_repo_url
fi

echo
echo "Created remotes listed bellow: "
echo
git remote -v
