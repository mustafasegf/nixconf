-- refactoring
-- Remaps for the refactoring operations currently offered by the plugin
vim.keymap.set(
	"v",
	"<leader>re",
	":lua require('refactoring').refactor('Extract Function')<CR>",
	{ noremap = true, silent = true, expr = false }
)
vim.keymap.set(
	"v",
	"<leader>rf",
	":lua require('refactoring').refactor('Extract Function To File')<CR>",
	{ noremap = true, silent = true, expr = false }
)
vim.keymap.set(
	"v",
	"<leader>rv",
	":lua require('refactoring').refactor('Extract Variable')<CR>",
	{ noremap = true, silent = true, expr = false }
)
vim.keymap.set(
	"v",
	"<leader>ri",
	":lua require('refactoring').refactor('Inline Variable')<CR>",
	{ noremap = true, silent = true, expr = false }
)

-- Extract block doesn't need visual mode
vim.keymap.set(
	"n",
	"<leader>rb",
	":lua require('refactoring').refactor('Extract Block')<CR>",
	{ noremap = true, silent = true, expr = false }
)
vim.keymap.set(
	"n",
	"<leader>rbf",
	":lua require('refactoring').refactor('Extract Block To File')<CR>",
	{ noremap = true, silent = true, expr = false }
)

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.keymap.set(
	"n",
	"<leader>ri",
	":lua require('refactoring').refactor('Inline Variable')<CR>",
	{ noremap = true, silent = true, expr = false }
)
