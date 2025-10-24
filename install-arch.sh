#!/bin/bash

user_name="$USER"

#Global menu and xfce plugin
sudo pacman -S  xfce4-goodies xfce4-power-manager --needed

#GTK theme
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
WhiteSur-gtk-theme/install.sh -l -c dark -c light

#Icons
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git --depth=1
WhiteSur-icon-theme/install.sh

#Cursors
git clone https://github.com/vinceliuice/WhiteSur-cursors.git --depth=1
mkdir -p ~/.local/share/icons/
cp -r WhiteSur-cursors/dist/ ~/.local/share/icons/

#Wallpapers
mkdir -p ~/Pictures/
cp -r wallpaper/* ~/Pictures/

#Plank themes
mkdir -p ~/.local/share/plank/themes/
cp -rp WhiteSur-gtk-theme/src/other/plank/* ~/.local/share/plank/themes/
cp -rp plank/mcOS-BS-iMacM1-Black/ ~/.local/share/plank/themes/


echo "SmallSur installed"
echo "Reboot You system"
