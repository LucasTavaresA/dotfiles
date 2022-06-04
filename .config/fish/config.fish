# caso esteja em uma sessão interativa
if status is-interactive
    ## Fish ##
    # set fish_trace 1 # ativa modo debug
    set -U fish_greeting # desativa mensagem ao iniciar
    set -x SHELL "fish"
    set -x GPG_TTY (tty)
    set fzf_fd_opts --base-directory $HOME -H -I -d 4 -t d -E '*cache*' -E '*git*'
    set fzf_git_log_opts --preview-window=bottom
    set fish_color_normal white
    set fish_color_autosuggestion '#444444'
    set fish_color_command green
    set fish_color_error '#ff0000'
    set fish_color_param cyan

    ## Plugins ##
    if test ! -e $HOME/.config/fish/fish_plugins
        echo "Installing fisher! 🎣"
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
        echo "Installing fzf! 🔍"
        fisher install PatrickF1/fzf.fish
        echo "Installing done! ✅"
        fisher install franciscolourenco/done
        echo "Installing abbrevition-tips!"
        fisher install gazorby/fish-abbreviation-tips
    end

    ## Teclas ##
    # teclas emacs/vi
    function fish_user_key_bindings
        # fish_default_key_bindings
        fish_vi_key_bindings
        # fzf
        fzf_configure_bindings --history=\es --directory=\ed --git_log=\ew --variables=\cv --processes=\e\cP
    end

    ## funções ##
    # localizar e editar arquivo
    function ea
        set arquivo (locate -Ai "$argv" | fzf)
        if test -n "$arquivo"
           eval $VISUAL "$arquivo"
        end
    end

    # localizar e editar executavel
    function ee
        set executavel (whereis -b "$argv" | cut -d' ' -f2)
        if test -x "$executavel"
           eval $VISUAL "$executavel"
        end
    end

    # git status recursivo
    function gsr
        for repo in (fd -H -I -E "*cache*" -E "*.local*" -E "*.config/emacs*" | grep --color -i -I --color -i -I "/.git\$")
            set repo (echo $repo | sed 's/\/.git$//')
            set cols (tput cols)
            set i 0
            while test $i -lt $cols;
                echo -n "─"
                set i (math $i + 1)
            end
            if git status $repo | grep nothing > /dev/null;
                printf "\033[96m\033[1m%s\033[0m\n" "$repo"
            else
                printf "\033[96m\033[1m%s\033[0m\n" "$repo"
                git status $repo
            end
        end
    end

    # Facilita extrair arquivos
    # exemplo: ex <arquivo>.zip
    function ex
        for arquivo in "$argv"
            if test -e "$arquivo"
                switch "$arquivo"
                    case "*.7z" "*.arj" "*.cab" "*.cb7" "*.chm" "*.dmg" "*.iso" \
                    "*.lzh" "*.msi" "*.pkg" "*.rpm" "*.udf" "*.wim" "*.xar"; 7z x "$arquivo"
                    case "*.bz2";                                            bunzip2 "$arquivo"
                    case "*.cba" "*.ace";                                    unace x "$arquivo"
                    case "*.cbr";                                            unrar x -ad "$arquivo"
                    case "*.cbt" "*.txz";                                    tar xvf "$arquivo"
                    case "*.cbz" "*.epub" "*.zip";                           unzip "$arquivo"
                    case "*.cpio";                                           cpio -id < "$arquivo"
                    case "*.deb";                                            ar x "$arquivo"
                    case "*.exe";                                            cabextract "$arquivo"
                    case "*.gz";                                             gunzip "$arquivo"
                    case "*.lzma";                                           unlzma "$arquivo"
                    case "*.rar";                                            unrar x "$arquivo"
                    case "*.tar.bz2" "*.tbz2";                               tar xjf "$arquivo"
                    case "*.tar.gz" "*.tgz";                                 tar xzf "$arquivo"
                    case "*.tar.xz" "*.tar";                                 tar xf "$arquivo"
                    case "*.tar.zst";                                        unzstd "$arquivo"
                    case "*.xz";                                             unxz "$arquivo"
                    case "*.Z" "*.z";                                        uncompress "$arquivo"
                    case "*";         echo "$arquivo não pode ser extraído com ex()!" && return 1
                end
            else
                echo "$arquivo arquivo não existe!"
                return 1
            end
        end
    end

    ## Abbr ##
    abbr -a -g df df -hT --total -x tmpfs -x devtmpfs
    abbr -a -g hc herbstclient
    abbr -a -g fm fzf_man
    abbr -a -g as "abbr | grep --color -i"
    abbr -a -g n neofetch
    abbr -a -g v nvim
    abbr -a -g vv term_open nvim -e
    abbr -a -g h htop
    abbr -a -g ed emacs --daemon
    abbr -a -g ek "emacsclient -e '(kill-emacs)'"
    abbr -a -g et "emacsclient -t -a 'nvim'"
    abbr -a -g e "emacsclient -n -c -a 'term_open nvim -e'"
    abbr -a -g copy xclip -selection clipboard
    abbr -a -g sudo doas
    abbr -a -g ping ping google.com
    abbr -a -g p "patch -p1 <"
    abbr -a -g pr "patch -R <"
    abbr -a -g yt yt-dlp
    abbr -a -g yta yt-dlp -x --audio-format mp3
    abbr -a -g pk pkill
    abbr -a -g mi make install
    abbr -a -g mu make uninstall
    abbr -a -g dh doom help
    abbr -a -g ds doom sync
    abbr -a -g dd doom doctor
    abbr -a -g du doom upgrade
    abbr -a -g dr doom_reset
    abbr -a -g dp doom purge
    abbr -a -g dmi doas make install
    abbr -a -g dmu doas make uninstall
    abbr -a -g dnr dotnet run
    abbr -a -g dnn dotnet new
    abbr -a -g dns dotnet-script
    abbr -a -g xp xprop
    abbr -a -g xk xkill
    abbr -a -g sys doas systemctl
    test "$OS" = "voidlinux"; and abbr -a -g sys doas sv
    # arquivos e Diretórios
    abbr -a -g f fmz
    abbr -a -g rm lixo
    abbr -a -g rml lixo limpar
    abbr -a -g rmf rm -rf
    abbr -a -g grep grep --color -i -I
    abbr -a -g l lsd -AX1 --group-dirs first
    abbr -a -g la lsd -lXA1 --group-dirs first
    abbr -a -g .. "cd .."
    abbr -a -g ... "cd ../.."
    abbr -a -g .... "cd ../../.."
    abbr -a -g lo locate -Ai
    abbr -a -g u doas updatedb
    abbr -a -g ch chmod +x
    abbr -a -g cp cp -ri
    abbr -a -g mv mv -i
    abbr -a -g ln ln -i
    abbr -a -g md mkdir -p
    abbr -a -g t touch
    abbr -a -g mnt doas mount
    abbr -a -g umnt doas umount
    # git
    abbr -a -g gi git init
    abbr -a -g gc git clone
    abbr -a -g gs git status
    abbr -a -g gsa git submodule add https://github.com/
    abbr -a -g gd git diff
    abbr -a -g gds git diff --staged
    abbr -a -g gl git log --oneline
    abbr -a -g ga git add
    abbr -a -g gaf git add -f
    abbr -a -g gcm git commit
    abbr -a -g gcmm git commit -m
    abbr -a -g gca git commit --amend --no-edit
    abbr -a -g gcam git commit --amend
    abbr -a -g gcamm git commit --amend -m
    abbr -a -g gco git checkout
    abbr -a -g gps git push
    abbr -a -g gpsf git push -f
    abbr -a -g gpl git pull
    abbr -a -g gf git fetch
    abbr -a -g gr git restore
    abbr -a -g grv git remote -v
    abbr -a -g grs git restore --staged
    abbr -a -g grsu git remote set-url origin
    abbr -a -g grrs git reset --soft
    abbr -a -g grrh git reset --hard
    abbr -a -g gg git grep -i -I -n --break --heading -p

    ## Abbrs em sistemas
    if test "$OS" = "artixlinux"; or test "$OS" = "archlinux"; or test "$OS" = "manjaro";
        # pacman
        abbr -a -g ps doas pacman --color always -S
        abbr -a -g psi pacman --color always -Si
        abbr -a -g pss pacman --color always -Ss
        abbr -a -g psyu doas pacman --color always -Syu
        abbr -a -g pq pacman --color always -Q
        abbr -a -g pqi pacman --color always -Qi
        abbr -a -g pqs pacman --color always -Qs
        abbr -a -g pfyl doas pacman --color always -Fyl
        abbr -a -g prns doas pacman --color always -Rns
        abbr -a -g exp "expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n"
        # paru
        abbr -a -g pps paru --color always -S
        abbr -a -g ppsi paru --color always -Si
        abbr -a -g ppss paru --color always -Ss
        abbr -a -g ppsyu "paru -Pw;paru --color always -Syu"
        abbr -a -g ppq paru --color always -Q
        abbr -a -g ppqi paru --color always -Qi
        abbr -a -g ppqs paru --color always -Qs
        abbr -a -g ppfyl paru --color always -Fyl
        abbr -a -g pprns paru --color always -Rns
    else if test "$OS" = "voidlinux";
        abbr -a -g xs "./xbps-src"
        # xbps
        abbr -a -g xis doas xbps-install -S
        abbr -a -g xqrs xbps-query -Rs
        abbr -a -g xisu doas xbps-install -Su
        abbr -a -g xql xbps-query -l
        abbr -a -g xqlg "xbps-query -l | grep --color -i"
        abbr -a -g xrr doas xbps-remove -R
        # xtools
        abbr -a -g chroot xchroot
        abbr -a -g xg xgrep
        abbr -a -g xh xhog
        abbr -a -g xil xilog
        abbr -a -g xl "xlocate -S && xlocate"
        abbr -a -g xm xmandoc
        abbr -a -g xqr xq -R
    else if test "$OS" = "linuxmint";
        abbr -a -g bat batcat
        # apt
        abbr -a -g ai doas apt install
        abbr -a -g as apt show
        abbr -a -g ass apt search
        abbr -a -g auau "doas apt update && doas apt upgrade"
        abbr -a -g ali apt list --installed
        abbr -a -g ar doas apt remove
    end

    ## Prompt ##
    starship init fish | source
end
