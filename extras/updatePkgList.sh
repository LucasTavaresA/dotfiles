#!/bin/sh
[ "$PC" = "voidlinux" ] && xbps-query -l > "$HOME/extras/voidlinux-pkgs.txt"
[ "$PC" = "archlinux" ] && pacman -Qqem > "$HOME/extras/$PC-aurpkgs.txt" && pacman -Qqen > "$HOME/extras/$PC-nativepkgs.txt"
