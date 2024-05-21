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
  ["vim-dadbod-completion"] = "[DB]",
	nvim_lsp = "[LSP]",
	otter = "[Otter]",
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
		{ name = "otter" },
		{ name = "vim-dadbod-completion" },
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

local on_attach = function(client, bufnr)
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

require("null-ls").setup({
	sources = {
		formatting.stylua,
		formatting.prettier,
		formatting.gofumpt,
		formatting.goimports,
		formatting.jq,
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
		formatting.nixfmt,
		formatting.cmake_format,
		-- formatting.statix,
	},
})

-- vim.api.nvim_exec([[ autocmd BufWritePost,FileWritePost *.go execute 'PrettyTag' | checktime ]], false)

lsp.diagnosticls.setup({
	on_attach = on_attach,
})

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
-- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
-- for _, ls in ipairs(language_servers) do
-- 	require("lspconfig")[ls].setup({
-- 		capabilities = capabilities,
-- 		-- you can add other fields for setting up lsp server in this table
-- 	})
-- end
-- require("ufo").setup()

-- vim.api.nvim_command(
-- 	"autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })"
-- )

require("lsp-inlayhints").setup()
vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = "LspAttach_inlayhints",
	callback = function(args)
		if not (args.data and args.data.client_id) then
			return
		end

		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>h", ":lua require('lsp-inlayhints').toggle()<CR>", opts)
		require("lsp-inlayhints").on_attach(client, bufnr)
	end,
})

local servers = {
	"clangd",
	"hls",
	"gopls",
	"pyright",
	"tflint",
	"yamlls",
	"vimls",
	"texlab",
	"html",
	"emmet_ls",
	"tailwindcss",
	"taplo",
	"graphql",
	"dockerls",
	"bashls",
	-- "sqlls",
	-- "jdtls",
	"svelte",
	"astro",
	"prismals",
	"ocamllsp",
	"nixd",
	-- "grammarly",
	"wgsl_analyzer",
	"quick_lint_js",
	"intelephense",
  "cmake",
}

for _, server in ipairs(servers) do
	lsp[server].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

-- Update this path
local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb"
local this_os = vim.loop.os_uname().sysname

-- The path in windows is different
if this_os:find("Windows") then
	codelldb_path = extension_path .. "adapter\\codelldb.exe"
	liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
else
	-- The liblldb extension is .so for linux and .dylib for macOS
	liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

require("rust-tools").setup({
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
	tools = {
		inlay_hints = {
			auto = false,
		},
	},
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
})

lsp.tsserver.setup({
	capabilities = capabilities,
	on_attach = function(c, b)
		on_attach(c, b)
	end,
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
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

-- local jdtls = require('jdtls')
-- jdtls.start_or_attach({})

-- lsp.sqls.setup({
-- 	capabilities = capabilities,
-- 	on_attach = function(client, bufnr)
-- 		require("sqls").on_attach(client, bufnr)
-- 		on_attach(client, bufnr)
-- 	end,
-- 	-- on_attach = on_attach,
-- })

-- api.nvim_create_user_command('QuartoPreview', quarto.quartoPreview, { nargs = '*' })
-- api.nvim_create_user_command('QuartoClosePreview', quarto.quartoClosePreview, {})
-- api.nvim_create_user_command('QuartoActivate', quarto.activate, {})
-- api.nvim_create_user_command('QuartoHelp', quarto.searchHelp, { nargs = 1 })
-- vim.api.nvim_create_user_command('QuartoHover', ':lua require"otter".ask_hover()<cr>', {})
