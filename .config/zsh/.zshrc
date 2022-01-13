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

# Sai do modo vim
bindkey -e
# Deleta caracteres usado delete
bindkey "^[[3~" delete-char

# Completar comandos
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Incluir arquivos ocultos.

## FUNÇÕES

# Entra em diretórios usando o lf
# e ajuda com previsão de imagens no lf
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
alias clip='xclip -selection clipboard'
alias sudo="doas"
alias yt='yt-dlp'
alias yta='yt-dlp -x --audio-format mp3'
# Arquivos e Diretórios
alias l='lsd -l --group-dirs first'
alias la='lsd -A --group-dirs first'
alias lla='lsd -lA --group-dirs first'
alias ..='cd ..'
alias lo='locate -Ai'
alias u='sudo updatedb'
alias ch='chmod +x'
alias rm='rm -rf'
# Programas
alias n='neofetch'
alias v='nvim'
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
source $HOME/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.config/zsh/plugins/expand-all.zsh

# Adiciona ícones no lf
export LF_ICONS="\
tw=:\
st=:\
ow=:\
dt=:\
di=:\
fi=:\
ln=:\
or=:\
ex=:\
*.conf=:\
*.cfg=:\
*.config=:\
*.c=:\
*.cc=:\
*.clj=:\
*.coffee=:\
*.cpp=:\
*.css=:\
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
*.html=:\
*.java=:\
*.jl=:\
*.js=:\
*.json=:\
*.lua=:\
*.md=:\
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
*.tar=:\
*.tgz=:\
*.arc=:\
*.arj=:\
*.taz=:\
*.lha=:\
*.lz4=:\
*.lzh=:\
*.lzma=:\
*.tlz=:\
*.txz=:\
*.tzo=:\
*.t7z=:\
*.zip=:\
*.z=:\
*.dz=:\
*.gz=:\
*.lrz=:\
*.lz=:\
*.lzo=:\
*.xz=:\
*.zst=:\
*.tzst=:\
*.bz2=:\
*.bz=:\
*.tbz=:\
*.tbz2=:\
*.tz=:\
*.deb=:\
*.rpm=:\
*.jar=:\
*.war=:\
*.ear=:\
*.sar=:\
*.rar=:\
*.alz=:\
*.ace=:\
*.zoo=:\
*.cpio=:\
*.7z=:\
*.rz=:\
*.cab=:\
*.wim=:\
*.swm=:\
*.dwm=:\
*.esd=:\
*.jpg=:\
*.jpeg=:\
*.mjpg=:\
*.mjpeg=:\
*.gif=:\
*.bmp=:\
*.pbm=:\
*.pgm=:\
*.ppm=:\
*.tga=:\
*.xbm=:\
*.xpm=:\
*.tif=:\
*.tiff=:\
*.png=:\
*.svg=:\
*.svgz=:\
*.mng=:\
*.pcx=:\
*.mov=:\
*.mpg=:\
*.mpeg=:\
*.m2v=:\
*.mkv=:\
*.webm=:\
*.ogm=:\
*.mp4=:\
*.m4v=:\
*.mp4v=:\
*.vob=:\
*.qt=:\
*.nuv=:\
*.wmv=:\
*.asf=:\
*.rm=:\
*.rmvb=:\
*.flc=:\
*.avi=:\
*.fli=:\
*.flv=:\
*.gl=:\
*.dl=:\
*.xcf=:\
*.xwd=:\
*.yuv=:\
*.cgm=:\
*.emf=:\
*.ogv=:\
*.ogx=:\
*.aac=:\
*.au=:\
*.flac=🎵:\
*.m4a=🎵:\
*.mid=:\
*.midi=🎵:\
*.mka=:\
*.mp3=🎵:\
*.mpc=:\
*.ogg=🎵:\
*.ra=:\
*.wav=:\
*.oga=:\
*.opus=🎵:\
*.spx=:\
*.xspf=:\
*.pdf=:\
*.nix=:\
"
