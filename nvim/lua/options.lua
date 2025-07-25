-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

-- Disable mouse mode
vim.o.mouse = ''

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
--vim.cmd [[colorscheme onedark]]
vim.cmd.colorscheme 'catppuccin'

vim.opt.clipboard = 'unnamedplus'
vim.api.nvim_set_option_value('clipboard', 'unnamedplus', {})

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.conceallevel = 0

-- Preferences
vim.opt.wrap = false
vim.opt.wrapscan = true
vim.opt.scrolloff = 11
-- vim.opt.colorcolumn = '120'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.editorconfig = false
