#!/bin/bash

echo '=> Installing Bitwarden'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/Bitwarden-*-amd64.deb
curl -s https://api.github.com/repos/bitwarden/desktop/releases/latest \
| grep browser_download_url \
| grep Bitwarden- \
| grep \\-amd64.deb \
| cut -d '"' -f 4 \
| wget -i -
sudo apt install "${PWD}"/Bitwarden-*-amd64.deb
rm -f "${PWD}"/Bitwarden-*-amd64.deb
