#!/bin/sh

pacman -Qqem > foreignpkglist.txt && pacman -Qq > pkglist.txt
