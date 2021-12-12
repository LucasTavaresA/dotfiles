#
# ~/.bash_profile
#
# Executa o bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

### EXPORTS
# Terminal
export TERMINAL='st'
# Ignora comandos duplicados no bash_history
export HISTCONTROL=ignoredups
# Editor no terminal
export EDITOR="nvim"
# Editor com interface gráfica
export VISUAL="geany"
# Navegador padrão
export BROWSER="firefox"
# Pager
export PAGER='less'
# Diretorio de binarias do dmenu
# Facilita lidar com os dotfiles de dentro da $HOME
export PATH=/home/lucas/dmenu/menus:$PATH
export HISTSIZE=5000
export HISTFILESIZE=5000

# Inicia o servidor xorg com .xinitrc do usuario
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  exec startx
fi
