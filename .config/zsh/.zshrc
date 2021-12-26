# Se não executando zsh interativamente
# Não executa o resto do bashrc
[[ $- != *i* ]] && return

export SHELL="zsh"

# Carrega cores
autoload -U colors && colors

# Ativa comentários na mesma linha de um comando
setopt interactive_comments

# Completar comandos
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# modo vi
bindkey -v
export KEYTIMEOUT=1
# Muda o formato do cursor para modos diferentes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      
        viins|main) echo -ne '\e[5 q';;
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Usa o cursor | ao iniciar.
preexec() { echo -ne '\e[5 q' ;} # Usa o cursor Z para cada prompt iniciado.

# ZSH EXPORTS
# Shell interativo
export SHELL="zsh"
# Não adiciona esses itens ao histórico
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

# Facilita extrair arquivos
# Exemplo: ex (arquivo).zip
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
function ex {
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "ex: '$n' - Metodo de archivação desconhecido"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - Arquivo não existe"
          return 1
      fi
    done
}
IFS=$SAVEIFS

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

# Prompt do starship
eval "$(starship init zsh)"

# Carrega os indicações de sintaxe; deve ser o ultimo comando.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
