-- treesitter

-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-- parser_config.wgsl = {
-- 	install_info = {
-- 		url = "https://github.com/szebniok/tree-sitter-wgsl",
-- 		files = { "src/parser.c" },
-- 	},
-- }

vim.filetype.add({extension = {wgsl = "wgsl"}})

require("nvim-treesitter.configs").setup({
	-- ensure_installed = { "wgsl" },
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
