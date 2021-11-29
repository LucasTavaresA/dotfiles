#
# ~/.bashrc
#

### EXPORTS
# Ignora comandos duplicados no bash_history
export HISTCONTROL=ignoredups
# Torna o vim o editor no terminal
export EDITOR="nvim"
# Torna geany o editor com interface gráfica
export VISUAL="geany"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='lsd'
alias l='lsd -l'
alias la='lsd -A'
alias lla='lsd -lA'
alias ..='cd ..'
alias g='geany'
alias gitlog='git log --oneline'
alias v='nvim'

# Ignora case-sensitivity quando completa commandos com tab
if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi
echo 'set completion-ignore-case On' >> ~/.inputrc

### Facilita extrair arquivos
# Exemplo: ex <arquivo>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' não pode ser extraído com ex()" ;;
    esac
  else
    echo "'$1' não é um arquivo valido"
  fi
}

# Inicia prompt do starship
eval "$(starship init bash)"
