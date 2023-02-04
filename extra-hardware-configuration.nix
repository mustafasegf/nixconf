{ hardware, pkgs, upkgs, lib, ... }: {

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = pkgs.lib.mkForce true;
  };

  hardware.opengl = {
    package = upkgs.mesa.drivers;
    enable = true;
    driSupport32Bit = true;
  };

  sound.enable = true;

  # network
  networking.firewall.enable = false;
  networking.hostName = "mustafa-pc"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
}

