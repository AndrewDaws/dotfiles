#!/bin/bash

echo '=> Installing Wine'

# Enable multiarch to install both 64-bit and 32-bit applications
sudo dpkg --add-architecture i386
sudo apt update

# Install Wine
sudo apt install wine64 wine32

# Configure Wine
winecfg
