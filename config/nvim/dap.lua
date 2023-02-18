-- dap
vim.keymap.set("n", "<F5>", ":lua require'dap'.continue() <CR>")
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over() <CR>")
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into() <CR>")
vim.keymap.set("n", "<F4>", ":lua require'dap'.step_out() <CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint() <CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) <CR>")
vim.keymap.set(
	"n",
	"<leader>dm",
	":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) <CR>"
)
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open() <CR>")
vim.keymap.set("n", "<leader>do", ":lua require'dapui'.toggle() <CR>")

require("nvim-dap-virtual-text").setup()
require("dap-go").setup()
require("dapui").setup()

local dap = require("dap")
dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "/home/mustafa/.local/share/ccptools/extension/debugAdapters/bin/OpenDebugAD7",
}

dap.configurations.c = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = true,
		setupCommands = {
			{
				text = "-enable-pretty-printing",
				description = "enable pretty printing",
				ignoreFailures = false,
			},
		},
	},
	{
		name = "Attach to gdbserver :1234",
		type = "cppdbg",
		request = "launch",
		MIMode = "gdb",
		miDebuggerServerAddress = "localhost:1234",
		miDebuggerPath = "/usr/bin/gdb",
		cwd = "${workspaceFolder}",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		setupCommands = {
			{
				text = "-enable-pretty-printing",
				description = "enable pretty printing",
				ignoreFailures = false,
			},
		},
	},
}
