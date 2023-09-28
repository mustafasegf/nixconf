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

-- Update this path
local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb"
local this_os = vim.loop.os_uname().sysname

-- The path in windows is different
if this_os:find("Windows") then
	codelldb_path = extension_path .. "adapter\\codelldb.exe"
	liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
else
	-- The liblldb extension is .so for linux and .dylib for macOS
	liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

local dap = require("dap")

dap.adapters.codelldb = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "/home/mustafa/.local/share/ccptools/extension/debugAdapters/bin/OpenDebugAD7",
}

-- dap.adapters.codelldb = {
-- 	type = "server",
-- 	host = "127.0.0.1",
-- 	port = 13000,
-- }

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

dap.configurations.cpp = dap.configurations.c

-- dap.configurations.rust = {
-- 	{
-- 		name = "Rust debug",
-- 		type = "codelldb",
-- 		request = "launch",
-- 		program = function()
-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
-- 		end,
-- 		cwd = "${workspaceFolder}",
-- 		stopOnEntry = true,
-- 	},
-- }

dap.configurations.rust = {
	{
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		terminal = "integrated",
		sourceLanguages = { "rust" },
	},
}
