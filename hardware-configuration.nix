# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_1.override {
  #   argsOverride = rec {
  #     src = pkgs.fetchurl {
  #       url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
  #       sha256 = "/tCth9Qvg6cM4Bn/KAC8MKhV5nLnK/bVSgFNmNNE9mU=";
  #     };
  #     version = "6.2.8";
  #     modDirVersion = "6.2.8";
  #   };
  # });
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_testing;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" "i2c-dev" "i2c-piix4" "hid-playstasion" "v4l2loopback" ];
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];

  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "ntfs" "cifs" ];


  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/1877725c-b780-4b31-8304-0c8a17ac975b";
      fsType = "ext4";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/1725d93d-59b7-4795-a27e-678706b0adf4";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/C51D-9D51";
      fsType = "vfat";
    };

  fileSystems."/win" =
    {
      device = "/dev/disk/by-uuid/92BEF8A5BEF88351";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

  swapDevices = [ {
    device = "/swapfile";
    size = 8*1024;
  } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp10s0.wakeOnLan.enable = true;
  # networking.interfaces.br-320b4711a30e.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp10s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.vboxnet0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp9s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;

}
