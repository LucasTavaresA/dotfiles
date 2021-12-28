# Se não executando bash interativamente
# Não executa o resto do bashrc
[[ $- != *i* ]] && return

# Aliases
# Arquivos e Diretórios
alias rm="rm -ri"
alias l='lsd -l --group-dirs first'
alias la='lsd -A --group-dirs first'
alias lla='lsd -lA --group-dirs first'
alias ..='cd ..'
alias lo='locate -Ai'
alias u='sudo updatedb'
alias ch='chmod +x'
# Programas
alias n='neofetch'
alias g='geany'
alias v='nvim'
alias r='ranger'
alias cat='bat'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'
# Git aliases
alias gi='git init'
alias gc='git clone'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline'
alias ga='git add'
alias gcm='git commit -m'
alias gp='git push'
alias gr='git restore'
# Pacman
alias ps='sudo pacman -S'
alias psi='pacman -Si'
alias pss='pacman -Ss'
alias psyu='sudo pacman -Syu'
alias pqs='pacman -Qs'
alias prns='sudo pacman -Rns'
alias expac="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n"

# Ignora case-sensitivity quando completa comandos com tab
if [ ! -a $HOME/.config/readline/inputrc ]; then echo '$include /etc/inputrc' > $HOME/.config/readline/inputrc; fi
echo 'set completion-ignore-case On' >> $HOME/.config/readline/inputrc
# Corrige automaticamente erros ao usar o cd
shopt -s cdspell
# Salva comandos de múltiplas linhas como uma linha única
shopt -s cmdhist

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
