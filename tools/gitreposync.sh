#!/bin/bash
IFS=$(echo -en "\n\b")
for i in $(cat $REPOS_LIST_FILE); do
  if [[ $i && ! $i =~ ^[[:space:]]*\#.*$ ]]; then
    cd "$REPOS_BASE_PATH/$i"
    echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    echo "Synching `pwd`"
    gitcom pull all develop
  fi
done
IFS=$SAVEIFS
