#!/bin/bash

echo '=> Installing Wireshark'
# @todo Create Version Specific Wireshark Installation
# @body Create a distro and version specific Wireshark installation
sudo apt install wireshark
sudo dpkg-reconfigure wireshark-common
sudo usermod -a -G wireshark "${USER}"
