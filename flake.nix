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
        mustafa-pc = lib.nixosSystem {
          inherit system;


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

          modules = [

            (import ./configuration.nix)
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
            }
          ];
        };
      };
    };
}
