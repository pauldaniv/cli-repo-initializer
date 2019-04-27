#!/bin/bash

function check_added_successfully() {
	if [[ $? == 0 ]]; then
		echo "$1 init was successful"
	else 
		echo "Not able to init $1"
	fi
}

current_folder_name=${PWD##*/}
git init

bitbucket_repo_url="git@bitbucket.org:miamibeach87/$current_folder_name.git"
github_repo_url="git@github.com:pauldaniv/$current_folder_name.git"
gitlab_repo_url="git@gitlab.com:miamibeach87/$current_folder_name.git"

git remote add origin $bitbucket_repo_url
git remote add all $bitbucket_repo_url
git remote set-url --add --push all $bitbucket_repo_url
check_added_successfully "Bitbucket"

git remote add github $github_repo_url
git remote set-url --add --push all $github_repo_url
check_added_successfully "Github"

git remote add gitlab $gitlab_repo_url
git remote set-url --add --push all $gitlab_repo_url
check_added_successfully "Gitlab"

echo
echo "Created remotes listed bellow: "
echo
git remote -v