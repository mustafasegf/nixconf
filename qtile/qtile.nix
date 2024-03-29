{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.qtile;
  qtile = cfg.package;
in

{
  disabledModules = [ "services/x11/window-managers/qtile.nix" ];

  options = {
    services.xserver.windowManager.qtile = {
      enable = mkEnableOption "qtile";

      package = mkOption {
        type = types.package;
        default = pkgs.qtile;
        defaultText = literalExpression "pkgs.qtile";
        description = ''
          Qtile package to use.
        '';
      };

      configFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = literalExpression "./your_config.py";
        description = ''
          Path to the qtile configuration file.
          If null, $HOME/.config/qtile/config.py will be used.
        '';
      };

      extraSessionCommands = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Shell commands executed just before qtile is started.
        '';
      };

      backend = mkOption {
        type = types.enum [ "x11" "wayland" ];
        default = "x11";
        description = ''
          Backend to use in qtile: 
          <option>x11</option> or <option>wayland</option>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = [{
      name = "qtile";
      start = ''
        ${cfg.extraSessionCommands}
        ${qtile}/bin/qtile start -b ${cfg.backend} \
        ${optionalString (cfg.configFile != null)
        "--config \"${cfg.configFile}\""} &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [ qtile ];
  };
}
