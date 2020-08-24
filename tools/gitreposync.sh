#!/bin/bash

for i in $(cat $REPOS_LIST_FILE); do
  cd "$REPOS_BASE_PATH/$i"
  gitcom pull all develop
done
