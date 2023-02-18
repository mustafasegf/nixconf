{ hardware, pkgs, upkgs, lib, mesa-git-src, staging-next, ... }:
let
  # future = staging-next.legacyPackages.${pkgs.system};
  future = pkgs;


  mesaGitApplier = base: base.mesa.overrideAttrs (fa: {
    version = "23.0.99";
    src = mesa-git-src;
    buildInputs = fa.buildInputs ++ [ base.zstd base.libunwind base.lm_sensors ];
    mesonFlags = lib.lists.remove "-Dgallium-rusticl=true" fa.mesonFlags; # fails to find "valgrind.h" with 23.0+ codebase
  });

  mesa-bleeding = mesaGitApplier future;
  lib32-mesa-bleeding = mesaGitApplier future.pkgsi686Linux;
in
{

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = pkgs.lib.mkForce true;
  };

  # hardware.opengl = {
  #   package = upkgs.mesa.drivers;
  #   enable = true;
  #   driSupport32Bit = true;
  # };

  hardware.opengl.package = mesa-bleeding.drivers;
  hardware.opengl.package32 = lib32-mesa-bleeding.drivers;
  hardware.opengl.extraPackages = [ mesa-bleeding.opencl ];

  # Creates a second boot entry without latest drivers
  specialisation.stable-mesa.configuration = {
    system.nixos.tags = [ "stable-mesa" ];
    # hardware.opengl.package = lib.mkForce pkgs.mesa.drivers;
    # hardware.opengl.package32 = lib.mkForce pkgs.pkgsi686Linux.mesa.drivers;
    hardware.opengl = {
      package = lib.mkForce upkgs.mesa.drivers;
      enable = true;
      driSupport32Bit = true;
    };
  };

  sound.enable = true;

  # network
  networking.firewall.enable = false;
  networking.hostName = "mustafa-pc"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
}

