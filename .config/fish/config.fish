# caso esteja em uma sessão interativa
if status is-interactive
    ## Fish ##
    # set fish_trace 1 # ativa modo debug
    set -x SHELL (which fish)
    set fzf_fd_opts --base-directory $HOME -H -I -d 4 -t d -E '*cache*' -E '*git*'
    set fzf_git_log_opts --preview-window=bottom --no-sort -e
    set --global fish_color_command green
    set --global fish_color_error '#ff0000'
    set fish_color_param cyan
    set -g fish_key_bindings fish_vi_key_bindings

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

    # needs to happen after fisher installs fzf
    fzf_configure_bindings --history=\cS --git_log=\cA --variables=\cV --processes=\cX

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

    # now you need a token server to get high quality stuff from ytb, this just starts it
    function yt-dlp
        if not pgrep -fx "node $XDG_DATA_HOME/bgutil-ytdlp-pot-provider/server/build/main.js" > /dev/null
            echo "Starting POT token server..."
            node $XDG_DATA_HOME/bgutil-ytdlp-pot-provider/server/build/main.js &> /tmp/pot-server.log &
            disown

            while not curl -s localhost:4416 > /dev/null
                sleep 0.2
            end
        end

        command yt-dlp $argv
    end

    # Git bare dotfiles
    function git
        if test "$(pwd)" = "$HOME"
            switch $argv[1]
                # safe subcommands
                case status diff log reset grep revise submodule push pull commit add \
                     restore rebase stash remote show revert fetch branch checkout \
                     rev-parse rm mv reflog
                    command git --work-tree=. --git-dir="$HOME/etc/.dotfiles/" $argv
                case '*'
                    echo "command 'git $argv[1]' not allowed in your dotfiles"
            end
        else
            command git $argv
        end
    end

    # git status recursivo
    function gsr
        set cdir (pwd)
        for repo in (fd -a -t d -u -E '*cache*' -E '*.local*' -E '*.config/emacs*' | rg '\.git/$')
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
        for repo in (fd -a -t d -u -E '*cache*' -E '*.local*' -E '*.config/emacs*' | rg '\.git/$')
            set repo (echo $repo | sed 's/\/.git\/$//')
            cd $repo

            set cols (tput cols)
            set i 0
            while test $i -lt $cols
                echo -n "─"
                set i (math $i + 1)
            end
            echo

            read -l -P "pull $repo? [y/N/c] " confirm
            if test $confirm = y -o $confirm = Y
                git pull
            else if test $confirm = c -o $confirm = C
                break
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

    function 2opus
        for file in $argv
            if test -f $file
                set out (path change-extension '.opus' $file)
                echo "Converting: $file → $out"

                if ffmpeg -hide_banner -loglevel error -i "$file" -c:a libopus -vbr on -compression_level 10 -y "$out"
                    echo "✅ Success, removing original: $file"
                    trash "$file"
                else
                    echo "❌ Failed to convert: $file (keeping original)"
                end
            end
        end
    end

    function 2webp
        for file in $argv
            if test -f $file
                set out (path change-extension '.webp' $file)
                echo "Converting: $file → $out"

                if cwebp -lossless -q 100 -m 6 "$file" -o "$out"
                    echo "✅ Success, removing original: $file"
                    trash "$file"
                else
                    echo "❌ Failed to convert: $file (keeping original)"
                end
            end
        end
    end

    function nvimdiff
        if test (count $argv) -lt 1
            echo "Usage: git_diff <file> [ref1] [ref2]"
            return 1
        end

        set file $argv[1]
        set ref1 (test (count $argv) -ge 2; and echo $argv[2]; or echo "HEAD")
        set ref2 (test (count $argv) -ge 3; and echo $argv[3]; or echo "WORK")

        set tmp (mktemp -d)
        set left $tmp/(basename $file).old
        set right $tmp/(basename $file).new

        git show "$ref1:$file" >$left 2>/dev/null; or touch $left

        if test "$ref2" = WORK
            cp $file $right
        else
            git show "$ref2:$file" >$right 2>/dev/null; or touch $right
        end

        nvim -d $left $right

        rm -rf $tmp
    end

    ## Abbr ##
    abbr --set-cursor=% -a -g 0x0 "curl -F'file=@%' https://0x0.st"
    abbr -a -g rest 'sleep 30m && notify-send -u critical "rest for a while" && foot -T nvim -a nvim nvim ~/.cache/rest'
    abbr -a -g docker podman
    abbr -a -g trl transmission-remote -l
    abbr -a -g tra transmission-remote -a
    abbr --set-cursor=% -a -g trt "transmission-remote -t %"
    abbr --set-cursor=% -a -g trr "transmission-remote -t % -r"
    abbr --set-cursor=% -a -g trrad "transmission-remote -t % -rad"
    abbr --set-cursor=% -a -g trs "transmission-remote -t % -s"
    abbr --set-cursor=% -a -g trS "transmission-remote -t % -S"
    abbr -a -g y yazi
    abbr -a -g b bluetui
    abbr -a -g wget wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"
    abbr -a -g cd z
    abbr -a -g cage cage -s --
    abbr -a -g sg sgrade
    abbr -a -g pk pkill -i
    abbr -a -g pg pgrep -ia
    abbr -a -g uma doas usermod -aG
    abbr -a -g umr doas usermod -rG
    abbr -a -g df df -hT --total -x tmpfs -x devtmpfs
    abbr -a -g tep trans en:pt
    abbr -a -g tpe trans pt:en
    abbr -a -g tje trans ja:en
    abbr -a -g tej trans en:ja
    abbr -a -g as "abbr | rg -i"
    abbr -a -g ff fastfetch
    abbr -a -g v nvim
    abbr -a -g vc nvim --clean
    abbr -a -g vv foot -T nvim -a nvim nvim
    abbr -a -g h htop
    abbr -a -g copy wl-copy
    abbr -a -g sudo doas
    abbr -a -g ping ping gnu.org
    abbr -a -g p "patch -p1 <"
    abbr -a -g pr "patch -R <"
    abbr -a -g vol wpctl set-volume @DEFAULT_AUDIO_SINK@ 70%
    abbr -a -g vols wpctl status
    abbr -a -g yt yt-dlp -P ~/Downloads --write-subs --no-playlist --cookies-from-browser chromium
    abbr -a -g yta "yt-dlp -o '%(artist)s - %(track,title)s.%(ext)s' --no-playlist --cookies-from-browser chromium -x"
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
    abbr -a -g rml "trash-list | sort -k 1,1 -k 2,2"
    abbr -a -g rmr trash-restore
    abbr -a -g rmrm trash-rm
    abbr -a -g g rg -j "$THREADS" -ip
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
    abbr -a -g gf git fetch
    abbr -a -g gg git grep -iIn
    abbr -a -g ggs git grep -iIn -8
    abbr -a -g gi git init
    abbr -a -g gl git log --oneline --graph
    abbr -a -g gpl git pull
    abbr -a -g gps git push
    abbr -a -g gpsf git push --force-with-lease
    abbr -a -g gr git restore
    abbr -a -g gra git rebase --abort
    abbr -a -g grc git rebase --continue
    abbr -a -g gri git rebase -i --autostash
    abbr -a -g grv git revert
    abbr -a -g grva git revert --abort
    abbr -a -g grvc git revert --continue
    abbr -a -g grp git restore -p
    abbr -a -g grrh git reset --hard
    abbr -a -g grrs git reset --soft
    abbr -a -g grs git restore --staged
    abbr -a -g grsp git restore --staged -p
    abbr -a -g grsu git remote set-url origin
    abbr -a -g gs git status
    abbr -a -g gS git show
    abbr -a -g gsi git status --ignored
    abbr -a -g gsa git submodule add https://github.com/
    abbr -a -g gss git stash push -m
    abbr -a -g gssp git stash push --patch -m
    abbr -a -g gsss git stash push -S -m
    abbr -a -g gu gitui
    abbr -a -g gwa git worktree add
    abbr -a -g gwr git worktree remove

    ## Abbrs em sistemas
    if test "$OS" = nixos
        abbr -a -g nixre doas nixos-rebuild switch
        abbr -a -g nixcg 'doas nix-collect-garbage -d && doas nix-store --optimise'
    else if test "$OS" = artixlinux || test "$OS" = archlinux || test "$OS" = manjaro
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
