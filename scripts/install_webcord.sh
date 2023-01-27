#!/bin/bash

echo '=> Installing WebCord'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/webcord_*_amd64.deb
curl -s https://api.github.com/repos/SpacingBat3/WebCord/releases/latest |
    grep browser_download_url |
    grep webcord_ |
    grep _amd64.deb |
    cut -d '"' -f 4 |
    wget -i -
sudo apt install "${PWD}"/webcord_*_amd64.deb
rm -f "${PWD}"/webcord_*_amd64.deb
