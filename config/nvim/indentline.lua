-- indent-blankline
vim.opt.termguicolors = true

local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}

-- local hooks = require("ibl.hooks")
-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
-- 	vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#E06C75" })
-- 	vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#E5C07B" })
-- 	vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg = "#98C379" })
-- 	vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg = "#56B6C2" })
-- 	vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg = "#61AFEF" })
-- 	vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { fg = "#C678DD" })
-- end)

require("ibl").setup({
	scope = { enabled = false },
	indent = { highlight = highlight },
})
