{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/aa1d74709f5dac623adb4d48fdfb27cc2c92a4d4";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    pypi-fetcher.url = "github:DavHau/nix-pypi-fetcher";
    pypi-fetcher.flake = false;
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-ld, pypi-fetcher, home-manager, ... }@inputs:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "python-2.7.18.6"
          ];

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
    rec
    {
      # homeConfigurations = {
      #   "mustafa" = home-manager.lib.homeManagerConfiguration {
      #     inherit system pkgs;
      #     username = "mustafa";
      #     homeDirectory = "/home/mustafa";
      #     configuration = {
      #       imports = [
      #         ./home.nix
      #       ];
      #     };
      #   };
      # };

      inputs.pkgs = pkgs;
      inputs.upkgs = upkgs;
      inputs.lib = lib;
      inputs.nix-ld = nix-ld;
      inputs.pypi-fetcher = pypi-fetcher;

      nixosConfigurations = {
        mustafa-pc = lib.nixosSystem {
          inherit system;

          modules = [
            ./hardware-configuration.nix
            ./qtile/qtile.nix
            ./penrose.nix
            (import ./extra-hardware-configuration.nix (inputs // { inherit (self) hardware; }))
            nix-ld.nixosModules.nix-ld
            ({

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
                    xdg-desktop-portal
                    xdg-desktop-portal-gnome
                    libsForQt5.xdg-desktop-portal-kde
                    lxqt.xdg-desktop-portal-lxqt
                  ];
                  # gtkUsePortal = true;
                };
              };


              # nixpkgs
              nixpkgs.overlays = [
                (self: super: {
                  nix-direnv = super.nix-direnv.override {
                    enableFlakes = true;
                  };
                })
              ];

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
              };

              environment.systemPackages = (import ./packages inputs).packages;


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
                  defaultSession = "none+qtile";
                  lightdm = {
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
                    ''gnome-keyring-daemon --start -d --components=pkcs11,secrets,ssh'';
                };

                windowManager = {
                  qtile = {
                    enable = true;
                    extraSessionCommands = "gnome-keyring-daemon --start -d --components=pkcs11,secrets,ssh";
                    backend = "x11";
                    # configFile = ./qtile/config.py;
                  };

                  penrose = {
                    enable = false;
                    path = ''/home/mustafa/project/penrose-wm/target/release/penrose-wm'';
                  };
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

            home-manager.nixosModules.home-manager
            {
              home-manager.users.mustafa = (import ./home.nix inputs);
            }
          ];
        };
      };
    };
}
