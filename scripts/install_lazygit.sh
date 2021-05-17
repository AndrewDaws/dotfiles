#!/bin/bash

echo '=> Installing lazygit'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}/lazygit_"*"_Linux_x86_64.tar.gz"
mkdir -p "${HOME}/bin"
curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
    grep browser_download_url |
    grep lazygit_ |
    grep _Linux_x86_64.tar.gz |
    cut -d '"' -f 4 |
    wget -i -
tar -xvzf "${PWD}/lazygit_"*"_Linux_x86_64.tar.gz" -C "${HOME}/bin" "lazygit"
rm -f "${PWD}/lazygit_"*"_Linux_x86_64.tar.gz"
