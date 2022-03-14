#!/bin/bash

echo '=> Installing AppImageLauncher'
echo 'Installing repository.'
sudo add-apt-repository ppa:appimagelauncher-team/stable

echo 'Updating package list.'
sudo apt update

echo 'Installing package.'
sudo apt install appimagelauncher
