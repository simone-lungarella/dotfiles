-- buffers
vim.api.nvim_set_keymap('n', 'th', ':bprev<enter>', { noremap = false })
vim.api.nvim_set_keymap('n', 'tl', ':bnext<enter>', { noremap = false })
vim.api.nvim_set_keymap('n', 'td', ':bdelete<enter>', { noremap = false })

-- files
vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })

-- splits
vim.api.nvim_set_keymap('n', '<C-W>,', ':vertical resize -10<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-W>.', ':vertical resize +10<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', 'n', 'nzzzv', { noremap = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Lsp
vim.api.nvim_set_keymap('n', 'gI', "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', "<cmd>lua require('telescope.builtin').lsp_references()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>D', "<cmd> lua require('telescope.builtin').lsp_type_definitions()<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<M-f>', '<Cmd>lua vim.lsp.buf.format()<CR>', { noremap = false })
