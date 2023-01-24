{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/aa1d74709f5dac623adb4d48fdfb27cc2c92a4d4";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        mustafa-pc = lib.nixosSystem
          {
            inherit system;
            modules = [


              # Use the systemd-boot EFI boot loader.
              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;
              boot.loader.grub.device = "nodev";
              boot.loader.grub.efiSupport = true;

              boot.kernelPackages = pkgs.linuxPackages_latest;
              boot.initrd.kernelModules = [ "amdgpu" ];
              boot.kernelModules = [ "i2c-dev" "i2c-piix4" "hid-playstasion" "v4l2loopback" ];
              boot.supportedFilesystems = lib.mkForce
              [ "btrfs" "reiserfs" "vfat" "f2fs" "ntfs" "cifs" ];

              boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];

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

              # services        
              services.hardware.openrgb = {
              enable = true;
              motherboard = "amd";
            };
              services.udisks2.enable = true;
              services.tailscale.enable = true;

              services.gnome = {
              gnome-keyring.enable = true;
            };

              services.xserver = {
              enable = true;
              digimend.enable = true;
              videoDrivers = [ "modesetting" ];
              # videoDrivers = [ "amdgpu" ];
              autorun = true;
              displayManager = {
                # defaultSession = "none+dwm";
                defaultSession = "none+qtile";
                # startx.enable = true;
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
                  "sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap ${functionkey}";
              };

              windowManager = {
                qtile = {
                  enable = true;
                  extraSessionCommands = "gnome-keyring-daemon --start -d --components=pkcs11,secrets,ssh";
                  package = pkgs.qtile;
                  backend = "x11";
                  # configFile = ./qtile/config.py;
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

              # modules = [
              #
              #   (import ./configuration.nix)
              #   home-manager.nixosModules.home-manager
              #   {
              #     home-manager.useGlobalPkgs = true;
              #   }
              # ];
            ];
          };
      };
    };
}
