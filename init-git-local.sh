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

current_folder_name=${PWD##*/}
git init

git config user.email paulsegfault@gmail.com
git config user.name Paul

bitbucket_repo_url="git@bitbucket.org:miamibeach87/$current_folder_name.git"
github_repo_url="git@github.com:pauldaniv/$current_folder_name.git"
gitlab_repo_url="git@gitlab.com:miamibeach87/$current_folder_name.git"

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
