#!/bin/bash

echo '=> Installing Fd'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/fd_*_amd64.deb
curl -s https://api.github.com/repos/sharkdp/fd/releases/latest |
    grep browser_download_url |
    grep fd_ |
    grep _amd64.deb |
    cut -d '"' -f 4 |
    wget -i -
sudo apt install "${PWD}"/fd_*_amd64.deb
rm -f "${PWD}"/fd_*_amd64.deb
