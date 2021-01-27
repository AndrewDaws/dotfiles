#!/bin/bash

echo '=> Installing FiraMono'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}/FiraMono.zip"
curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |
    grep browser_download_url |
    grep FiraMono.zip |
    cut -d '"' -f 4 |
    wget -i -
mkdir -p "${HOME}/.local/share/fonts/NerdFonts"
unzip -o "${PWD}/FiraMono.zip" -d "${HOME}/.local/share/fonts/NerdFonts"
rm -f "${PWD}/FiraMono.zip"
sudo fc-cache -f -v
