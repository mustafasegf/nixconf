{ config, pkgs, libs, ... }: {

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = let
      pluginGit = owner: repo: rev: sha256:
        pkgs.vimUtils.buildVimPluginFrom2Nix {

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

    in with pkgs.vimPlugins; [
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
      markdown-preview-nvim
      nvim-jdtls

      {
        plugin = (pluginGit "lvimuser" "lsp-inlayhints.nvim" "master"
          "0fx0swsagjdng9m9x73wkfqnk464qk63q9wi32rhywllbm7gsflf");
        type = "lua";
      }

      {
        plugin = (pluginGit "nanotee" "sqls.nvim" "main"
          "sha256-jKFut6NZAf/eIeIkY7/2EsjsIhvZQKCKAJzeQ6XSr0s=");
        type = "lua";
      }

      #language spesific
      ## idk some issues
      # {
      #   plugin = (pluginGit "ray-x" "go.nvim" "master"
      #     "z65o3cOoxWILDKjEUWNTK1X7riQjxAS7BGeo29049Ms=");
      #   type = "lua";
      # }
      {
        plugin = (pluginGit "mechatroner" "rainbow_csv" "master"
          "kNjEjIOyWViQ6hLyTwP9no7ZF0Iv/TGW0oXPlBM4eu4=");
      }
      {
        plugin = (pluginGit "kiyoon" "jupynium.nvim" "master"
          "HJrg+Jun4CxXKBgKEQGnF/EjyrXjJMwLexCCrnXA0+Y=");
        type = "lua";
        config = builtins.readFile ../config/nvim/jupyter.lua;
      }
      dressing-nvim
      rust-tools-nvim
      nvim-notify
      vim-android
      neoconf-nvim

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
      rainbow-delimiters-nvim
      promise-async
      {
        plugin = nvim-ufo;
        type = "lua";
        config = builtins.readFile ../config/nvim/fold.lua;
      }

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
        plugin = (pluginGit "APZelos" "blamer.nvim" "master"
          "etLCmzOMi7xjYc43ZBqjPnj2gqrrSbmtcKdw6eZT8rM=");
        type = "lua";
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ../config/nvim/gitsigns.lua;
      }
      {
        plugin = trouble-nvim;
        type = "lua";
        config = "require('trouble').setup()";
      }
      

      #addon app
      vim-dadbod
      vim-dadbod-ui
      # vim-dadbod-completion
      (vim-dadbod-completion.overrideAttrs (old: {
        patchPhase = ''
          substituteInPlace autoload/vim_dadbod_completion.vim \
            --replace "['sql', 'mysql', 'plsql']" \
                      "['sql', 'mysql', 'plsql', 'rust']"

            substituteInPlace autoload/vim_dadbod_completion/compe.vim \
            --replace "['sql', 'mysql', 'plsql']" \
                      "['sql', 'mysql', 'plsql', 'rust']"

            substituteInPlace plugin/vim_dadbod_completion.vim \
            --replace "sql,mysql,plsql" \
                      "sql,mysql,plsql,rust"

        '';
      }))

      otter-nvim
      # {
      #   plugin = rest-nvim;
      #   type = "lua";
      #   config = builtins.readFile ../config/nvim/rest.lua;
      # }

      #auto
      cmp-tabnine
      # copilot-vim
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
      { plugin = nvim-ts-context-commentstring; }
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
        plugin = (pluginGit "szw" "vim-maximizer" "master"
          "+VPcMn4NuxLRpY1nXz7APaXlRQVZD3Y7SprB/hvNKww=");
      }

      #misc
      popup-nvim
      plenary-nvim
      registers-nvim
      vim-suda
      nui-nvim
      # {
      #   plugin = (pluginGit "amitds1997" "remote-nvim.nvim" "main"
      #     "yU9eqb4YSSnJ/tgsqq/P/LQBz/yJCwbQJhPoqYBOlaY=");
      #   type = "lua";
      #   config = ''require("remote-nvim").setup()'';
      # }
      {
        plugin = harpoon;
        type = "lua";
        config = builtins.readFile ../config/nvim/harpoon.lua;
      }
      vim-sneak
      {
        plugin = nvim-config-local;
        type = "lua";
        config = builtins.readFile ../config/nvim/local.lua;
      }

      {
        plugin = (pluginGit "VonHeikemen" "fine-cmdline.nvim" "main"
          "w9wwjClkOWk3wCgEiZIFLZRJ/gAfX38x2LnVRaelKD8=");
        type = "lua";
        config = ''
          vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})
          -- vim.api.nvim_set_keymap('v', ':', '<cmd>FineCmdline<CR>', {noremap = true})
        '';
      }
      {
        plugin = (pluginGit "marilari88" "twoslash-queries.nvim" "main"
          "QlzfWZg8v0N19SmwPquWjCc/nsWAeOLeri5iMXOIueA=");
        type = "lua";
      }

      playground
      {
        plugin = (nvim-treesitter.withPlugins (_:
          nvim-treesitter.allGrammars ++ [
            nvim-treesitter-parsers.wgsl
            nvim-treesitter-parsers.astro

            # (pkgs.tree-sitter.buildGrammar
            #   {
            #     language = "wgsl";
            #     version = "40259f3";
            #     src = pkgs.fetchFromGitHub {
            #       owner = "szebniok";
            #       repo = "tree-sitter-wgsl";
            #       rev = "40259f3c77ea856841a4e0c4c807705f3e4a2b65";
            #       sha256 = "sha256-voLkcJ/062hzipb3Ak/mgQvFbrLUJdnXq1IupzjMJXA=";
            #     };
            #   })
            # (pkgs.tree-sitter.buildGrammar {
            #   language = "astro";
            #   version = "e122a8f";
            #   src = pkgs.fetchFromGitHub {
            #     owner = "virchau13";
            #     repo = "tree-sitter-astro";
            #     rev = "e122a8fcd07e808a7b873bfadc2667834067daf1";
            #     sha256 = "sha256-iCVRTX2fMW1g40rHcJEwwE+tfwun+reIaj5y4AFgmKk=";
            #   };
            # })
          ]));
        type = "lua";
        config = builtins.readFile ../config/nvim/treesitter.lua;
      }
      (vim-wakatime.overrideAttrs (old: {
        patchPhase = ''
          # Move the BufEnter hook from the InitAndHandleActivity call
          # to the common HandleActivity call. This is necessary because
          # InitAndHandleActivity prompts the user for an API key if
          # one is not found, which breaks the remote plugin manifest
          # generation.
          substituteInPlace plugin/wakatime.vim \
            --replace 'autocmd BufEnter,VimEnter' \
                      'autocmd VimEnter' \
            --replace 'autocmd CursorMoved,CursorMovedI' \
                      'autocmd CursorMoved,CursorMovedI,BufEnter'
        '';
        configurePhase = ''
          export 
        '';
      }))
    ];
  };
}
