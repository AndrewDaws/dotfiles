#!/bin/bash

echo '=> Installing Anonymous'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}/AnonymousPro.zip"
curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
| grep browser_download_url \
| grep AnonymousPro.zip \
| cut -d '"' -f 4 \
| wget -i -
mkdir -p "${HOME}/.local/share/fonts/NerdFonts"
unzip -o "${PWD}/AnonymousPro.zip" -d "${HOME}/.local/share/fonts/NerdFonts"
rm -f "${PWD}/AnonymousPro.zip"
sudo fc-cache -f -v
