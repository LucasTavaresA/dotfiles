#!/bin/bash

# Gnome keyring daemon
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# Clipmenu
systemctl --user import-environment DISPLAY
export CM_DIR="$HOME/.cache/clipmenu"
clipmenud &

# Outros
fluxgui &
nm-applet &
slstatus &
dunst &
nitrogen --restore &
xbanish &

# Protetor de tela
xautolock -detectsleep -time 30 -locker "slock" -notify 30 -notifier "notify-send -u critical -t 10000 -- 'BLOQUEANDO A TELA 30 SEGUNDOS'" &

# Teclado
setxkbmap -option caps:escape # muda a função da tecla caps lock para esc
xset r rate 300 50 # acelera repetição de teclas quando seguradas

exec dwm
