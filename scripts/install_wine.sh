#!/bin/bash

echo '=> Installing Wine'

# Enable multiarch to install both 64-bit and 32-bit applications
sudo dpkg --add-architecture i386
sudo apt update

# Import WineHQ repository’s GPG key
wget -qO- https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -

# Add WineHQ repository
sudo apt install software-properties-common
sudo apt-add-repository "deb http://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main"

# Install Wine
sudo apt install --install-recommends winehq-stable

# Configure Wine
winecfg
