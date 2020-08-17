#!/bin/bash

echo '=> Installing Chrome'
echo 'Getting latest release from Google.'
rm -f "${PWD}/google-chrome-stable_current_amd64.deb"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install "${PWD}/google-chrome-stable_current_amd64.deb"
rm -f "${PWD}/google-chrome-stable_current_amd64.deb"
