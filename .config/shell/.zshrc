# Trocado de diretório pela variável ZDOTDIR

# se não executando zsh interativamente não executa o resto do zshrc
[[ $- != *i* ]] && return

#### Zsh exports ####
export SHELL="/bin/zsh"
export GPG_TTY=$TTY
# não adiciona esses itens ao histórico
export HISTORY_IGNORE="(lsd|ls|cd|pwd|exit|doas reboot|history|cd -|cd ..)"

HISTFILE=~/.config/shell/history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

eval "$(zoxide init zsh)"

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
        eval $EDITOR "$arquivo"
    fi
}

# localizar e editar executável
ee () {
    executavel=$(dmenu_path | fzf)
    if [ -x "$executavel" ]; then
        eval $EDITOR "$executavel"
    fi
}

# git bare dotfiles
git () {
    if [ $(pwd) = $HOME ] && [ $1 != "init" ]; then
        /usr/bin/git --git-dir="$HOME/etc/.dotfiles/" $@
    else
        /usr/bin/git $@
    fi
}

# git status recursivo
gsr () {
    cdir=$(pwd)
    for repo in $(fd -a -t d -u -E '*cache*' -E '*.local*' -E '*.config/emacs*' | ugrep '\.git/$');
    do
        repo=$(echo $repo | sed 's/\/.git\/$//')
        cd $repo

        cols=$(tput cols)
        i=0
        while [ $i -lt $cols ]; do
            echo -n "─"
            i=$((i+1))
        done

        if git status | grep nothing > /dev/null; then
            printf "\033[96m\033[1m%s\033[0m\n" "$repo"
        else
            printf "\033[96m\033[1m%s\033[0m\n" "$repo"
            git status
        fi
    done
    cd $cdir
}

# git pull recursivo
gpr () {
    cdir=$(pwd)
    for repo in $(fd -a -t d -u -E '*cache*' -E '*.local*' -E '*.config/emacs*' | ugrep '\.git/$');
    do
        repo=$(echo $repo | sed 's/\/.git\/$//')
        cd $repo

        cols=$(tput cols)
        i=0
        while [ $i -lt $cols ]; do
            echo -n "─"
            i=$((i+1))
        done
        echo

        read -p "pull $repo ? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            git pull
        fi
    done
    cd $cdir
}

