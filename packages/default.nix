{ ppkgs, pkgs, upkgs, pypi-fetcher, ... }: {
  packages = with pkgs; [
    vim

    neovim
    vscode-fhs
    # (vscode-with-extensions.override {
    #   vscodeExtensions = with vscode-extensions; [
    #
    #   ];
    # })

    wget
    glxinfo

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
    nvtop
    p7zip
    pinta
    postman
    qpwgraph
    libsForQt5.qt5ct
    libsForQt5.okular
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
    (
      let
        packagePypi = name: ver: ref: deps: python310.pkgs.buildPythonPackage rec {
          pname = name;
          version = ver;

          src = python310.pkgs.fetchPypi {
            inherit pname version;
            hash = ref;
          };
          # src = pypi-fetcher.fetchPypi name ver;


          buildInputs = deps;
          doCheck = false;
        };
      in
      python310.withPackages (ps: [
        # sha from nix store prefetch-file 
        (
          packagePypi
            "iwlib"
            "1.7.0"
            "sha256-qAX2WXpw7jABq6jwOft7Lct13BXE54UvVZT9Y3kZbaE="
            [ wirelesstools ps.setuptools ps.cffi ]
        )
        (
          packagePypi
            "qtile"
            "0.22.1"
            "sha256-J8PLTXQjEWIs9aJ4Fnw76Z6kdafe9dQe6GC9PoZHj4s="
            [
              pkg-config
              libinput
              wayland
              wlroots
              libxkbcommon
              ps.setuptools-scm
              ps.xcffib
              (ps.cairocffi.override { withXcffib = true; })
              ps.setuptools
              ps.python-dateutil
              ps.dbus-python
              ps.dbus-next
              ps.mpd2
              ps.psutil
              ps.pyxdg
              ps.pygobject3
              ps.pywayland
              ps.pywlroots
              ps.xkbcommon
            ]
        )
        ps.jupyterlab
        ps.ipykernel
        ps.pandas
        ps.scikitlearn
        ps.matplotlib
        ps.numpy
        ps.scipy
        ps.pip
        ps.seaborn
        ps.plotly
        ps.statsmodels

      ])
    )
    poetry
    rustup
    go
    gofumpt
    nodejs-16_x
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
    clang-tools

    black
    stylua
    gofumpt
    gotools
    ##terrafmt
    shfmt
    ##fourmolu

    gopls
    nodePackages.pyright
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
    ##jdtls
    nodePackages.svelte-language-server
    ##astro
    ##prisma
    ##jsonls
    sumneko-lua-language-server
    nodePackages.diagnostic-languageserver
    nodePackages.bash-language-server

    kdeconnect
    rnix-lsp
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
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
    dbeaver
    beekeeper-studio
    (appimage-run.override {
      extraPkgs = pkgs: [ pkgs.xorg.libxshmfence pkgs.libsecret ];
    })

    jdk11
    rclone

    llvmPackages_latest.llvm
    lldb
    llvmPackages_latest.bintools
    zlib.out
    xorriso
    grub2
    qemu
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
    minecraft
    virtualbox
    virt-manager
    qemu_full
    libreoffice
    gcc
    gdb
    gnome.gedit
    libsForQt5.kate
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
    # unstable.soundux
    fwupd
    prismlauncher
    gnome.seahorse
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
    ppkgs.blender
    nix-prefetch-scripts
    gnome.file-roller
    libsForQt5.ark
    libsForQt5.kdenlive
    qalculate-qt
    libsForQt5.kcalc
    qbittorrent
    gnome.cheese
    libsForQt5.kamoso
    alacritty
    xournalpp
    du-dust
    exa
    exercism
    # dune-release
    dune_3
    ocaml
    opam
    ocamlPackages.findlib
    ocamlPackages.ocaml-lsp

  ];
}
