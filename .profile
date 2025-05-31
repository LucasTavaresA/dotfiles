#!/usr/bin/env sh
#### Exports ####
#
# muda o local padrão de alguns dotfiles limpando a $HOME ou ~
# define diretórios com o padrão xdg
export HOME="/home/lucas"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_BIN_HOME="$HOME/.local/bin"
# window manager
export WM="sway"
# terminal
export TERMINAL="foot"
export TERM="xterm-256color"
# navegador padrão
export BROWSER="qutebrowser"
# threads
THREADS="$(nproc)"
export THREADS
# systema
HOSTNAME="$(uname -n)"
export HOSTNAME
case $HOSTNAME in
	*"artixlinux"*) export OS="artixlinux" ;;
	*"voidlinux"*) export OS="voidlinux" ;;
	*"archlinux"*) export OS="archlinux" ;;
	*"manjaro"*) export OS="manjaro" ;;
	*"linuxmint"*) export OS="linuxmint" ;;
esac
# Wayland
if [ "$WM" = "sway" ] || [ "$WM" = "dwl" ] || [ "$WM" = "cagebreak" ]; then
	export XDG_SESSION_TYPE=wayland
	export MOZ_ENABLE_WAYLAND=1
	export QT_QPA_PLATFORM=wayland-egl
	export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
	export SDL_VIDEODRIVER=wayland
	export _JAVA_AWT_WM_NONREPARENTING=1
	export LIBSEAT_BACKEND=seatd
	export ELM_DISPLAY=wl
else
	export XDG_SESSION_TYPE="x11"
fi
# onde procurar manpages
export MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man:/usr/lib/jvm/default/man:/usr/lib/jvm/java-11-openjdk/man"
# bat como o manpager
export MANPAGER="nvim +Man!"
[ "$OS" = "voidlinux" ] && export XBPS_DISTDIR="/home/lucas/code/void-packages"
# pass
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pass"
# pager
export PAGER="less -R --ignore-case --incsearch"
export LESS="-R --ignore-case --incsearch"
# less
export LESSHISTFILE="-"
# wget
export WGETRC="${XDG_DATA_HOME:-$HOME/.local/share}/wget/wgetrc"
export PARALLEL_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/parallel"
# xauthority
export XAUTHORITY="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/Xauthority"
export XCURSOR_PATH="${XCURSOR_PATH}:~/.local/share/icons"
export XCURSOR_THEME="Adwaita"
export XCURSOR_SIZE="14"
# cargo
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export CARGO_INSTALL_OPTS="--locked"
# omnisharp
export OMNISHARPHOME="${XDG_DATA_HOME:-$HOME/.local/share}/omnisharp"
# java
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME:-$HOME/.config}/java"
# dotnet
export DOTNET_ROOT="$XDG_DATA_HOME/dotnet"
export DOTNET_CLI_TELEMETRY_OPTOUT=true
# nuget
export NUGET_PACKAGES="${XDG_CACHE_HOME:-$HOME/.cache}/NuGetPackages"
# npm
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
# terminfo
export TERMINFO="${XDG_DATA_HOME:-$HOME/.local/share}/terminfo"
# inputrc
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/readline/inputrc"
# w3m
export W3M_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/w3m"
# go
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
# ghcup
export GHCUP_USE_XDG_DIRS="1"
export GHCUP_INSTALL_BASE_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/"
# cabal
export CABAL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/cabal/config"
export CABAL_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/cabal"
# android sdk
export ANDROID_STUDIO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/android-studio"
export ANDROID_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/Android/Sdk"
export ANDROID_USER_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/android"
export GRADLE_USER_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/gradle"
# wine
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
# ls colors
export LS_COLORS="di=1;34:ln=1;36:so=1;33:pi=1;35:ex=32:bd=1;0;44:cd=1;36;42:su=1;32;42:sg=1;32;44:tw=0;45:ow=30;43"
# fzf
export FZF_ALT_C_COMMAND="fd --base-directory $HOME -H -I -d 4 -t d -E '*cache*' -E '*git*'"

# shell
export SHELL="/bin/sh"
# muda o local do zshrc
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
# muda o local do histórico
export HISTFILE="${XDG_CONFIG_HOME:-$HOME/.config}/shell/history"
# aumenta o tamanho limite do histórico
export HISTSIZE=10000
export HISTFILESIZE=10000
# ignora e deleta comandos duplicados no histórico
export HISTCONTROL=ignoredups:erasedups

# adiciona diretórios bin e scripts ao path
export PATH="$PATH:$ANDROID_STUDIO_HOME/bin"
export PATH="$GOPATH/bin:$PATH"
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/bflat:$PATH"
export PATH="$XDG_DATA_HOME/dotnet:$PATH"
export PATH="$XDG_DATA_HOME/dotnet/tools:$PATH"
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/omnisharp:$PATH"
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/netcoredbg:$PATH"
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/cargo/bin:$PATH"
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/npm/bin:$PATH"
export PATH="${XDG_BIN_HOME:-$HOME/.local/bin}:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/code/shellscripts/shellscripts:$PATH"
export PATH="$HOME/code/shellscripts/orgmenu:$PATH"
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/ollama/bin:$PATH"
# diffprog
export DIFFPROG="nvim -d"
# mergeprog
export MERGEPROG="nvim -d"
# editor no terminal
export EDITOR="nvim"
# editor com interface gráfica
export VISUAL="term_open -a nvim nvim"
# localização para datas
export LC_TIME="pt_BR.UTF-8"
export FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0"

running="$(ps cax)"
is_running() {
	if echo "$running" | grep -qF "$@"; then
		return 0
	fi
	return 1
}

## GPG/SSH
export GNUPGHOME="$HOME/.gnupg"
SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK
is_running "ssh-agent" || eval "$(ssh-agent -s)"

## Execute
fork() {
	fzf_man update >/dev/null 2>&1
	is_running "syncthing" || syncthing >"$XDG_CACHE_HOME/syncthing.log" 2>&1 &
	is_running "transmission-da" || transmission-daemon >/dev/null 2>&1
	# musica
	is_running "pipewire" || pipewire >"$XDG_CACHE_HOME/pipewire.log" 2>&1 &
	is_running "mpd" || mpd >/dev/null 2>&1
	mpc update >/dev/null 2>&1
}
fork &

[ "$(tty)" != "/dev/tty1" ] && exec fish

# exec sx sh "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
exec sway
