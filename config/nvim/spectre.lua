-- spectre
require("spectre").setup()

vim.keymap.set("n", "<leader>fr", ":lua require('spectre').open()<CR>")
vim.keymap.set("n", "<leader>fw", ":lua require('spectre').open_visual({select_word=true})<CR>")
vim.keymap.set("v", "<leader>fw", ":lua require('spectre').open_visual()<CR>")
vim.keymap.set("n", "<leader>fe", ":lua require('spectre').open_file_search()<CR>")
