#!/bin/bash
script_name="$(basename "${0}")"

echo '=> Installing Virt-Manager'
# @todo Create Version Specific KVM Installation
# @body Create a distro and version specific KVM installation as per: https://help.ubuntu.com/community/KVM/Installation
if egrep -c '(vmx|svm)' /proc/cpuinfo > /dev/null; then
  echo 'Installing Dependencies'
  sudo apt-get install ebtables dnsmasq gir1.2-spiceclientgtk-3.0 qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

  echo 'Configuring KVM'
  sudo adduser "${USER}" libvirt

  echo 'Installing Virt-Manager'
  sudo apt-get install virt-manager

  echo 'Installing Optional libguestfs Software'
  sudo apt-get install libguestfs-tools

  if egrep -c ' lm ' /proc/cpuinfo > /dev/null; then
    if [[ "$(uname -m)" != "x86_64" ]]; then
      echo 'Warning: May be limited to 2GB RAM per VM due to 32-bit kernel on 64-bit capable system'
    fi
  fi
  echo 'Warning: Re-login or restart may be required to function correctly'
else
  echo "Aborting ${script_name}"
  echo "  CPU Does Not Support Hardware Virtualization"
  exit 1
fi

exit 0
