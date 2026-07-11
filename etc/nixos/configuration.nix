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

    acpid.enable = true;
    dbus.enable = true;
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
      extraFlags =
        lib.throwIf (lib.versionAtLeast pkgs.syncthing.version "2.0.16")
          (Color yellow "syncthing ${pkgs.syncthing.version} updates config to v52, remove --allow-newer-config from configuration.nix!")
          [ "--allow-newer-config" ];
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
              "/.ssh" = { };
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
      lib.throwIf (lib.versionAtLeast pkgs.systemd.version "260.3")
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

  # fixes transmission not being able to read/write anything except its download/incomplete/config folders
  systemd.services.transmission.serviceConfig.BindPaths = [
    "/home/lucas"
  ];

  systemd.user.services.mpd = {
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
    shells = [
      pkgs.dash
      pkgs.fish
    ];
    systemPackages = requirePackages [
      # TODO(LucasTA): readd when they fix this upstream
      # [ "snes9x-gtk" ]
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
      [ "bluez-alsa" ]
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
      [
        "gst_all_1"
        "gstreamer"
      ]
      [ "gtk3" ]
      [ "gtkspell3" ]
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
      [
        "kdePackages"
        "kwayland"
      ]
      [ "keepassxc" ]
      [ "libarchive" ]
      [ "libnotify" ]
      [ "libreoffice" ]
      [ "libtool" ]
      [ "libvdpau-va-gl" ]
      [ "libvirt" ]
      [ "libwebp" ]
      [
        "llvmPackages_18"
        "clang"
      ]
      [
        "llvmPackages_18"
        "clang-tools"
      ]
      [
        "llvmPackages_18"
        "lld"
      ]
      [
        "llvmPackages_18"
        "llvm"
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
      [
        "mpvScripts"
        "mpris"
      ]
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
      [ "openjdk17" ]
      [ "openjdk21" ]
      [ "openjdk25" ]
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
        "adblock"
      ]
      [
        "python3Packages"
        "brotli"
      ]
      [
        "python3Packages"
        "evdev"
      ]
      [
        "python3Packages"
        "flake8"
      ]
      [
        "python3Packages"
        "pip"
      ]
      [
        "python3Packages"
        "pyclip"
      ]
      [
        "python3Packages"
        "pynvim"
      ]
      [
        "python3Packages"
        "websockets"
      ]
      [
        "python3Packages"
        "wheel"
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
      [ "seatd" ]
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
      [ "typescript" ]
      [ "typescript-language-server" ]
      [ "typioca" ]
      [ "ueberzugpp" ]
      [ "unar" ]
      [ "unrar" ]
      [ "valgrind" ]
      [ "vlc" ]
      [ "vscode-css-languageserver" ]
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
      [ "xf86inputjoystick" ]
      [ "xf86inputsynaptics" ]
      [ "xf86videoamdgpu" ]
      [ "xf86videoati" ]
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
    # combined so every SDK is visible to a single bin/dotnet
    ++ [
      (with pkgs.dotnetCorePackages;
        combinePackages [
          sdk_8_0
          sdk_9_0
          sdk_10_0
        ])
    ];
  };
}
