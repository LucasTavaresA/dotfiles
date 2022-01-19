### EXPORTS

# Muda o local padrão de alguns dotfiles limpando a $HOME ou ~
# Define diretórios com o padrão xdg
UID="$(id -u)"
export HOME="/home/lucas"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="/run/user/$UID"

# Bat como um manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Terminal
export TERMINAL="st"
export TERM="xterm-256color"
# Editor no terminal
export EDITOR="nvim"
# Editor com interface gráfica
export VISUAL="nvim"
# Navegador padrão
export BROWSER="qutebrowser"
# Pager
export PAGER='less'
# Faz o qt usar o thema do gtk2
export QT_QPA_PLATFORMTHEME="gtk2"
# Less
export LESSHISTFILE="-"
# Wget
export WGETRC="$HOME/.config/wget/wgetrc"
# XAuthority
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
# Cargo
export CARGO_HOME="$HOME/.local/share/cargo"
# Neovim omnisharp
export OMNISHARPHOME="$HOME/.local/share/omnisharp"
# Gnupg
export GNUPGHOME="$HOME/.local/share/gnupg"
# Npm
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm"
# Terminfo
export TERMINFO="$HOME/.local/share/terminfo"
# Inputrc
export INPUTRC="$HOME/.config/readline/inputrc"
# Gtk 2
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc"
# W3m
export W3M_DIR="$HOME/.config/w3m"
# Go
export GOPATH="$HOME/.local/share/go"
# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
# Android sdk
export ANDROID_SDK_HOME="$HOME/.config/android"
# Wine
export WINEPREFIX="$HOME/.local/share/wineprefixes/default"

# Shell
export SHELL="dash"
# Muda o local do zshrc
export ZDOTDIR="$HOME/.config/zsh"
# Muda o local do histórico
export HISTFILE="$HOME/.local/share/history"
# Aumenta o tamanho limite do histórico
export HISTSIZE=10000
export HISTFILESIZE=10000
# Ignora e deleta comandos duplicados no histórico
export HISTCONTROL=ignoredups:erasedups

# Adiciona diretório de scripts ao path
export PATH="$HOME/code/dmenuscripts:$PATH"
export PATH="$HOME/code/scripts:$PATH"

# Usa o dmenu como autenticador GUI
export SSH_ASKPASS="$HOME/code/scripts/doas_askpass"
export GIT_ASKPASS="$HOME/code/scripts/doas_askpass"
export SUDO_ASKPASS="$HOME/code/scripts/doas_askpass"
export DOAS_ASKPASS="$HOME/code/scripts/doas_askpass"

# Localização para datas
export LC_TIME="pt_BR.UTF-8"

# Inicia o servidor xorg com .xinitrc do usuário
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  exec startx "$HOME/.config/x11/xinitrc"
fi
