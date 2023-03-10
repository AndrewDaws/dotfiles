#!/bin/bash

echo '=> Installing Syncthing'
# @todo Create Version Specific Syncthing Installation
# @body Create a distro and version specific Syncthing installation

################################################################################
# APT Install processs from: https://apt.syncthing.net/
################################################################################
# Add the release PGP keys:
sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.

# Add the "stable" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Increase preference of Syncthing's packages ("pinning")
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing

# Update and install syncthing:
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates syncthing

################################################################################
# Autostart instructions from: https://docs.syncthing.net/users/autostart.html#linux
################################################################################
# Enable systemd user service
systemctl --user enable syncthing.service

# Start systemd user service
systemctl --user start syncthing.service

# Print out web UI address
echo '=> Access Web UI @ http://127.0.0.1:8384/'

################################################################################
# Gnome extension from: https://extensions.gnome.org/extension/1070/syncthing-indicator/
################################################################################
