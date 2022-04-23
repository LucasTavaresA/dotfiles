# Trocado de diretório pela variável ZDOTDIR

# se não executando zsh interativamente não executa o resto do zshrc
[[ $- != *i* ]] && return

#### Zsh exports ####
export SHELL="zsh"
export GIT_TTY=$TTY
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
bindkey "^X" execute-named-cmd
bindkey "^[[H"   beginning-of-line
bindkey "^[[4~"   end-of-line
bindkey -s "^[f" '^Ulf^M'

# completar comandos
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Incluir arquivos ocultos.

#### Aliases ####
alias as="alias | grep --color -i"
alias n="neofetch"
alias v="nvim"
alias vv="st -e nvim"
alias h="htop"
alias ed="emacs --daemon"
alias ek="emacsclient -e '(kill-emacs)'"
alias ec="emacsclient -n -c"
alias e="emacs"
alias copy="xclip -selection clipboard"
alias sudo="doas"
alias ping="ping google.com"
alias p="patch -p1 <"
alias pr="patch -R <"
alias yt="yt-dlp"
alias yta="yt-dlp -x --audio-format mp3"
alias ka="killall"
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
# arquivos e Diretórios
alias l="lsd -lXA1 --group-dirs first"
alias la="lsd -AX1 --group-dirs first"
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
# git
alias gi="git init"
alias gc="git clone"
alias gs="git status"
alias gpr="find . -mindepth 2 -maxdepth 2 | xargs -I{} git -C {} pull"
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
alias gf="git fetch"
alias gr="git restore"
alias grs="git restore --staged"
alias grrs="git reset --soft"
alias grrh="git reset --hard"

## aliases em systemas
if [ "$OS" = "voidlinux" ]; then
    # xbps
    alias xis="doas xbps-install -S"
    alias xqr="xbps-query -R"
    alias xqrs="xbps-query -Rs"
    alias xisu="doas xbps-install -Su"
    alias xql="xbps-query -l"
    alias xrr="doas xbps-remove -R"
    alias xqp="xbps-query -p install-date -s '' | sort -k2 | column -t"
elif [ "$OS" = "archlinux" ] || [ "$OS" = "manjaro" ]; then
    # pacman
    alias ps="doas pacman -S"
    alias psi="pacman -Si"
    alias pss="pacman -Ss"
    alias psyu="doas pacman -Syu"
    alias pq="pacman -Q"
    alias pqs="pacman -Qs"
    alias prns="doas pacman -Rns"
    alias exp="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n"
    # paru
    alias pps="paru -S"
    alias ppsi="paru -Si"
    alias ppss="paru -Ss"
    alias ppsyu="paru -Syu"
    alias ppq="paru -Q"
    alias ppqs="paru -Qs"
    alias pprns="paru -Rns"
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
# localizar e editar arquivo
vw () {
    nvim $(where $1)
}

# hersbstluftwm
hc () {
    herbstclient "$@"
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
PS1="%B[%n@%m] %4~ %{$fg[green]%}>%{$reset_color%}%b"

# carrega plugins do zsh, deve ser o ultimo comando
source $HOME/.config/shell/plugins/fsh/F-Sy-H.plugin.zsh
source $HOME/.config/shell/plugins/zsh-you-should-use.plugin.zsh
source $HOME/.config/shell/plugins/zsh-auto-notify.zsh
source $HOME/.config/shell/plugins/fzf.zsh
source $HOME/.config/shell/plugins/keys-fzf.zsh
bindkey  "^[d"   fzf-cd-widget
bindkey  "^[s"   fzf-history-widget
