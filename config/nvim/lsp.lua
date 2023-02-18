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
			args = {
				"--stdin-filename",
				"$FILENAME",
				"--quiet",
				"-",
				"--line-length",
				"110",
				"--skip-string-normalization",
			},
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
