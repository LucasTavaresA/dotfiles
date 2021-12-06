#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

### EXPORTS
# Ignora comandos duplicados no bash_history
export HISTCONTROL=ignoredups
# Torna o vim o editor no terminal
export EDITOR="nvim"
# Torna geany o editor com interface gráfica
export VISUAL="geany"
# Torna firefox o navegador padrão
export BROWSER="firefox"
# Torna o less o pager
export PAGER='less'

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  exec startx
fi
