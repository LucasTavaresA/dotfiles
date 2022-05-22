# Trocado de diretório pela variável ZDOTDIR

# se não executando zsh interativamente não executa o resto do zshrc
[[ $- != *i* ]] && return

#### Zsh exports ####
export SHELL="zsh"
export GPG_TTY=$TTY
# não adiciona esses itens ao histórico
export HISTORY_IGNORE="(lsd|ls|cd|pwd|exit|doas reboot|history|cd -|cd ..)"

HISTFILE=~/.config/shell/history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# carrega cores
autoload -U colors && colors

# ativa comentários na mesma linha de um comando
setopt interactive_comments

# Teclas
# modo emacs
bindkey -e
# modo vi
# bindkey -v
bindkey "^?" backward-delete-char
bindkey "^[[3~" delete-char
bindkey -a '^[[3~' delete-char
bindkey "^[[H"   beginning-of-line
bindkey "^[[4~"   end-of-line
bindkey "^J"   backward-char
bindkey "^K"   forward-char

# completar comandos
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Incluir arquivos ocultos.

#### Aliases ####
alias hc="herbstclient"
alias as="alias | grep --color -i"
alias n="neofetch"
alias v="nvim"
alias vv="st -e nvim"
alias h="htop"
alias ed="emacs --daemon"
alias ek="emacsclient -e '(kill-emacs)'"
alias et="emacsclient -nw"
alias e="emacsclient -n -c"
alias copy="xclip -selection clipboard"
alias sudo="doas"
alias ping="ping google.com"
alias p="patch -p1 <"
alias pr="patch -R <"
alias yt="yt-dlp"
alias yta="yt-dlp -x --audio-format mp3"
alias pk="pkill"
alias mi="make install"
alias mu="make uninstall"
alias dh="doom help"
alias ds="doom sync"
alias dd="doom doctor"
alias du="doom upgrade"
alias dr="doom_reset"
alias dp="doom purge"
alias dmi="doas make install"
alias dmu="doas make uninstall"
alias dnr="dotnet run"
alias dnn="dotnet new"
alias dns="dotnet-script"
alias xp="xprop"
alias xk="xkill"
alias grep="grep --color -i -I"
alias sys="doas systemctl"
[ "$OS" = "voidlinux" ] && alias sys="doas sv"
# arquivos e Diretórios
alias l="lsd -AX1 --group-dirs first"
alias la="lsd -lXA1 --group-dirs first"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias lo="locate -Ai"
alias u="doas updatedb"
alias ch="chmod +x"
alias cp="cp -ri"
alias mv="mv -i"
alias rm="lixo"
alias rml="lixo limpar"
alias ln="ln -i"
alias md="mkdir -p"
alias t="touch"
alias mnt="doas mount"
alias umnt="doas umount"
# git
alias gi="git init"
alias gc="git clone"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline"
alias ga="git add"
alias gaf="git add -f"
alias gcm="git commit"
alias gcmm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gcam="git commit --amend"
alias gcamm="git commit --amend -m"
alias gco="git checkout"
alias gps="git push"
alias gpsf="git push -f"
alias gpl="git pull"
alias gf="git fetch"
alias gr="git restore"
alias grs="git restore --staged"
alias grrs="git reset --soft"
alias grrh="git reset --hard"
alias gg="git grep -i -I -n --break --heading -p"

## aliases em sistemas
if [ "$OS" = "voidlinux" ]; then
    alias xs="./xbps-src"
    # xbps
    alias xis="doas xbps-install -S"
    alias xqrs="xbps-query -Rs"
    alias xisu="doas xbps-install -Su"
    alias xql="xbps-query -l"
    alias xqlg="xbps-query -l | grep --color -i"
    alias xrr="doas xbps-remove -R"
    # xtools
    alias chroot="xchroot"
    alias xg="xgrep"
    alias xh="xhog"
    alias xil="xilog"
    alias xl="xlocate -S && xlocate"
    alias xls="xls"
    alias xm="xmandoc"
    alias xqr="xq -R"
