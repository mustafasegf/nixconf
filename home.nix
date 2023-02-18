{ pkgs, upkgs, pypi-fetcher, ... }:
let
  dracula-gtk = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
    rev = "502f212d83bc67e8f0499574546b99ec6c8e16f9";
    sha256 = "1wx9nzq7cqyvpaq4j60bs8g7gh4jk8qg4016yi4c331l4iw1ymsa";
  };
  dracula-xresources = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "xresources";
    rev = "8de11976678054f19a9e0ec49a48ea8f9e881a05";
    sha256 = "12wmjynk0ryxgwb0hg4kvhhf886yvjzkp96a5bi9j0ryf3pc9kx7";
  };
in
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



  ## no program config yet: neofetch glab dunst flameshot
  imports = [
    (import ./programs/btop.nix)
    (import ./programs/kitty.nix)
    (import ./programs/mimeapps.nix)
    (import ./programs/nvim/nvim.nix)
    (import ./programs/rofi.nix)
    (import ./programs/tmux.nix)
    (import ./programs/zsh.nix)
  ];

  xresources.extraConfig = builtins.readFile ("${dracula-xresources}/Xresources");
  xdg = {
    enable = true;
    configFile = {
      "qtile/config.py".source = ./qtile/config.py;
      "qtile/floating_window_snapping.py".source = ./qtile/floating_window_snapping.py;

      "Kvantum/Dracula/Dracula.kvconfig".source = "${dracula-gtk}/kde/kvantum/Dracula-purple-solid/Dracula-purple-solid.kvconfig";
      "Kvantum/Dracula/Dracula.svg".source = "${dracula-gtk}/kde/kvantum/Dracula-purple-solid/Dracula-purple-solid.svg";
      "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Dracula";
      "lxqt/lxqt.conf".source = ./config/dracula/lxqt/lxqt.conf;
      "lxqt/session.conf".source = ./config/dracula/lxqt/session.conf;
      "gtk-3.0/settings.ini".source = ./config/dracula/gtk-3.0/settings.ini;
      "gtk-2.0/gtkrc".source = ./config/dracula/gtk-2.0/gtkrc-2.0;

    };
  };

  # home.file = {
  #   # ".gtkrc-2.0".source = ../../config/dracula/gtk-2.0/gtkrc-2.0;
  #   ".gtkrc-2.0".source = ../../config/dracula/gtk-2.0/gtkrc-2.0;
  # };

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

  programs.fzf =
    let
      cmd = "fd --hidden --follow --ignore-file=$HOME/.gitignore --exclude .git";
    in
    {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      defaultOptions = [ "--layout=reverse --inline-info --height=90%" ];
      defaultCommand = cmd;

      fileWidgetCommand = "${cmd} --type f";
      changeDirWidgetCommand = "${cmd} --type d";

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
    package = upkgs.obs-studio;
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
