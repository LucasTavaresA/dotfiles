# Se não executando zsh interativamente
# Não executa o resto do bashrc
[[ $- != *i* ]] && return

# ZSH EXPORTS
export SHELL="zsh"
# Não adiciona esses itens ao histórico
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
HISTFILE=~/.local/share/history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Carrega cores
autoload -U colors && colors

# Ativa comentários na mesma linha de um comando
setopt interactive_comments

# Completar comandos
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Incluir arquivos ocultos.

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
alias clip='xclip -selection clipboard'
alias sudo="doas"
alias yt='yt-dlp'
alias yta='yt-dlp -k -x --audio-format mp3'
# Arquivos e Diretórios
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
alias exp="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n"

# Prompt do starship
eval "$(starship init zsh)"

# Carrega os indicações de sintaxe; deve ser o ultimo comando.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-expand-all/zsh-expand-all.zsh
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh
