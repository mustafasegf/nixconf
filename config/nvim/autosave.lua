-- autosave
require("auto-save").setup({
	enabled = true,
	execution_message = {
		message = function()
			return "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")
		end,
		cleaning_interval = 0,
	},
	-- trigger_events = { "InsertLeave", "TextChanged" },
	trigger_events = { -- See :h events
		immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
		defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
		cancel_defered_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
	},
	conditions = {
		exists = true,
		filename_is_not = {},
		filetype_is_not = {},
		modifiable = true,
	},
	write_all_buffers = false,
	noautocmd = false, -- do not execute autocmds when saving
	lockmarks = false, -- lock marks when saving, see `:h lockmarks` for more details
	debounce_delay = 135,
})
