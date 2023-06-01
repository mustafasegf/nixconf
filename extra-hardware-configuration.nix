{ hardware
, pkgs
, upkgs
, lib
  # , mesa-git-src
, staging-next
, ...
}:
let
  # # future = staging-next.legacyPackages.${pkgs.system};
  # future = pkgs;
  #
  #
  # mesaGitApplier = base: base.mesa.overrideAttrs (fa: {
  #   version = "23.0.99";
  #   src = mesa-git-src;
  #   buildInputs = fa.buildInputs ++ [ base.zstd base.libunwind base.lm_sensors ];
  #   mesonFlags = lib.lists.remove "-Dgallium-rusticl=true" fa.mesonFlags; # fails to find "valgrind.h" with 23.0+ codebase
  # });
  #
  # mesa-bleeding = mesaGitApplier future;
  # lib32-mesa-bleeding = mesaGitApplier future.pkgsi686Linux;
in
{

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = pkgs.lib.mkForce true;
  };


  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    # mesaPackage = upkgs.mesa_23;
    # mesaPackage32 = upkgs.pkgsi686Linux.mesa_23;
    package = upkgs.mesa.drivers;
    package32 = upkgs.pkgsi686Linux.mesa.drivers;
    extraPackages = [ upkgs.mesa.opencl ];
  };

  # Creates a second boot entry without latest drivers
  # specialisation.stable-mesa.configuration = {
  #   system.nixos.tags = [ "mesa-22" ];
  #   hardware.opengl = {
  #     enable = true;
  #     driSupport32Bit = true;
  #     mesaPackage = upkgs.mesa_22.drivers;
  #     mesaPackage32 = upkgs.pkgsi686Linux.mesa_22;
  #     extraPackages = [ upkgs.mesa_22.opencl ];
  #   };
  # };

  sound.enable = true;

  # network
  networking.firewall.enable = false;
  networking.hostName = "mustafa-pc"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
}

