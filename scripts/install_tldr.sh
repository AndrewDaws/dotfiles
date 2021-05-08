#!/bin/bash

echo '=> Installing tldr++'
echo 'Getting latest release from GitHub.'
rm -f "${PWD}/tldr_"*"_linux_amd64.tar.gz"
mkdir -p "${HOME}/bin"
curl -s https://api.github.com/repos/isacikgoz/tldr/releases/latest |
    grep browser_download_url |
    grep tldr_ |
    grep _linux_amd64.tar.gz |
    cut -d '"' -f 4 |
    wget -i -
tar -xvzf "${PWD}/tldr_"*"_linux_amd64.tar.gz" -C "${HOME}/bin"
rm -f "${PWD}/tldr_"*"_linux_amd64.tar.gz"
