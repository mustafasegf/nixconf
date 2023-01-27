{ hardware, pkgs, upkgs, llvm15pkgs, ... }: {

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = pkgs.lib.mkForce true;
  };

  hardware.opengl.package =
    (upkgs.mesa.override {
      llvmPackages = llvm15pkgs.llvmPackages_15;
      enableOpenCL = false;
    }).drivers;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  sound.enable = true;
}
