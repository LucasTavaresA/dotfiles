#### Exports ####
# adiciona ícones no lf
export LF_ICONS="di=📁:fi=📃:tw=🤝:st=:ow=📂:dt=📁:ln=⛓:or=❌:ex=🎯:*.txt=✍:*.mom=✍:*.me=✍:*.ms=✍:,hosts=:\
*.hook=🪝:*.ttf=:*.otf=:*.woff=:*.woff2=:*.png=🖼:*.webp=🖼:*.ico=🖼:*.bmp=🖼:*.pbm=🖼:*.pgm=🖼:*.ppm=🖼:\
*.tga=🖼:*.xbm=🖼:*.xpm=🖼:*.jpg=📸:*.jpe=📸:*.jpeg=📸:*.mjpg=📸:*.mjpeg=📸:*.gif=🖼:*.svg=🗺:*.svgz=🗺:\
*.mng=🗺:*.pcx=🗺:*.tif=🖼:*.tiff=🖼:*.xwd=🖼:*.yuv=🖼:*.gl=🖼:*.dl=🖼:*.cgm=🖼:*.emf=🖼:*.xcf=🖌:*.html=🌎:\
*.xml=📰:*.qt=📰:*.yml=:*.toml=:*.ini=:,config=:*.conf=:*.cfg=:*.config=:,.gitignore=:*.gpg=🔒:\
*.css=🎨:*.dic=📖:*.pdf=📚:*.djvu=📚:*.epub=📚:*.csv=📓:*.xlsx=📓:*.xspf=📓:*.tex=📜:*.md=📘:*.org=🦄:*.r=📊:\
*.R=📊:*.rmd=📊:*.Rmd=📊:*.m=📊:*.mp3=🎵:*.opus=🎵:*.ogg=🎵:*.m4a=🎵:*.midi=🎵:*.mid=🎵:*.aac=🎵:*.au=🎵:\
*.mka=🎵:*.mpc=🎵:*.ra=🎵:*.oga=🎵:*.spx=🎵:*.flac=🎼:*.wav=🎼:*.asf=🎥:*.rm=🎥:*.rmvb=🎥:*.flc=🎥:*.mkv=🎥:\
*.m2v=🎥:*.mp4=🎥:*.webm=🎥:*.mpeg=🎥:*.avi=🎥:*.mov=🎥:*.mpg=🎥:*.wmv=🎥:*.m4b=🎥:*.flv=🎥:*.ogm=🎥:*.m4v=🎥:\
*.mp4v=🎥:*.vob=🎥:*.nuv=🎥:*.fli=🎥:*.ogv=🎥:*.ogx=🎥:*.zip=📦:*.rar=📦:*.7z=📦:*.tar.gz=📦:*.tar=📦:*.tgz=📦:*.arc=📦:\
*.arj=📦:*.taz=📦:*.lha=📦:*.lz4=📦:*.lzh=📦:*.lzma=📦:*.tlz=📦:*.txz=📦:*.tzo=📦:*.t7z=📦:*.z=📦:*.dz=📦:*.gz=📦:\
*.lrz=📦:*.lz=📦:*.lzo=📦:*.xz=📦:*.zst=📦:*.tzst=📦:*.bz2=📦:*.bz=📦:*.tbz=📦:*.tbz2=📦:*.tz=📦:*.deb=📦:*.rpm=📦:\
*.war=📦:*.ear=📦:*.sar=📦:*.alz=📦:*.ace=📦:*.zoo=📦:*.cpio=📦:*.rz=📦:*.cab=📦:*.wim=📦:*.swm=📦:*.dwm=📦:*.esd=📦:\
*.sqlite=:*.db=:*.rom=🎮:*.nds=🎮:*.z64=🎮:*.v64=🎮:*.n64=🎮:*.gba=🎮:*.nes=🎮:*.gdi=🎮:*.1=ℹ:*.nfo=ℹ:*.info=ℹ:\
*.log=📙:*.bin=🎯:*.exe=🎯:*.dll=🎯:*.iso=📀:*.img=📀:*.vdi=📀:*.bib=🎓:*.ged=👪:*.part=💔:*.torrent=🔽:*.jar=♨:\
*.java=♨:*.el=:*.csproj=:*.sln=:*.cs=:*.c=:*.cpp=:*.cc=:*.clj=:*.coffee=:*.d=:*.dart=:*.erl=:\
*.exs=:*.fs=:*.go=:*.h=:*.hh=:*.hpp=:*.hs=:*.jl=:*.js=:*.json=:*.lua=:*.php=:*.pl=:*.pro=:\
*.py=:*.rb=:*.rs=:*.scala=:*.ts=:*.vim=:*.cmd=:*.ps1=:*.sh=:*.bash=:*.zsh=:*.fish=:,Makefile=:*.mk=:*.nix=:\
"
# muda o local padrão de alguns dotfiles limpando a $HOME ou ~
# define diretórios com o padrão xdg
UID="$(id -u)" # Pega o id de usuário
export HOME="/home/lucas"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="/run/user/$UID"
export XDG_BIN_HOME="$HOME/.local/bin"
# window manager
export WM="herbstluftwm"
# systema
export HOSTNAME="$(uname -n)"
case $HOSTNAME in
    *"voidlinux"*) export OS="voidlinux" ;;
    *"archlinux"*) export OS="archlinux" ;;
    *"manjaro"*) export OS="manjaro" ;;
    *"linuxmint"*) export OS="linuxmint" ;;
