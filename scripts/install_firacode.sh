#!/bin/bash

echo '=> Installing FiraCode'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}/FiraCode.zip"
curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |
    grep browser_download_url |
    grep FiraCode.zip |
    cut -d '"' -f 4 |
    wget -i -
mkdir -p "${HOME}/.local/share/fonts/NerdFonts"
unzip -o "${PWD}/FiraCode.zip" -d "${HOME}/.local/share/fonts/NerdFonts"
rm -f "${PWD}/FiraCode.zip"
sudo fc-cache -f -v
