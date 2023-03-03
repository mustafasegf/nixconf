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
        {
          plugin = (pluginGit "lvimuser" "lsp-inlayhints.nvim" "master" "0fx0swsagjdng9m9x73wkfqnk464qk63q9wi32rhywllbm7gsflf");
          type = "lua";
        }

        #language spesific
        {
          plugin = (pluginGit "ray-x" "go.nvim" "master" "z65o3cOoxWILDKjEUWNTK1X7riQjxAS7BGeo29049Ms=");
          type = "lua";
        }
        {
          plugin = (pluginGit "mechatroner" "rainbow_csv" "master" "kNjEjIOyWViQ6hLyTwP9no7ZF0Iv/TGW0oXPlBM4eu4=");
        }
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
        {
          plugin = (pluginGit "szw" "vim-maximizer" "master" "+VPcMn4NuxLRpY1nXz7APaXlRQVZD3Y7SprB/hvNKww=");
        }

        #misc
        popup-nvim
        plenary-nvim
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
        # vim-wakatime
      ];
  };
}
