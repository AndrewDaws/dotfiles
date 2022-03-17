#!/bin/bash

echo '=> Installing Lutris'
echo 'Installing repository.'
sudo add-apt-repository ppa:lutris-team/lutris

echo 'Updating package list.'
sudo apt update

echo 'Installing package.'
sudo apt install lutris
