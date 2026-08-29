{
  config,
  lib,
  pkgs,
  ...
}:

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

  mahoganyDesktop = pkgs.writeText "mahogany.desktop" ''
    [Desktop Entry]
    Name=Mahogany
    Comment=A tiling window manager for Wayland modeled after StumpWM
    Exec=systemd-cat --identifier=mahogany mahogany
    Type=Application
    DesktopNames=mahogany;wlroots
  '';

  mahoganySession =
    pkgs.runCommand "mahogany-session"
      {
        passthru.providedSessions = [ "mahogany" ];
      }
      ''
        install -Dm644 ${mahoganyDesktop} $out/share/wayland-sessions/mahogany.desktop
      '';

  GB = 1024;

  user = "lucas";
  home = "/home/${user}";

  sessionService = description: command: {
    inherit description;
    unitConfig.ConditionUser = user;
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "wayland-session.target" ];
    serviceConfig.ExecStart = "${pkgs.dash}/bin/dash -lc 'exec ${command}'";
  };

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
      enableAskPassword = true;
      askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = requirePackages [
        [ "mako" ]
        [ "swayidle" ]
        [ "swaylock" ]
        [ "swaybg" ]
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
    displayManager = {
      sessionPackages = [ mahoganySession ];
      defaultSession = "mahogany";
    };

    greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session.command = lib.concatStringsSep " " [
        (lib.getExe pkgs.tuigreet)
        "--time"
        "--remember"
        "--remember-session"
        "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
      ];
    };

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

    user.targets.wayland-session = {
      description = "wayland compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    user.services = {
      notify-bat = sessionService "Battery threshold notifications" "${home}/code/shellscripts/notify-bat";
      sway-audio-idle-inhibit = sessionService "Inhibit idle while audio is playing" "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
      waybar = sessionService "Wayland status bar" "${pkgs.waybar}/bin/waybar";
      swaybg = sessionService "Wallpaper" "${pkgs.swaybg}/bin/swaybg -i ${home}/media/imagens/wallpapers/stsr1.png -m fill";
      cliphist = sessionService "Clipboard history" "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      wl-clip-persist = sessionService "Keep clipboard contents after the source window closes" "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";

      mpd = {
        description = "Music Player Daemon";
        after = [
          "pipewire.service"
          "network.target"
        ];
        wantedBy = [ "default.target" ];
        unitConfig.ConditionUser = user;

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
              bind_to_address        "::1"
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

      mpDris2 = {
        description = "mpDris2 - Music Player Daemon D-Bus bridge";
        after = [ "mpd.service" ];
        wants = [ "mpd.service" ];
        wantedBy = [ "default.target" ];
        unitConfig.ConditionUser = user;
        serviceConfig = {
          ExecStart = "${pkgs.mpdris2}/bin/mpDris2 --use-journal --music-dir=${home}/media/musicas";
          Restart = "on-failure";
        };
      };

      # yt-dlp needs proof-of-origin tokens for full-quality youtube formats
      bgutil-pot-provider = {
        description = "POT token server for yt-dlp";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        unitConfig.ConditionUser = user;
        serviceConfig = {
          ExecStart = lib.getExe pkgs.python3Packages.bgutil-ytdlp-pot-provider;
          Restart = "on-failure";
        };
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
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = requirePackages [ [ "xdg-desktop-portal-gtk" ] ];
    config.mahogany = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
      "org.freedesktop.impl.portal.Inhibit" = "none";
    };
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
        [ "wl-clip-persist" ]
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
      ++ [
        (
          let
            sanitize = true;
          in
          pkgs.callPackage ./mahogany.nix {
            inherit sanitize;
            # localSrc = /. + "${home}/code/mahogany/mahogany";
            # localRev = null;
            patches = /. + "${home}/code/mahogany/patches";
            patchesOnly = [ ];
            patchesExcept = [ ];
            skipInitFile = false;
            runTests = true;
            wlroots_0_20 = pkgs.callPackage ./wlroots.nix {
              wlroots = pkgs.wlroots_0_20;
              inherit sanitize;
              trace = true;
              patches = /. + "${home}/code/mahogany/wlroots_patches";
              patchesOnly = [ ];
              patchesExcept = [ ];
            };
          }
        )
      ]
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
