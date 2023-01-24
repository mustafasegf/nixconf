{ config, pkgs, ... }:

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

  # pkgs.mkShell = rec {
  #   buildInputs = with pkgs; [
  #     llvmPackages_latest.llvm
  #     llvmPackages_latest.bintools
  #     zlib.out
  #     rustup
  #     xorriso
  #     qemu
  #     grub2
  #     llvmPackages_latest.lld
  #     python3
  #   ];
  #   RUSTC_VERSION = pkgs.lib.readFile ./rust-toolchain;
  #   LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];
  #   HISTFILE = toString ./.history;
  #   shellHook = ''
  #     export PATH=$PATH:${CARGO_HOME:-~/.cargo}/bin
  #     export PATH=$PATH:${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/
  #   '';
  #
  #   RUSTFLAGS = (builtins.map (a: ''-L ${a}/lib'') [
  #     pkgs.libvmi
  #   ]);
  #
  #   BINDGEN_EXTRA_CLANG_ARGS =
  #     # Includes with normal include path
  #     (builtins.map (a: ''-I"${a}/include"'') [
  #       pkgs.libvmi
  #       pkgs.glibc.dev
  #     ])
  #     # Includes with special directory paths
  #     ++ [
  #       ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
  #       ''-I"${pkgs.glib.dev}/include/glib-2.0"''
  #       ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
  #     ];
  # };

  programs.zsh = {
    enable = true;
    autocd = true;

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    envExtra =
      # let RUSTC_VERSION = pkgs.lib.strings.removeSuffix "\n" pkgs.lib.readFile ./rust-toolchain;
      let RUSTC_VERSION = "nightly";
      in
      ''
        #XDG 
        export XDG_DATA_HOME=$HOME/.local/share
        export XDG_CONFIG_HOME=$HOME/.config
        export XDG_STATE_HOME=$HOME/.local/state
        export XDG_CACHE_HOME=$HOME/.cache

        # home cleaning
        export ANDROID_HOME="$XDG_DATA_HOME"/android
        export ASDF_DATA_DIR="$XDG_DATA_HOME"/asdf
        export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
        export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
        export HISTFILE="$XDG_STATE_HOME"/zsh/history
        export CARGO_HOME="$XDG_DATA_HOME"/cargo
        export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
        export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
        export ELINKS_CONFDIR="$XDG_CONFIG_HOME"/elinks
        export GEM_HOME="$XDG_DATA_HOME"/gem
        export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem
        export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem
        export GNUPGHOME="$XDG_DATA_HOME"/gnupg
        export GOPATH="$XDG_DATA_HOME"/go
        export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
        export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
        export KDEHOME="$XDG_CONFIG_HOME"/kde
        export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
        export DVDCSS_CACHE="$XDG_DATA_HOME"/dvdcss
        export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
        export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
        export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
        export PSQL_HISTORY="$XDG_DATA_HOME"/psql_history
        export KERAS_HOME="$XDG_STATE_HOME"/keras
        export REDISCLI_HISTFILE="$XDG_DATA_HOME"/redis/rediscli_history
        export VAGRANT_HOME="$XDG_DATA_HOME"/vagrant
        export WINEPREFIX="$XDG_DATA_HOME"/wine
        export _Z_DATA="$XDG_DATA_HOME"/z

        # Path
        export PATH=$PATH:$CARGO_HOME/bin
        export PATH=$PATH:$RUSTUP_HOME:~/.rustup/toolchains/${RUSTC_VERSION}-x86_64-unknown-linux-gnu/bin/

        # misc
        export CHTSH_QUERY_OPTIONS="style=rrt"

        # lf icons
        export LF_ICONS="\
        di=:\
        fi=:\
        ln=:\
        or=:\
        ex=:\
        *.vimrc=:\
        *.viminfo=:\
        *.gitignore=:\
        *.c=:\
        *.cc=:\
        *.clj=:\
        *.coffee=:\
        *.cpp=:\
        *.css=:\
        *.d=:\
        *.dart=:\
        *.erl=:\
        *.exs=:\
        *.fs=:\
        *.go=:\
        *.h=:\
        *.hh=:\
        *.hpp=:\
        *.hs=:\
        *.html=:\
        *.java=:\
        *.jl=:\
        *.js=:\
        *.json=:\
        *.lua=:\
        *.md=:\
        *.php=:\
        *.pl=:\
        *.pro=:\
        *.py=:\
        *.rb=:\
        *.rs=:\
        *.scala=:\
        *.ts=:\
        *.vim=:\
        *.cmd=:\
        *.ps1=:\
        *.sh=:\
        *.bash=:\
        *.zsh=:\
        *.fish=:\
        *.tar=:\
        *.tgz=:\
        *.arc=:\
        *.arj=:\
        *.taz=:\
        *.lha=:\
        *.lz4=:\
        *.lzh=:\
        *.lzma=:\
        *.tlz=:\
        *.txz=:\
        *.tzo=:\
        *.t7z=:\
        *.zip=:\
        *.z=:\
        *.dz=:\
        *.gz=:\
        *.lrz=:\
        *.lz=:\
        *.lzo=:\
        *.xz=:\
        *.zst=:\
        *.tzst=:\
        *.bz2=:\
        *.bz=:\
        *.tbz=:\
        *.tbz2=:\
        *.tz=:\
        *.deb=:\
        *.rpm=:\
        *.jar=:\
        *.war=:\
        *.ear=:\
        *.sar=:\
        *.rar=:\
        *.alz=:\
        *.ace=:\
        *.zoo=:\
        *.cpio=:\
        *.7z=:\
        *.rz=:\
        *.cab=:\
        *.wim=:\
        *.swm=:\
        *.dwm=:\
        *.esd=:\
        *.jpg=:\
        *.jpeg=:\
        *.mjpg=:\
        *.mjpeg=:\
        *.gif=:\
        *.bmp=:\
        *.pbm=:\
        *.pgm=:\
        *.ppm=:\
        *.tga=:\
        *.xbm=:\
        *.xpm=:\
        *.tif=:\
        *.tiff=:\
        *.png=:\
        *.svg=:\
        *.svgz=:\
        *.mng=:\
        *.pcx=:\
        *.mov=:\
        *.mpg=:\
        *.mpeg=:\
        *.m2v=:\
        *.mkv=:\
        *.webm=:\
        *.ogm=:\
        *.mp4=:\
        *.m4v=:\
        *.mp4v=:\
        *.vob=:\
        *.qt=:\
        *.nuv=:\
        *.wmv=:\
        *.asf=:\
        *.rm=:\
        *.rmvb=:\
        *.flc=:\
        *.avi=:\
        *.fli=:\
        *.flv=:\
        *.gl=:\
        *.dl=:\
        *.xcf=:\
        *.xwd=:\
        *.yuv=:\
        *.cgm=:\
        *.emf=:\
        *.ogv=:\
        *.ogx=:\
        *.aac=:\
        *.au=:\
        *.flac=:\
        *.m4a=:\
        *.mid=:\
        *.midi=:\
        *.mka=:\
        *.mp3=:\
        *.mpc=:\
        *.ogg=:\
        *.ra=:\
        *.wav=:\
        *.oga=:\
        *.opus=:\
        *.spx=:\
        *.xspf=:\
        *.pdf=:\
        *.nix=:\
        "
      '';
    initExtraFirst = ''
      # tmux auto start config
      # change this
      ZSH_TMUX_AUTOSTART=true
      ZSH_TMUX_AUTOSTART_ONCE=false
      ZSH_TMUX_AUTOCONNECT=true
      ZSH_TMUX_CONFIG=/home/mustafa/.config/tmux/tmux.conf

      # vi mode config
      VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
      VI_MODE_SET_CURSOR=true
      MODE_INDICATOR="%F{yellow}+%f"
      KEYTIMEOUT=15
      VI_MODE_PROMPT_INFO=true

      #FZF
      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
      export FZF_DEFAULT_COMMAND='fd --hidden --follow --ignore-file=$HOME/.gitignore --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
      export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
      export FZF_CTRL_R_OPTS="$FZF_DEFAULT_COMMAND"
      export FZF_DEFAULT_OPTS="--layout=reverse --inline-info --height=90%"

      # LF
      LFCD="$HOME/.config/lf/lfcd.sh"                                
      #  pre-built binary, make sure to use absolute path
      if [ -f "$LFCD" ]; then
          source "$LFCD"
      fi

      function mkcdir ()
      {
          mkdir -p -- "$1" &&
          cd -P -- "$1"
      }

      function cdg() { cd "$(git rev-parse --show-toplevel)"  }

      #dir env
      #eval "$(direnv hook zsh)"

      #Git
      function gsts (){git status}
      function gc (){git commit -am "$@"}
      function ga (){git add "$@"}
      function gs (){git switch "$@"}
      function gm (){git merge "$@"}
      function gcb (){git checkout -b "$@"}
      function gca (){git commit --amend --no-edit -m "$@"}
      function gu (){git reset --soft HEAD~1}
      function gst (){git stash "$@"}
      function gstp (){git stash pop "$@"}
      function grmc (){git rm --cached "$@"}

      function gpo (){git push origin "$@"}
      function gplo (){git pull origin "$@"}
      function gpu (){git push upstream "$@"}
      function gplu (){git pull upstream  "$@"}


      function gsm (){gs "master"}

      function gpom (){gpo "master"}
      function gpum (){gpu "master"}

      function gplom (){gplo "master"}
      function gplum (){gplu "master"}

      function gplob (){gplo "$(git symbolic-ref --short HEAD)"}
      function gplub (){gplu "$(git symbolic-ref --short HEAD)"}

      function gpob (){gpo "$(git symbolic-ref --short HEAD)"}
      function gpub (){gpu "$(git symbolic-ref --short HEAD)"}
    '';
    shellAliases = {
      update = "sudo nixos-rebuild switch";
      rm = "trash";
      cat = "bat";
      grep = "rg";
      c = "clear";

      ls = "lsd";
      la = "ls -A";
      l = "ls -Alh";
      ll = "ls -Al";
      lt = "ls --tree";
      lta = "ls -A --tree";

      g = "git";
      lg = "lazygit";
      wget = ''wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'';
      xbindkeys = ''xbindkeys -f "$XDG_CONFIG_HOME"/xbindkeys/config'';

      mans = '' 'man -k  . | cut -d " " -f 1 | fzf -m --preview "man {1}"' '';
      m = "make";
    };

    history = {
      size = 10000;
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "dracula/zsh"; tags = [ "as:theme" ]; }
        { name = "agkozak/zsh-z"; }
        { name = "plugins/tmux"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/vi-mode"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/docker"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/docker-compose"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/sudo"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/copyfile"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/copypath"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/dirhistory"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/history"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/fzf"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/history-substring-search"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/colored-man-pages"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/gcloud"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/aws"; tags = [ from:oh-my-zsh ]; }
      ];
    };
  };

  ## no program config yet: neofetch

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "git"
          set -g @dracula-show-left-icon session
          set -g @dracula-show-fahrenheit false
        '';
      }
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'off'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
      {
        plugin = open;
      }
      {
        plugin = sidebar;
      }
      {
        plugin = yank;
        extraConfig = ''
          set -g @yank_highlight 'true'
          set -g @yank_highlight_cursor 'true'
        '';
      }
      {
        plugin = copycat;

      }
      # {
      #   plugin = sensible;
      # }
      {
        plugin = logging;
      }
    ];

    shell = "${pkgs.zsh}/bin/zsh";

    extraConfig = ''
      # split panes using | and -, make sure they open in the same path
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      unbind '"'
      unbind %

      # open new windows in the current path
      bind c new-window -c "#{pane_current_path}"
      bind s new-session

      # reload config file
      bind r source-file ~/.config/tmux/tmux.conf \: display-message "Loaded tmux config"

      unbind p
      bind p previous-window

      # vim key to switch window and session
      bind -r j previous-window
      bind -r k next-window
      bind -r h switch-client -p
      bind -r l switch-client -n

      # vim key to move pane
      bind -r K select-pane -U
      bind -r J select-pane -D
      bind -r H select-pane -R
      bind -r L select-pane -L

      set -g mouse on
      # don't rename windows automatically
      set -g allow-rename off

      # for server
      #Variables
      color_status_text="colour245"
      color_window_off_status_bg="colour238"
      color_light="white" #colour015
      color_dark="colour232" # black= colour232
      color_window_off_status_current_bg="colour254"

      bind -T root F12  \
        set prefix None \;\
        set key-table off \;\
        set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
        set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
        set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
        if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
        refresh-client -S \;\

      bind -T off F12 \
        set -u prefix \;\
        set -u key-table \;\
        set -u status-style \;\
        set -u window-status-current-style \;\
        set -u window-status-current-format \;\
        refresh-client -S

      wg_is_keys_off="#[fg=$color_light,bg=$color_window_off_indicator]#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#[default]"
    '';
    prefix = "C-a";
    keyMode = "vi";
    historyLimit = 10000;
    baseIndex = 1;
    # escapeTime = 1;
    # newSession = true;
  };

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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

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
}
