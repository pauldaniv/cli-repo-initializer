#!/bin/bash

sudo chmod +x gitinit.sh
sudo chmod +x gitpush.sh

if [[ ! $(grep -q "export PATH=\$PATH:`pwd`/dist" ~/.zshrc) ]]; then
  echo "export PATH=\$PATH:`pwd`/dist" >> ~/.zshrc
fi

[[ ! -d dist ]] && mkdir dist

[[ ! -L dist/gitinit ]] && ln -s gitinit.sh dist/gitinit
[[ ! -L dist/gitpush ]] && ln -s gitpush.sh dist/gitpush

if [[ ! $? ]]; then
  error_code=$?
  echo "Error: $error_code"
  exit $error_code
fi

source ~/.zshrc
echo "Successfully installed:"
echo "1) gitinit"
echo "2) gitpush"
