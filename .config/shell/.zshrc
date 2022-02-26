# Se não executando zsh interativamente
# Não executa o resto do bashrc
[[ $- != *i* ]] && return

# ZSH EXPORTS
export SHELL="zsh"
# Não adiciona esses itens ao histórico
export HISTORY_IGNORE="(ls|cd|pwd|exit|doas reboot|history|cd -|cd ..)"
HISTFILE=~/.config/shell/history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Carrega cores
autoload -U colors && colors

# Ativa comentários na mesma linha de um comando
setopt interactive_comments

# TECLAS
# Modo emacs
bindkey -e
bindkey "^?" backward-delete-char
bindkey "^[[3~" delete-char
bindkey -a '^[[3~' delete-char
bindkey "^X" execute-named-cmd
bindkey "^[[H"   beginning-of-line
bindkey "^[[4~"   end-of-line
bindkey -s "^[f" '^Ulf^M'

# Completar comandos
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Incluir arquivos ocultos.

## FUNÇÕES

# Previsão de imagens no lf
lf () {
    LF_TEMPDIR="$(mktemp -d -t lf-tempdir-XXXXXX)"
    LF_TEMPDIR="$LF_TEMPDIR" lf-run -last-dir-path="$LF_TEMPDIR/lastdir" "$@"
    if [ "$(cat "$LF_TEMPDIR/cdtolastdir" 2>/dev/null)" = "1" ]; then
	cd "$(cat "$LF_TEMPDIR/lastdir")"
    fi
    rm -r "$LF_TEMPDIR"
    unset LF_TEMPDIR
}

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
alias n="neofetch"
alias v="nvim"
alias h="htop"
alias ed="emacs --daemon"
alias ek="emacsclient -e '(kill-emacs)'"
alias e="emacsclient -n -c"
alias copy="xclip -selection clipboard"
alias sudo="doas"
alias p="ping google.com"
alias yt="yt-dlp"
alias yta="yt-dlp -x --audio-format mp3"
alias ka="doas killall"
alias mi="make install"
alias mu="make uninstall"
alias dh="doom help"
alias ds="doom sync"
alias dd="doom doctor"
alias du="doom upgrade"
alias dr="doom run"
alias dp="doom purge"
alias dmi="doas make install"
alias dmu="doas make uninstall"
alias dnr="dotnet run"
alias dnn="dotnet new"
alias dns="dotnet-script"
alias xp="xprop"
alias xk="xkill"
alias grep="grep --color -i"
alias sys="doas systemctl"
# Arquivos e Diretórios
alias l="lsd -l --group-dirs first"
alias la="lsd -A --group-dirs first"
alias lla="lsd -lA --group-dirs first"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias lo="locate -Ai"
alias u="doas updatedb"
alias ch="chmod +x"
alias cp="cp -ri"
alias mv="mv -i"
alias rm="rm -rI"
alias rmf="rm -rf"
alias ln="ln -i"
alias md="mkdir -p"
alias t="touch"
alias mnt="doas mount"
alias umnt="doas umount"
# Git
alias gi="git init"
alias gc="git clone"
alias gs="git status"
alias gsr="git_status_recursivo"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline"
alias ga="git add"
alias gaf="git add -f"
alias gcm="git commit"
alias gcmm="git commit -m"
alias gco="git checkout"
alias gps="git push"
alias gpsf="git push -f"
alias gpl="git pull"
alias gr="git restore"
alias grs="git restore --staged"
alias grrs='git reset --soft'
alias grrh='git reset --hard'
# Pacman
alias ps="doas pacman -S"
alias psi="pacman -Si"
alias pss="pacman -Ss"
alias psyu="doas pacman -Syu"
alias pq="pacman -Q"
alias pqs="pacman -Qs"
alias prns="doas pacman -Rns"
alias exp="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n"
# Paru
alias pps="paru -S"
alias ppsi="paru -Si"
alias ppss="paru -Ss"
alias ppsyu="paru -Syu"
alias ppq="paru -Q"
alias ppqs="paru -Qs"
alias pprns="paru -Rns"

# Prompt do starship
eval "$(starship init zsh)"

# Carrega plugins do zsh, deve ser o ultimo comando
source $HOME/.config/shell/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.config/shell/plugins/you-should-use.plugin.zsh
source $HOME/.config/shell/plugins/fzf.zsh
source $HOME/.config/shell/plugins/keys-fzf.zsh
bindkey  "^[d"   fzf-cd-widget
