#!/bin/bash

echo '=> Installing Angry IP Scanner'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/bat_*_amd64.deb
curl -s https://api.github.com/repos/angryip/ipscan/releases/latest |
    grep browser_download_url |
    grep ipscan_ |
    grep _amd64.deb |
    cut -d '"' -f 4 |
    wget -i -
sudo apt install "${PWD}"/ipscan_*_amd64.deb
rm -f "${PWD}"/ipscan_*_amd64.deb
