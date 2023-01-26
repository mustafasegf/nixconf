{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/aa1d74709f5dac623adb4d48fdfb27cc2c92a4d4";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    llvm15 = {
      url = "github:rrbutani/nixpkgs/feature/llvm-15";
      # flake = false;
    };
  };

  outputs = { self, llvm15, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      upkgs = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      lib = nixpkgs.lib;
    in
    {
      homeConfigurations = {
        "mustafa" = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "mustafa";
          homeDirectory = "/home/mustafa";
          configuration = {
            imports = [
              ./home.nix
            ];
          };
        };
      };

      nixosConfigurations = {
        mustafa-pc = lib.nixosSystem {
          inherit system;

          modules = [
            (import ./hardware-configuration.nix)
            (import ./configuration.nix)
            # (import ./qtile.nix)
            (import ./penrose.nix)
            ({ config, pkgs, ... }: {

              system.stateVersion = "22.11";

              #hardware

              hardware.bluetooth = {
                enable = true;
                powerOnBoot = pkgs.lib.mkForce true;
              };

              hardware.opengl.package =
                (upkgs.mesa.override {
                  llvmPackages = llvm15.legacyPackages."${system}".llvmPackages_15;
                  enableOpenCL = false;
                }).drivers;

              hardware.opengl = {
                enable = true;
                driSupport32Bit = true;
              };
              # hardware.opengl.package =
              #   nixpkgs-unstable.legacyPackages.x86_64-linux.mesa.override {
              #     llvmPackages = llvm15.legacyPackages.x86_64-linux.llvmPackages_15;
              #     enableOpenCL = false;
              #   };

              # let
              #   staging-next = import
              #     (builtins.fetchTarball {
              #       url = "https://github.com/nixos/nixpkgs/tarball/staging-next";
              #       sha256 = "06fp8hxrg4r9slslcvds4qflkmi42is1vkcnv00srdqax9qkj0p1";
              #     })
              #     {
              #       config = config.nixpkgs.config;
              #     };
              #   llvm15 = import
              #     (builtins.fetchTarball {
              #       url = "https://github.com/rrbutani/nixpkgs/tarball/feature/llvm-15";
              #       sha256 = "05yhljmjw3iw7pmj4nvjvlh3sfmg0d993x54bbcs5wm30qflnxk8";
              #     })
              #     {
              #       config = config.nixpkgs.config;
              #     };
              # in
              # (staging-next.mesa.override {
              #   llvmPackages = llvm15.llvmPackages_15;
              #   enableOpenCL = false;
              # }).drivers;

              sound.enable = true;

              # Use the systemd-boot EFI boot loader.
              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;
              boot.loader.grub.device = "nodev";
              boot.loader.grub.efiSupport = true;

              boot.kernelPackages = pkgs.linuxPackages_latest;
              boot.initrd.kernelModules = [ "amdgpu" ];
              boot.kernelModules = [ "i2c-dev" "i2c-piix4" "hid-playstasion" "v4l2loopback" ];
              boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "ntfs" "cifs" ];

              boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];

              # localization
              time.timeZone = "Asia/Jakarta";

              i18n.defaultLocale = "en_US.UTF-8";
              i18n.extraLocaleSettings = {
                LC_ADDRESS = "id_ID.utf8";
                LC_IDENTIFICATION = "id_ID.utf8";
                LC_MEASUREMENT = "id_ID.utf8";
                LC_MONETARY = "id_ID.utf8";
                LC_NAME = "id_ID.utf8";
                LC_NUMERIC = "id_ID.utf8";
                LC_PAPER = "id_ID.utf8";
                LC_TELEPHONE = "id_ID.utf8";
                LC_TIME = "id_ID.utf8";
              };

              # font
              fonts.fonts = with pkgs; [
                noto-fonts
                noto-fonts-cjk
                noto-fonts-emoji
                liberation_ttf
                fira-code
                fira-code-symbols
                mplus-outline-fonts.githubRelease
                dina-font
                proggyfonts
                ibm-plex
                nerdfonts
              ];

              console = {
                font = "Lat2-Terminus16";
                useXkbConfig = true; # use xkbOptions in tty.
              };

              xdg = {
                portal = {
                  enable = true;
                  extraPortals = with pkgs; [
                    xdg-desktop-portal-wlr
                    xdg-desktop-portal-gtk
                  ];
                  # gtkUsePortal = true;
                };
              };


              # nixpkgs
              nixpkgs.config.permittedInsecurePackages = [
                "python-2.7.18.6"
              ];

              nixpkgs.overlays = [
                (self: super: {
                  nix-direnv = super.nix-direnv.override {
                    enableFlakes = true;
                  };
                })
              ];
              nixpkgs.config.allowUnfree = true;

              # nix 
              nix.settings = {
                keep-outputs = true;
                keep-derivations = true;
                experimental-features = [ "nix-command" "flakes" ];
              };

              # environment
              environment.pathsToLink = [
                "/share/nix-direnv"
              ];

              environment.variables = {
                SUDO_EDITOR = "neovim";
                EDITOR = "neovim";
                VISUAL = "neovim";
                PAGER = "less";
                BROWSER = "google-chrome-stable";
                QT_QPA_PLATFORMTHEME = "qt5ct";
                MANPAGER = "nvim +Man!";
              };

              environment.systemPackages = with pkgs; [
                vim

                neovim
                vscode-fhs
                # (vscode-with-extensions.override {
                #   vscodeExtensions = with vscode-extensions; [
                #
                #   ];
                # })

                wget
                glxinfo

                kitty
                zsh
                oh-my-zsh
                fzf
                fzf-zsh

                zip
                unzip
                bind
                bat
                btop
                blueman
                dunst
                gh
                htop
                input-remapper
                lf
                lsd
                neofetch
                picom
                rofi
                starship
                arandr
                awscli2
                copyq
                cloc
                dbeaver
                dos2unix
                fd
                ffmpeg_5-full
                ffmpegthumbnailer
                find-cursor
                flameshot
                gdu
                git-annex
                glab
                google-cloud-sdk
                gromit-mpx
                handbrake
                httpie
                inxi
                jq
                man
                nitrogen
                nmap
                notion-app-enhanced
                nvtop
                obs-studio
                p7zip
                pinta
                postman
                qpwgraph
                libsForQt5.qt5ct
                radeontop
                scrcpy
                speedtest-cli
                trashy
                wine
                wine64
                winetricks
                wireplumber
                x11vnc
                xclip
                xcolor
                youtube-dl
                yt-dlp
                (
                  let
                    packagePypi = name: ver: ref: deps: python39.pkgs.buildPythonPackage rec {
                      pname = "${lib.strings.sanitizeDerivationName name}";
                      version = ver;

                      src = python39.pkgs.fetchPypi {
                        inherit pname version;
                        hash = ref;
                      };

                      buildInputs = deps;
                      doCheck = false;
                    };
                  in
                  python39.withPackages (ps: [
                    # (
                    #   packagePypi
                    #     "iwlib"
                    #     "1.7.0"
                    #     "sha256-qAX2WXpw7jABq6jwOft7Lct13BXE54UvVZT9Y3kZbaE="
                    #     [ ps.cffi ]
                    # )
                  ])
                )
                poetry
                rustup
                go
                gofumpt
                nodejs-16_x
                nodePackages.npm
                nodePackages.pnpm
                nodePackages.sass
                git
                docker
                pavucontrol
                ncpamixer
                pulseaudioFull
                slack
                zoom-us
                tdesktop
                google-chrome
                thunderbird
                alsa-utils
                pulseaudio-ctl
                home-manager
                openrgb
                discord
                killall
                libnotify
                noisetorch
                statix
                tmux
                terraform
                clang
                clang-tools

                black
                stylua
                gofumpt
                gotools
                ##terrafmt
                shfmt
                ##fourmolu

                gopls
                nodePackages.pyright
                nodePackages.typescript-language-server
                tflint
                ##yamlls
                ##vimls
                texlab
                nodePackages.vscode-langservers-extracted
                ##emmet-ls
                nodePackages_latest.tailwindcss
                taplo
                nodePackages.graphql-language-service-cli
                sqls
                ##jdtls
                nodePackages.svelte-language-server
                ##astro
                ##prisma
                ##jsonls
                sumneko-lua-language-server
                nodePackages.diagnostic-languageserver
                nodePackages.bash-language-server

                kdeconnect
                rnix-lsp
                xfce.thunar
                xfce.thunar-volman
                xfce.thunar-archive-plugin
                gvfs
                udisks
                usermount
                gnumake
                lazygit
                air
                most
                ripgrep
                steam
                rescuetime
                tailscale
                libsecret
                dbeaver
                beekeeper-studio
                (appimage-run.override {
                  extraPkgs = pkgs: [ pkgs.xorg.libxshmfence pkgs.libsecret ];
                })

                jdk11
                rclone

                llvmPackages_latest.llvm
                llvmPackages_latest.bintools
                zlib.out
                xorriso
                grub2
                qemu
                llvmPackages_latest.lld
                SDL2
                SDL2_ttf
                SDL2_net
                SDL2_gfx
                SDL2_sound
                SDL2_mixer
                SDL2_image
                radare2
                # iaito
                minecraft
                virtualbox
                virt-manager
                qemu_full
                libreoffice
                gcc
                gdb
                gnome.gedit
                libsForQt5.kate
                screenkey
                k6
                direnv
                nix-direnv
                pciutils
                usbutils
                uwufetch
                webcamoid
                glade
                man-pages
                man-pages-posix
                # unstable.soundux
                fwupd
                prismlauncher
                gnome.seahorse
                xorg.xkbcomp
                xorg.xkbutils
                xorg.xmodmap
                xorg.xinput
                xorg.libX11
                xorg.libXft
                xorg.libXinerama

                clang-tools
                clang
                pkg-config
                gtk3
                gtk4
                vlc
                mpv
                psmisc
                hello
              ];

              # network

              networking.firewall.enable = false;
              networking.hostName = "mustafa-pc"; # Define your hostname.
              networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

              # services        
              services.dbus.packages = with pkgs; [ dconf gnome3.gnome-keyring ];
              services.hardware.openrgb = {
                enable = true;
                motherboard = "amd";
              };
              services.udisks2.enable = true;
              services.tailscale.enable = true;
              services.printing.enable = true;

              services.blueman.enable = true;
              services.picom.enable = true;

              programs.noisetorch.enable = true;
              programs.dconf.enable = true;

              # security
              security.rtkit.enable = true;
              security.sudo.configFile = ''
                mustafa ALL = NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/poweroff
              '';

              services.gnome.gnome-keyring.enable = true;
              services.openssh.enable = true;

              services.xserver = {
                enable = true;
                digimend.enable = true;
                videoDrivers = [ "modesetting" ];
                # videoDrivers = [ "amdgpu" ];

                autorun = true;
                displayManager = {
                  # defaultSession = "none+qtile";
                  # defaultSession = "none+dwm";
                  # startx.enable = true;

                  defaultSession = "none+qtile";
                  # session = [
                  #   {
                  #     manage = "window";
                  #     name = "penrose";
                  #     # start = ''exec /home/mustafa/project/penrose-wm/result/bin/penrose_wm'';
                  #     start = ''exec /home/mustafa/project/penrose-wm/target/release/penrose-wm'';
                  #   }
                  # ];

                  lightdm = {
                    # enable = false;
                    enable = true;
                    greeter.enable = true;
                  };
                  sessionCommands =
                    let
                      functionkey = pkgs.writeText "xkb-layout" ''
                        keycode 191 = F13 F13 F13
                        keycode 192 = F14 F14 F14
                        keycode 193 = F15 F15 F15
                        keycode 194 = F16 F16 F16
                        keycode 195 = F17 F17 F17
                        keycode 196 = F18 F18 F18
                        keycode 197 = F19 F19 F19
                        keycode 198 = F20 F20 F20
                        keycode 199 = F21 F21 F21
                        keycode 200 = F22 F22 F22
                        keycode 201 = F23 F23 F23
                        keycode 202 = F24 F24 F24
                      '';
                    in
                    ''sleep 3 && ${pkgs.xorg.xmodmap}/bin/xmodmap ${functionkey} &&
                    gnome-keyring-daemon --start -d --components=pkcs11,secrets,ssh
                    '';
                };

                windowManager = {
                  qtile = {
                    enable = true;
                    # extraSessionCommands = "gnome-keyring-daemon --start -d --components=pkcs11,secrets,ssh";
                    # backend = "x11";
                    # configFile = ./qtile/config.py;
                  };

                  penrose = {
                    enable = true;
                    path = ''/home/mustafa/project/penrose-wm/target/release/penrose-wm'';
                  };

                  # dwm = {
                  #   enable = true;
                  #   package = pkgs.dwm.overrideAttrs (old: rec {
                  #     src = builtins.path { path = "${config.users.users.mustafa.home}/project/dwm"; };
                  #   });
                  # };
                };
              };

              services.pipewire = {
                media-session.config.bluez-monitor.rules = [
                  {
                    # Matches all cards
                    matches = [{ "device.name" = "~bluez_card.*"; }];
                    actions = {
                      "update-props" = {
                        "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                        # mSBC is not expected to work on all headset + adapter combinations.
                        "bluez5.msbc-support" = true;
                        # SBC-XQ is not expected to work on all headset + adapter combinations.
                        "bluez5.sbc-xq-support" = true;
                      };
                    };
                  }
                  {
                    matches = [
                      # Matches all sources
                      { "node.name" = "~bluez_input.*"; }
                      # Matches all outputs
                      { "node.name" = "~bluez_output.*"; }
                    ];
                  }
                ];

                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;
              };

              systemd.services.tailscale-autoconnect = {
                description = "Automatic connection to Tailscale";

                # make sure tailscale is running before trying to connect to tailscale
                after = [ "network-pre.target" "tailscale.service" ];
                wants = [ "network-pre.target" "tailscale.service" ];
                wantedBy = [ "multi-user.target" ];

                # set this service as a oneshot job
                serviceConfig.Type = "oneshot";

                # have the job run this shell script
                script = with pkgs; ''
                  # wait for tailscaled to settle
                  sleep 2

                  # check if we are already authenticated to tailscale
                  status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
                  if [ $status = "Running" ]; then # if so, then do nothing
                    exit 0
                  fi

                  # otherwise authenticate with tailscale
                  ${tailscale}/bin/tailscale up
                '';
              };

              # documentation
              documentation.man.generateCaches = true;
              documentation.dev.enable = true;

              # virtualisation

              virtualisation = {
                docker.enable = true;
                virtualbox.host = {
                  enable = false;
                  enableExtensionPack = true;
                };
                libvirtd.enable = true;
              };

              # user

              users.defaultUserShell = pkgs.zsh;
              users.extraGroups.vboxusers.members = [ "mustafa" ];

              users.users.mustafa = {
                shell = pkgs.zsh;
                isNormalUser = true;
                extraGroups = [ "wheel" "networkmanager" "rtkit" "media" "audio" "sys" "wireshark" "rfkill" "video" "uucp" "docker" "vboxusers" "libvirtd" ];
                # openssh.authorizedKeys.keyFiles = [ "${config.users.users.mustafa.home}/.ssh/id_ed25519.pub" ];
              };

            })
          ];



          # modules = [
          #
          #   (import ./configuration.nix)
          #   home-manager.nixosModules.home-manager
          #   {
          #     home-manager.useGlobalPkgs = true;
          #   }
          # ];
        };
      };
    };
}
