-- Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = true
vim.o.undofile = true
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
vim.wo.signcolumn = 'yes'
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
    { "vague2k/vague.nvim", }, -- Colorscheme
    { 'nvim-treesitter/nvim-treesitter', },
    { 'cameron-wags/rainbow_csv.nvim',
        config = true,
        ft = {
            'csv',
        }
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            "mfussenegger/nvim-jdtls", -- Java LSP, ikr?
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
            require("lspconfig").lua_ls.setup({})
        end
    },
    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = '*',
        opts = {
            keymap = { preset = 'default' },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono',
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
        },
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
                "--glob '!.import/**'"
            }, " ")
        end,
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
vim.lsp.enable({ 'lua_ls', 'clangd', 'pyright', 'bashls', })

-- Keymaps
vim.keymap.set('n', '<M-f>', vim.lsp.buf.format)
vim.keymap.set('n', 'td', ":bdelete<CR>")
vim.keymap.set('n', 'th', ":bprevious<CR>")
vim.keymap.set('n', 'tl', ":bnext<CR>")

-- Extra
vim.cmd("colorscheme vague")
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
