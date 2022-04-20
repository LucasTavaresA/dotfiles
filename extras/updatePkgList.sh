#!/bin/sh
xbps-query -l > "$HOME/extras/voidlinux-pkgs.txt" && exit
pacman -Qqem > "$HOME/extras/$PC-aurpkgs.txt" && pacman -Qqen > "$HOME/extras/$PC-nativepkgs.txt"
