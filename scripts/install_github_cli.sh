#!/bin/bash

echo '=> Installing GitHub CLI'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}/gh_"*"_linux_amd64.deb"
curl -s https://api.github.com/repos/cli/cli/releases/latest |
    grep browser_download_url |
    grep gh_ |
    grep _linux_amd64.deb |
    cut -d '"' -f 4 |
    wget -i -
sudo apt install "${PWD}/gh_"*"_linux_amd64.deb"
rm -f "${PWD}/gh_"*"_linux_amd64.deb"
