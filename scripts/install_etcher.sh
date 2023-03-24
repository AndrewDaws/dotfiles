#!/bin/bash

echo '=> Installing etcher'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/balena-etcher_*_amd64.deb
curl -s https://api.github.com/repos/balena-io/etcher/releases/latest |
    grep browser_download_url |
    grep balena-etcher_ |
    grep _amd64.deb |
    cut -d '"' -f 4 |
    wget -i -
sudo apt install "${PWD}"/balena-etcher_*_amd64.deb
rm -f "${PWD}"/balena-etcher_*_amd64.deb
