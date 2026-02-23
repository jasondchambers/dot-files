return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python", -- Python-specific DAP config
      "rcarriga/nvim-dap-ui",         -- visual debugging UI
      "nvim-neotest/nvim-nio",        -- required by dap-ui
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      -- Setup dap-ui (variable inspector, call stack, breakpoints, REPL)
      dapui.setup()

      -- Auto open/close the UI when debugging starts/stops
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Setup Python debugging with debugpy
      -- Prefer .venv in the project root so project dependencies are available;
      -- fall back to the debugpy installed by Mason.
      local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
      local mason_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local python_path = vim.fn.executable(venv_python) == 1 and venv_python or mason_python
      dap_python.setup(python_path)

      -- Add a launch config that prompts for arguments (e.g. "Trimedx")
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch file with arguments",
        program = "${file}",
        args = function()
          local input = vim.fn.input("Arguments: ")
          return vim.split(input, " ", { trimempty = true })
        end,
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue debugging" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart debugging" })
      vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate debugging" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle debug UI" })
    end,
  },
}
