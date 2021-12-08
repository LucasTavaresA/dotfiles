#
# ~/.bash_profile
#

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
# Subs file
export SUBS_FILE='$HOME/especial/subs.txt'

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  exec startx
fi
