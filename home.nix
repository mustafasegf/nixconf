{ config, pkgs, lib, ... }:

{
  home.username = "mustafa";
  home.homeDirectory = "/home/mustafa";
  home.stateVersion = "22.11";
  programs.bash.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
  services.blueman-applet.enable = true;
  services.easyeffects.enable = true;

  xdg.enable = true;


  ## no program config yet: neofetch glab dunst flameshot
  imports = [
    (import ./programs/btop.nix)
    (import ./programs/kitty.nix)
    (import ./programs/mimeapps.nix)
    (import ./programs/nvim.nix)
    (import ./programs/rofi.nix)
    (import ./programs/tmux.nix)
    (import ./programs/zsh.nix)
  ];

  xdg.configFile."qtile/config.py".source = ./qtile/config.py;
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = false;
    shadow = false;

    fade = true;
    fadeDelta = 4;

    opacityRules = [
      "100:name *= 'Chrome' && focused"
      "95:name *= 'Chrome' && !focused"
      "100:class_g *= 'discord' && focused"
      "95:class_g *= 'discord' && !focused"
      "95:name *= 'Code' && !focused"
      "100:name *= 'Postman' && focused"
      "98:name *= 'Postman' && !focused"
      "85:name *= 'Cisco'"
    ];
  };

  services.gromit-mpx = {
    enable = true;

    tools = [
      {
        device = "default";
        type = "pen";
        size = 3;
      }
      {
        device = "default";
        type = "pen";
        color = "blue";
        size = 3;
        modifiers = [ "SHIFT" ];
      }
      {
        device = "default";
        type = "pen";
        color = "black";
        size = 3;
        modifiers = [ "CONTROL" ];
      }
      {
        device = "default";
        type = "pen";
        color = "white";
        size = 3;
        modifiers = [ "2" ];
      }
      {
        device = "default";
        type = "eraser";
        size = 30;
        modifiers = [ "3" ];
      }
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      tabs = "2";
      style = "plain";
      paging = "never";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      format = "[$symbol$version]($style)[$directory]($style)[$git_branch]($style)[$git_commit]($style)[$git_state]($style)[$git_status]($style)[$line_break]($style)[$username]($style)[$hostname]($style)[$shlvl]($style)[$jobs]($style)[$time]($style)[$status]($style)[$character]($style)";
      line_break.disabled = true;
      cmd_duration.disabled = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✖](bold red)";
        vicmd_symbol = "[❮](bold yellow)";
      };
      package.disabled = true;
    };
  };

  programs.lsd = {
    enable = true;
    enableAliases = false;
    settings = {
      layout = "grid";
      blocks = [ "permission" "user" "group" "date" "size" "name" ];
      color.when = "auto";
      date = "+%d %m(%b) %Y %a";
      recursion = {
        enable = false;
        depth = 7;
      };
      size = "short";
      permission = "rwx";
      no-symlink = false;
      total-size = false;
      hyperlink = "auto";
    };
  };

  programs.git = {
    enable = true;
    userName = "Mustafa Zaki Assagaf";
    userEmail = "mustafa.segf@gmail.com";
    extraConfig = {
      core.editor = "nvim";
      #credential."https://github.com" = {
      #  helper = "!/run/current-system/sw/bin/gh auth git-credential";
      #};
      init.defaultBranch = "master";
      pull.rebase = false;
      pull.ff = true;
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
      prompt = "enable";
      pager = "nvim";
      http_unix_socket.browser = "google-chrome-stable";
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      # obs-multi-rtmp
      # obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-move-transition
      input-overlay
      obs-vkcapture
    ];
  };
}