elif [ "$OS" = "artixlinux" ] || [ "$OS" = "archlinux" ] || [ "$OS" = "manjaro" ]; then
    # pacman
    alias ps="doas pacman --color always -S"
    alias psi="pacman --color always -Si"
    alias pss="pacman --color always -Ss"
    alias psyu="doas pacman --color always -Syu"
    alias pq="pacman --color always -Q"
    alias pqi="pacman --color always -Qi"
    alias pqs="pacman --color always -Qs"
    alias pfyl="pacman --color always -Fyl"
    alias prns="doas pacman --color always -Rns"
    alias exp="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n"
    # paru
    alias pps="paru --color always -S"
    alias ppsi="paru --color always -Si"
    alias ppss="paru --color always -Ss"
    alias ppsyu="paru -Pw;paru --color always -Syu"
    alias ppq="paru --color always -Q"
    alias ppqi="paru --color always -Qi"
    alias ppqs="paru --color always -Qs"
    alias ppfyl="paru --color always -Fyl"
    alias pprns="paru --color always -Rns"
elif [ "$OS" = "linuxmint" ]; then
    alias bat="batcat"
    # apt
    alias ai="doas apt install"
    alias as="apt show"
    alias ass="apt search"
    alias auau="doas apt update && doas apt upgrade"
    alias ali="apt list --installed"
    alias ar="doas apt remove"
fi

## Funções
# lixeira
lixo () {
    [ ! -d ~/.trash ] && mkdir ~/.trash
    [ ! -d ~/.cache ] && mkdir ~/.cache
    if [ "$1" = "limpar" ]; then
        lsd -lA ~/.trash/
        \rm -rf ~/.trash/*
        \rm -rf ~/.trash/.*
        \rm -f .cache/lixo
        return
    fi
    substituir () {
        for arquivo in "$@"
        do
            mv -f $arquivo ~/.trash >/dev/null 2>&1 || nome=${arquivo##*/} && \rm -rf ~/.trash/$nome && mv -f $arquivo ~/.trash
        done
    }
    mv -f "$@" ~/.trash >/dev/null 2>&1 || substituir "$@"
    if [ -e ~/.cache/lixo ]; then
        quantia=$(cat ~/.cache/lixo)
        quantia=$((quantia+1))
        echo $quantia > ~/.cache/lixo
        [ $(cat ~/.cache/lixo) -gt 5 ] && echo "Limpe a sua lixeira!" && notify-send -u critical "Lixeira" "Limpe a sua lixeira!" && return
    else
        touch ~/.cache/lixo
        echo 1 > ~/.cache/lixo
    fi
}

# localizar e editar arquivo
vw () {
    nvim $(where $1)
}

# previsão de imagens no lf
lf () {
    LF_TEMPDIR="$(mktemp -d -t lf-tempdir-XXXXXX)"
    LF_TEMPDIR="$LF_TEMPDIR" lf-run -last-dir-path="$LF_TEMPDIR/lastdir" "$@"
    if [ "$(cat "$LF_TEMPDIR/cdtolastdir" 2>/dev/null)" = "1" ]; then
        cd "$(cat "$LF_TEMPDIR/lastdir")"
    fi
    \rm -r "$LF_TEMPDIR"
    unset LF_TEMPDIR
}

# git status recursivo
gsr () {
    status_ops="$*"
    find . -name '.git' \
        | while read -r repo
    do
        repo=${repo%".git"}
        (git -C "$repo" status -s \
            | grep -q -v "^\$" \
            && echo -e "\n\033[1m${repo}\033[m" \
            && git -C "$repo" status $status_ops) \
            || true
    done
}

# git pull recursivo
gpr () {
    find . -mindepth $1 -maxdepth $1 | xargs -I{} git -C {} pull
}

# facilita extrair arquivos
# exemplo: ex (arquivo).zip
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
                         echo "ex: '$n' - Método de arquivação desconhecido"
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

# prompt
#PS1="%B[%n] %4~ %{$fg[green]%}>%{$reset_color%}%b"

# carrega plugins do zsh, deve ser o ultimo comando
source $HOME/.config/shell/plugins/fsh/F-Sy-H.plugin.zsh
source $HOME/.config/shell/plugins/zsh-expand-all.zsh
ZSH_EXPAND_ALL_DISABLE=word
source $HOME/.config/shell/plugins/zsh-auto-notify.zsh
source $HOME/.config/shell/plugins/fzf.zsh
source $HOME/.config/shell/plugins/keys-fzf.zsh
bindkey  "^[d"   fzf-cd-widget
bindkey  "^[s"   fzf-history-widget

eval "$(starship init zsh)"
