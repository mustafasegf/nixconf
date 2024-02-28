{ config
, pkgs
, libs
, ...
}: {

  programs.zsh = {
    enable = true;
    autocd = true;

    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
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
        export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
        export ZSH_WAKATIME_BIN="$WAKATIME_HOME/.wakatime/wakatime-cli"

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
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      unset -v SSH_ASKPASS

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

      # LF
      LFCD="$HOME/.config/lf/lfcd.sh"                                
      #  pre-built binary, make sure to use absolute path
      if [ -f "$LFCD" ]; then
          source "$LFCD"
      fi

      function mkcdir() {
          mkdir -p -- "$1" &&
          cd -P -- "$1"
      }

      function cdg() { cd "$(git rev-parse --show-toplevel)"  }

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

      # Nix
      function update() {
        pushd $HOME/.config/nixpkgs
        sudo nixos-rebuild switch --flake .#
        popd
      }

      function update-test() {
        pushd $HOME/.config/nixpkgs
        sudo nixos-rebuild test --flake .#
        popd
      }

      alias update-flake='nix flake update --commit-lock-file'

      function tmem () {
        smem -t -k -c pss -P "$@"
      }
      function gi() { 
        curl -sLw \"\\\n\" https://www.toptal.com/developers/gitignore/api/\$@ 
      }

    '';
    shellAliases = {
      # update = "sudo nixos-rebuild switch";
      rm = "trash put";
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

      mans = '' man -k  . | cut -d " " -f 1 | fzf -m --preview "man {1}" | xargs man '';
      m = "make";
      v = "nvim";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };

    history = {
      size = 10000;
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "dracula/zsh"; tags = [ "as:theme" ]; }
        { name = "agkozak/zsh-z"; }
        { name = "lib/history"; tags = [ from:oh-my-zsh ]; }
        { name = "lib/key-bindings"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/tmux"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/vi-mode"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/docker"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/docker-compose"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/sudo"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/copyfile"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/copypath"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/dirhistory"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/history"; tags = [ from:oh-my-zsh ]; }
        # { name = "plugins/fzf"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/history-substring-search"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/colored-man-pages"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/gcloud"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/aws"; tags = [ from:oh-my-zsh ]; }
        { name = "sobolevn/wakatime-zsh-plugin"; }
        { name = "ellie/atuin"; }
      ];
    };
  };
}
