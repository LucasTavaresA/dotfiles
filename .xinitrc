#!/bin/bash

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

slstatus &
lxsession &
dunst &
nitrogen --restore &
clipmenud &

xautolock -detectsleep -time 30 -locker "slock" -notify 30 -notifier "notify-send -u critical -t 10000 -- 'LOCKING SCREEN IN 30 SECONDS'" &
setxkbmap -option caps:escape # muda a função da tecla caps lock para esc
xset r rate 300 50 # acelera repetição de teclas quando seguradas

exec dwm
