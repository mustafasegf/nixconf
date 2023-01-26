{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.penrose;
in

{
  options = {
    services.xserver.windowManager.penrose = {
      enable = mkEnableOption "penrose";

      path = mkOption {
        type = types.path;
        example = literalExpression "./penrose-wm";
        description = ''
          Path to the penrose binary.
        '';
      };

      extraSessionCommands = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Shell commands executed just before penrose is started.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = [{
      name = "penrose";
      start = ''
        ${cfg.path} &
        waitPID=$!
      '';
    }];

  };
}
