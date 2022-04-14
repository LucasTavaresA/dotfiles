#!/bin/sh
pacman -Qqem > "$HOME/extras/$PC-aurpkgs.txt" && pacman -Qqen > "$HOME/extras/$PC-nativepkgs.txt"
