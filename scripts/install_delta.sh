#!/bin/bash

echo '=> Installing Delta'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/git-delta_*_amd64.deb
curl -s https://api.github.com/repos/dandavison/delta/releases/latest |
    grep browser_download_url |
    grep git-delta_ |
    grep _amd64.deb |
    cut -d '"' -f 4 |
    wget -i -
sudo apt install "${PWD}"/git-delta_*_amd64.deb
rm -f "${PWD}"/git-delta_*_amd64.deb
