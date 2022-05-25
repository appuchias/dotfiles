#!/bin/sh

sudo pacman -Syyuu fish


# Install oh my fish for fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

# Install omf !! plugin
omf install bang-bang

# Install colorscript
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
rm -rf /opt/shell-color-scripts || return 1
sudo mkdir -p /opt/shell-color-scripts/colorscripts || return 1
sudo cp -rf colorscripts/* /opt/shell-color-scripts/colorscripts
sudo cp colorscript.sh /usr/bin/colorscript
touch ~/.Xresources

# Dependencies of headsetcontrol
pacman -S git cmake hidapi
git clone https://github.com/Sapd/HeadsetControl && cd HeadsetControl
mkdir build && cd build
cmake ..
make
# Install headsetcontrol in every folder
sudo make install
# HSC without root
sudo headsetcontrol -u
sudo udevadm control --reload-rules && sudo udevadm trigger

# Install wanted packages
sudo pacman -S starship gparted alacritty htop ripgrep inxi lsd bat tree traceroute udns kitty vim git
