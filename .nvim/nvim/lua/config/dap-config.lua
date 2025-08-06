local dap = require("dap")
local dapui = require("dapui")

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/usr/OpenDebugAD7/extension/debugAdapters/bin/OpenDebugAD7',
  options = {
    detached = false
  }
}

dap.configurations.cpp = {
  {
    name = "Launch with GDB",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    setupCommands = {
      {
        description = "Enable pretty-printing for gdb",
        text = "-enable-pretty-printing",
        ignoreFailures = false
      },
    },
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = 'Toggle Breakpoint'})
vim.keymap.set("n", "<Leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = 'Set Breakpoint'})
vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = 'Open REPL'})

-- Key to terminate the session
vim.keymap.set("n", "<F6>", function()
  -- Gracefully terminate the session
  dap.terminate()
  -- Optionally disconnect if terminate isn't enough
  dap.disconnect()
  -- Close dapui windows and REPL
  dapui.close()
  dap.repl.close()
end, { desc = "Terminate DAP session and clean up" })

-- Set the breakpoint appearance
vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#5b70da', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPoint',  { fg = '#61afef', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapStopped',   { fg = '#98c379', bg = '#31353f' })
vim.fn.sign_define('DapBreakpoint',          { text='●', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text='●', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',  { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapLogPoint',            { text='◆', texthl='DapLogPoint', linehl='DapLogPoint', numhl='DapLogPoint' })
vim.fn.sign_define('DapStopped',             { text='', texthl='DapStopped', linehl='DapStopped', numhl='DapStopped' })

