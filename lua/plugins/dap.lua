return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local ui = require("dapui")

		ui.setup()
		require("nvim-dap-virtual-text").setup()

		local ensure_installed = {
			"codelldb",
		}

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
				args = { "--port", "${port}" },

				-- On windows you may have to uncomment this:
				-- detached = false,
			},
		}

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "set [D]ebug [B]reakpoint" })
		vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Step over" })
		vim.keymap.set("n", "<F3>", dap.step_into, { desc = "Step into" })
		vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Step out" })
		vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Step back" })
		vim.keymap.set("n", "<F6>", dap.continue, { desc = "Continue debugger" })
		vim.keymap.set("n", "<F7>", dap.restart, { desc = "Restart debugger" })

		vim.keymap.set("n", "<leader>d?", function()
			ui.eval(nil, { enter = true })
		end, { desc = "Inspect value in debugger" })

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end
	end,
}