# git stash list
# usa o fzf para selecionar uma stash e uma ação
gsl () {
    snum="$(git stash list | fzf | sed 's/^.*{//;s/}.*$//')"
    [ -z $snum ] && return
    action="$(printf "apply\ndrop\nshow\nbranch\nclear" | fzf)"
    [ -z $action ] && return

    [ "$action" = "clear" ] && git stash $action && return

    if [ $action = "branch" ]; then
        read "name?Branch name: "
        [ -z $name ] && return
        git stash branch $name $snum && return
    fi

    git stash $action $snum
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

criar_script () {
    lang=$1
    arquivo=$2
    printf "#!/usr/bin/env $lang\n${*:3}" > $arquivo
}

#### Aliases ####
alias cd="z"
alias cage="cage -s --"
alias cat="bat"
alias sg="sgrade"
alias cs="criar_script"
alias css="criar_script sh script.sh"
alias pk="pkill -i"
alias pg="pgrep -ia"
alias uma="doas usermod -aG"
alias umr="doas usermod -rG"
alias df="df -hT --total -x tmpfs -x devtmpfs"
alias tep="trans -s pt -l en"
alias tpe="trans -s pt -l en"
alias fm="fzf_man"
alias hc="herbstclient"
alias as="alias | ugrep --color -i"
alias ff="flashfetch"
alias v="nvim"
alias vc="nvim --clean"
alias vv="term_open -a nvim nvim"
alias h="htop"
alias copy="xclip -selection clipboard"
alias sudo="doas"
alias ping="ping gnu.org"
alias p="patch -p1 <"
alias pr="patch -R <"
alias vol="wpctl set-volume @DEFAULT_AUDIO_SINK@ 70%"
alias vols="wpctl status"
alias yt="yt-dlp -P ~/Downloads --write-subs"
[ "$HOSTNAME" = "$OS"note ] && alias yt="yt-dlp -P ~/Downloads --write-subs -f 'worstvideo*[height=720]+worstaudio/worst[height=720]'"
alias yta="yt-dlp -x"
alias ytw="mpv --ytdl-format='worstvideo*[height=720]+worstaudio/worst[height=720]' --cache=yes --demuxer-max-bytes=2048Kib --wayland-app-id=Picture-in-Picture"
alias sw="streamlink -a '--wayland-app-id=Picture-in-Picture'"
alias mi="make install"
alias mu="make uninstall"
alias dmi="doas make install"
alias dmu="doas make uninstall"
alias dnr="dotnet run"
alias dnn="dotnet new"
alias dnp="dotnet publish"
alias nit="npm init -y"
alias ni="npm install"
alias nii="npm info"
alias nig="npm install -g"
alias nid="npm install -D"
alias nrg="npm remove -g"
alias nrd="npm remove -D"
alias ns="npm search"
alias nl="npm list"
alias nlg="npm list -g"
alias nr="npm run"
alias nrb="npm run build"
# arquivos e Diretórios
alias g="ugrep --color -iIn"
alias rm="trash"
alias rml="trash clean"
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
alias ga="git add"
alias gaf="git add -f"
alias gap="git add -p"
alias gba="git branch -a"
alias gbd="git branch -d"
alias gc="git clone"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gcm="git commit"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcr="git clone --recurse-submodules"
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gg="git grep -iIn"
alias ggs="git grep -iIn -8"
alias gi="git init"
alias gl="git log --oneline --graph"
alias gpl="git pull"
alias gps="git push"
alias gpsf="git push -f"
alias gr="git restore"
alias gra="git rebase --abort"
alias grc="git rebase --continue"
alias gri="git rebase -i"
alias grp="git restore -p"
alias grrh="git reset --hard"
alias grrs="git reset --soft"
alias grs="git restore --staged"
alias grsp="git restore --staged -p"
alias grsu="git remote set-url origin"
alias grv="git remote -v"
alias gs="git status"
alias gsa="git submodule add https://github.com/"
alias gss="git stash push -m"
alias gssp="git stash push --patch -m"
alias gsss="git stash push -S -m"
alias gwa="git worktree add"
alias gwr="git worktree remove"

## aliases em sistemas
if [ "$OS" = "artixlinux" ] || [ "$OS" = "archlinux" ] || [ "$OS" = "manjaro" ]; then
    # pacman
    alias ps="doas pacman --noconfirm --color always -S"
    alias psi="pacman --color always -Si"
    alias pss="pacman --color always -Ss"
    alias psyu="doas pacman --noconfirm --color always -Syu"
    alias pq="pacman --color always -Q"
    alias pqi="pacman --color always -Qi"
    alias pqs="pacman --color always -Qs"
    alias pfyl="doas pacman --color always -Fyl"
    alias prns="doas pacman --noconfirm --color always -Rns"
    alias exp="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 100"
    # paru
    alias pps="paru --noconfirm --color always -S"
    alias ppsi="paru --color always -Si"
    alias ppss="paru --color always -Ss"
    alias ppsyu="paru -Pw;paru --noconfirm --color always -Syu"
    alias ppq="paru --color always -Q"
    alias ppqi="paru --color always -Qi"
    alias ppqs="paru --color always -Qs"
    alias ppfyl="paru --color always -Fyl"
    alias pprns="paru --noconfirm --color always -Rns"
    alias sys="doas systemctl"
elif [ "$OS" = "voidlinux" ]; then
    alias xs="./xbps-src"
    alias xc="./xbps-src clean"
    alias xp="./xbps-src pkg"
    alias xpm="./xbps-src -a \*musl pkg"
    alias xbb="./xbps-src binary-bootstrap"
    # xbps
    alias xis="doas xbps-install -Sy"
    alias xqrs="xbps-query -Rs"
    alias xisu="doas xbps-install -Suy"
    alias xql="xbps-query -l"
    alias xqlg="xbps-query -l | ugrep --color -i"
    alias xrr="doas xbps-remove -Ry"
    # xtools
    alias xch="xchroot"
    alias xg="xgrep"
    alias xh="xhog"
    alias xil="xilog"
    alias xl="xlocate -S && xlocate"
    alias xm="xmandoc"
    alias xqr="xq -R"
    alias sys="doas sv"
elif [ "$OS" = "linuxmint" ]; then
    alias bat="batcat"
    alias cat="batcat"
    # apt
    alias ai="doas apt install -y"
    alias as="apt show"
    alias ass="apt search"
    alias auau="doas apt update -y && doas apt upgrade -y"
    alias ali="apt list --installed"
    alias ar="doas apt remove -y"
    alias sys="doas systemctl"
fi

# carrega plugins do zsh, deve ser o ultimo comando
source $HOME/.config/shell/plugins/fsh/fast-syntax-highlighting.plugin.zsh
source $HOME/.config/shell/plugins/zsh-expand-all.zsh
ZSH_EXPAND_ALL_DISABLE=word
source $HOME/.config/shell/plugins/zsh-auto-notify.zsh
source $HOME/.config/shell/plugins/fzf.zsh
source $HOME/.config/shell/plugins/keys-fzf.zsh
bindkey  "^[d"   fzf-cd-widget
bindkey  "^[s"   fzf-history-widget

# prompt
PS1="%B[%n] %4~ %{$fg[green]%}>%{$reset_color%}%b"
