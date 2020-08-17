#!/bin/bash

echo '=> Installing Alacritty'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/Alacritty-*_amd64.deb
curl -s https://api.github.com/repos/alacritty/alacritty/releases/latest \
| grep browser_download_url \
| grep Alacritty- \
| grep _amd64.deb \
| cut -d '"' -f 4 \
| wget -i -
sudo apt install "${PWD}"/Alacritty-*_amd64.deb
rm -f "${PWD}"/Alacritty-*_amd64.deb
