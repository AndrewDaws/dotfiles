#!/bin/bash

echo '=> Installing JetBrainsMono'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}"/JetBrainsMono-*.zip
curl -s https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest \
| grep browser_download_url \
| grep JetBrainsMono- \
| grep .zip \
| cut -d '"' -f 4 \
| wget -i -
mkdir -p "${HOME}/.local/share/fonts/JetBrains"
unzip -o "${PWD}"/JetBrainsMono-*.zip -d "${HOME}/.local/share/fonts/JetBrains"
rm -f "${PWD}"/JetBrainsMono-*.zip
sudo fc-cache -f -v
