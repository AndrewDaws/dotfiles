#!/bin/bash

echo '=> Installing VirtualBox'
sudo apt install virtualbox virtualbox-ext-pack
sudo usermod --append --groups vboxusers "${USER}"
sudo mkdir --parents -- "/etc/vbox"
if ! grep --max-count=1 -- "\* 10.0.0.0/8 192.168.0.0/16" "/etc/vbox/networks.conf" &>/dev/null; then
  echo "* 10.0.0.0/8 192.168.0.0/16" | sudo tee --append "/etc/vbox/networks.conf"
fi
if ! grep --max-count=1 -- "\* 2001::/64" "/etc/vbox/networks.conf" &>/dev/null; then
  echo "* 2001::/64" | sudo tee --append "/etc/vbox/networks.conf"
fi
