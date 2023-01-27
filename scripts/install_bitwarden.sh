#!/bin/bash

echo '=> Installing Bitwarden'
echo 'Getting latest desktop release from GitHub.'
rm -f "${PWD}"/Bitwarden-*-amd64.deb
curl -s https://api.github.com/repos/bitwarden/clients/releases |
    grep browser_download_url |
    grep Bitwarden- |
    grep --max-count=1 -- \\-amd64.deb |
    cut -d '"' -f 4 |
    wget -i -
sudo apt install "${PWD}"/Bitwarden-*-amd64.deb
rm -f "${PWD}"/Bitwarden-*-amd64.deb

echo 'Getting latest CLI release from GitHub.'
rm -f "${PWD}"/bw-linux-*.zip
curl -s https://api.github.com/repos/bitwarden/clients/releases |
    grep browser_download_url |
    grep bw-linux- |
    grep --max-count=1 -- .zip |
    cut -d '"' -f 4 |
    wget -i -
mkdir -p "${HOME}/bin"
unzip -o "${PWD}"/bw-linux-*.zip -d "${HOME}/bin"
chmod +x "${HOME}/bin/bw"
rm -f "${PWD}"/bw-linux-*.zip
# @todo Add Bitwarden CLI Shell Profile
# @body Create environment variables such as BW_SESSION

# @todo Add Bitwarden CLI SSH Agent
# @body https://github.com/joaojacome/bitwarden-ssh-agent