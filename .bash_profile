#
# ~/.bash_profile
#
# Executa o bashrc

export SHELL='dash'

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
# Diretorio de scripts do dmenu
export PATH=/home/lucas/dmenu/menus:$PATH
# Aumenta o amanho limite do .bash_history
export HISTSIZE=5000
export HISTFILESIZE=5000
# Usa o seahorse como autenticador GUI
export SUDO_ASKPASS="/usr/lib/seahorse/ssh-askpass"

# Inicia o servidor xorg com .xinitrc do usuario
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  exec startx
fi
