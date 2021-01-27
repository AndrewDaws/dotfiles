#!/bin/bash

echo '=> Installing Hack'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}/Hack.zip"
curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |
    grep browser_download_url |
    grep Hack.zip |
    cut -d '"' -f 4 |
    wget -i -
mkdir -p "${HOME}/.local/share/fonts/NerdFonts"
unzip -o "${PWD}/Hack.zip" -d "${HOME}/.local/share/fonts/NerdFonts"
rm -f "${PWD}/Hack.zip"
sudo fc-cache -f -v
