#!/bin/bash

sudo chmod +x init-git-local.sh

echo "export PATH=\$PATH:`pwd`" >> ~/.zshrc

ln -s init-git-local.sh ginlo

echo "Successfully installed. Try to run 'ginlo'"
