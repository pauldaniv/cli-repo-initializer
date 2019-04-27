#!/bin/bash
sudo chmod +x init-git-local.sh

sudo ln -s $pwd/init-git-local.sh /usr/bin/ginlo

sudo chown $(whoami):$(whoami) /usr/bin/ginlo

echo "Successfully installed. Try to run 'ginlo'"