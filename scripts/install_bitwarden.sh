#!/bin/bash

echo '=> Installing Bitwarden'
echo 'Getting latest desktop release from GitHub.'
rm -f "${PWD}"/Bitwarden-*-amd64.deb
curl -s https://api.github.com/repos/bitwarden/desktop/releases/latest |
    grep browser_download_url |
    grep Bitwarden- |
    grep \\-amd64.deb |
    cut -d '"' -f 4 |
    wget -i -
sudo apt install "${PWD}"/Bitwarden-*-amd64.deb
rm -f "${PWD}"/Bitwarden-*-amd64.deb

echo 'Getting latest CLI release from GitHub.'
rm -f "${PWD}"/bw-linux-*.zip
curl -s https://api.github.com/repos/bitwarden/cli/releases/latest |
    grep browser_download_url |
    grep bw-linux- |
    grep .zip |
    cut -d '"' -f 4 |
    wget -i -
mkdir -p "${HOME}/bin"
unzip -o "${PWD}"/bw-linux-*.zip -d "${HOME}/bin"
chmod +x "${HOME}/bin/bw"
rm -f "${PWD}"/bw-linux-*.zip
