# Shells

Todos os shells do sistema, localizados em `~/.config/shell`

## Sumario

-   [Dash](#dash)
-   [Zsh](#zsh)
-   [Bash](#bash)

## Dash

Usar o comando `chsh -s /bin/dash` para usar o dash como login shell, Profile trocado de lugar no meu [fork](https://gitlab.com/LucasTavaresA/dash)

- `~/.config/shell/profile`

```sh tangle:~/.config/shell/profile
## EXPORTS
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
export WM="herbstluftwm"
# Pass
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pass"
# Bat como o manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Terminal
export TERMINAL="st"
export TERM="xterm-256color"
# Navegador padrão
export BROWSER="qutebrowser"
# Pager
export PAGER="less -R"
# Faz o qt usar o tema do gtk2
export QT_QPA_PLATFORMTHEME="gtk2"
# Less
export LESSHISTFILE="-"
# Wget
export WGETRC="${XDG_DATA_HOME:-$HOME/.local/share}/wget/wgetrc"
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

## Zsh

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
# Modo vi
# bindkey -v
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

# Hersbstluftwm
hc() {
    herbstclient "$@"
}

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
alias vv="/usr/bin/nvim"
alias h="htop"
alias hc="herbstclient"
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
bindkey  "^[s"   fzf-history-widget
```

## Bash

Shell usado pelo arch também muito usado em scripts, bashrc trocado de lugar colocando `. local/do/bashrc` no final de `/etc/bash.bashrc`

- `~/.config/shell/bashrc`

```bash tangle:~/.config/shell/bashrc
# Se não executando bash interativamente
# Não executa o resto do bashrc
[[ $- != *i* ]] && return

# Aliases
alias n="neofetch"
alias v="nvim"
alias vv="/usr/bin/nvim"
alias h="htop"
alias hc="herbstclient"
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

## FUNÇÕES

# Hersbstluftwm
hc() {
    herbstclient "$@"
}

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