esac
# onde procurar manpages
export MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man:/usr/lib/jvm/default/man:/usr/lib/jvm/java-11-openjdk/man"
# bat como o manpager
[ ! "$OS" = "voidlinux" ] && export MANPAGER="sh -c 'col -bx | bat -l man -p'"
[ "$OS" = "linuxmint" ] && export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
# pass
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pass"
# terminal
export TERMINAL="st"
export TERM="xterm-256color"
# navegador padrão
export BROWSER="qutebrowser"
# pager
export PAGER="less -R"
# faz o qt usar o tema do qt5ct
export QT_QPA_PLATFORMTHEME="qt5ct"
# less
export LESSHISTFILE="-"
# wget
export WGETRC="${XDG_DATA_HOME:-$HOME/.local/share}/wget/wgetrc"
# xauthority
export XAUTHORITY="${XDG_RUNTIME_DIR:-/run/user/$UID}/Xauthority"
# dbus
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"
# cargo
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
# omnisharp
export OMNISHARPHOME="${XDG_DATA_HOME:-$HOME/.local/share}/omnisharp"
# dotnet
export DOTNET_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/dotnet"
# nuget
export NUGET_PACKAGES="${XDG_CACHE_HOME:-$HOME/.cache}/NuGetPackages"
# gnupg
export GNUPGHOME="$HOME/.gnupg"
# npm
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
# terminfo
export TERMINFO="${XDG_DATA_HOME:-$HOME/.local/share}/terminfo"
# inputrc
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/readline/inputrc"
# gtk 2
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc"
# w3m
export W3M_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/w3m"
# go
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
# ghcup
export GHCUP_USE_XDG_DIRS="1"
export GHCUP_INSTALL_BASE_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/"
# cabal
export CABAL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/cabal/config"
export CABAL_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/cabal"
# android sdk
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
# wine
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
# ls colors
export LS_COLORS=""
# fzf
export FZF_ALT_C_COMMAND="find . -maxdepth 4 -type d | grep -v '^\./\.cache'"

# shell
export SHELL="sh"
# muda o local do zshrc
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
# muda o local do histórico
export HISTFILE="${XDG_CONFIG_HOME:-$HOME/.config}/shell/history"
# aumenta o tamanho limite do histórico
export HISTSIZE=10000
export HISTFILESIZE=10000
# ignora e deleta comandos duplicados no histórico
export HISTCONTROL=ignoredups:erasedups

# adiciona diretórios bin e scripts ao path
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:/usr/lib/jvm/java-11-openjdk/bin"
export PATH="$HOME/code/shell:$PATH"
export PATH="$PATH:${XDG_BIN_HOME:-$HOME/.local/bin}"
export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/cargo/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/dotnet"
# DOOM emacs
export PATH="$PATH:${XDG_CONFIG_HOME:-$HOME/.config}/emacs/bin"
export EMACSDIR="${XDG_CONFIG_HOME:-$HOME/.config}/emacs"
export DOOMDIR="${XDG_CONFIG_HOME:-$HOME/.config}/doom"
export DOOMLOCALDIR="${XDG_CONFIG_HOME:-$HOME/.config}/emacs/.local"
# editor no terminal
export EDITOR="nvim"
# editor com interface gráfica
export VISUAL="st -e nvim"

# usa o dmenu como autenticador GUI
export SSH_ASKPASS="doas_askpass"
export GIT_ASKPASS="doas_askpass"
export SUDO_ASKPASS="$HOME/code/shell/dmenu_pass"
export DOAS_ASKPASS="dmenu -fn Monospace-18 -c -cw 500 -P -p Senha:"

# localização para datas
export LC_TIME="pt_BR.UTF-8"

[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
