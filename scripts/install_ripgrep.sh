#!/bin/bash

echo '=> Installing ripgrep'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/ripgrep_*_amd64.deb
curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
| grep browser_download_url \
| grep ripgrep_ \
| grep _amd64.deb \
| cut -d '"' -f 4 \
| wget -i -
sudo apt install "${PWD}"/ripgrep_*_amd64.deb
rm -f "${PWD}"/ripgrep_*_amd64.deb
