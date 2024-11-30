{
  description = "My NixOS Flake Configuration";
  inputs = {
    nixpkgs-prev.url = "github:NixOS/nixpkgs/release-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    staging-next.url = "github:NixOS/nixpkgs/staging-next";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    # nixpkgs-master.url = "git+ssh://git@github.com/NixOS/nixpkgs.git";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    firefox.url = "github:nix-community/flake-firefox-nightly";

    flake-parts.url = "github:hercules-ci/flake-parts";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-prev, staging-next
    , nixpkgs-master, firefox
    # , mesa-git-src
    , home-manager, nix-ld, nix-index-database, ... }@inputs:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          # rocmSupport = true;
          allowUnfree = true;
          permittedInsecurePackages = [ "python-2.7.18.6" "nix-2.16.2" ];
        };
      };

      upkgs = import nixpkgs-unstable {
        inherit system;
        config = {
          # rocmSupport = true;
          allowunfree = true;
        };
      };

      ppkgs = import nixpkgs-prev {
        inherit system;
        config = {
          # rocmSupport = true;
          allowunfree = true;
        };
      };

      staging-pkgs = import staging-next {
        inherit system;
        config = {
          # rocmSupport = true;
          allowunfree = true;
        };
      };

      mpkgs = import nixpkgs-master {
        inherit system;
        config = {
          # rocmSupport = true;
          allowunfree = true;
        };
      };

      # firefoxpkgs = import firefox {
      #   inherit system;
      #   config = {
      #     allowUnfree = true;
      #   };
      # };

      lib = nixpkgs.lib;
    in rec {
      inputs.pkgs = pkgs;
      inputs.upkgs = upkgs;
      inputs.ppkgs = ppkgs;
      inputs.staging-pkgs = staging-pkgs;
      inputs.mpkgs = mpkgs;
      inputs.lib = lib;
      inputs.staging-next = staging-next;
      # inputs.firefoxpkgs = firefoxpkgs;
      # inputs.mesa-git-src = mesa-git-src;

      nixosConfigurations = {
        mustafa-pc = lib.nixosSystem {
          inherit system;

          modules = [
            ./hardware-configuration.nix
            ./qtile/qtile.nix
            ./penrose.nix
            (import ./extra-hardware-configuration.nix
              (inputs // { inherit (self) hardware; }))
            nix-index-database.nixosModules.nix-index
            nix-ld.nixosModules.nix-ld
            ({ config, ... }: {

              system.stateVersion = "22.11";

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
              fonts.packages = with pkgs; [
                noto-fonts
                noto-fonts-cjk-sans
                noto-fonts-emoji
                liberation_ttf
                fira-code
                fira-code-symbols
                mplus-outline-fonts.githubRelease
                dina-font
                proggyfonts
                ibm-plex
                nerd-fonts.blex-mono
              ];

              console = {
                font = "Lat2-Terminus16";
                useXkbConfig = true; # use xkbOptions in tty.
              };

              qt = {
                enable = true;
                platformTheme = "lxqt";
                style = "adwaita-dark";
              };

              xdg = {
                mime.enable = true;
                portal = {
                  enable = true;
                  xdgOpenUsePortal = true;
                  lxqt.styles = with pkgs;
                    [ pkgs.libsForQt5.qtstyleplugin-kvantum ];
                  config.common.default = "*";
                  lxqt.enable = true;
                  extraPortals = with pkgs;
                    [
                      #   xdg-desktop-portal-wlr
                      xdg-desktop-portal-gtk
                      #   xdg-desktop-portal
                      #   # xdg-desktop-portal-gnome
                      # libsForQt5.xdg-desktop-portal-kde
                      #   lxqt.xdg-desktop-portal-lxqt
                    ];
                };
              };

              # nixpkgs
              nixpkgs.overlays = [
                (self: super: {
                  nix-direnv =
                    super.nix-direnv.override { enableFlakes = true; };
                })
              ];

              # nix 
              nix.settings = {
                keep-outputs = true;
                keep-derivations = true;
                experimental-features = [ "nix-command" "flakes" ];
                # substituters = [ "https://cache.komunix.org/" ];
                substituters = lib.mkForce [ "https://cache.nixos.org" ];
                fallback = true;
                trusted-users = [ "root" "mustafa" "@wheel" ];
                # trusted-substituters = [ "https://devenv.cachix.org" ];
                # trusted-public-keys = [
                #   "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
                # ];
              };

              # nix.extraOptions = ''
              #   extra-trusted-substituters = https://devenv.cachix.org;
              #   extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=;
              # '';

              # environment
              environment.pathsToLink = [ "/share/nix-direnv" ];

              environment.variables = {
                SUDO_EDITOR = "nvim";
                EDITOR = "nvim";
                VISUAL = "nvim";
                PAGER = "less";
                BROWSER = "google-chrome-stable";
                # QT_QPA_PLATFORMTHEME = "qt5ct";
                QT_QPA_PLATFORMTHEME = "lxqt";
                GTK_USE_PORTAL = "1";
                MANPAGER = "nvim +Man!";
                TERMINAL = "kitty";
                GDK_SCALE = "1";
              };

              environment.systemPackages = (import ./packages inputs).packages
                ++ [ firefox.packages.${system}.firefox-nightly-bin ];
              environment.shellAliases =
                (import ./packages inputs).shellAliases;
              environment.etc."X11/xorg.conf.d/10-tablet.conf".source =
                pkgs.writeText "10-tablet.conf" ''
                  Section "InputClass"
                  Identifier "Tablet"
                  Driver "wacom"
                  MatchDevicePath "/dev/input/event*"
                  MatchUSBID "256c:006d"
                  EndSection
                '';

              # services        
              services.dbus.packages = with pkgs; [
                dconf
                gnome-keyring
              ];

              services.hardware.openrgb = {
                enable = true;
                motherboard = "amd";
              };

              services.udisks2.enable = true;
              services.tailscale.enable = true;
              services.printing.enable = true;

              services.blueman.enable = true;
              services.picom.enable = false;

              services.tumbler.enable = true;
              services.gvfs.enable = true;
              services.flatpak.enable = true;

              programs.wireshark.enable = true;

              programs.thunar.enable = true;
              programs.thunar.plugins = with pkgs.xfce; [
                thunar-volman
                thunar-archive-plugin
                thunar-media-tags-plugin
              ];

              programs.noisetorch.enable = true;
              programs.dconf.enable = true;
              programs.zsh.enable = true;
              programs.nix-ld.dev.enable = true;

              programs.adb.enable = true;
              # programs.openvpn3.enable = true;

              environment.extraInit = ''
                # Do not want this in the environment. NixOS always sets it and does not
                # provide any option not to, so I must unset it myself via the
                # environment.extraInit option.
                unset -v SSH_ASKPASS
              '';

              programs.nix-ld.libraries = with pkgs; [
                stdenv.cc.cc
                zlib
                fuse3
                icu
                zlib
                nss
                openssl
                curl
                expat

                xorg.libXcursor
                xorg.libXrandr
                xorg.libXi
                xorg.libX11

              ];

              programs.command-not-found.enable = false;

              # security
              security.rtkit.enable = true;
              security.sudo.configFile = ''
                mustafa ALL = NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/poweroff
              '';

              security.polkit.extraConfig = ''
                polkit.addRule(function(action, subject) {
                  if (
                    subject.isInGroup("users")
                      && (
                        action.id == "org.freedesktop.login1.reboot" ||
                        action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                        action.id == "org.freedesktop.login1.power-off" ||
                        action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                      )
                    )
                  {
                    return polkit.Result.YES;
                  }
                })
              '';

              services.gnome.gnome-keyring.enable = true;
              services.openssh.enable = true;

              # services.cloudflare-warp = {
              #   enable = true;
              # };

              services.openvpn.servers = {
                uihpc = {
                  config = "config /home/mustafa/openvpn/hpc12.ovpn ";
                };
              };

              services.xserver = {
                enable = true;
                digimend.enable = false; # idk why error 
                wacom.enable = true;
                videoDrivers = [ "modesetting" ];
                # videoDrivers = [ "amdgpu" ];

                autorun = true;
                displayManager = {
                  # defaultSession = "none+qtile";
                  defaultSession = "none+qtile";
                  lightdm = {
                    enable = true;
                    greeter.enable = true;
                  };
                  sessionCommands = let
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
                  in ''
                    sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap ${functionkey}
                    # gnome-keyring-daemon --start -d --components=pkcs11,secrets,ssh
                  '';

                };

                windowManager = {
                  qtile = {
                    enable = true;
                    package = ppkgs.qtile;
                    extraSessionCommands =
                      "gnome-keyring-daemon --start -d --components=pkcs11,secrets,ssh";
                    backend = "x11";
                    # configFile = ./qtile/config.py;
                  };

                  penrose = {
                    enable = false;
                    path =
                      "/home/mustafa/project/penrose-wm/target/release/penrose-wm";
                  };

                  i3 = {
                    enable = false;
                    extraPackages = with pkgs; [
                      i3status # gives you the default i3 status bar
                      i3blocks # if you are planning on using i3blocks over i3status
                      i3lock # default i3 screen locker
                    ];
                  };

                };
              };

              services.tor = {
                enable = true;
                # settings = {
                #   UseBridges = true;
                #   ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
                #   Bridge = "obfs4 IP:ORPort [fingerprint]";
                # };
                client.enable = true;
              };

              services.pipewire = {
                wireplumber.enable = true;
                # media-session.config.bluez-monitor.rules = [
                #   {
                #     # Matches all cards
                #     matches = [{ "device.name" = "~bluez_card.*"; }];
                #     actions = {
                #       "update-props" = {
                #         "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                #         # mSBC is not expected to work on all headset + adapter combinations.
                #         "bluez5.msbc-support" = true;
                #         # SBC-XQ is not expected to work on all headset + adapter combinations.
                #         "bluez5.sbc-xq-support" = true;
                #       };
                #     };
                #   }
                #   {
                #     matches = [
                #       # Matches all sources
                #       { "node.name" = "~bluez_input.*"; }
                #       # Matches all outputs
                #       { "node.name" = "~bluez_output.*"; }
                #     ];
                #   }
                # ];

                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;
              };

              services.zerotierone = {
                package = pkgs.zerotierone;
                enable = true;
                joinNetworks = [ ];
              };

              systemd.services.NetworkManager-wait-online.enable = false;

              # systemd.tmpfiles.rules = [
              #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
              # ];

              # Enable xrdp
              services.xrdp.enable = true; # use remote_logout and remote_unlock
              services.xrdp.defaultWindowManager =
                "{ppkgs.qtile}/bin/qtile -b start x11";
              services.xrdp.openFirewall = true;

              systemd.services.pcscd.enable = false;
              systemd.sockets.pcscd.enable = false;
              systemd = {
                user.services.polkit-gnome-authentication-agent-1 = {
                  description = "polkit-gnome-authentication-agent-1";
                  wantedBy = [ "graphical-session.target" ];
                  wants = [ "graphical-session.target" ];
                  after = [ "graphical-session.target" ];
                  serviceConfig = {
                    Type = "simple";
                    ExecStart =
                      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                    Restart = "on-failure";
                    RestartSec = 1;
                    TimeoutStopSec = 10;
                  };
                };
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

              systemd.services."libvirt-nosleep@" = {
                enable = true;
                description =
                  ''Preventing sleep while libvirt domain "%i" is running'';

                serviceConfig = {
                  Type = "simple";
                  ExecStart = ''
                    ${pkgs.systemd}/bin/systemd-inhibit --what=sleep --why=" Libvirt domain \"%i\" is running" --who=%U --mode=block sleep infinity'';

                };
              };

              systemd.services.libvirtd = {
                enable = true;
                path = let
                  env = pkgs.buildEnv {
                    name = "qemu-hook-env";
                    paths = with pkgs; [
                      bash
                      libvirt
                      kmod
                      systemd
                      ripgrep
                      sd
                      pciutils
                      procps
                      gawk

                    ];
                  };
                in [ env ];

                # preStart =
                #   ''
                #     mkdir -p /var/lib/libvirt/hooks
                #     mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin
                #     mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/release/end
                #     mkdir -p /var/lib/libvirt/vgabios
                #     ln -sf /home/mustafa/.config/qemu/qemu /var/lib/libvirt/hooks/qemu
                #     ln -sf /home/mustafa/.config/qemu/kvm.conf /var/lib/libvirt/hooks/kvm.conf
                #     ln -sf /home/mustafa/.config/qemu/start.sh /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
                #     ln -sf /home/mustafa/.config/qemu/stop.sh /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh
                #     # ln -sf /home/mustafa/.config/qemu/patched.rom /var/lib/libvirt/vgabios/patched.rom
                #     chmod +x /var/lib/libvirt/hooks/qemu
                #     chmod +x /var/lib/libvirt/hooks/kvm.conf
                #     chmod +x /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
                #     chmod +x /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh
                #   '';
              };

              # documentation
              documentation.man.generateCaches = true;
              documentation.dev.enable = true;

              # virtualisation

              virtualisation = {
                docker = {
                  enable = true;
                  # package = (ppkgs.docker.override {
                  #   # docker-compose = ppkgs.docker-compose;
                  # });
                  daemon.settings = {
                    debug = true;
                    metrics-addr = "0.0.0.0:9323";
                    default-address-pools = [
                      {
                        base = "172.17.0.0/12";
                        size = 24;
                      }
                      {
                        base = "192.168.0.0/16";
                        size = 24;
                      }
                    ];
                  };
                };
                virtualbox.host = {
                  enable = false;
                  enableExtensionPack = true;
                };
                libvirtd = {
                  enable = true;
                  onBoot = "ignore";
                  onShutdown = "shutdown";
                  qemu.ovmf.enable = true;
                  qemu.runAsRoot = true;
                };
              };

              systemd.services.warp-svc.enable = true;
              systemd.packages = with pkgs; [ cloudflare-warp ];

              # user

              users.defaultUserShell = pkgs.zsh;
              users.extraGroups.vboxusers.members = [ "mustafa" ];

              users.users.mustafa = {
                shell = pkgs.zsh;
                isNormalUser = true;
                extraGroups = [
                  "wheel"
                  "networkmanager"
                  "rtkit"
                  "media"
                  "audio"
                  "sys"
                  "wireshark"
                  "rfkill"
                  "video"
                  "uucp"
                  "docker"
                  "vboxusers"
                  "libvirtd"
                  "render"
                  "adbusers"
                ];
                openssh.authorizedKeys.keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNEKM6YnhuLcLfy5FkCt+rX1M10vMS00zynI6tsta1s mustafa.segf@gmail.com"
                ];
              };

            })

            home-manager.nixosModules.home-manager
            { home-manager.users.mustafa = (import ./home.nix inputs); }
          ];
        };
      };
    };
}
