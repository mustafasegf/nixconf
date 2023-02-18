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

        keymapConfig = pkgs.vimUtils.buildVimPlugin {
          name = "keymap-config";
          src = ../config/nvim/keymapconfig;
        };

        config = pkgs.vimUtils.buildVimPlugin {
          name = "config";
          src = ../config/nvim/config;
        };
      in

      with pkgs.vimPlugins; [
        {
          plugin = config;
          type = "lua";
          config = builtins.readFile ../config/nvim/config.lua;
        }
        # theme
        {
          plugin = dracula-vim;
          type = "lua";
          config = builtins.readFile ../config/nvim/color.lua;
        }

        #keymap
        {
          plugin = keymapConfig;
          type = "lua";
          config = builtins.readFile ../config/nvim/keymap.lua;
        }

        #lsp
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ../config/nvim/lsp.lua;
        }
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
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ../config/nvim/filetree.lua;
        }
        nvim-web-devicons

        # buffer
        {
          plugin = bufferline-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/bufferline.lua;
        }
        {

          plugin = toggleterm-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/toggleterm.lua;
        }

        #cosmetic
        {
          plugin = indent-blankline-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/indentline.lua;
        }
        nvim-ts-rainbow
        {
          plugin = lualine-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/lualine.lua;
        }
        {
          plugin = nvim-colorizer-lua;
          type = "lua";
          config = ''

            -- nvim-colorizer
            require("colorizer").setup()
          '';
        }

        #git
        octo-nvim
        vim-fugitive
        {
          plugin = (pluginGit "APZelos" "blamer.nvim" "master" "etLCmzOMi7xjYc43ZBqjPnj2gqrrSbmtcKdw6eZT8rM=");
          type = "lua";
        }
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/gitsigns.lua;
        }
        trouble-nvim

        #addon app
        vim-dadbod-ui
        vim-dadbod
        {
          plugin = rest-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/rest.lua;
        }

        #auto
        cmp-tabnine
        copilot-vim
        {
          plugin = nvim-autopairs;
          type = "lua";
          config = builtins.readFile ../config/nvim/autopairs.lua;
        }

        #quality of life
        {
          plugin = comment-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/comment.lua;
        }
        nvim-ts-context-commentstring
        nvim-ts-autotag
        vim-move
        vim-visual-multi
        vim-surround
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/telescope.lua;
        }
        {
          plugin = auto-save-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/autosave.lua;
        }
        {
          plugin = refactoring-nvim;
          type = "lua";
          config = builtins.readFile ../config/nvim/refactoring.lua;
        }
        {
          plugin = nvim-spectre;
          type = "lua";
          config = builtins.readFile ../config/nvim/spectre.lua;
        }

        #session
        {
          plugin = auto-session;
          type = "lua";
          config = builtins.readFile ../config/nvim/session.lua;
        }
        ## session-lens

        #debugger
        {
          plugin = nvim-dap;
          type = "lua";
          config = builtins.readFile ../config/nvim/dap.lua;
        }
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
        {
          plugin = harpoon;
          type = "lua";
          config = builtins.readFile ../config/nvim/harpoon.lua;
        }
        vim-sneak

        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = builtins.readFile ../config/nvim/treesitter.lua;
        }
      ];
  };
}
