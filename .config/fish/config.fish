# caso esteja em uma sessão interativa
if status is-interactive
    ## Fish ##
    # set fish_trace 1 # ativa modo debug
    set -U fish_greeting # desativa mensagem ao iniciar
    set -x SHELL /bin/fish
    set -x GPG_TTY (tty)
    set fzf_fd_opts --base-directory $HOME -H -I -d 4 -t d -E '*cache*' -E '*git*'
    set fzf_git_log_opts --preview-window=bottom --no-sort -e
    set fish_color_normal white
    set fish_color_autosuggestion '#444444'
    set fish_color_command green
    set fish_color_error '#ff0000'
    set fish_color_param cyan

    zoxide init fish | source

    ## Plugins ##
    if test ! -e /home/lucas/.config/fish/fish_plugins
        echo "Installing fisher! 🎣"
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
        echo "Installing fzf! 🔍"
        fisher install PatrickF1/fzf.fish
        echo "Installing done! ✅"
        fisher install franciscolourenco/done
        echo "Installing abbrevition-tips! 💡"
        fisher install gazorby/fish-abbreviation-tips
        echo "Installing autopair! (\"\")"
        fisher install jorgebucaran/autopair.fish
        echo "Installing puffer-fish! 🐡"
        fisher install nickeb96/puffer-fish
    end

    ## Teclas ##
    # teclas emacs/vi
    function fish_user_key_bindings
        # fish_default_key_bindings
        fish_vi_key_bindings
        bind -M insert jj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
        # fzf
        fzf_configure_bindings --history=\cS --git_log=\cA --variables=\cV --processes=\cX
    end

    ## funções ##
    # localizar e editar arquivo
    function ea
        set arquivo (locate -Ai "$argv" | fzf)
        if test -n "$arquivo"
            eval $EDITOR "$arquivo"
        end
    end

    # localizar e editar executável
    function ee
        set executavel (fd . $PATH | fzf)
        if test -x "$executavel"
            eval $EDITOR "$executavel"
        end
    end

    # Abre um processo e o separa
    function dis
        $argv >/dev/null 2>&1 &
        disown
    end

    # Git bare dotfiles
    function git
        if test "$(pwd)" = "$HOME" && test $argv[1] != init && test $argv[1] != clone
            /usr/bin/git --work-tree=. --git-dir="$HOME/etc/.dotfiles/" $argv
        else
            /usr/bin/git $argv
        end
    end

    # git status recursivo
    function gsr
        set cdir (pwd)
        for repo in (fd -a -t d -u -E '*cache*' -E '*.local*' -E '*.config/emacs*' | ugrep '\.git/$')
            set repo (echo $repo | sed 's/\/.git\/$//')
            cd $repo

            set cols (tput cols)
            set i 0
            while test $i -lt $cols
                echo -n "─"
                set i (math $i + 1)
            end

            if git status | grep nothing >/dev/null
                printf "\033[96m\033[1m%s\033[0m\n" "$repo"
            else
                printf "\033[96m\033[1m%s\033[0m\n" "$repo"
                git status
            end
        end
        cd $cdir
    end

    # git pull recursivo
    function gpr
        set cdir (pwd)
        for repo in (fd -a -t d -u -E '*cache*' -E '*.local*' -E '*.config/emacs*' | ugrep '\.git/$')
            set repo (echo $repo | sed 's/\/.git\/$//')
            cd $repo

            set cols (tput cols)
            set i 0
            while test $i -lt $cols
                echo -n "─"
                set i (math $i + 1)
            end
            echo

            read -l -P "pull $repo? [y/N] " confirm
            if test $confirm = y -o $confirm = Y
                git pull
            end
        end
        cd $cdir
    end

    # git stash list
    # usa o fzf para selecionar uma stash e uma ação
    function gsl
        set snum (git stash list | fzf | sed 's/^.*{//;s/}.*$//')
        test -z $snum && return
        set action (printf "apply\ndrop\nshow\nbranch\nclear" | fzf)
        test -z $action && return

        test $action = clear && git stash $action && return

        if test $action = branch
            read -l -P "Branch name: " name
            test -z $name && return
            git stash branch $name $stash && return
        end

        git stash $action $snum
    end

    ## Abbr ##
    abbr -a -g wget wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"
    abbr -a -g code code-oss
    abbr -a -g cd z
    abbr -a -g cage cage -s --
    abbr -a -g sg sgrade
    abbr -a -g pk pkill -i
    abbr -a -g pg pgrep -ia
    abbr -a -g uma doas usermod -aG
    abbr -a -g umr doas usermod -rG
    abbr -a -g df df -hT --total -x tmpfs -x devtmpfs
    abbr -a -g tep trans -s en -hl pt
    abbr -a -g tpe trans -s pt -hl en
    abbr -a -g hc herbstclient
    abbr -a -g stc stc -homedir ~/.config/syncthing/
    abbr -a -g fm fzf_man
    abbr -a -g as "abbr | ugrep --color -i"
    abbr -a -g ff flashfetch
    abbr -a -g v nvim
    abbr -a -g vc nvim --clean
    abbr -a -g vv term_open -a nvim nvim
    abbr -a -g h htop
    abbr -a -g copy xclip -selection clipboard
    abbr -a -g sudo doas
    abbr -a -g ping ping gnu.org
    abbr -a -g p "patch -p1 <"
    abbr -a -g pr "patch -R <"
    abbr -a -g vol wpctl set-volume @DEFAULT_AUDIO_SINK@ 70%
    abbr -a -g vols wpctl status
    abbr -a -g yt yt-dlp -P ~/Downloads --write-subs
    if test "$HOSTNAME" = "$OS"note
        abbr -a -g yt "yt-dlp -P ~/Downloads --write-subs -f 'worstvideo*[height=720]+worstaudio/worst[height=720]'"
    end
    abbr -a -g yta yt-dlp -x
    abbr -a -g ytw "mpv --ytdl-format='worstvideo*[height=720]+worstaudio/worst[height=720]' --cache=yes --demuxer-max-bytes=2048Kib --wayland-app-id=Picture-in-Picture"
    abbr -a -g sw "streamlink -a '--wayland-app-id=Picture-in-Picture'"
    abbr -a -g scdl scdl --path ~/Downloads --max-size 100m -c --addtofile -l
    abbr -a -g mi make install
    abbr -a -g mu make uninstall
    abbr -a -g dmi doas make install
    abbr -a -g dmu doas make uninstall
    abbr -a -g dnr dotnet run
    abbr -a -g dnrp dotnet run --project
    abbr -a -g dnn dotnet new
    abbr -a -g dnb dotnet build
    abbr -a -g dnbp dotnet build --project
    abbr -a -g dnp dotnet publish
    abbr -a -g dnap dotnet add package
    abbr -a -g dnar dotnet add reference
    abbr -a -g dnw dotnet watch
    abbr -a -g dnwp dotnet watch --project
    abbr -a -g dti dotnet tool install -g
    abbr -a -g dtu dotnet tool uninstall -g
    abbr -a -g dts dotnet tool search
    abbr -a -g dtl dotnet tool list -g
    abbr -a -g dnsa dotnet sln add
    abbr -a -g dnsl dotnet sln list
    abbr -a -g dnsr dotnet sln remove
    abbr -a -g nit npm init -y
    abbr -a -g ni npm install
    abbr -a -g nii npm info
    abbr -a -g nig npm install -g
    abbr -a -g nid npm install -D
    abbr -a -g nrg npm remove -g
    abbr -a -g nrd npm remove -D
    abbr -a -g ns npm search
    abbr -a -g nl npm list
    abbr -a -g nlg npm list -g
    abbr -a -g nr npm run
    abbr -a -g nrb npm run build
    # arquivos e Diretórios
    abbr -a -g rm trash
    abbr -a -g rme trash-empty
    abbr -a -g rml trash-list
    abbr -a -g rmr trash-restore
    abbr -a -g rmrm trash-rm
    abbr -a -g g ugrep --color -iIn
    abbr -a -g l lsd -AX1 --group-dirs first
    abbr -a -g la lsd -lXA1 --group-dirs first
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
    abbr -a -g ga git add
    abbr -a -g gaf git add -f
    abbr -a -g gap git add -p
    abbr -a -g gba git branch -a
    abbr -a -g gbd git branch -d
    abbr -a -g gc git clone
    abbr -a -g gcd git clone --depth
    abbr -a -g gcr git clone --recurse-submodules
    abbr -a -g gca git commit --amend
    abbr -a -g gcan git commit --amend --no-edit
    abbr -a -g gcm git commit
    abbr -a -g gco git checkout
    abbr -a -g gcob git checkout -b
    abbr -a -g gd git diff
    abbr -a -g gds git diff --staged
    abbr -a -g gdd git d
    abbr -a -g gf git fetch
    abbr -a -g gg git grep -iIn
    abbr -a -g ggs git grep -iIn -8
    abbr -a -g gi git init
    abbr -a -g gl git log --oneline --graph
    abbr -a -g gll git l
    abbr -a -g gpl git pull
    abbr -a -g gps git push
    abbr -a -g gpsf git push -f
    abbr -a -g gr git restore
    abbr -a -g gra git rebase --abort
    abbr -a -g grc git rebase --continue
    abbr -a -g gri git rebase -i --autostash
    abbr -a -g grp git restore -p
    abbr -a -g grrh git reset --hard
    abbr -a -g grrs git reset --soft
    abbr -a -g grs git restore --staged
    abbr -a -g grsp git restore --staged -p
    abbr -a -g grsu git remote set-url origin
    abbr -a -g grv git remote -v
    abbr -a -g gs git status
    abbr -a -g gsa git submodule add https://github.com/
    abbr -a -g gss git stash push -m
    abbr -a -g gssp git stash push --patch -m
    abbr -a -g gsss git stash push -S -m
    abbr -a -g gwa git worktree add
    abbr -a -g gwr git worktree remove

    ## Abbrs em sistemas
    if test "$OS" = artixlinux || test "$OS" = archlinux || test "$OS" = manjaro
        # pacman
        abbr -a -g ps doas pacman --noconfirm --color always -S
        abbr -a -g psi pacman --color always -Si
        abbr -a -g pss pacman --color always -Ss
        abbr -a -g psyu doas pacman --noconfirm --color always -Syu
        abbr -a -g pq pacman --color always -Q
        abbr -a -g pqi pacman --color always -Qi
        abbr -a -g pqs pacman --color always -Qs
        abbr -a -g pfyl doas pacman --color always -Fyl
        abbr -a -g prns doas pacman --noconfirm --color always -Rns
        abbr -a -g exp "expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 100"
        # paru
        abbr -a -g pps paru --noconfirm --color always -S
        abbr -a -g ppsi paru --color always -Si
        abbr -a -g ppss paru --color always -Ss
        abbr -a -g ppsyu "paru -Pw;paru --noconfirm --color always -Syu"
        abbr -a -g ppq paru --color always -Q
        abbr -a -g ppqi paru --color always -Qi
        abbr -a -g ppqs paru --color always -Qs
        abbr -a -g ppfyl paru --color always -Fyl
        abbr -a -g pprns paru --noconfirm --color always -Rns
        abbr -a -g sys doas systemctl
    else if test "$OS" = voidlinux
        abbr -a -g xs "./xbps-src"
        abbr -a -g xc "./xbps-src clean"
        abbr -a -g xp "./xbps-src pkg"
        abbr -a -g xpm "./xbps-src pkg -a \*musl"
        abbr -a -g xbb "./xbps-src binary-bootstrap"
        # xbps
        abbr -a -g xis doas xbps-install -Sy
        abbr -a -g xqrs xbps-query -Rs
        abbr -a -g xisu doas xbps-install -Suy
        abbr -a -g xql xbps-query -l
        abbr -a -g xqlg "xbps-query -l | ugrep --color -i"
        abbr -a -g xrr doas xbps-remove -Ry
        # xtools
        abbr -a -g xch xchroot
        abbr -a -g xg xgrep
        abbr -a -g xh xhog
        abbr -a -g xil xilog
        abbr -a -g xl "xlocate -S && xlocate"
        abbr -a -g xm xmandoc
        abbr -a -g xqr xq -R
        abbr -a -g sys doas sv
    else if test "$OS" = linuxmint
        abbr -a -g bat batcat
        # apt
        abbr -a -g ai doas apt install -y
        abbr -a -g as apt show
        abbr -a -g ass apt search
        abbr -a -g auau "doas apt update -y && doas apt upgrade -y"
        abbr -a -g ali apt list --installed
        abbr -a -g ar doas apt remove -y
        abbr -a -g sys doas systemctl
    end

    ## Prompt ##
    starship init fish | source
end
