---@diagnostic disable: undefined-global

-- Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.wrapscan = true
vim.o.scrolloff = 11
vim.o.conceallevel = 0
vim.o.completeopt = 'menuone,noselect'
vim.o.winborder = 'rounded'
vim.o.clipboard = 'unnamedplus'
vim.bo.expandtab = true
vim.wo.signcolumn = 'no'
vim.g.mapleader = ' '

vim.api.nvim_set_option_value('clipboard', 'unnamedplus', {})

-- Plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    -- Theme
    { "EdenEast/nightfox.nvim",
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = true,
                    terminal_colors = true,
                },
                groups = {
                    all = {
                        NormalFloat = { bg = "NONE" },
                        FloatBorder = { bg = "NONE" },
                        Pmenu = { bg = "NONE" },
                        PmenuSel = { bg = "#5e81ac", fg = "#eceff4" },
                    },
                },
            })
        end,
    },
    { "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    },
    { 'cameron-wags/rainbow_csv.nvim',
        config = true,
        ft = {
            'csv',
        }
    },
    {
        'junegunn/fzf',
        build = './install --bin',
        config = function()
            vim.env.FZF_DEFAULT_COMMAND = table.concat({
                "rg --files",
                "--glob '!*.class'",
                "--glob '!*.import'",
                "--glob '!*.cfg'",
                "--glob '!*.uid'",
                "--glob '!.godot/**'",
                "--glob '!.import/**'",
            }, " ")
        end,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup()
        end,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'mfussenegger/nvim-jdtls', -- Java LSP, ikr?
        },
    },
    {
        'nvim-lualine/lualine.nvim', -- Status line
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    component_separators = '|',
                    section_separators = '',
                },
                sections = {
                    lualine_x = {},
                    lualine_a = {
                        {
                            'buffers',
                        },
                    },
                    lualine_c = {},
                },
            }
        end
    },
}

-- LSP — JDTLS has its own file configuration because lombok does not work out of the box.
vim.lsp.enable({ 'lua_ls', 'clangd', 'pyright', 'bashls' })

-- Keymaps
vim.keymap.set('n', '<M-f>', vim.lsp.buf.format, { desc = 'Format buffer' })
vim.keymap.set('n', 'td', ':bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', 'th', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', 'tl', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', 'dq', vim.diagnostic.setqflist, { desc = 'Diagnostics to quickfix' })
vim.keymap.set('n', 'dK', vim.diagnostic.open_float, { desc = "Show diagnostic in float" })

-- Diagnostic
vim.diagnostic.config({
    sign = false,
    virtual_text = false,
})

-- Extra
vim.cmd("colorscheme nordfox")
vim.cmd(":hi statusline guibg=NONE")

-- Autogroup that handles number lines. It turns off relative numbers in insert mode
-- and turns relative numbers back on when leaving insert mode.
vim.api.nvim_create_augroup("NumberToggle", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
    group = "NumberToggle",
    callback = function()
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = "NumberToggle",
    callback = function()
        vim.opt.relativenumber = true
    end,
})

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
