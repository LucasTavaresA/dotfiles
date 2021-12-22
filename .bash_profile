#
# ~/.bash_profile
#
# Shell do systema
export SHELL="dash"

# Muda o local padrão de alguns dotfiles
# limpando a $HOME ~/
export HOME="/home/lucas"
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
# Go
export GOPATH="$HOME/.config/go"
# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"

# Executa o bashrc
[[ -f $HOME/.bashrc ]] && . $HOME/.bashrc

### EXPORTS
# Terminal
export TERMINAL='st'
# Ignora comandos duplicados no bash_history
export HISTCONTROL=ignoredups
# Editor no terminal
export EDITOR="nvim"
# Editor com interface gráfica
export VISUAL="nvim"
# Navegador padrão
export BROWSER="firefox"
# Pager
export PAGER='less'
# Diretorio de scripts do dmenu
export PATH=/home/lucas/suckless/dmenu/menus:$PATH
# Aumenta o amanho limite do .bash_history
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=5000
export HISTFILESIZE=5000
# Usa o seahorse como autenticador GUI
export SUDO_ASKPASS="/usr/lib/seahorse/ssh-askpass"

# Inicia o servidor xorg com .xinitrc do usuario
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  exec startx "$HOME/.config/x11/xinitrc"
fi
