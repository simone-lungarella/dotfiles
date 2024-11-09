require('dapui').setup()
require('nvim-dap-virtual-text').setup(_)
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

-- Debugger
vim.api.nvim_set_keymap('n', '<leader>da', ':DapContinue<CR>', { noremap = false })

-- vim.api.nvim_set_keymap('n', '<F5>', ':DapContinue<CR>', { noremap = false })
vim.api.nvim_set_keymap('n', '<F8>', ':DapStepOver<CR>', { noremap = false })
vim.api.nvim_set_keymap('n', '<F7>', ':DapStepInto<CR>', { noremap = false })
vim.api.nvim_set_keymap('n', '<S-F8>', ':DapStepOut<CR>', { noremap = false })

vim.api.nvim_set_keymap('n', '<leader>dt', ':DapUiToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>db', ':DapToggleBreakpoint<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':DapContinue<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dr', ":lua require('dapui').open({reset = true})<CR>", { noremap = true })

local dap = require 'dap'
dap.adapters.java = {
  type = 'server',
  host = '127.0.0.1',
  port = 5005,
}

dap.configurations.java = {
  {
    type = 'java',
    name = 'Debug (Attach)',
    request = 'attach',
    hostName = '127.0.0.1',
    port = 5005,
  },
}

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
