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
