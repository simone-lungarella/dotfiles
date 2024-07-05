vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
-- buffers
vim.api.nvim_set_keymap("n", "tk", ":blast<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "tj", ":bfirst<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "th", ":bprev<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "tl", ":bnext<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "td", ":bdelete<enter>", { noremap = false })

-- files
vim.api.nvim_set_keymap("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- splits
vim.api.nvim_set_keymap("n", "<C-W>,", ":vertical resize -10<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-W>.", ":vertical resize +10<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true })
vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set("n", "<leader>ee", "<cmd>GoIfErr<cr>",
  { silent = true, noremap = true }
)

-- Lsp
vim.api.nvim_set_keymap('n', 'gI', "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', "<cmd>lua require('telescope.builtin').lsp_references()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>D', "<cmd> lua require('telescope.builtin').lsp_type_definitions()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ds', "<cmd> lua require('telescope.builtin').lsp_document_symbols()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ws', "<cmd> lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>",
  { noremap = true, silent = true })
