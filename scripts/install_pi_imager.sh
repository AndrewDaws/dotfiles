#!/bin/bash

echo '=> Installing Raspberry Pi Imager'
rm -f "${PWD}/imager_latest_amd64.deb"
wget https://downloads.raspberrypi.org/imager/imager_latest_amd64.deb
sudo apt install "${PWD}/imager_latest_amd64.deb"
rm -f "${PWD}/imager_latest_amd64.deb"
