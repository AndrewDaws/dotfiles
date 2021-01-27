#!/bin/bash

echo '=> Installing Cadmus'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/cadmus.deb
curl -s https://api.github.com/repos/josh-richardson/cadmus/releases/latest |
    grep browser_download_url |
    grep cadmus |
    grep .deb |
    cut -d '"' -f 4 |
    wget -i -
sudo apt install "${PWD}"/cadmus.deb
rm -f "${PWD}"/cadmus.deb
