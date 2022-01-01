#!/bin/bash

echo '=> Installing ADB'
sudo apt install android-tools-adb android-tools-fastboot
sudo usermod -a -G plugdev "${USER}"
