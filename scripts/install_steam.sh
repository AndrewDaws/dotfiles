#!/bin/bash

echo '=> Installing Steam'
echo 'Getting dependencies.'
sudo apt-get update
sudo apt-get install libc6-i386
echo 'Getting latest release from Valve.'
rm -f "${PWD}/steam.deb"
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo apt install "${PWD}/steam.deb"
rm -f "${PWD}/steam.deb"
