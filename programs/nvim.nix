{ config
, pkgs
, libs
, ...
}: {

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins =
      let
        pluginGit = owner: repo: rev: sha256: pkgs.vimUtils.buildVimPluginFrom2Nix {

          pname = repo;
          version = rev;
          src = pkgs.fetchFromGitHub {
            owner = owner;
            repo = repo;
            rev = rev;
            sha256 = sha256;
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
          plugin = (pluginGit "APZelos" "blamer.nvim" "master" "etLCmzOMi7xjYc43ZBqjPnj2gqrrSbmtcKdw6eZT8rM=");
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

        # (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
        nvim-treesitter.withAllGrammars
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
