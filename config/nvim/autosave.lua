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
