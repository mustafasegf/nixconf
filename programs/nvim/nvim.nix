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
          src = ./keymapconfig;
        };
      in

      with pkgs.vimPlugins; [
        # theme
        {
          plugin = dracula-vim;
          type = "lua";
          config = ''

            -- color
            vim.api.nvim_command("colorscheme dracula")
            vim.api.nvim_command("highlight Normal guibg=none ctermbg=none")
            vim.api.nvim_command("highlight WinBar guibg=#44475A")
            vim.api.nvim_command("highlight WinSeparator guifg=None")
            vim.api.nvim_command("highlight NvimTreeVertSplit guibg=None")
          '';
        }

        #keymap
        {
          plugin = keymapConfig;
          type = "lua";
          config = ''

            -- keymap
            -- change leader
            vim.g.mapleader = " "
            vim.keymap.set("n", "<space", "<nop>", { silent = true })

            -- resize buffer
            vim.keymap.set("n", "<leader>m", ":MaximizerToggle<CR>")

            vim.keymap.set("n", "<C-k>", ":resize +2<CR>", { silent = true })
            vim.keymap.set("n", "<C-j>", ":resize -2<CR>", { silent = true })

            vim.keymap.set("n", "<C-l>", ":vertical resize +2<CR>", { silent = true })
            vim.keymap.set("n", "<C-h>", ":vertical resize -2<CR>", { silent = true })

            -- reload config
            vim.keymap.set("n", "<leader><leader>x", ":source $MYVIMRC<CR>")

            -- copy to clipboard
            vim.keymap.set({ "v", "n" }, "<leader>y", '"+y')
            vim.keymap.set("n", "<leader>Y", '"+yg_')

            -- paste to clipbord
            vim.keymap.set({ "v", "n" }, "<leader>p", '"+p')
            vim.keymap.set({ "v", "n" }, "<leader>P", '"+P')

            -- indent line in tab (becase of copilot :/)
            vim.keymap.set("i", "<C-i>", "  ", { silent = true })

            -- save and close buffer
            --[[ vim.keymap.set("n", "<leader>w", ':bd<CR>', {silent= true})
            vim.keymap.set("n", "<leader>s", ':w<CR>', {silent= true})
            vim.keymap.set("n", "<leader>q", ':q<CR>', {silent= true}) ]]

            -- splits
            vim.keymap.set("n", "<leader>s", ":split<CR><C-w>j", { silent = true })
            vim.keymap.set("n", "<leader>v", ":vsplit<CR><C-w>l", { silent = true })

            -- fugitive conflict resolution
            vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>", { silent = true })
            vim.keymap.set("n", "gdl", ":diffget //3<CR>", { silent = true })
            vim.keymap.set("n", "gdh", ":diffget //2<CR>", { silent = true })
          '';
        }

        #lsp
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''

            -- lsp
            -- Setup nvim-cmp.

            local tabnine = require("cmp_tabnine.config")

            tabnine:setup({
              max_lines = 1000,
              max_num_results = 5,
              sort = true,
              run_on_every_keystroke = true,
              snippet_placeholder = "..",
            })

            local source_mapping = {
              luasnip = "[Snip]",
              cmp_tabnine = "[TN]",
              nvim_lsp = "[LSP]",
              buffer = "[Buff]",
              path = "[Path]",
            }

            local lspkind = require("lspkind")
            local cmp = require("cmp")
            local lsp = require("lspconfig")

            cmp.setup({
              snippet = {
                expand = function(args)
                  require("luasnip").lsp_expand(args.body)
                end,
              },
              mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
              }),
              sources = cmp.config.sources({
                { name = "luasnip" },
                { name = "cmp_tabnine" },
                { name = "nvim_lsp" },
                { name = "buffer" },
              }),
              formatting = {
                format = function(entry, vim_item)
                  vim_item.kind = lspkind.presets.default[vim_item.kind]
                  local menu = source_mapping[entry.source.name]
                  if entry.source.name == "cmp_tabnine" then
                    if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                      menu = entry.completion_item.data.detail .. " " .. menu
                    end
                    vim_item.kind = ""
                  end
                  vim_item.menu = menu
                  return vim_item
                end,
              },
            })

            local opts = { noremap = true, silent = true }
            vim.api.nvim_set_keymap("n", "ge", ':lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>', opts)
            vim.api.nvim_set_keymap("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>", opts)
            vim.api.nvim_set_keymap("n", "]d", ":lua vim.diagnostic.goto_next()<CR>", opts)
            vim.api.nvim_set_keymap("n", "<space>q", ":lua vim.diagnostic.setloclist()<CR>", opts)

            local on_attach = function(_, bufnr)
              vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
              vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", ":lua vim.lsp.buf.declaration()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "gvd", ":vsplit <CR><C-w>l:lua vim.lsp.buf.definition()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "gsd", ":split <CR><C-w>l:lua vim.lsp.buf.definition()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":lua vim.lsp.buf.implementation()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-q>", ":lua vim.lsp.buf.signature_help()<CR>", opts)
              --[[ vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', ':lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', ':lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts) ]]
              vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>D", ":lua vim.lsp.buf.type_definition()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn", ":lua vim.lsp.buf.rename()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca", ":lua vim.lsp.buf.code_action()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":lua vim.lsp.buf.references()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fo", ":lua vim.lsp.buf.format( {timeout_ms = 5000} )<CR>", opts)
            end

            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting

            -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            require("null-ls").setup({
              -- you can reuse a shared lspconfig on_attach callback here
              --[[ on_attach = function(client, bufnr)
                on_attach(client, bufnr) ]]
              --[[ if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                  vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                      -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                      vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                  })
                end ]]
              -- end,
              sources = {
                formatting.stylua,
                formatting.prettier,
                formatting.gofumpt,
                formatting.goimports,
                formatting.jq,
                -- formatting.rustfmt,
                formatting.black.with({
                  args = { "--stdin-filename", "$FILENAME", "--quiet", "-", "--line-length", "110", "--skip-string-normalization"},
                }),
                formatting.terrafmt,
                formatting.clang_format,
                formatting.shfmt,
                formatting.fourmolu,
                formatting.statix,
              },
            })

            -- vim.api.nvim_exec([[ autocmd BufWritePost,FileWritePost *.go execute 'PrettyTag' | checktime ]], false)

            lsp.diagnosticls.setup({
              on_attach = on_attach,
            })

            -- Setup lspconfig.
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

            -- lsp.ltex.setup({
            -- 	capabilities = capabilities,
            -- 	on_attach = on_attach,
            -- 	filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "text" },
            -- 	settings = {
            -- 		ltex = {
            -- 			additionalRules = {
            -- 				languageModel = "~Downloads/ngrams/",
            -- 			},
            -- 		},
            -- 	},
            -- })

            -- local ih = require("inlay-hints")
            --
            -- ih.setup()

            lsp.clangd.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.rust_analyzer.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                rust = {
                  inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                  },
                },
              },
            })

            -- local rt = require("rust-tools")

            -- rt.setup({
            --   server = {
            --     on_attach = function(_, bufnr)
            --       -- Hover actions
            --       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            --       -- Code action groups
            --       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            --     end,
            --   },
            -- })

            lsp.hls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.gopls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.pyright.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.tsserver.setup({
              capabilities = capabilities,
              on_attach = function(c, b)
                on_attach(c, b)
              end,
              settings = {
                javascript = {
                  inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                  },
                },
                typescript = {
                  inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                  },
                },
              },
            })

            lsp.tflint.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.yamlls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.vimls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.texlab.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.html.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.emmet_ls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.tailwindcss.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              -- root_dir = function(fname)
              -- 	return lsp.util.root_pattern(
             --      "tailwind.config.cjs",
              -- 		"tailwind.config.js",
              -- 		"tailwind.config.ts",
              -- 		"tailwind.config.mjs",
              -- 		"tailwind.config.json",
              -- 		"package.json",
              -- 		"postcss.config.js",
              -- 		"postcss.config.ts",
              -- 		"postcss.config.cjs",
              -- 		"postcss.config.mjs",
              -- 		"postcss.config.json",
              -- 		".git"
              -- 	)(fname) or vim.loop.os_homedir()
              -- end,
            })

            lsp.taplo.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.graphql.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.dockerls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.bashls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.sqls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.jdtls.setup({
              cmd = { "jdtls" },
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.svelte.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.astro.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.prismals.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.rnix.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })

            lsp.jsonls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              commands = {
                Format = {
                  function()
                    vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
                  end,
                },
              },
            })
          '';
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
          config = ''

            -- nvim-tree
            vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<CR>")
            vim.keymap.set("n", "<leader>tr", ":NvimTreeRefresh<CR>")
            vim.keymap.set("n", "<leader>tn", ":NvimTreeFindFile<CR>")

            require("nvim-tree").setup({
              ignore_buffer_on_setup = true,
              view = {
                side = "right",
                width = 40,
              },
              diagnostics = {
                enable = true,
                show_on_dirs = true,
              },
            })
          '';
        }
        nvim-web-devicons

        # buffer
        {
          plugin = bufferline-nvim;
          type = "lua";
          config = ''

            -- bufferline
            -- vim.keymap.set("n", "<leader>l", ":BufferLineCycleNext<CR>")
            -- vim.keymap.set("n", "<leader>h", ":BufferLineCyclePrev<CR>")
            -- vim.keymap.set("n", "<leader>L", ":BufferLineMoveNext<CR>")
            -- vim.keymap.set("n", "<leader>H", ":BufferLineMovePrev<CR>")
            --
            -- vim.keymap.set("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>")
            -- vim.keymap.set("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>")
            -- vim.keymap.set("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>")
            -- vim.keymap.set("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>")
            -- vim.keymap.set("n", "<leader>5", ":BufferLineGoToBuffer 5<CR>")
            -- vim.keymap.set("n", "<leader>6", ":BufferLineGoToBuffer 6<CR>")
            -- vim.keymap.set("n", "<leader>7", ":BufferLineGoToBuffer 7<CR>")
            -- vim.keymap.set("n", "<leader>8", ":BufferLineGoToBuffer 8<CR>")
            -- vim.keymap.set("n", "<leader>9", ":BufferLineGoToBuffer 9<CR>")
            --
            -- require("bufferline").setup({
            -- 	options = {
            -- 		diagnostics = "nvim_lsp",
            -- 	},
            -- 	theme = require("lualine-theme").theme(),
            -- })
          '';
        }
        {

          plugin = toggleterm-nvim;
          type = "lua";
          config = ''
          
            -- toggleterm
            require("toggleterm").setup({
              -- size can be a number or function which is passed the current terminal
              size = 10,
              open_mapping = [[<c-\>]],
              hide_numbers = true, -- hide the number column in toggleterm buffers
              shade_filetypes = {},
              shade_terminals = true,
              shading_factor = "0.5", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
              start_in_insert = true,
              insert_mappings = true, -- whether or not the open mapping applies in insert mode
              persist_size = true,
              direction = "horizontal",
              close_on_exit = true, -- close the terminal window when the process exits
              shell = vim.o.shell, -- change the default shell
              -- This field is only relevant if direction is set to 'float'
            })
            function _G.set_terminal_keymaps()
              local opts = { noremap = true }
              vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
              vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
              vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
              vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
              vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
              vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
            end

            -- if you only want these mappings for toggle term use term://*toggleterm#* instead
            vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
          '';
        }

        #cosmetic
        {
          plugin = indent-blankline-nvim;
          type = "lua";
          config = ''

            -- indent-blankline
            vim.opt.termguicolors = true

            vim.api.nvim_command("highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine")
            vim.api.nvim_command("highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine")
            vim.api.nvim_command("highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine")
            vim.api.nvim_command("highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine")
            vim.api.nvim_command("highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine")
            vim.api.nvim_command("highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine")

            --[[ vim.opt.list = true
            vim.opt.listchars:append("space:⋅")
            vim.opt.listchars:append("eol:↴") ]]

            require("indent_blankline").setup({
              space_char_blankline = " ",
              char_highlight_list = {
                "IndentBlanklineIndent1",
                "IndentBlanklineIndent2",
                "IndentBlanklineIndent3",
                "IndentBlanklineIndent4",
                "IndentBlanklineIndent5",
                "IndentBlanklineIndent6",
              },
            })
          '';
        }
        nvim-ts-rainbow
        {
          plugin = lualine-nvim;
          type = "lua";
          config = ''

          -- lualine
          require("lualine").setup({
            options = {
              globalstatus = true,
            },
          })
          '';
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
          config = ''

          -- gitsigns
          require("gitsigns").setup({
            signs = {
              add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
              change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
              delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
              topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
              changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
              interval = 1000,
              follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
              virt_text = false,
              virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
              delay = 300,
              ignore_whitespace = false,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000,
            preview_config = {
              -- Options passed to nvim_open_win
              border = "single",
              style = "minimal",
              relative = "cursor",
              row = 0,
              col = 1,
            },
            yadm = {
              enable = false,
            },
            on_attach = function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- Navigation
              map("n", "]c", function()
                if vim.wo.diff then
                  return "]c"
                end
                vim.schedule(function()
                  gs.next_hunk()
                end)
                return "<Ignore>"
              end, { expr = true })

              map("n", "[c", function()
                if vim.wo.diff then
                  return "[c"
                end
                vim.schedule(function()
                  gs.prev_hunk()
                end)
                return "<Ignore>"
              end, { expr = true })

              -- Actions
              -- map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
              -- map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
              -- map('n', '<leader>hS', gs.stage_buffer)
              -- map('n', '<leader>hu', gs.undo_stage_hunk)
              -- map('n', '<leader>hR', gs.reset_buffer)
              -- map('n', '<leader>hp', gs.preview_hunk)
              -- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
              -- map('n', '<leader>hd', gs.diffthis)
              -- map('n', '<leader>hD', function() gs.diffthis('~') end)
              map("n", "<leader>tb", gs.toggle_current_line_blame)
              map("n", "<leader>td", gs.toggle_deleted)

              -- Text object
              map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
          })

          vim.g.blamer_enabled = 1
          '';

        }
        trouble-nvim

        #addon app
        vim-dadbod-ui
        vim-dadbod
        {
          plugin = rest-nvim;
          type = "lua";
          config = ''

          -- rest.nvim
          vim.keymap.set("n", "<leader>rr", "<Plug>RestNvim")
          vim.keymap.set("n", "<leader>rp", "<Plug>RestNvimPrevw")
          vim.keymap.set("n", "<leader>rl", "<Plug>RestNvimLast")

          require("rest-nvim").setup({
            -- Open request results in a horizontal split
            result_split_horizontal = false,
            -- Skip SSL verification, useful for unknown certificates
            skip_ssl_verification = false,
            -- Highlight request on run
            highlight = {
              enabled = true,
              timeout = 150,
            },
            result = {
              -- toggle showing URL, HTTP info, headers at top the of result window
              show_url = true,
              show_http_info = true,
              show_headers = true,
            },
            -- Jump to request line on run
            jump_to_request = false,
            env_file = ".env",
            custom_dynamic_variables = {},
            yank_dry_run = true,
          })
         '';
        }

        #auto
        cmp-tabnine
        copilot-vim
        {
          plugin = nvim-autopairs;
          type = "lua";
          config = ''

            -- autopairs
            require("nvim-autopairs").setup({
              pairs_map = {
                ["'"] = "'",
                ['"'] = '"',
                ["("] = ")",
                ["["] = "]",
                ["{"] = "}",
                ["`"] = "`",
              },
              disable_filetype = { "TelescopePrompt" },
              break_line_filetype = nil, -- mean all file type
              check_line_pair = true,
              html_break_line_filetype = {
                "html",
                "vue",
                "typescriptreact",
                "svelte",
                "javascriptreact",
              },
              ignored_next_char = "%w",
            })
          '';

        }

        #quality of life
        {
          plugin = comment-nvim;
          type = "lua";
          config = ''

            -- comment
            require("Comment").setup({
              -- pre_hook = function(ctx)
              -- 	local U = require("Comment.utils")
              --
              -- 	local location = nil
              -- 	if ctx.ctype == U.ctype.blockwise then
              -- 		location = require("ts_context_commentstring.utils").get_cursor_location()
              -- 	elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
              -- 		location = require("ts_context_commentstring.utils").get_visual_start_location()
              -- 	end
              --
              -- 	return require("ts_context_commentstring.internal").calculate_commentstring({
              -- 		key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
              -- 		location = location,
              -- 	})
              -- end,
              pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
          '';
        }
        nvim-ts-context-commentstring
        nvim-ts-autotag
        vim-move
        vim-visual-multi
        vim-surround
        {
          plugin = telescope-nvim;
          type = "lua";
          config = ''

            -- telescope
            vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
            vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
            vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
            vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
            vim.keymap.set("n", "<leader>fl", ":Telescope git_files<CR>")
            vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>")
            vim.keymap.set("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case previewer=false<CR>")

            local telescope = require("telescope")
            telescope.load_extension("dap")
            -- telescope.load_extension("session-lens")
            telescope.load_extension("harpoon")
          '';
        }
        {
          plugin = auto-save-nvim;
          type = "lua";
          config = ''

            -- autosave
            require("auto-save").setup({
              enabled = true,
              execution_message = {
                message = function()
                  return "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")
                end,
                cleaning_interval = 0,
              },
              trigger_events = { "InsertLeave", "TextChanged" },
              conditions = {
                exists = true,
                filename_is_not = {},
                filetype_is_not = {},
                modifiable = true,
              },
              write_all_buffers = false,
              debounce_delay = 135,
            })
          '';
        }
        {
          plugin = refactoring-nvim;
          type = "lua";
          config = ''

            -- refactoring
            -- Remaps for the refactoring operations currently offered by the plugin
            vim.keymap.set("v", "<leader>re", ":lua require('refactoring').refactor('Extract Function')<CR>", { noremap = true, silent = true, expr = false })
            vim.keymap.set("v", "<leader>rf", ":lua require('refactoring').refactor('Extract Function To File')<CR>", { noremap = true, silent = true, expr = false })
            vim.keymap.set("v", "<leader>rv", ":lua require('refactoring').refactor('Extract Variable')<CR>", { noremap = true, silent = true, expr = false })
            vim.keymap.set("v", "<leader>ri", ":lua require('refactoring').refactor('Inline Variable')<CR>", { noremap = true, silent = true, expr = false })

            -- Extract block doesn't need visual mode
            vim.keymap.set("n", "<leader>rb", ":lua require('refactoring').refactor('Extract Block')<CR>", { noremap = true, silent = true, expr = false })
            vim.keymap.set("n", "<leader>rbf", ":lua require('refactoring').refactor('Extract Block To File')<CR>", { noremap = true, silent = true, expr = false })

            -- Inline variable can also pick up the identifier currently under the cursor without visual mode
            vim.keymap.set("n", "<leader>ri", ":lua require('refactoring').refactor('Inline Variable')<CR>", { noremap = true, silent = true, expr = false })
            '';
        }
        {
          plugin = nvim-spectre;
          type = "lua";
          config = ''

              -- spectre
              require("spectre").setup()

              vim.keymap.set("n", "<leader>fr", ":lua require('spectre').open()<CR>")
              vim.keymap.set("n", "<leader>fw", ":lua require('spectre').open_visual({select_word=true})<CR>")
              vim.keymap.set("v", "<leader>fw", ":lua require('spectre').open_visual()<CR>")
              vim.keymap.set("n", "<leader>fe", ":lua require('spectre').open_file_search()<CR>")
            '';

        }

        #session
        {
          plugin = auto-session;
          type = "lua";
          config = ''

            -- auto-session
            require("auto-session").setup({
              log_level = "info",
              auto_session_suppress_dirs = { "~/", "~/projects" },
            })
          '';
        }
        ## session-lens

        #debugger
        {
          plugin = nvim-dap;
          type = "lua";
          config = ''

            -- dap
            vim.keymap.set("n", "<F5>", ":lua require'dap'.continue() <CR>")
            vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over() <CR>")
            vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into() <CR>")
            vim.keymap.set("n", "<F4>", ":lua require'dap'.step_out() <CR>")
            vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint() <CR>")
            vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) <CR>")
            vim.keymap.set(
              "n",
              "<leader>dm",
              ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) <CR>"
            )
            vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open() <CR>")
            vim.keymap.set("n", "<leader>do", ":lua require'dapui'.toggle() <CR>")

            require("nvim-dap-virtual-text").setup()
            require("dap-go").setup()
            require("dapui").setup()

            local dap = require("dap")
            dap.adapters.cppdbg = {
              id = "cppdbg",
              type = "executable",
              command = "/home/mustafa/.local/share/ccptools/extension/debugAdapters/bin/OpenDebugAD7",
            }

            dap.configurations.c = {
              {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "''${workspaceFolder}",
                stopAtEntry = true,
                setupCommands = {
                  {
                    text = "-enable-pretty-printing",
                    description = "enable pretty printing",
                    ignoreFailures = false,
                  },
                },
              },
              {
                name = "Attach to gdbserver :1234",
                type = "cppdbg",
                request = "launch",
                MIMode = "gdb",
                miDebuggerServerAddress = "localhost:1234",
                miDebuggerPath = "/usr/bin/gdb",
                cwd = "''${workspaceFolder}",
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                setupCommands = {
                  {
                    text = "-enable-pretty-printing",
                    description = "enable pretty printing",
                    ignoreFailures = false,
                  },
                },
              },
            }
          '';
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
          config = ''

            -- harpoon
            require("harpoon").setup({
              menu = {
                width = 100,
              },
            })

            vim.keymap.set("n", "<leader>mm", ':lua require("harpoon.mark").add_file()<CR>')
            vim.keymap.set("n", "<leader>mr", ':lua require("harpoon.mark").rm_file()<CR>')
            vim.keymap.set("n", "<leader>mc", ':lua require("harpoon.mark").clear_all()<CR>')
            vim.keymap.set("n", "<leader>mf", ':lua require("harpoon.ui").toggle_quick_menu()<CR>')

            vim.keymap.set("n", "<leader>ml", ':lua require("harpoon.ui").nav_next()<CR>')
            vim.keymap.set("n", "<leader>mh", ':lua require("harpoon.ui").nav_prev()<CR>')

            vim.keymap.set("n", "<leader>fm", ":Telescope harpoon marks<CR>")
          '';
        }
        vim-sneak

        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = ''

            -- treesitter
            require("nvim-treesitter.configs").setup({
              autotag = {
                enable = true,
              },
              indent = {
                enable = true,
              },
              highlight = {
                enable = true,
              },
              incremental_selection = {
                enable = true,
              },
              textobjects = {
                enable = true,
              },
              context_commentstring = {
                enable = true,
                enable_autocmd = false,
              },
              ensure_installed = {},
              rainbow = {
                enable = true,
                extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                max_file_lines = nil, -- Do not enable for files with more than n lines, int
                colors = {
                  "#E06C75",
                  "#E5C07B",
                  "#98C379",
                  "#56B6C2",
                  "#61AFEF",
                  "#C678DD",
                }, -- table of hex strings
                -- termcolors = {} -- table of colour name strings
              },
              playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
              },
            })
          '';
        }
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

      # lua require("start")
    '';
  };
}
