# Archlinux dotfiles

Arquivos de configuração do archlinux

Blocos de código são salvos em seus arquivos usando [md-tangle](https://github.com/joakimmj/md-tangle)

## Sumario

-   [Emacs](#emacs)
-   [Neovim](#neovim)
-   [Shells](#shells)
    -   [Dash](#dash)
    -   [Zsh](#zsh)
    -   [Bash](#bash)
-   [X11](#x11)
-   [Sxhkd](#sxhkd)
    -   [Dwm](#dwm)
    -   [Bspwm](#bspwm)
-   [Qutebrowser](#qutebrowser)
    -   [Configuração](#configuração)
    -   [Tema escuro](#tema-escuro)
-   [Lf](#lf)
-   [Extras](#extras)

## Emacs

[Minha configuração do doom emacs](https://github.com/LucasTavaresA/dotfiles/blob/main/.config/doom/config.org)

## Neovim

[Minha configuração do neovim](https://github.com/LucasTavaresA/dotfiles/blob/main/.config/nvim/nvim.md)

## Shells

Todos os shells do sistema localizados em `~/.config/shell`

### Dash

Usar o comando `chsh -s /bin/dash` para usar o dash como login shell, Profile trocado de lugar no meu [fork](https://gitlab.com/LucasTavaresA/dash)

- `~/.config/shell/profile`

```sh tangle:~/.config/shell/profile
### EXPORTS
# Adiciona ícones no lf
export LF_ICONS="di=📁:\
fi=📃:\
tw=🤝:\
st=:\
ow=📂:\
dt=📁:\
ln=⛓:\
or=❌:\
ex=🎯:\
*.txt=✍:\
*.mom=✍:\
*.me=✍:\
*.ms=✍:\
,hosts=:\
*.hook=🪝:\
*.ttf=:\
*.otf=:\
*.woff=:\
*.woff2=:\
*.png=🖼:\
*.webp=🖼:\
*.ico=🖼:\
*.bmp=🖼:\
*.pbm=🖼:\
*.pgm=🖼:\
*.ppm=🖼:\
*.tga=🖼:\
*.xbm=🖼:\
*.xpm=🖼:\
*.jpg=📸:\
*.jpe=📸:\
*.jpeg=📸:\
*.mjpg=📸:\
*.mjpeg=📸:\
*.gif=🖼:\
*.svg=🗺:\
*.svgz=🗺:\
*.mng=🗺:\
*.pcx=🗺:\
*.tif=🖼:\
*.tiff=🖼:\
*.xwd=🖼:\
*.yuv=🖼:\
*.gl=🖼:\
*.dl=🖼:\
*.cgm=🖼:\
*.emf=🖼:\
*.xcf=🖌:\
*.html=🌎:\
*.xml=📰:\
*.qt=📰:\
*.yml=:\
*.toml=:\
*.ini=:\
,config=:\
*.conf=:\
*.cfg=:\
*.config=:\
,.gitignore=:\
*.gpg=🔒:\
*.css=🎨:\
*.dic=📖:\
*.pdf=📚:\
*.djvu=📚:\
*.epub=📚:\
*.csv=📓:\
*.xlsx=📓:\
*.xspf=📓:\
*.tex=📜:\
*.md=📘:\
*.org=🦄:\
*.r=📊:\
*.R=📊:\
*.rmd=📊:\
*.Rmd=📊:\
*.m=📊:\
*.mp3=🎵:\
*.opus=🎵:\
*.ogg=🎵:\
*.m4a=🎵:\
*.midi=🎵:\
*.mid=🎵:\
*.aac=🎵:\
*.au=🎵:\
*.mka=🎵:\
*.mpc=🎵:\
*.ra=🎵:\
*.oga=🎵:\
*.spx=🎵:\
*.flac=🎼:\
*.wav=🎼:\
*.asf=🎥:\
*.rm=🎥:\
*.rmvb=🎥:\
*.flc=🎥:\
*.mkv=🎥:\
*.m2v=🎥:\
*.mp4=🎥:\
*.webm=🎥:\
*.mpeg=🎥:\
*.avi=🎥:\
*.mov=🎥:\
*.mpg=🎥:\
*.wmv=🎥:\
*.m4b=🎥:\
*.flv=🎥:\
*.ogm=🎥:\
*.m4v=🎥:\
*.mp4v=🎥:\
*.vob=🎥:\
*.nuv=🎥:\
*.fli=🎥:\
*.ogv=🎥:\
*.ogx=🎥:\
*.zip=📦:\
*.rar=📦:\
*.7z=📦:\
*.tar.gz=📦:\
*.tar=📦:\
*.tgz=📦:\
*.arc=📦:\
*.arj=📦:\
*.taz=📦:\
*.lha=📦:\
*.lz4=📦:\
*.lzh=📦:\
*.lzma=📦:\
*.tlz=📦:\
*.txz=📦:\
*.tzo=📦:\
*.t7z=📦:\
*.z=📦:\
*.dz=📦:\
*.gz=📦:\
*.lrz=📦:\
*.lz=📦:\
*.lzo=📦:\
*.xz=📦:\
*.zst=📦:\
*.tzst=📦:\
*.bz2=📦:\
*.bz=📦:\
*.tbz=📦:\
*.tbz2=📦:\
*.tz=📦:\
*.deb=📦:\
*.rpm=📦:\
*.war=📦:\
*.ear=📦:\
*.sar=📦:\
*.alz=📦:\
*.ace=📦:\
*.zoo=📦:\
*.cpio=📦:\
*.rz=📦:\
*.cab=📦:\
*.wim=📦:\
*.swm=📦:\
*.dwm=📦:\
*.esd=📦:\
*.sqlite=:\
*.db=:\
*.rom=🎮:\
*.nds=🎮:\
*.z64=🎮:\
*.v64=🎮:\
*.n64=🎮:\
*.gba=🎮:\
*.nes=🎮:\
*.gdi=🎮:\
*.1=ℹ:\
*.nfo=ℹ:\
*.info=ℹ:\
*.log=📙:\
*.bin=🎯:\
*.exe=🎯:\
*.dll=🎯:\
*.iso=📀:\
*.img=📀:\
*.vdi=📀:\
*.bib=🎓:\
*.ged=👪:\
*.part=💔:\
*.torrent=🔽:\
*.jar=♨:\
*.java=♨:\
*.el=:\
*.csproj=:\
*.sln=:\
*.cs=:\
*.c=:\
*.cpp=:\
*.cc=:\
*.clj=:\
*.coffee=:\
*.d=:\
*.dart=:\
*.erl=:\
*.exs=:\
*.fs=:\
*.go=:\
*.h=:\
*.hh=:\
*.hpp=:\
*.hs=:\
*.jl=:\
*.js=:\
*.json=:\
*.lua=:\
*.php=:\
*.pl=:\
*.pro=:\
*.py=:\
*.rb=:\
*.rs=:\
*.scala=:\
*.ts=:\
*.vim=:\
*.cmd=:\
*.ps1=:\
*.sh=:\
*.bash=:\
*.zsh=:\
*.fish=:\
,Makefile=:\
*.mk=:\
*.nix=:\
"

# Muda o local padrão de alguns dotfiles limpando a $HOME ou ~
# Define diretórios com o padrão xdg
UID="$(id -u)" # Pega o id de usuário
export HOME="/home/lucas"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="/run/user/$UID"
export XDG_BIN_HOME="$HOME/.local/bin"

# Window manager
export WM="dwm"
# Pass
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pass"
# Bat como um manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Terminal
export TERMINAL="st"
export TERM="xterm-256color"
# Navegador padrão
export BROWSER="qutebrowser"
# Pager
export PAGER='less'
# Faz o qt usar o tema do gtk2
export QT_QPA_PLATFORMTHEME="gtk2"
# Less
export LESSHISTFILE="-"
# Wget
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
# XAuthority
export XAUTHORITY="${XDG_RUNTIME_DIR:-/run/user/$UID}/Xauthority"
# Cargo
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
# Omnisharp
export OMNISHARPHOME="${XDG_DATA_HOME:-$HOME/.local/share}/omnisharp"
# Nuget
export NUGET_PACKAGES="${XDG_CACHE_HOME:-$HOME/.cache}/NuGetPackages"
# Gnupg
export GNUPGHOME="$HOME/.gnupg"
# Npm
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
# Terminfo
export TERMINFO="${XDG_DATA_HOME:-$HOME/.local/share}/terminfo"
# Inputrc
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/readline/inputrc"
# Gtk 2
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc"
# W3m
export W3M_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/w3m"
# Go
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
# Ghcup
export GHCUP_USE_XDG_DIRS="1"
export GHCUP_INSTALL_BASE_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/"
# Cabal
export CABAL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/cabal/config"
export CABAL_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/cabal"
# Starship
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/config.toml"
# Android sdk
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
# Wine
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
# Fzf
export FZF_ALT_C_COMMAND="find . -maxdepth 4 -type d | grep -v '^\./\.cache'"

# Shell
export SHELL="dash"
# Muda o local do zshrc
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
# Muda o local do histórico
export HISTFILE="${XDG_CONFIG_HOME:-$HOME/.config}/shell/history"
# Aumenta o tamanho limite do histórico
export HISTSIZE=10000
export HISTFILESIZE=10000
# Ignora e deleta comandos duplicados no histórico
export HISTCONTROL=ignoredups:erasedups

# Adiciona diretórios bin e scripts ao path
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/lib/jvm/java-11-openjdk/bin:$PATH"
export PATH="$HOME/code/shell/dmenuscripts:$PATH"
export PATH="$HOME/code/shell/scripts:$PATH"
export PATH="${XDG_BIN_HOME:-$HOME/.local/bin}:$PATH"

# DOOM emacs
export PATH="${XDG_CONFIG_HOME:-$HOME/.config}/emacs/bin:$PATH"
export EMACSDIR="${XDG_CONFIG_HOME:-$HOME/.config}/emacs"
export DOOMDIR="${XDG_CONFIG_HOME:-$HOME/.config}/doom"
export DOOMLOCALDIR="${XDG_CONFIG_HOME:-$HOME/.config}/emacs/.local"
# Editor no terminal
export EDITOR="nvim"
# Editor com interface gráfica
export VISUAL="nvim"

# Usa o dmenu como autenticador GUI
export SSH_ASKPASS="doas_askpass"
export GIT_ASKPASS="doas_askpass"
export SUDO_ASKPASS="$HOME/code/shell/dmenuscripts/dmenu_pass"
export DOAS_ASKPASS="dmenu -fn Monospace-18 -c -cw 500 -P -p 🔑Senha:"

# Localização para datas
export LC_TIME="pt_BR.UTF-8"

[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
```

### Zsh

Shell interativo, Trocado de diretório pela variável **ZDOTDIR**

- `~/.config/shell/.zshrc`

```zsh tangle:~/.config/shell/.zshrc
# Se não executando zsh interativamente
# Não executa o resto do zshrc
[[ $- != *i* ]] && return

# EXPORTS
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
_comp_options+=(globdots)       # Incluir arquivos ocultos.

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

# Aliases
alias n="neofetch"
alias v="nvim"
alias h="htop"
alias ed="emacs --daemon"
alias ek="emacsclient -e '(kill-emacs)'"
alias ec="emacsclient -n -c"
alias e="emacs"
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
alias dr="doom_reset"
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
source $HOME/.config/shell/plugins/expand-all.zsh
source $HOME/.config/shell/plugins/fzf.zsh
source $HOME/.config/shell/plugins/keys-fzf.zsh
bindkey  "^[d"   fzf-cd-widget
```

### Bash

Shell usado pelo arch também muito usado em scripts, bashrc trocado de lugar colocando `. local/do/bashrc` no final de `/etc/bash.bashrc`

- `~/.config/shell/bashrc`

```bash tangle:~/.config/shell/bashrc
# Se não executando bash interativamente
# Não executa o resto do bashrc
[[ $- != *i* ]] && return

# Aliases
alias n="neofetch"
alias v="nvim"
alias h="htop"
alias ed="emacs --daemon"
alias ek="emacsclient -e '(kill-emacs)'"
alias ec="emacsclient -n -c"
alias e="emacs"
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
alias dr="doom_reset"
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
alias u="sudo updatedb"
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
alias grrs="git reset --soft"
alias grrh="git reset --hard"
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

# Ignora case-sensitivity quando completa comandos com tab
if [ ! -a $HOME/.config/readline/inputrc ]; then echo '$include /etc/inputrc' > $HOME/.config/readline/inputrc; fi
echo 'set completion-ignore-case On' >> $HOME/.config/readline/inputrc
# Corrige automaticamente erros ao usar o cd
shopt -s cdspell
# Salva comandos de múltiplas linhas como uma linha única
shopt -s cmdhist

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
```

## X11

Configuração do xorg

- `~/.config/x11/xinitrc`

```sh tangle:~/.config/x11/xinitrc
#!/bin/sh

# Mouse
xsetroot -cursor_name left_ptr

# Teclado
setxkbmap -option caps:escape # grep -E "(ctrl|caps):" /usr/share/X11/xkb/rules/base.lst
xset r rate 300 100 # acelera repetição de teclas

# Gnome keyring daemon
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Clipmenu
systemctl --user import-environment DISPLAY
export CM_DIR="$HOME/code/shell/dmenuscripts/listas/clipmenu"
clipmenud &

# Outros
mpd &
dunst &
nitrogen --restore &
nm-applet &
xbanish &
fluxgui &
sxhkd &
dwmblocks &
picom &

# Protetor de tela
xautolock -detectsleep -time 30 -locker "slock" -notify 30 -notifier "notify-send Slock -u critical -t 1800000 'BLOQUEANDO A TELA 30 SEGUNDOS'" &

exec "$WM"
```

## Sxhkd

Todos os atalhos e teclas do dwm e bspwm

### Dwm

- `~/.config/sxhkd/sxhkdrc`

```sxhkdrc tangle:~/.config/sxhkd/sxhkdrc
# Ativa/Desativa a barra enquando super é segurado
Super_L + any
    dwmc togglebar
~@Super_L + any
    dwmc togglebar
Super_R + any
    dwmc togglebar
~@Super_R + any
    dwmc togglebar

# Ativa/Desativa a barra
super + b
    dwmc togglebar

# Muda o tamanho da janela
ctrl + super + {Left,Right}
    dwmc setmfact {-,+}0.05

# Muda o tamanho da janela
ctrl + super + {Down,Up}
    dwmc setcfact {-,+}0.20

# Muda entre as janelas
super + Tab
    dwmc focusstack +1

# Muda de tag
super + {Left, Right}
    dwmc {viewprev, viewnext}

# Troca a janela de tag
super + shift {Left, Right}
  dwmc {tagtoprev, tagtonext}

# Fecha uma janela
super + shift + backslash
    dwmc killclient

# Alterna janela flutuante
super + w
    dwmc togglefloating

# troca todas as janelas de posição
super + Return
    dwmc inplacerotate +2

# Troca entre layouts
super + Escape
    dwmc layoutscroll +1

# Ncmpcpp/Pulsemixer
super + {_,shift} + a
    st -g 100x30 -c {ncmpcpp -n ncmpcpp -e ncmpcpp,pulsemixer -n pulsemixer -e pulsemixer}

# Pausa/Toca musica
super + space
    mpc toggle && pkill -RTMIN+11 dwmblocks

# Anterior/Proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar && pkill -RTMIN+11 dwmblocks

# Abaixar/Aumentar o volume e atualizar a barra
super + {comma, period, Down, Up}
    amixer -q set Master 5%{-,+,-,+} && pkill -RTMIN+9 dwmblocks

# St
super + shift + Return
    st

# Aparece/Esconde o st
super + backslash
    st_scratchpad

# Torna a janela fixa em todas as tags
super + s
    dwmc togglesticky

# Monocle
super + f
    dwmc setmonocle 0

# Menu
Menu;Menu
    dmenu_run

# Menu energia
Menu;Escape
    dmenu_sys

# Editar
Menu;e
    dmenu_edit

# Emojis
Menu;E
    dmenu_emoji

# Montar/Desmontar
Menu;m
    dmenu_mont

# Atalhos do sxhkd
Menu;slash
    sxhkd_atalhos

# Shell History
Menu;h
    dmenu_shhistory

# Htop
Menu;H
    st -g 100x30 -c htop -n htop -e htop

# Passmenu
Menu;p
    passmenu --type

# Picom
Menu;P
    killall picom || picom

# Fluxgui
Menu;F
    killall fluxgui || fluxgui

# Clipboard
Menu;c
    dmenu_clip

# Calculadora
Menu;C
    galculator

# Gimp
Menu;g
    gimp

# Transmission
Menu;t
    transmission-gtk

# Telegram
Menu;T
    telegram-desktop

# Discord
Menu;d
    discord

# Qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml

# Anotações
Menu;a
    nvim ~/documentos/anotações.md

# Aliases
Menu;A
    zsh-aliases

# Tira print
Print
    dmenu_print
```

### Bspwm

- `~/.config/sxhkd/sxhkdrc_bspwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkdrc_bspwm
# Fecha janela
super + shift + backslash
    bspc node -c

# Troca janela selecionada pela maior janela
super + Return
    bspc node -s biggest.window

# Troca entre layout monocle e tiled
super + Escape
    bspc desktop -l next

# Troca o foco para a janela anterior
super + Left
    bspc node -f prev.local.!hidden.window

# Troca o foco para a proxima janela
super + {Right,Tab}
    bspc node -f next.local.!hidden.window

# Alterna entre ou muda janela para um desktop
super + {_,shift + }{1-9,0}
    bspc {desktop -f,node -d} '^{1-9,10}'

# Move janela para o espaço preselecionado
super + ctrl + Return
    bspc node -n last.!automatic

# Preseleciona uma direção
super + ctrl + {Left,Down,Up,Right}
    bspc node -p {west,south,north,east}

# Cancela seleção
ctrl + space
    bspc node -p cancel

# muda o tamanho das janelas
ctrl + {Left,Down,Up,Right}
    {bspc node @parent/second -z left -20 0; \
     bspc node @parent/first -z right -20 0, \
     bspc node @parent/second -z top 0 +20; \
     bspc node @parent/first -z bottom 0 +20, \
     bspc node @parent/first -z bottom 0 -20; \
     bspc node @parent/second -z top 0 -20, \
     bspc node @parent/first -z right +20 0; \
     bspc node @parent/second -z left +20 0}

# Alterna entre janela flutuante
super + t
    bspc node -t \~floating

# Alterna tela cheia
Menu;f
    bspc node -t \~fullscreen

# Ajusta proporção da janela selecionada
shift + Tab
    ajustar_tamanho.sh

# Menu
Menu;Menu
    dmenu_menu

# Menu energia
Menu;Escape
    dmenu_sys

# Editar
Menu;e
    dmenu_edit

# Emojis
Menu;E
    dmenu_emoji

# Ncmpcpp/Pulsemixer
super + {_,shift} + a
    st -g 100x30 -c {'ncmpcpp\,ncmpcpp' -e ncmpcpp,'pulsemixer\,pulsemixer' -e pulsemixer}

# Pausa/Toca musica
super + space
    mpc toggle

# Anterior/Proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar

# Abaixar/Aumentar o volume e atualizar a barra
super + {comma, period}
    amixer -q set Master 5%{-,+}

# St
super + shift + Return
    st

# Aparece/Esconde o st
super + backslash
    st_scratchpad

# Gimp
Menu;g
    gimp

# Clipboard
Menu;c
    dmenu_clip

# Calculadora
Menu;C
    galculator

# Transmission
Menu;t
    transmission-gtk

# Telegram
Menu;T
    telegram-desktop

# Discord
Menu;d
    discord

# Shell History
Menu;h
    dmenu_shhistory

# Htop
Menu;H
    st -e htop

# Passmenu
Menu;p
    passmenu --type

# Picom
Menu;P
    killall picom || picom

# Fluxgui
Menu;F
    killall fluxgui || fluxgui

# Montar/Desmontar
Menu;m
    dmenu_mont

# Teclas do sxhkd
Menu;slash
    sxhkd_atalhos

# Qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml

# Anotações
Menu;a
    nvim ~/documentos/anotações.md

# Aliases
Menu;A
    zsh-aliases

# Tira print
Print
    dmenu_print
```

## Qutebrowser

Navegador controlado majoritariamente pelo teclado inspirado no **vim**

### Configuração

- `~/.config/qutebrowser/config.py`

```python tangle:~/.config/qutebrowser/config.py
# Autogenerated config.py
#
# NOTE: config.py is intended for advanced users who are comfortable
# with manually migrating the config file on qutebrowser upgrades. If
# you prefer, you can also configure qutebrowser using the
# :set/:bind/:config-* commands without having to write a config.py
# file.
#
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# Carregar o autoconfig.yml
config.load_autoconfig()

# CONFIGURAÇÕES PADRÃO

# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set('content.cookies.accept', 'all', 'devtools://*')

# Value to send in the `Accept-Language` header. Note that the value
# read from JavaScript is always the global value.
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')

# User agent to send.
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
# User agent to send.
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0', 'https://accounts.google.com/*')
# User agent to send.
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

# Load images automatically in web pages.
config.set('content.images', True, 'chrome-devtools://*')
# Load images automatically in web pages.
config.set('content.images', True, 'devtools://*')

# Enable JavaScript.
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
# Enable JavaScript.
config.set('content.javascript.enabled', True, 'devtools://*')
# Enable JavaScript.
config.set('content.javascript.enabled', True, 'chrome://*/*')
# Enable JavaScript.
config.set('content.javascript.enabled', True, 'qute://*/*')

# MINHAS CONFIGURAÇÕES

# Tela cheia limitada a janela do navegador
config.set('content.fullscreen.window', True)

# Mostra a barra de scroll quando procurando uma palavra
config.set('scrolling.bar', 'when-searching')

# Encolhe janela de compleção dependendo das opções
config.set('completion.shrink', True)

# Diminuiu javascript lento nos sites
config.set('content.prefers_reduced_motion', True)

# Vê pdfs no browser usando o pdfjs
config.set('content.pdfjs', True)

# Javascript desativado por padrão
config.set('content.javascript.enabled', False)

# Abre novas abas de fundo
config.set('new_instance_open_target', 'window')

# Não sai do modo de inserção automaticamente
config.set('input.insert_mode.auto_leave', False)
config.set('input.insert_mode.leave_on_load', False)

# Barra escondida
config.set("statusbar.show", "in-mode")
config.set("tabs.show", "switching")

# O que fazer caso a ultima pagina seja fechada
config.set("tabs.last_close", "ignore")

# Abre abas como janelas
config.set("tabs.tabs_are_windows", True)

# Confirma antes de sair
config.set('confirm_quit', ["multiple-tabs"])

# Muda ordem do menu de compleção
config.set("completion.open_categories", ["bookmarks", "history", "filesystem"])

# Formatação dos títulos das abas
config.set("tabs.title.format", "{perc}{private}{current_title}")

# Vídeos não tocam automaticamente
config.set("content.autoplay", False)

# Formatação de horários
config.set('completion.timestamp_format', '%A %d/%m/%Y - %H:%M')

# Corretor ortográfico
config.set('spellcheck.languages', ["pt-BR", "en-US"])

# Conteúdo da barra de status
config.set('statusbar.widgets', ["keypress", "url", "progress"])

# Posição da barra de status
config.set('statusbar.position', 'top')

# Tamanho da barra de compleção
config.set('completion.height', '100%')

# Adblock
config.set('content.blocking.method', 'both')
c.content.blocking.adblock.lists = [
        'https://easylist.to/easylist/easylist.txt',
        'https://easylist.to/easylist/easyprivacy.txt',
        'https://easylist-downloads.adblockplus.org/easylistdutch.txt',
        'https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt',
        'https://www.i-dont-care-about-cookies.eu/abp/',
        'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt',
        "https://easylist.to/easylist/fanboy-social.txt",
        "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
        "https://pgl.yoyo.org/adservers/serverlist.php?showintro=0;hostformat=hosts",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
        ]

# Usa o lf para mandar arquivos
config.set("fileselect.handler", "external")
config.set("fileselect.single_file.command", ["st", "-e", "lf", "-selection-path", "{}"])
config.set("fileselect.multiple_files.command", ["st", "-e", "lf", "-selection-path", "{}"])

# Permitir notificações.
# Valid values:
#   - true
#   - false
#   - ask
config.set('content.notifications.enabled', True, 'https://www.youtube.com/*')
config.set('content.notifications.enabled', True, 'https://twitter.com/*')
config.set('content.notifications.enabled', True, 'https://facebook.com/*')

# Editor (and arguments) to use for the `edit-*` commands. The following
# placeholders are defined:  * `{file}`: Filename of the file to be
# edited. * `{line}`: Line in which the caret is found in the text. *
# `{column}`: Column in which the caret is found in the text. *
# `{line0}`: Same as `{line}`, but starting from index 0. * `{column0}`:
# Same as `{column}`, but starting from index 0.
c.editor.command = ['nvim', '{}']

# Search engines which can be used via the address bar.  Maps a search
# engine name (such as `DEFAULT`, or `ddg`) to a URL with a `{}`
# placeholder. The placeholder will be replaced by the search term, use
# `{{` and `}}` for literal `{`/`}` braces.  The following further
# placeholds are defined to configure how special characters in the
# search terms are replaced by safe characters (called 'quoting'):  *
# `{}` and `{semiquoted}` quote everything except slashes; this is the
# most   sensible choice for almost all search engines (for the search
# term   `slash/and&amp` this placeholder expands to `slash/and%26amp`).
# * `{quoted}` quotes all characters (for `slash/and&amp` this
# placeholder   expands to `slash%2Fand%26amp`). * `{unquoted}` quotes
# nothing (for `slash/and&amp` this placeholder   expands to
# `slash/and&amp`). * `{0}` means the same as `{}`, but can be used
# multiple times.  The search engine named `DEFAULT` is used when
# `url.auto_search` is turned on and something else than a URL was
# entered to be opened. Other search engines can be used by prepending
# the search engine name to the search term, e.g. `:open google
# qutebrowser`.
c.url.searchengines = {'DEFAULT': 'https://www.google.com/search?q={}'
                    ,  'yt':   'https://www.youtube.com/results?search_query={}'
                    ,  'r':    'https://www.reddit.com/search/?q={}'
                    ,  'gh':   'https://github.com/search?q={}'
                    ,  'gl':   'https://gitlab.com/search?search={}'
                    ,  'se':   'https://stackexchange.com/search?q={}'
                    ,  'aw':   'https://wiki.archlinux.org/index.php?search={}'
                    ,  'gt':   'https://translate.google.com/?sl=auto&tl=en&text={}'
                    ,  'b':    'https://brainly.com.br/app/ask?q={}'
                    ,  'tw':   'https://twitter.com/search?q={}'
                    ,  'sc':   'https://soundcloud.com/search?q={}'
                    ,  'al':   'https://anilist.co/search/anime?search={}&sort=SEARCH_MATCH'
                    ,  'alm':  'https://anilist.co/search/manga?search={}&sort=SEARCH_MATCH'
                    ,  'md':   'https://mangadex.org/titles?page=1&q={}&order=relevance.desc'
                    ,  'vn':   'https://vndb.org/v?sq={}'
                    ,  'imdb': 'https://www.imdb.com/find?q={}&ref_=nv_sr_sm'
                    ,  'gm':   'https://www.google.com.br/maps/search/{}'
                    ,  'sf':   'https://sourceforge.net/directory/?q={}'
                    ,  'gf':   'https://greasyfork.org/en/scripts?q={}'
                    ,  'ud':   'https://www.urbandictionary.com/define.php?term={}'
                    ,  'tg':   'https://trends.google.com.br/trends/explore?q={}'
                    ,  'wm':   'https://web.archive.org/web/*/{}'
                    }

# ATALHOS
config.unbind('M')
config.unbind('m')
config.unbind('u')
config.unbind('<Shift-H>')
config.unbind('<Shift-L>')

config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Ctrl-Left>', 'tab-prev')
config.bind('<Ctrl-Right>', 'tab-next')
config.bind('<Ctrl-a>', 'back')
config.bind('<Ctrl-d>', 'forward')
config.bind('u', 'undo --window')
# Atalho para assistir link com mpv
config.bind('zvw', 'hint links spawn mpv {hint-url}')
# Baixar imagem selecionada
config.bind('zid', 'hint images download')
# Baixar como video
config.bind('zvd', 'hint links spawn st -c st_download -e yt {hint-url}')
# Baixar como audio
config.bind('zad', 'hint links spawn st -c st_download -e yta {hint-url}')
# Abre no firefox
config.bind('zf', 'hint links spawn firefox {url}')
# Ativa/Desativa a barra
config.bind('zx', 'config-cycle statusbar.show always in-mode;; config-cycle tabs.show always switching')
# Ativa/Desativa tema escuro
config.bind('zd', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/dark.css ""')
# Ativa/Desativa javascript para um site
config.bind('zj', 'config-cycle -p -u *://*.{url:host}/* content.javascript.enabled ;; reload')
# Ativa/Desativa adblocking para um site
config.bind('zb', 'config-cycle -p -u *://*.{url:host}/* content.blocking.enabled ;; reload')
# Modo leitura
config.bind('zr', 'spawn --userscript readability')
# Traduz a pagina
config.bind('ztp', 'spawn --userscript translate')
# Traduz o texto selecionado
config.bind('zts', 'spawn --userscript translate --text')
# Copia links
config.bind('cl', 'hint links yank')
# Copia trechos de código
config.bind('cc', 'hint code userscript code_select.py')
c.hints.selectors["code"] = [
    # Seleciona code tags onde o parente não é uma tag pre
    ":not(pre) > code",
    "pre"
]

# diretório de downloads
c.downloads.location.directory = '~/Downloads'

# pagina inicial e novas abas
# quando usando comandos como :open -t e :open -w .
c.url.default_page = 'https://www.google.com/'
c.url.start_pages = 'https://www.google.com/'

# CORES

# Pedir modo escuro aos sites que o suportam
config.set('colors.webpage.preferred_color_scheme', 'dark')
# Cor do texto da barra de compleção
c.colors.completion.fg = '#ffffff'
# Cor de fundo da barra de compleção.
c.colors.completion.odd.bg = '#2f334d'
c.colors.completion.even.bg = '#2f334d'
# Cor do texto das categorias.
c.colors.completion.category.fg = '#ffffff'
# Cor de fundo das categorias.
c.colors.completion.category.bg = '#2f334d'
# Cor da borda superior de categorias.
c.colors.completion.category.border.top = '#ffffff'
# Cor da borda inferior de categorias.
c.colors.completion.category.border.bottom = '#ffffff'
# Cor de texto selecionado na barra de seleção
c.colors.completion.item.selected.fg = '#2f334d'
# Cor de fundo de texto selecionado na barra de compleção
c.colors.completion.item.selected.bg = '#ffffff'
# Cor do texto procurado quando selecionado na barra de compleção
c.colors.completion.item.selected.match.fg = '#ff0000'
# Cor de texto procurado na aba de compleção.
c.colors.completion.match.fg = '#ff0000'
# Cor da barra de scroll na aba de compleção
c.colors.completion.scrollbar.fg = '#2f334d'
# Cor de fundo da barra de download
c.colors.downloads.bar.bg = '#2f334d'
# Cor de fundo de downloads com erro
c.colors.downloads.error.bg = '#ff0000'
# Cor da fonte de indicadores de links
c.colors.hints.fg = '#ffffff'
# Cor de fundo de indicadores de links
c.colors.hints.bg = '#2f334d'
# Borda de indicadores de links
config.set('hints.border', '1px solid #ffffff')
config.set('hints.radius', 0)
# Cor da fonte em partes procuradas
c.colors.hints.match.fg = '#ff0000'
# Cor de fundo de informações importantes
c.colors.messages.info.bg = '#2f334d'
# Cor de fundo da barra de status
c.colors.statusbar.normal.bg = '#2f334d'
# Cor do texto da barra de status quando inserindo texto
c.colors.statusbar.insert.fg = '#ffffff'
# Cor da barra de status quando inserindo texto
c.colors.statusbar.insert.bg = '#008800'
# Cor da barra de status no modo passthrough
c.colors.statusbar.passthrough.bg = '#2f334d'
# Cor de fundo da barra de status quando digitando comandos
c.colors.statusbar.command.bg = '#2f334d'
# Cor do texto da barra de status quando em alerta
c.colors.statusbar.url.warn.fg = '#ff0000'
# Cor de fundo da barra de abas abertas
c.colors.tabs.bar.bg = '#2f334d'
# Cor de fundo de abas não selecionadas
c.colors.tabs.odd.bg = '#000000'
c.colors.tabs.even.bg = '#000000'
# Cor de fundo de abas selecionadas
c.colors.tabs.selected.odd.bg = '#2f334d'
c.colors.tabs.selected.even.bg = '#2f334d'
# Cor de fundo de abas fixadas não selecionadas
c.colors.tabs.pinned.odd.bg = '#000000'
c.colors.tabs.pinned.even.bg = '#000000'
# Cor de fundo de abas fixadas selecionadas
c.colors.tabs.pinned.selected.odd.bg = '#2f334d'
c.colors.tabs.pinned.selected.even.bg = '#2f334d'
# Cor das fontes de abas não selecionadas
c.colors.tabs.even.fg = '#ffffff'
c.colors.tabs.odd.fg = '#ffffff'
c.colors.tabs.pinned.even.fg = '#ffffff'
c.colors.tabs.pinned.odd.fg = '#ffffff'
# Cor das fontes de abas selecionadas
c.colors.tabs.pinned.selected.odd.fg = '#ffffff'
c.colors.tabs.pinned.selected.even.fg = '#ffffff'
c.colors.tabs.selected.even.fg = '#ffffff'
c.colors.tabs.selected.odd.fg = '#ffffff'
# Cor da borda do texto selecionado na barra de compleção
c.colors.completion.item.selected.border.bottom = '#ffffff'
c.colors.completion.item.selected.border.top = '#ffffff'

# FONTES

# Fonte padrão
c.fonts.default_family = '"monospace"'
# Tamanho padrão das fontes
c.fonts.default_size = '14px'
# Fonte usada nas abas de completação de comandos.
c.fonts.completion.entry = '14px "monospace"'
# Fonte used for the debugging console.
c.fonts.debug_console = '14px "monospace"'
# Fonte usada nos prompts.
c.fonts.prompts = 'default_size "monospace"'
# Fonte usada na barra de status.
c.fonts.statusbar = '14px "monospace"'
```

### Tema escuro

-   [dark.css](https://github.com/LucasTavaresA/dotfiles/blob/main/.config/qutebrowser/styles/dark.css)

## Lf

Explorador de arquivos lf

- `~/.config/lf/lfrc`

```sh tangle:~/.config/lf/lfrc
# interpreter for shell commands
set shell sh

# set '-eu' options for shell commands
# These options are used to have safer shell commands. Option '-e' is used to
# exit on error and option '-u' is used to give error for unset variables.
# Option '-f' disables pathname expansion which can be useful when $f, $fs, and
# $fx variables contain names with '*' or '?' characters. However, this option
# is used selectively within individual commands as it can be limiting at
# times.
set shellopts '-eu'

# set internal field separator (IFS) to "\n" for shell commands
# This is useful to automatically split file names in $fs and $fx properly
# since default file separator used in these variables (i.e. 'filesep' option)
# is newline. You need to consider the values of these options and create your
# commands accordingly.
set ifs "\n"

set period 1

# arquivos ocultos
set hidden on

# ícones
set icons on

# informação mostrada do lado do arquivo
set info "size"

# previa de arquivos
set previewer lf-previewer
set cleaner lf-cleaner

# fração das abas
set ratios 1:2

set wrapscroll on

# informação no topo das abas
set promptfmt "\033[32;1m\033[0m\033[34;1m%d\033[0m\033[1m%f\033[0m"

# borda ao redor das abas
set drawbox on

# abre espaço na parte superior e inferior da tela
set scrolloff 0

cmd open ${{
    case $(file --mime-type "$(readlink -f $f)" -b) in
        application/vnd.openxmlformats-officedocument.wordprocessingml.document) libreoffice $f ;;
        image/vnd.djvu|application/pdf|application/octet-stream|application/postscript) zathura $fx ;;
        text/*) nvim $fx ;;
        image/*) nsxiv . ;;
        audio/*) mpv --audio-display=no $fx ;;
        video/*) mpv $fx ;;
        application/pdf|application/vnd*|application/epub*) zathura $fx ;;
        application/pgp-encrypted) nvim $fx ;;
        *) xdg-open $fx ;;
    esac
}}

cmd delete ${{
    clear; tput cup $(($(tput lines)/3)); tput bold
    set -f
    printf "%s\n\t" "$fx"
    printf "deletar?[y/N]"
    read ans
    [ $ans = "y" ] && rm -rf -- $fx
}}

cmd mkdir ${{
  printf "Nome do diretório: "
  read ans
  mkdir $ans
}}

cmd extract ${{
    clear; tput cup $(($(tput lines)/3)); tput bold
    set -f
    printf "%s\n\t" "$fx"
    printf "extrair?[y/N]"
    read ans
    [ $ans = "y" ] && aunpack $fx
}}

cmd mkfile ${{
  printf "Nome do arquivo: "
  read ans
  if [ $ans != "" ]; then
  touch $ans
  echo " " > $ans
  fi
}}

cmd chmod ${{
    clear; tput cup $(($(tput lines)/3)); tput bold
    set -f
    printf "%s\n\t" "$fx"
    printf "tornar executavel?[y/N]"
    read ans
    if [ $ans = "y" ]; then
  for file in "$fx"
  do
     chmod +x $file
  done

  lf -remote 'send reload'
  fi
}}

map m
map o
map n
map "'"
map '"'
map e
map f

cmd open-with %"$@" $fx
map o push :open-with<space>

map <delete> delete
map t mkfile
map c chmod
map C clear
map m mkdir
map E extract
map i !nsxiv .

# Atalhos
map gC cd ~/.config
map gcc cd ~/code/c
map gcs cd ~/code/shell
map gcS cd ~/code/csharp
map gcw cd ~/code/webPages
map gcu cd ~/code/unity

map gd cd ~/documentos
map gD cd ~/downloads
map ge cd ~/extras
map gj cd ~/jogos
map gh cd ~
map gM cd ~/mnt

map gmv cd ~/media/videos
map gmi cd ~/media/imagens
map gmm cd ~/media/musicas
map gmc cd ~/media/cursos
```

## Extras

- [Mais configurações](https://github.com/LucasTavaresA/dotfiles/blob/main/extras.md)
