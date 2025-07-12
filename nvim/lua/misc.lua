-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_set_hl(0, 'YankHighlight', { bg = '#fab387', fg = '#000000', bold = true })

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { higroup = 'YankHighlight', timeout = 100 }
  end,
  group = highlight_group,
  pattern = '*',
})


-- Always enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.api.nvim_create_augroup("NumberToggle", { clear = true })

-- Turn off relative numbers in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "NumberToggle",
  callback = function()
    vim.opt.relativenumber = false
  end,
})

-- Turn relative numbers back on when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  group = "NumberToggle",
  callback = function()
    vim.opt.relativenumber = true
  end,
})
