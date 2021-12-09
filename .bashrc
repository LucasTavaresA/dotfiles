#
# ~/.bashrc
#

# Se não executando bash interativamente
# Não executa o resto do bashrc
# Impede que o systema não intencionalmente use aliases causando erros
# Faça seus exports no .bash_profile
[[ $- != *i* ]] && return

# Aliases
alias ls='lsd --group-dirs first'
alias l='lsd -l --group-dirs first'
alias la='lsd -A --group-dirs first'
alias lla='lsd -lA --group-dirs first'
alias ..='cd ..'
alias g='geany'
alias v='nvim'
alias bh='less $HOME/.bash_history'
alias gi='git init'
alias gc='git clone'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline'
alias ga='git add'
alias gcm='git commit -m'
alias gp='git push'
alias gr='git restore'
alias locate='locate -Ai'
alias r='ranger'
alias cat='bat'

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
