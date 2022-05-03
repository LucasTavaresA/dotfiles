#!/bin/sh
[ "$OS" = "voidlinux" ] && xpkg -m > "$HOME/extras/$HOSTNAME-pkgs.txt"
[ "$OS" = "archlinux" ] && pacman -Qqem > "$HOME/extras/$HOSTNAME-aurpkgs.txt" && pacman -Qqen > "$HOME/extras/$HOSTNAME-nativepkgs.txt"
