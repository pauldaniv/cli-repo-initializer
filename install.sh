#!/bin/bash

if ! grep -q "export PATH=\$PATH:$(pwd)/dist" ~/.zshrc; then
  echo "export PATH=\$PATH:$(pwd)/dist" >>~/.zshrc
fi

rm -rf dist
mkdir dist

echo "Creating link to tools:"

for i in $(ls tools/); do
  sudo chmod +x tools/$i
  src_path="$(pwd)/tools/$i"
  dst_path="$(pwd)/dist/$(echo $i | sed 's/\.[^.]*$//')"
  echo "$src_path => $dst_path"
  ln -s $src_path $dst_path
done

if [[ ! $? ]]; then
  error_code=$?
  echo "Error: $error_code"
  exit $error_code
fi

source ~/.zshrc &>/dev/null
echo "Successfully installed:"

for i in $(ls tools/); do
  echo $i
done
