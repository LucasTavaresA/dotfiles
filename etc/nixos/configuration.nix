{ lib, pkgs, ... }:

let
  pkgPath = pkg: "pkgs.${lib.concatStringsSep "." pkg}";

  requirePackages =
    pkgList:
    map (
      path: lib.attrByPath path (throw (Color yellow "Missing package: ${pkgPath path}")) pkgs
    ) pkgList;

  stevenBlackGamblingHosts = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/f0c1e878685f647bac77f6ed81980379318ee7c3/alternates/gambling/hosts";
    hash = "sha256-WkYgwQBPhFx19cIAKVJvseF5jRV4WLelJkNvxAikvSM=";
  };

  GB = 1024;

  user = "lucas";
  home = "/home/${user}";

  esc = builtins.fromJSON ''"\u001b"'';
  yellow = "${esc}[1;33m";
  reset = "${esc}[0m";
  Color = color: text: "${color}${text}${reset}";
in
{
  imports = [ /etc/nixos/hardware-configuration.nix ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * GB;
    }
  ];
  zramSwap.enable = true;

  networking = {
    hostName = "nixosT14";
    hostFiles = [ stevenBlackGamblingHosts ];
    networkmanager.enable = true;
  };

  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = false;
  };

  console.keyMap = "br-abnt2";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "pt_BR.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_COLLATE = "C";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  nix = {
    # i use nix-command and flakes only for dev environments
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    channel.enable = false;
    nixPath = [
      "nixpkgs=${home}/code/nixpkgs"
      "nixos-config=${home}/etc/nixos/configuration.nix"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        scripts = [ self.mpvScripts.mpris ];
      };

      # so my userscripts can see pyperclip
      qutebrowser = super.qutebrowser.overrideAttrs (old: {
        preFixup = old.preFixup + ''
          makeWrapperArgs+=(
            --prefix PYTHONPATH : ${self.python3Packages.pyperclip}/${self.python3.sitePackages}
          )
        '';
      });
    })
  ];

  fonts.fontDir.enable = true;
  fonts.packages = requirePackages [
    [ "corefonts" ]
    [ "dejavu_fonts" ]
    [ "fira" ]
    [ "fira-code" ]
    [ "inconsolata" ]
    [ "iosevka" ]
    [ "noto-fonts-cjk-sans" ]
    [ "noto-fonts-cjk-serif" ]
    [ "noto-fonts-color-emoji" ]
    [ "roboto" ]
    [ "terminus_font" ]
    [ "ubuntu-classic" ]
  ];

  programs = {
    fish.enable = true;
    bash.interactiveShellInit = ''
      unset HISTFILE
    '';
    ssh = {
      startAgent = true;
      agentTimeout = "10m";
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = requirePackages [
        [ "mako" ]
        [ "swayidle" ]
        [ "swaylock" ]
        [ "waybar" ]
        [ "xwayland" ]
        [ "sway-audio-idle-inhibit" ]
        [
          "sway-contrib"
          "grimshot"
        ]
        [ "swayimg" ]
        [ "swayr" ]
      ];
    };
    yazi = {
      enable = true;

      plugins = {
        git = pkgs.yaziPlugins.git;
      };

      initLua = /. + "${home}/.config/yazi/main.lua";

      settings = {
        yazi = lib.importTOML (/. + "${home}/.config/yazi/yazi.toml");
        keymap = lib.importTOML (/. + "${home}/.config/yazi/keymap.toml");
        theme = lib.importTOML (/. + "${home}/.config/yazi/theme.toml");
      };
    };
  };

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        extraConfig = ''
          [global]
          # stops any pressing if held for 300ms
          overload_tap_timeout = 300

          [main]
          a = lettermod(control, a, 150, 200)
          s = lettermod(shift, s, 150, 200)
          d = lettermod(meta, d, 150, 200)
          f = lettermod(alt, f, 150, 200)
          h = lettermod(alt, h, 150, 200)
          j = lettermod(meta, j, 150, 200)
          k = lettermod(shift, k, 150, 200)
          l = lettermod(control, l, 150, 200)

          # force the home row mods
          leftshift = noop
          rightshift = noop
          leftcontrol = noop
          rightcontrol = noop
          leftmeta = noop
          rightmeta = noop
          leftalt = noop
          # rightalt is altgr, keep it for br-abnt2 symbols

          # force escape for arrow keys
          left = noop
          down = noop
          up = noop
          right = noop

          # hold esc for arrow hjkl, esc+shift for paging
          esc = overload(nav, esc)

          [nav]
          leftshift = layer(shift)
          h = left
          j = down
          k = up
          l = right

          [nav+shift]
          h = home
          j = pagedown
          k = pageup
          l = end
        '';
      };
    };
    flatpak.enable = true;
    fwupd.enable = true;
    locate.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        # switches to bluetooth headphones when they connect
        extraConfig."51-bluetooth-priority" = {
          "monitor.bluez.rules" = [
            {
              matches = [
                { "node.name" = "~bluez_output.*"; }
              ];
              actions = {
                update-props = {
                  "priority.session" = 1600;
                  "priority.driver" = 1600;
                };
              };
            }
          ];
        };
      };
    };

    tlp.enable = true;

    syncthing = {
      enable = true;
      inherit user;
      group = "users";
      dataDir = home;
      configDir = "${home}/.config/syncthing";
      openDefaultPorts = false;
      settings = {
        devices = {
          "SM-A528B" = {
            autoAcceptFolders = true;
            id = "QHXWC4X-SFUJA2W-HKWVPKK-EMZMTRM-XXAM6OL-Y5NAZ6E-4G25RN7-OSOKNAL";
          };
        };
        folders =
          lib.mapAttrs'
            (key: _: {
              name = home + key;
              value = {
                label = baseNameOf key;
                id = baseNameOf key;
                devices = [ "SM-A528B" ];
                versioning = {
                  type = "trashcan";
                  params.cleanoutDays = "14";
                };
              };
            })
            {
              "/Downloads/sync" = { };
              "/media/jogos/roms" = { };
              "/media/musicas" = { };
              "/media/videos" = { };
              "/media/lit" = { };
              "/documentos" = { };
              "/media/imagens" = { };
            };
      };
    };

    transmission = {
      enable = true;
      inherit user;
      group = "users";
      inherit home;
      settings.incomplete-dir-enabled = false;
      openPeerPorts = false;
    };

    tailscale = {
      enable = true;
    };

    # Lenovo ThinkPad T14 Gen 1 AMD, Brazilian keyboard fix slash key
    # change caps lock to escape
    # make prtsc into menu/compose key for use in the window manager
    udev.extraHwdb =
      lib.throwIf (lib.versionAtLeast pkgs.systemd.version "262")
        (Color yellow "systemd ${pkgs.systemd.version} fixes the slash key, remove KEYBOARD_KEY_9d=ro from configuration.nix!")
        ''
          evdev:atkbd:dmi:bvn*:bvr*:bd*:svnLENOVO:pn20UES5TQ00:pvr*
           KEYBOARD_KEY_9d=ro
           KEYBOARD_KEY_3a=esc
           KEYBOARD_KEY_b7=compose
        '';

    openssh = {
      enable = true;
      openFirewall = false;

      settings = {
        AllowUsers = [ user ];
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  systemd = {
    # fixes transmission not being able to read/write anything except its download/incomplete/config folders
    services.transmission.serviceConfig.BindPaths = [
      "/home/lucas"
    ];

    user.services.mpd = {
      description = "Music Player Daemon";
      after = [
        "pipewire.service"
        "network.target"
      ];
      wantedBy = [ "default.target" ];

      serviceConfig =
        let
          mpdDataDir = "${home}/.config/mpd";
          mpdConf = pkgs.writeText "mpd.conf" ''
            music_directory        "${home}/media/musicas"
            playlist_directory     "${mpdDataDir}/playlists"
            db_file                "${mpdDataDir}/database"
            state_file             "${mpdDataDir}/state"
            sticker_file           "${mpdDataDir}/sticker.sql"

            bind_to_address        "127.0.0.1"
            auto_update            "yes"
            restore_paused         "yes"
            max_output_buffer_size "16384"

            audio_output {
                type "pipewire"
                name "PipeWire Sound Server"
            }
          '';
        in
        {
          Type = "notify";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${mpdDataDir}/playlists";
          ExecStart = "${pkgs.mpd}/bin/mpd --systemd ${mpdConf}";
          ExecStartPost = "${pkgs.mpc}/bin/mpc update";
          Restart = "on-failure";
        };
    };

    # yt-dlp needs proof-of-origin tokens for full-quality youtube formats
    user.services.bgutil-pot-provider = {
      description = "POT token server for yt-dlp";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = lib.getExe pkgs.python3Packages.bgutil-ytdlp-pot-provider;
        Restart = "on-failure";
      };
    };
  };

  security = {
    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          setEnv = [ "NIX_PATH" ];
          persist = true;
        }
      ];
    };
    polkit.enable = true;
    rtkit.enable = true;
    sudo.enable = false;
  };

  hardware = {
    alsa.enablePersistence = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    containers.registries.search = [ "docker.io" ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = requirePackages [ [ "xdg-desktop-portal-gtk" ] ];
    config.common.default = [
      "wlr"
      "gtk"
    ];
  };

  users.users = {
    root.shell = pkgs.fish;
    ${user} = {
      isNormalUser = true;
      inherit home;
      shell = pkgs.dash;
      extraGroups = [
        "audio"
        "input"
        "libvirtd"
        "networkmanager"
        "video"
        "wheel"
      ];
    };
  };

  system = {
    activationScripts.flatpakFlathub.text = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
    '';

    stateVersion = "26.05";
  };

  environment = {
    etc."yt-dlp/plugins/bgutil/yt_dlp_plugins".source =
      "${pkgs.python3Packages.bgutil-ytdlp-pot-provider}/${pkgs.python3.sitePackages}/yt_dlp_plugins";

    shells = [
      pkgs.dash
      pkgs.fish
    ];
    systemPackages =
      requirePackages [
        [ "_7zz" ]
        [ "acpi" ]
        [ "alsa-firmware" ]
        [ "alsa-utils" ]
        [ "android-file-transfer" ]
        [ "android-tools" ]
        [ "asciidoc" ]
        [ "asciinema" ]
        [ "aspell" ]
        [
          "aspellDicts"
          "en"
        ]
        [
          "aspellDicts"
          "pt_BR"
        ]
        [ "atool" ]
        [ "automake" ]
        [ "bash-language-server" ]
        [ "bat" ]
        [ "bc" ]
        [ "bear" ]
        [ "bluetui" ]
        [ "bluez" ]
        [ "brightnessctl" ]
        [ "btop" ]
        [ "cage" ]
        [ "cargo" ]
        [ "cargo-update" ]
        [ "ccls" ]
        [ "chafa" ]
        [ "checkbashisms" ]
        [ "chromium" ]
        [ "claude-code" ]
        [ "cliphist" ]
        [ "cloc" ]
        [ "cmake" ]
        [ "csharpier" ]
        [ "csharprepl" ]
        [ "curl" ]
        [ "darcs" ]
        [ "deadnix" ]
        [ "delta" ]
        [ "dpkg" ]
        [ "easyeffects" ]
        [ "entropy" ]
        [ "evtest" ]
        [ "exiftool" ]
        [ "expect" ]
        [ "fastfetch" ]
        [ "fd" ]
        [ "ffmpeg" ]
        [ "ffmpegthumbnailer" ]
        [ "file" ]
        [ "firefox" ]
        [ "flac" ]
        [ "foot" ]
        [ "fzf" ]
        [ "gcab" ]
        [ "gcc" ]
        [ "gdb" ]
        [ "gdu" ]
        [ "gettext" ]
        [ "gh" ]
        [ "gimp" ]
        [ "git" ]
        [ "git-revise" ]
        [ "gitui" ]
        [ "glow" ]
        [ "gnome-epub-thumbnailer" ]
        [ "gnumake" ]
        [ "go" ]
        [ "golangci-lint" ]
        [ "gopls" ]
        [ "grim" ]
        [ "gtk3" ]
        [ "gucharmap" ]
        [ "guilt" ]
        [ "handlr-regex" ]
        [ "hexchat" ]
        [ "highlight" ]
        [ "htop" ]
        [ "hunspell" ]
        [
          "hunspellDicts"
          "en_US"
        ]
        [
          "hunspellDicts"
          "pt_BR"
        ]
        [ "hyperfine" ]
        [ "ilspycmd" ]
        [ "imagemagick" ]
        [ "inkscape" ]
        [ "jadx" ]
        [ "jd-diff-patch" ]
        [ "jdupes" ]
        [ "jpegoptim" ]
        [ "jq" ]
        [ "keepassxc" ]
        [ "ktlint" ]
        [ "libarchive" ]
        [ "libnotify" ]
        [ "libreoffice" ]
        [ "libtool" ]
        [ "libwebp" ]
        [
          "llvmPackages"
          "clang"
        ]
        [
          "llvmPackages"
          "clang-tools"
        ]
        [ "lsd" ]
        [ "lsp-plugins" ]
        [ "lua" ]
        [ "lua-language-server" ]
        [ "lutris" ]
        [ "man-pages" ]
        [ "man-pages-posix" ]
        [ "mdcat" ]
        [ "mediainfo" ]
        [ "mesa-demos" ]
        [ "meson" ]
        [ "mpc" ]
        [ "mpdris2" ]
        [ "mplayer" ]
        [ "mpv" ]
        [ "msbuild" ]
        [ "msitools" ]
        [ "ncmpcpp" ]
        [ "neovim" ]
        [ "netcoredbg" ]
        [ "nim" ]
        [ "nixd" ]
        [ "nixfmt" ]
        [ "nodejs" ]
        [ "nuspell" ]
        [ "nvme-cli" ]
        [ "obs-studio" ]
        [ "omnisharp-roslyn" ]
        [ "opencode" ]
        [ "openjdk" ]
        [ "pandoc" ]
        [ "parallel" ]
        [ "patch" ]
        [ "patchelf" ]
        [
          "perlPackages"
          "NetDBus"
        ]
        [ "pkg-config" ]
        [ "pkgconf" ]
        [
          "pkgsCross"
          "mingwW64"
          "stdenv"
          "cc"
        ]
        [ "playerctl" ]
        [ "poppler-utils" ]
        [ "psmisc" ]
        [ "pulsemixer" ]
        [ "pyright" ]
        [ "python3" ]
        [
          "python3Packages"
          "flake8"
        ]
        [ "qemu_kvm" ]
        [ "quick-lint-js" ]
        [ "quilt" ]
        [ "qutebrowser" ]
        [ "resvg" ]
        [ "ripgrep" ]
        [ "rlwrap" ]
        [ "rsync" ]
        [ "rust-analyzer" ]
        [ "rustc" ]
        [ "scdl" ]
        [ "scdoc" ]
        [ "scrcpy" ]
        [ "shellcheck" ]
        [ "shfmt" ]
        [ "simple-mtpfs" ]
        [ "slurp" ]
        [ "speedtest-cli" ]
        [ "spotdl" ]
        [ "sqlite" ]
        [ "starship" ]
        [ "statix" ]
        [ "strace" ]
        [ "streamlink" ]
        [ "stress" ]
        [ "stylelint" ]
        [ "stylua" ]
        [ "telegram-desktop" ]
        [ "testdisk" ]
        [ "tofi" ]
        [ "translate-shell" ]
        [ "trash-cli" ]
        [ "tree-sitter" ]
        [ "typescript" ]
        [ "typescript-language-server" ]
        [ "typioca" ]
        [ "ueberzugpp" ]
        [ "unar" ]
        [ "unrar" ]
        [ "uv" ]
        [ "valgrind" ]
        [ "vlc" ]
        [ "vscode-langservers-extracted" ]
        [ "vulkan-loader" ]
        [ "vulkan-tools" ]
        [ "w3m" ]
        [ "wev" ]
        [ "wget" ]
        [ "wiggle" ]
        [
          "wineWow64Packages"
          "stable"
        ]
        [ "winetricks" ]
        [ "wl-clipboard" ]
        [ "xdg-user-dirs" ]
        [ "xdg-user-dirs-gtk" ]
        [ "xdg-utils" ]
        [ "xprop" ]
        [ "xrdb" ]
        [ "xxd" ]
        [ "xz" ]
        [ "yt-dlp" ]
        [ "zathura" ]
        [
          "zathuraPkgs"
          "zathura_cb"
        ]
        [
          "zathuraPkgs"
          "zathura_djvu"
        ]
        [
          "zathuraPkgs"
          "zathura_pdf_mupdf"
        ]
        [ "zig" ]
        [ "zip" ]
        [ "zls" ]
        [ "zoxide" ]
        [ "zstd" ]
      ]
      ++ [ (pkgs.callPackage ./tilth.nix { }) ]
      # combined so every SDK is visible to a single bin/dotnet
      ++ [
        (
          with pkgs.dotnetCorePackages;
          combinePackages [
            sdk_8_0
            sdk_9_0
            sdk_10_0
          ]
        )
      ];
  };
}
