#!/bin/bash

sudo chmod +x tools/gitinit.sh
sudo chmod +x tools/gitpush.sh

if ! grep -q "export PATH=\$PATH:$(pwd)/dist" ~/.zshrc; then
  echo "export PATH=\$PATH:$(pwd)/dist" >>~/.zshrc
fi

rm -rf dist
mkdir dist

ln -s $(pwd)/tools/gitinit.sh $(pwd)/dist/gitinit
ln -s $(pwd)/tools/gitpush.sh $(pwd)/dist/gitpush

if [[ ! $? ]]; then
  error_code=$?
  echo "Error: $error_code"
  exit $error_code
fi

source ~/.zshrc &>/dev/null
echo "Successfully installed:"
echo "1) gitinit"
echo "2) gitpush"
