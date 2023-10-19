-- telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
vim.keymap.set("n", "<leader>fl", ":Telescope git_files<CR>")
vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>")
vim.keymap.set(
	"n",
	"<leader>fc",
	":Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case previewer=false<CR>"
)

local telescope = require("telescope")
telescope.load_extension("dap")
-- telescope.load_extension("session-lens")
-- telescope.load_extension("harpoon")
