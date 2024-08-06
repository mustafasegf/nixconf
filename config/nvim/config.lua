--

-- config
vim.o.number = true
vim.o.rnu = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true
-- vim.o.noerrorbells = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.expand("~/.vim/undodir")
vim.o.undofile = true
vim.o.incsearch = true
vim.o.scrolloff = 12
vim.o.showmode = false
vim.o.signcolumn = "yes:2"
vim.o.completeopt = "menuone,noinsert"
vim.o.cmdheight = 1
vim.o.updatetime = 50
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.termguicolors = true
vim.o.pumblend = 15
vim.o.mouse = "a"
vim.o.winbar = "%=%{expand('%:~:.')}"
vim.cmd("syntax on")

vim.api.nvim_create_user_command("BufOnly", function()
	pcall(function()
		vim.cmd("%bd|e#|bd#")
	end)
end, { desc = "Close all buffer except this buffer" })
