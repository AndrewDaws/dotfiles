#!/bin/bash

echo '=> Installing Monoid'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}/Monoid.zip"
curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |
    grep browser_download_url |
    grep Monoid.zip |
    cut -d '"' -f 4 |
    wget -i -
mkdir -p "${HOME}/.local/share/fonts/NerdFonts"
unzip -o "${PWD}/Monoid.zip" -d "${HOME}/.local/share/fonts/NerdFonts"
rm -f "${PWD}/Monoid.zip"
sudo fc-cache -f -v
