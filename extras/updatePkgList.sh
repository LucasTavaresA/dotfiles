#!/bin/sh
[ "$OS" = "voidlinux" ] && xpkg -m > "$HOME/extras/voidlinux-pkgs.txt"
[ "$OS" = "archlinux" ] && pacman -Qqem > "$HOME/extras/$PC-aurpkgs.txt" && pacman -Qqen > "$HOME/extras/$PC-nativepkgs.txt"
