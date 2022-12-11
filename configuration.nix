# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, modulesPath, lib, pkgs, hardware, nix, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./qtile.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "ntfs" "cifs" ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  services.udisks2.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  virtualisation = {
    docker.enable = true;
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };


  networking.hostName = "mustafa-pc"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.utf8";
    LC_IDENTIFICATION = "id_ID.utf8";
    LC_MEASUREMENT = "id_ID.utf8";
    LC_MONETARY = "id_ID.utf8";
    LC_NAME = "id_ID.utf8";
    LC_NUMERIC = "id_ID.utf8";
    LC_PAPER = "id_ID.utf8";
    LC_TELEPHONE = "id_ID.utf8";
    LC_TIME = "id_ID.utf8";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      # gtkUsePortal = true;
    };
  };

  services.xserver = {
    enable = true;
    digimend.enable = true;
    videoDrivers = [ "amdgpu" ];
    autorun = true;
    displayManager = {
      defaultSession = "none+qtile";
      lightdm = {
        enable = true;
        greeter.enable = true;
      };
    };

    windowManager = {
      qtile = {
        enable = true;
        package = pkgs.qtile;
        backend = "x11";
        configFile = ./qtile/config.py;
      };
    };
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  services.printing.enable = true;

  programs.noisetorch.enable = true;

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
      }
    ];

    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.picom.enable = true;

  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [ dconf ];

  home-manager.users.mustafa = { pkgs, ... }: {
    home.username = "mustafa";
    home.homeDirectory = "/home/mustafa";
    home.stateVersion = "22.11";
    programs.bash.enable = true;
    nixpkgs.config.allowUnfree = true;
    services.kdeconnect.enable = true;

    ## no program config yet: neofetch

    # programs.tmux = {
    #   enable = false;
    #   plugins = with pkgs.tmuxPlugins; [
    #     # {
    #     #   plugin = dracula;
    #     #   extraConfig = ''
    #     #     set -g @dracula-plugins "git"
    #     #     set -g @dracula-show-left-icon session
    #     #     set -g @dracula-show-fahrenheit false
    #     #   '';
    #     # }
    #     # {
    #     #   plugin = resurrect;
    #     #   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
    #     # }
    #     # {
    #     #   plugin = continuum;
    #     #   extraConfig = ''
    #     #     set -g @continuum-restore 'on'
    #     #     set -g @continuum-save-interval '60' # minutes
    #     #   '';
    #     # }
    #     sidebar
    #     prefix-highlight
    #     open
    #     yank
    #     sensible
    #     copycat
    #     # pain-control
    #     logging
    #     sensible
    #   ];
    #   prefix = "C-a";
    #   keyMode = "vi";
    #   historyLimit = 10000;
    #   baseIndex = 1;
    #   # escapeTime = 1;
    #   # newSession = true;
    # };

    programs.rofi =
      {
        enable = false;

        plugins = with pkgs; [
          rofi-calc
          rofi-emoji
          rofi-pass
          rofi-systemd
        ];
        font = "IBM Plex Mono 12";

        # theme = {
        #   "*" = {
        #     drac-bgd = "rgba (40, 42, 54, 50%)";
        #     drac-cur = "#44475a";
        #     drac-fgd = "#f8f8f2";
        #     drac-cmt = "#6272a4";
        #     drac-cya = "#8be9fd";
        #     drac-grn = "#50fa7b";
        #     drac-ora = "#ffb86c";
        #     drac-pnk = "rgba (255, 121, 198, 17% )";
        #     drac-pur = "#bd93f9";
        #     drac-red = "rgba (255, 85, 85, 17%)";
        #     drac-yel = "#f1fa8c";
        #
        #     foreground = "@drac-fgd";
        #     background-color = "@drac-bgd";
        #     active-background = "@drac-pnk";
        #     urgent-background = "@drac-red";
        #
        #     selected-background = "@active-background";
        #     selected-urgent-background = "@urgent-background";
        #     selected-active-background = "@active-background";
        #     separatorcolor = "@active-background";
        #     bordercolor = "#6272a4";
        #   };
        #
        #   "#window" = {
        #     background-color = "@background-color";
        #     border = 1;
        #     border-radius = 6;
        #     border-color = "@bordercolor";
        #   };
        #
        #   "#mainbox" = {
        #     border = 0;
        #     padding = 5;
        #   };
        #   "#message" = {
        #     border = "0px dash 0px 0px ";
        #     border-color = "@separatorcolor";
        #     padding = "0px ";
        #   };
        #   "#textbox" = {
        #     text-color = "@foreground";
        #   };
        #   "#listview" = {
        #     lines = 10;
        #     columns = 3;
        #     fixed-height = 0;
        #     border = "2px dash 0px 0px ";
        #     border-color = "@bordercolor";
        #     spacing = "0px ";
        #     scrollbar = true;
        #     padding = "2px 0px 0px ";
        #   };
        #   "#element" = {
        #     border = 0;
        #     padding = "1px ";
        #   };
        #   "#element.normal.normal" = {
        #     background-color = "@background-color";
        #     text-color = "@foreground";
        #   };
        #   "#element.normal.urgent" = {
        #     background-color = "@urgent-background";
        #     text-color = "@urgent-foreground";
        #   };
        #   "#element.normal.active" = {
        #     background-color = "@active-background";
        #     text-color = "@background-color";
        #   };
        #   "#element.selected.normal" = {
        #     background-color = "@selected-background";
        #     text-color = "@foreground";
        #   };
        #   "#element.selected.urgent" = {
        #     background-color = "@selected-urgent-background";
        #     text-color = "@foreground";
        #   };
        #   "#element.selected.active" = {
        #     background-color = "@selected-active-background";
        #     text-color = "@background-color";
        #   };
        #   "#element.alternate.normal" = {
        #     background-color = "@background-color";
        #     text-color = "@foreground";
        #   };
        #   "#element.alternate.urgent" = {
        #     background-color = "@urgent-background";
        #     text-color = "@foreground";
        #   };
        #   "#element.alternate.active" = {
        #     background-color = "@active-background";
        #     text-color = "@foreground";
        #   };
        #   "#scrollbar" = {
        #     width = "1px ";
        #     border = 0;
        #     handle-width = "4px ";
        #     padding = 0;
        #   };
        #   "#sidebar" = {
        #     border = "2px dash 0px 0px ";
        #     border-color = "@separatorcolor";
        #   };
        #   "#button.selected" = {
        #     background-color = "@selected-background";
        #     text-color = "@foreground";
        #   };
        #   "#inputbar" = {
        #     spacing = 0;
        #     text-color = "@foreground";
        #     padding = "1px ";
        #   };
        #   "#case-indicator" = {
        #     spacing = 0;
        #     text-color = "@foreground";
        #   };
        #   "#entry" = {
        #     spacing = 0;
        #     text-color = "@drac-cya";
        #   };
        #   "#prompt" = {
        #     spacing = 0;
        #     text-color = "@drac-grn";
        #   };
        #   "#inputbar" = {
        #     children = "[ prompt,textbox-prompt-colon,entry,case-indicator ]";
        #   };
        #   "#textbox-prompt-colon" = {
        #     expand = false;
        #     str = ":";
        #     margin = "0px 0.3em 0em 0em ";
        #     text-color = "@drac-grn";
        #   };
        #   "element-text, element-icon" = {
        #     background-color = "inherit";
        #     text-color = "inherit";
        #   };
        # };
        extraConfig = {
          show-icons = true;
          icon-theme = "Arc-X-D";
          display-drun = "Apps";
          drun-display-format = "{name}";
          scroll-method = 0;
          disable-history = false;
          sidebar-mode = false;
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


    gtk = {
      enable = true;
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "google-chrome.desktop";
        "text/calendar" = "userapp-Thunderbird-OM4EI1.desktop";
        "text/plain" = "nvim.desktop";
        "text/csv" = "nvim.desktop";
        "text/javascript" = "nvim.desktop";
        "text/xml" = "nvim.desktop";
        "text/x-shellscript" = "nvim.desktop";
        "application/zip" = "tar.desktop";
        "application/pdf" = "org.kde.okular.desktop";
        "application/x-extension-ics" = "userapp-Thunderbird-OM4EI1.desktop";
        "image/jpeg" = "pinta.desktop";
        "image/jpg" = "pinta.desktop";
        "image/png" = "pinta.desktop";
        "inode/directory" = "thunar.desktop";
        "audio/wav" = "mpv.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
        "x-scheme-handler/postman" = "Postman.desktop";
        "x-scheme-handler/tg" = "userapp-Telegram Desktop-JPL1B1.desktop";
        "x-scheme-handler/eclipse+command" = "_usr_lib_dbeaver_.desktop";
        "x-scheme-handler/sidequest" = "SideQuest.desktop";
        "x-scheme-handler/webcal" = "google-chrome.desktop";
        "x-scheme-handler/mailto" = "userapp-Thunderbird-OQCEI1.desktop";
        "x-scheme-handler/mid" = "userapp-Thunderbird-OQCEI1.desktop";
        "x-scheme-handler/webcals" = "userapp-Thunderbird-OM4EI1.desktop";
        "x-scheme-handler/discord-402572971681644545" = "discord-402572971681644545.desktop";
        "message/rfc822" = "userapp-Thunderbird-OQCEI1.desktop";
      };
      associations.added = {
        "text/html" = "firefox.desktop;code-oss.desktop;nvim.desktop;wine-extension-txt.desktop;";
        "text/x-go" = "nvim.desktop;";
        "application/pdf" = "okularApplication_pdf.desktop;";
        "application/x-ms-dos-executable" = "wine.desktop;";
        "application/x-java-archive" = "java-java11-openjdk.desktop;";
        "application/sql" = "code-oss.desktop;nvim.desktop;";
        "application/x-navi-animation" = "gimp.desktop;";
        "image/png" = "pinta.desktop;";
        "video/x-matroska" = "vlc.desktop;";
        "video/mp4" = "vlc.desktop;mpv.desktop;";
        "x-scheme-handler/tg" = "userapp-Telegram Desktop-JPL1B1.desktop;";
        "x-scheme-handler/mailto" = "userapp-Thunderbird-OQCEI1.desktop;";
        "x-scheme-handler/mid" = "userapp-Thunderbird-OQCEI1.desktop;";
        "x-scheme-handler/webcal" = "userapp-Thunderbird-OM4EI1.desktop;";
        "x-scheme-handler/webcals" = "userapp-Thunderbird-OM4EI1.desktop;";
      };
    };

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "dracula";
        theme_background = false;
        truecolor = true;
        force_tty = false;
        presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
        vim_keys = false;
        rounded_corners = true;
        graph_symbol = "braille";
        shown_boxes = "mem net proc cpu";
        update_ms = 250;
        proc_sorting = "cpu lazy";
        proc_reversed = false;
        proc_tree = false;
        proc_colors = true;
        proc_gradient = false;
        proc_per_core = true;
        proc_mem_bytes = true;
        proc_cpu_graphs = true;
        proc_info_smaps = false;
        proc_left = true;
        proc_filter_kernel = false;
        cpu_graph_upper = "total";
        cpu_graph_lower = "user";
        cpu_invert_lower = true;
        cpu_single_graph = false;
        cpu_bottom = false;
        show_uptime = true;
        check_temp = true;
        cpu_sensor = "Auto";
        show_coretemp = true;
        cpu_core_map = "";
        temp_scale = "celsius";
      };
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
      enableAliases = true;
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



    programs.kitty = {
      enable = true;
      font = {
        name = "IBM Plex Mono";
        size = 10;
      };
      extraConfig = ''
        include /etc/nixos/kitty/dracula.conf
      '';

      settings = {
        background_opacity = "0.90";
        enable_audio_bell = false;
        confirm_os_window_close = "0";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        scrollback_lines = 5000;
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

    programs.neovim = {
      enable = true;
      #viAlias = true;
      #vimAlias = true;

      plugins =
        let
          pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "${lib.strings.sanitizeDerivationName repo}";
            version = ref;
            src = builtins.fetchGit {
              url = "https://github.com/${repo}.git";
              ref = ref;
            };
          };
        in

        with pkgs.vimPlugins; [
          # theme
          dracula-vim

          #lsp
          nvim-lspconfig
          cmp-nvim-lsp
          cmp-buffer
          nvim-cmp
          luasnip
          lspkind-nvim
          null-ls-nvim
          ## inlay-hints  

          #language spesific
          ## go-nvim
          rust-tools-nvim

          #file tree
          nvim-tree-lua
          nvim-web-devicons

          # buffer
          bufferline-nvim
          toggleterm-nvim

          #cosmetic
          indent-blankline-nvim
          nvim-ts-rainbow
          lualine-nvim
          nvim-colorizer-lua

          #git
          octo-nvim
          vim-fugitive
          {
            plugin = (pluginGit "master" "APZelos/blamer.nvim");
            type = "lua";
          }
          gitsigns-nvim
          trouble-nvim

          #addon app
          vim-dadbod-ui
          vim-dadbod
          rest-nvim

          #auto
          cmp-tabnine
          copilot-vim
          nvim-autopairs

          #quality of life
          comment-nvim
          nvim-ts-context-commentstring
          nvim-ts-autotag
          vim-move
          vim-visual-multi
          vim-surround
          telescope-nvim
          auto-save-nvim
          refactoring-nvim
          nvim-spectre

          #session
          auto-session
          ## session-lens

          #debugger
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
          telescope-dap-nvim
          nvim-dap-go
          ##vim-maximizer

          #misc
          popup-nvim
          plenary-nvim
          # presence-nvim
          registers-nvim
          harpoon
          vim-sneak

          (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
        ];


      extraConfig = ''
        set number
        set rnu
        set ignorecase
        set smartcase
        set hidden
        set noerrorbells
        set tabstop=2 softtabstop=2 shiftwidth=2
        set shiftwidth=2
        set expandtab
        set smartindent
        set wrap
        set noswapfile
        set nobackup
        set undodir=~/.vim/undodir
        set undofile
        set incsearch
        set scrolloff=12
        set noshowmode
        set signcolumn=yes:2
        set completeopt=menuone,noinsert
        set cmdheight=1
        set updatetime=50
        set shortmess+=c
        set termguicolors
        set pumblend=15
        set mouse=a
        set winbar=%=%{expand('%:~:.')}
        syntax on

        lua require("start")
      '';
    };
  };

  users.users.mustafa = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "rtkit" "media" "audio" "sys" "wireshark" "rfkill" "video" "uucp" "docker" ];
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    ibm-plex
    nerdfonts
  ];

  security.sudo.configFile = ''
    mustafa ALL = NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/poweroff
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim

    neovim
    vscode

    wget
    glxinfo

    kitty
    zsh
    oh-my-zsh
    fzf
    fzf-zsh

    zip
    bind
    bat
    btop
    blueman
    dunst
    gh
    htop
    input-remapper
    lf
    lsd
    neofetch
    picom
    rofi
    starship
    arandr
    awscli2
    copyq
    cloc
    dbeaver
    dos2unix
    fd
    ffmpeg_5-full
    ffmpegthumbnailer
    find-cursor
    flameshot
    gdu
    git-annex
    glab
    google-cloud-sdk
    gromit-mpx
    handbrake
    httpie
    inxi
    jq
    man
    nitrogen
    nmap
    notion-app-enhanced
    obs-studio
    p7zip
    pinta
    postman
    qpwgraph
    libsForQt5.qt5ct
    radeontop
    scrcpy
    speedtest-cli
    trashy
    wine
    wine64
    winetricks
    wireplumber
    x11vnc
    xclip
    xcolor
    youtube-dl
    yt-dlp
    python39
    poetry
    rustup
    go
    gofumpt
    nodejs-16_x
    nodePackages.npm
    nodePackages.pnpm
    git
    docker
    pavucontrol
    ncpamixer
    pulseaudioFull
    slack
    zoom-us
    tdesktop
    google-chrome
    thunderbird
    alsa-utils
    pulseaudio-ctl
    home-manager
    openrgb
    discord
    killall
    libnotify
    noisetorch
    statix
    tmux
    terraform
    clang

    black
    stylua
    gofumpt
    gotools
    ##terrafmt
    shfmt
    ##fourmolu

    gopls
    nodePackages.pyright
    nodePackages.typescript-language-server
    tflint
    ##yamlls
    ##vimls
    texlab
    nodePackages.vscode-langservers-extracted
    ##emmet-ls
    nodePackages_latest.tailwindcss
    taplo
    nodePackages.graphql-language-service-cli
    sqls
    ##jdtls
    nodePackages.svelte-language-server
    ##astro
    ##prisma
    ##jsonls
    sumneko-lua-language-server
    nodePackages.diagnostic-languageserver

    kdeconnect
    rnix-lsp
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    gvfs
    udisks
    usermount
    gnumake
    air
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}



