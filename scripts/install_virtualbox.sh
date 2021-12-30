#!/bin/bash

echo '=> Installing VirtualBox'
sudo apt install virtualbox virtualbox-ext-pack
sudo usermod -a -G vboxusers "${USER}"
