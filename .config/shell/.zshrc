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

## Funções
# localizar e editar arquivo
ea () {
    arquivo=$(locate -Ai "$@" | fzf)
    if [ -n "$arquivo" ]; then
        eval $VISUAL "$arquivo"
    fi
}

# localizar e editar executavel
ee () {
    executavel=$(whereis -b "$@" | cut -d' ' -f2)
    if [ -x "$executavel" ]; then
        eval $VISUAL "$executavel"
    fi
}

# git status recursivo
gsr () {
    for repo in $(fd -H -I -E "*cache*" -E "*.local*" -E "*.config/emacs*" | grep --color -i -I --color -i -I "/.git\$");
    do
        repo=$(echo $repo | sed 's/\/.git$//')
        cols=$(tput cols)
        i=0
        while [ $i -lt $cols ]; do
            echo -n "─"
            i=$((i+1))
        done
        if git status $repo | grep nothing > /dev/null; then
            printf "\033[96m\033[1m%s\033[0m\n" "$repo"
        else
            printf "\033[96m\033[1m%s\033[0m\n" "$repo"
            git status $repo
        fi
    done
}

# facilita extrair arquivos
# exemplo: ex (arquivo).zip
ex () {
    for arquivo in "$@"
    do
        if [ -f "$arquivo" ]; then
            case "$arquivo" in
                "*.7z|*.arj|*.cab|*.cb7|*.chm|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar") \
                                      7z x "$arquivo"        ;;
                "*.bz2")              bunzip2 "$arquivo"     ;;
                "*.cba|*.ace")        unace x "$arquivo"     ;;
                "*.cbr")              unrar x -ad "$arquivo" ;;
                "*.cbt|*.txz")        tar xvf "$arquivo"     ;;
                "*.cbz|*.epub|*.zip") unzip "$arquivo"       ;;
                "*.cpio")             cpio -id < "$arquivo"  ;;
                "*.deb")              ar x "$arquivo"        ;;
                "*.exe")              cabextract "$arquivo"  ;;
                "*.gz")               gunzip "$arquivo"      ;;
                "*.lzma")             unlzma "$arquivo"      ;;
                "*.rar")              unrar x "$arquivo"     ;;
                "*.tar.bz2|*.tbz2")   tar xjf "$arquivo"     ;;
                "*.tar.gz|*.tgz")     tar xzf "$arquivo"     ;;
                "*.tar.xz|*.tar")     tar xf "$arquivo"      ;;
                "*.tar.zst")          unzstd "$arquivo"      ;;
                "*.xz")               unxz "$arquivo"        ;;
                "*.Z|*.z")            uncompress "$arquivo"  ;;
                *)           echo "$arquivo não pode ser extraído com ex()!" && return 1 ;;
            esac
        else
            echo "$arquivo arquivo não existe!"
            return 1
        fi
    done
}

#### Aliases ####
alias hc="herbstclient"
alias as="alias | grep --color -i"
alias n="neofetch"
alias fm="fzf_man"
alias v="nvim"
alias vv="term_open -s nvim"
alias h="htop"
alias ed="emacs --daemon"
alias ek="emacsclient -e '(kill-emacs)'"
alias et="emacsclient -t -a 'nvim'"
alias e="emacsclient -n -c -a 'term_open -s nvim'"
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
alias sys="doas systemctl"
[ "$OS" = "voidlinux" ] && alias sys="doas sv"
# arquivos e Diretórios
alias grep="grep --color -i -I"
alias f="fmz"
alias rm="lixo"
alias rml="lixo limpar"
alias rmf="rm -rf"
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
alias ln="ln -i"
alias md="mkdir -p"
alias t="touch"
alias mnt="doas mount"
alias umnt="doas umount"
# git
alias gi="git init"
alias gc="git clone"
alias gs="git status"
alias gsa="git submodule add https://github.com/"
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
alias grv="git remote -v"
alias grs="git restore --staged"
alias grsu="git remote set-url origin"
alias grrs="git reset --soft"
alias grrh="git reset --hard"
alias gg="git grep -i -I -n --break --heading -p"

## aliases em sistemas
if [ "$OS" = "artixlinux" ] || [ "$OS" = "archlinux" ] || [ "$OS" = "manjaro" ]; then
    # pacman
    alias ps="doas pacman --color always -S"
    alias psi="pacman --color always -Si"
    alias pss="pacman --color always -Ss"
    alias psyu="doas pacman --color always -Syu"
    alias pq="pacman --color always -Q"
    alias pqi="pacman --color always -Qi"
    alias pqs="pacman --color always -Qs"
    alias pfyl="doas pacman --color always -Fyl"
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
elif [ "$OS" = "voidlinux" ]; then
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
    alias xm="xmandoc"
    alias xqr="xq -R"
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

# carrega plugins do zsh, deve ser o ultimo comando
source $HOME/.config/shell/plugins/fsh/F-Sy-H.plugin.zsh
source $HOME/.config/shell/plugins/zsh-expand-all.zsh
ZSH_EXPAND_ALL_DISABLE=word
source $HOME/.config/shell/plugins/zsh-auto-notify.zsh
source $HOME/.config/shell/plugins/fzf.zsh
source $HOME/.config/shell/plugins/keys-fzf.zsh
bindkey  "^[d"   fzf-cd-widget
bindkey  "^[s"   fzf-history-widget

# prompt
#PS1="%B[%n] %4~ %{$fg[green]%}>%{$reset_color%}%b"
eval "$(starship init zsh)"
