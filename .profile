#!/usr/bin/env sh
# shellcheck disable=SC2155
#### Exports ####
export HOME="/home/lucas"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_BIN_HOME="$HOME/.local/bin"
export WM="sway"
export TERMINAL="foot"
export BROWSER="qutebrowser"
export THREADS="$(nproc)"
export HOSTNAME="$(uname -n)"
export DMENU="tofi"

case $HOSTNAME in
	*"artixlinux"*) export OS="artixlinux" ;;
	*"nixos"*) export OS="nixos" ;;
	*"archlinux"*) export OS="archlinux" ;;
	*"manjaro"*) export OS="manjaro" ;;
	*"linuxmint"*) export OS="linuxmint" ;;
esac

export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
[ "$OS" != "nixos" ] && export LIBSEAT_BACKEND=seatd
export ELM_DISPLAY=wl
export MANPAGER="nvim +Man!"
export PAGER="less -R --ignore-case --incsearch"
export LESS="-R --ignore-case --incsearch"
export LESSHISTFILE="-"
export WGETRC="${XDG_DATA_HOME:-$HOME/.local/share}/wget/wgetrc"
export PARALLEL_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/parallel"
export XAUTHORITY="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/Xauthority"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export CARGO_INSTALL_OPTS="--locked"
export OMNISHARPHOME="${XDG_DATA_HOME:-$HOME/.local/share}/omnisharp"
export DOTNET_ROOT="$XDG_DATA_HOME/dotnet"
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export NUGET_PACKAGES="${XDG_CACHE_HOME:-$HOME/.cache}/NuGetPackages"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
export TERMINFO="${XDG_DATA_HOME:-$HOME/.local/share}/terminfo"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/readline/inputrc"
export W3M_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/w3m"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GHCUP_USE_XDG_DIRS="1"
export GHCUP_INSTALL_BASE_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/"
export CABAL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/cabal/config"
export CABAL_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/cabal"
export ANDROID_STUDIO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/android-studio"
export ANDROID_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/Android/Sdk"
export ANDROID_USER_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/android"
export GRADLE_USER_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/gradle"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
export LS_COLORS="di=1;34:ln=1;36:so=1;33:pi=1;35:ex=32:bd=1;0;44:cd=1;36;42:su=1;32;42:sg=1;32;44:tw=0;45:ow=30;43"
export FZF_ALT_C_COMMAND="fd --base-directory $HOME -H -I -d 4 -t d -E '*cache*' -E '*git*'"
export PYTHON_HISTORY="${XDG_DATA_HOME:-$HOME/.local/share}/python_history"
export SHELL="$(which sh)"
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups
export DIFFPROG="nvim -d"
export MERGEPROG="nvim -d"
export EDITOR="nvim"
export VISUAL="foot -T nvim -a nvim nvim"
export LC_TIME="pt_BR.UTF-8"
export DO_NOT_TRACK=true
export OPENCODE_EXPERIMENTAL_LSP_TOOL=true
export OPENCODE_ENABLE_EXA=1
export CLAUDE_CONFIG_DIR=$HOME/.config/claude

#### PATH ####
if [ "$OS" != "nixos" ]; then
	# TODO(LucasTA): update those PATH entries to work with nixos
	export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/bflat:$PATH"
	export PATH="$XDG_DATA_HOME/dotnet:$PATH"
	export PATH="$HOME/.dotnet/tools:$PATH"
	export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/omnisharp:$PATH"
	export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/netcoredbg:$PATH"
	export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/odin/bin:$PATH"
	export PATH="${XDG_BIN_HOME:-$HOME/.local/bin}:$PATH"
	export PATH="$PATH:$ANDROID_STUDIO_HOME/bin"
fi

export PATH="$HOME/code/shellscripts/shellscripts:$PATH"
export PATH="$HOME/code/rust/orgmenu:$PATH"

#### Startup ####
case "$-" in
	*i*)
		if [ "$(tty)" = "/dev/tty1" ]; then
			# detach from the console VT so child processes
			# fail isatty() and spawn terminal apps in a real terminal
			# this also logs to journalctl
			exec systemd-cat -t sway sway </dev/null
		else
			exec fish
		fi
		;;
esac
