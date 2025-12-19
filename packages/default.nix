{ ppkgs, pkgs, upkgs, staging-pkgs, mpkgs, lib
# , firefoxpkgs
, ... }: rec {
  # ollama-rocm = pkgs.ollama.override {
  #   llama-cpp = pkgs.llama-cpp.override {
  #     rocmSupport = true;
  #     openblasSupport = false;
  #   };
  # };
  #
  # ollama-ocl = pkgs.ollama.override {
  #   llama-cpp = pkgs.llama-cpp.override {
  #     openclSupport = true;
  #     openblasSupport = false;
  #   };
  # };

  shellAliases = {
    # ollama-rocm = lib.getExe ollama-rocm;
    # ollama-ocl = lib.getExe ollama-ocl;
    # steam-nix = lib.getExe pkgs.steam;
  };
  # mpkgs.config.allowUnfree = true;

  packages = with pkgs; [
    vim
    neovim
    wget
    # glxinfo
    mesa-demos

    kitty
    zsh
    oh-my-zsh
    fzf
    fzf-zsh

    zip
    unzip
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
    dbeaver-bin
    dos2unix
    fd
    ffmpeg-full
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
    nvtopPackages.full
    p7zip
    pinta
    postman
    qpwgraph
    libsForQt5.qt5ct
    kdePackages.okular
    radeontop
    scrcpy
    speedtest-cli
    # trashy
    (pkgs.rustPlatform.buildRustPackage rec {
      pname = "trashy";
      version = "c95b22";

      src = fetchFromGitHub {
        owner = "oberblastmeister";
        repo = "trashy";
        rev = "c95b22c0522f616b8700821540a1e58edcf709eb";
        hash = "sha256-O4r/bfK33hJ6w7+p+8uqEdREGUhcaEg+Zjh/T7Bm6sY=";
      };

      cargoHash = "sha256-qrqhIT7FKcRmz9AWAvdbPi1uzVpkGXBJefr3y06n9F0=";

      nativeBuildInputs = [ installShellFiles ];

      preFixup = ''
        installShellCompletion --cmd trash \
          --bash <($out/bin/trash completions bash) \
          --fish <($out/bin/trash completions fish) \
          --zsh <($out/bin/trash completions zsh) \
      '';

    })
    wine
    wine64
    winetricks
    wireplumber
    x11vnc
    xclip
    xsel
    xcolor
    yt-dlp
    (let
      packagePypi = name: ver: ref: deps:
        python3.pkgs.buildPythonPackage rec {
          pname = name;
          version = ver;

          src = python311.pkgs.fetchPypi {
            inherit pname version;
            hash = ref;
          };

          buildInputs = deps;
          doCheck = false;
        };
    in python3.withPackages (ps: [
      # sha from nix store prefetch-file 
      # (packagePypi "iwlib" "1.7.0"
      #   "sha256-qAX2WXpw7jABq6jwOft7Lct13BXE54UvVZT9Y3kZbaE=" [
      #     wirelesstools
      #     ps.setuptools
      #     ps.cffi
      #   ])
      # (packagePypi "Appium-Python-Client" "4.0.0"
      #   "sha256-0Ty9bdgdApBwG6RRFF7H6/Wm10Iiva78ErYu9vVqH9Y=" [ ])
      # (
      #   packagePypi
      #     "qtile"
      #     "0.22.1"
      #     "sha256-J8PLTXQjEWIs9aJ4Fnw76Z6kdafe9dQe6GC9PoZHj4s="
      #     [
      #       pkg-config
      #       libinput
      #       wayland
      #       wlroots
      #       libxkbcommon
      #       ps.setuptools-scm
      #       ps.xcffib
      #       (ps.cairocffi.override { withXcffib = true; })
      #       ps.setuptools
      #       ps.python-dateutil
      #       ps.dbus-python
      #       ps.dbus-next
      #       ps.mpd2
      #       ps.psutil
      #       ps.pyxdg
      #       ps.pygobject3
      #       ps.pywayland
      #       ps.pywlroots
      #       ps.xkbcommon
      #     ]
      # )
      ps.jupyterlab
      ps.notebook
      ps.jupyter-console
      ps.ipykernel
      ps.pandas
      ps.scikit-learn
      ps.matplotlib
      ps.numpy
      ps.scipy
      ps.pip
      # ps.seaborn
      # ps.plotly
      ps.statsmodels
      ps.opencv4
      ps.selenium
      # ps.torch

      # (packagePypi "pytorch-benchmark" "0.3.6"
      #   "sha256-HzbBeQlswbXU+cfhdlePZFgre/4kjoSwMcbpVbgKDhI=" [
      #   ])
      ps.scikit-image
      # ps.imbalanced-learn
      # ps.optuna
      ps.onnxruntime
      ps.pillow
      # ps.keras
      # ps.tensorflow
      # ps.numpydoc
      # ps.torchvision
      # ps.torchaudio
      # ps.triton
      ps.tkinter
    ]))
    poetry
    rustup
    go
    gofumpt
    nodejs
    nodePackages.npm
    nodePackages.pnpm
    nodePackages.sass
    nodePackages.vercel
    git
    docker
    pavucontrol
    ncpamixer
    pulseaudioFull
    slack
    zoom-us
    telegram-desktop
    google-chrome
    thunderbird
    alsa-utils
    pulseaudio-ctl
    home-manager
    openrgb
    mpkgs.discord
    discord-ptb
    killall
    libnotify
    noisetorch
    statix
    tmux
    terraform
    clang
    clang-tools

    black
    stylua
    gofumpt
    gotools
    ##terrafmt
    shfmt
    ##fourmolu

    gopls
    pyright
    upkgs.nodePackages.typescript-language-server
    # nodePackages.typescript
    tflint
    ##yamlls
    ##vimls
    texlab
    nodePackages.vscode-langservers-extracted
    ##emmet-ls
    nodePackages_latest."@tailwindcss/language-server"
    taplo
    nodePackages.graphql-language-service-cli
    sqls
    jdt-language-server
    nodePackages.svelte-language-server
    # nodePackages.grammarly-languageserver
    # nodePackages."@astrojs/language-server"
    astro-language-server
    emmet-ls
    ##astro
    ##prisma

    # buildNpmPackage
    # rec {
    #   pname = "@prisma/language-server";
    #   version = "4.11.0";
    #
    #   src = pkgs.fetchFromGitHub {
    #     owner = "prisma";
    #     repo = "language-tools";
    #     rev = "${version}";
    #     hash = "18xii6qsn0kzp53ln445ks83sqps27ihbqagnkn3ba3n88hgplys";
    #   };
    #
    #   npmDepsHash = "sha256-K46lLc6SsBF/ByYb3l1gQNfOrdW2XMazCZXLDuxEjmk=";
    #   buildInputs = [ nodejs typescript ];
    #   buildPhase = ''
    #     tsc --outDir $out/lib/dist
    #     cp -r node_modules $out/lib
    #     cp package.json $out/lib
    #   '';
    #
    #   installPhase = ''
    #     EXPAND_ARGS='$@'
    #     mkdir $out/bin
    #     echo '#!/bin/bash' >> $out/bin/prisma-language-server
    #     echo "${nodejs}/bin/node $out/lib/dist/src/bin.js $EXPAND_ARGS" >> $out/bin/prisma-language-server
    #     chmod +x $out/bin/prisma-language-server
    #   '';
    # }

    ##jsonls
    lua-language-server
    nodePackages.diagnostic-languageserver
    nodePackages.bash-language-server
    # nodePackages.prisma #broken

    kdePackages.kdeconnect-kde
    # xfce.thunar
    # xfce.thunar-volman
    # xfce.thunar-archive-plugin
    xfce.tumbler
    gvfs
    udisks
    usermount
    gnumake
    cmake
    fontconfig
    lazygit
    air
    most
    ripgrep
    steam
    rescuetime
    tailscale
    libsecret
    ppkgs.beekeeper-studio
    (appimage-run.override {
      extraPkgs = pkgs: [ pkgs.xorg.libxshmfence pkgs.libsecret ];
    })

    jdk17
    rclone

    llvmPackages_latest.llvm
    lldb
    llvmPackages_latest.bintools
    zlib.out
    xorriso
    grub2
    # mpkgs.qemu
    llvmPackages_latest.lld
    SDL2
    SDL2_ttf
    SDL2_net
    SDL2_gfx
    SDL2_sound
    SDL2_mixer
    SDL2_image
    radare2
    # iaito
    # minecraft
    virtualbox
    virt-manager
    # mpkgs.qemu_full
    libreoffice
    gcc
    gdb
    gedit
    kdePackages.kate
    screenkey
    k6
    direnv
    nix-direnv
    pciutils
    usbutils
    uwufetch
    webcamoid
    glade
    man-pages
    man-pages-posix
    # upkgs.soundux
    fwupd
    seahorse
    xorg.xkbcomp
    xorg.xkbutils
    xorg.xmodmap
    xorg.xinput
    xorg.libX11
    xorg.libXft
    xorg.libXinerama

    clang-tools
    clang
    pkg-config
    gtk3
    gtk4
    vlc
    mpv
    psmisc
    hello
    sqlite
    tunnelto
    scc

    libsForQt5.qtstyleplugin-kvantum
    lxqt.lxqt-qtplugin
    papirus-icon-theme
    openssl
    musl
    hexedit
    file
    devmem2
    nasm
    bear
    zerotierone
    lsof
    gnome-frog
    vulkan-tools
    clinfo
    firefox
    blender
    nix-prefetch-scripts
    file-roller
    kdePackages.ark
    kdePackages.kdenlive
    qalculate-qt
    kdePackages.kcalc
    qbittorrent
    cheese
    kdePackages.kamoso
    alacritty
    xournalpp
    dust
    eza
    exercism

    dune_3
    ocaml
    opam
    ocamlPackages.findlib
    ocamlPackages.ocaml-lsp

    dotnet-sdk
    wakatime-cli
    # microsoft-edge
    prefetch-npm-deps
    go-swag
    # ciscoPacketTracer8
    # gns3-gui
    # gns3-server
    xdg-user-dirs
    helvum
    qpwgraph
    qjackctl
    ventoy
    html-tidy
    pmutils
    notion-app-enhanced
    rar
    unrar

    # there's cve
    # unigine-valley
    # unigine-heaven
    # unigine-superposition
    phoronix-test-suite
    smem
    protobuf
    grpc-tools
    protoc-gen-go
    protoc-gen-doc
    protoc-gen-rust
    # teams
    solaar
    logitech-udev-rules
    # (vagrant.override { withLibvirt = false; })
    lutris
    tetrio-desktop
    tmate
    redis
    termshark
    wireshark
    imagemagick
    poppler-utils

    # ((vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    #   src = (builtins.fetchTarball {
    #     url =
    #       "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #     sha256 = "1b8lf6qqq6868kqzc35482ksfvzfxfhdpn2lisksjrji1qyiz06l";
    #   });
    #   version = "latest";
    # }))
    pomodoro
    prismlauncher
    calibre
    ppkgs.gimp-with-plugins
    mediainfo
    rust-script
    djvu2pdf
    djvulibre
    yarn
    xcolor
    cargo-tarpaulin
    # mods
    glow
    gum
    lxappearance
    lxqt.lxqt-config
    geckodriver
    mods
    atuin
    gImageReader
    patchelf
    libguestfs
    gpm
    scrot
    bunyan-rs
    cloudflare-warp
    iotop
    cargo-generate
    deno
    bun
    ghc
    cabal-install
    winbox
    winbox4
    libcamera
    pandoc
    texlive.combined.scheme-full
    tor-browser
    nixpacks
    license-cli
    fim
    ascii-image-converter
    # atlas
    postgresql
    dive
    pspp
    w3m
    dragon-drop
    # rocmPackages.rocminfo
    comma
    cargo-watch
    powertop
    yazi
    vesktop
    # (vesktop.override {
    #   electron = pkgs.electron_25;
    # })
    smartmontools
    nvme-cli
    chntpw
    cargo-zigbuild
    libarchive
    rpi-imager
    nix-index
    distrobox
    tree
    termscp
    quick-lint-js
    # renderdoc
    maven
    bottles
    godot3
    godot_4
    onedrive
    zig
    swi-prolog
    inetutils
    wol
    subversionClient
    hexyl
    bitwarden-desktop
    bitwarden-cli
    mpkgs.android-studio
    waifu2x-converter-cpp
    codux
    mpkgs.gleam
    erlang_26
    sidequest
    revanced-cli
    toilet
    bacon
    nixd
    evcxr
    deskreen
    ghostscript
    php83
    php83Packages.composer
    nodePackages.intelephense
    mangohud
    upkgs.bruno
    cargo-flamegraph
    measureme
    mold
    nixfmt
    # rocmPackages.hipcc
    # rocmPackages.hipify
    # rocmPackages.hip-common
    # rocmPackages.clr
    # rocmPackages.rocm-smi
    # cudaPackages.cuda_nvcc
    # cudaPackages.cudatoolkit
    sqls
    nodePackages.prettier
    # mpkgs.zluda
    nix-output-monitor
    # openai-whisper
    # mpkgs.ollama
    # semgrep
    # nodePackages.wrangler
    gfortran
    gdal
    colordiff
    wdiff
    dwdiff
    cmake-format
    cmake-language-server
    spotify
    weechat
    kdePackages.konversation
    git-filter-repo
    cargo-expand
    _86Box-with-roms
    dosbox
    open-watcom-bin
    libguestfs
    vlang
    cargo-bootimage
    gf
    imhex
    krita
    cargo-mommy
    parsec-bin
    devenv
    kdePackages.filelight
    dmidecode
    inotify-tools 
    pcsx2
    chafa
    nss
    nspr
    reveal-md
    autoconf
    uv
    ast-grep
    # nodePackages."@effect/language-service"
    tiled
    aseprite
    d2
  ];
}
