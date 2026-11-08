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
vim.wo.signcolumn = 'yes'

-- Enable when neovim is updated
-- vim.lsp.semantic_tokens.stop()

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
    {
        "EdenEast/nightfox.nvim",
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = true,
                    terminal_colors = true,
                },
                groups = {
                    all = {
                        -- Float windows and popup menus
                        NormalFloat = { bg = "NONE" },
                        FloatBorder = { bg = "NONE" },
                        Pmenu = { bg = "NONE" },
                        PmenuSel = { bg = "#5e81ac", fg = "#eceff4" },

                        ["@keyword"]               = { fg = "fg1" },
                        ["@type.builtin"]          = { fg = "fg1" }, -- Native primitives like int, void
                        ["@module"]                = { fg = "fg1" }, -- Packages / module names
                        ["@comment"]               = { fg = "palette.yellow.dim", style = "italic" },
                        ["@comment.documentation"] = { fg = "fg3", style = "NONE" },
                        ["@variable.parameter"]    = { fg = "fg1" }, -- Object properties/fields
                        ["@keyword.conditional"]   = { fg = "fg1" },
                        ["@keyword.repeat"]        = { fg = "fg1" },
                        ["@keyword.import"]        = { fg = "fg1" },
                        ["@type"]                  = { fg = "palette.pink" },
                        ["@type.definition"]       = { fg = "fg1" }, -- Type definitions
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        config = function()
            require("nvim-treesitter").setup()

            require("nvim-treesitter").install({
                "lua", "vim", "vimdoc", "query",
                "markdown", "markdown_inline", "java",
                "c", "python"
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    -- If a compiled parser exists for this file, turn it on natively!
                    pcall(vim.treesitter.start)
                end,
            })
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
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    yaml = { "prettier" },
                    yml = { "prettier" },
                },
                formatters = {
                    prettier = {
                        prepend_args = function(self, ctx)
                            if vim.bo[ctx.buf].filetype == "yaml" then
                                return { "--parser", "yaml" }
                            end
                            return {}
                        end,
                    },
                },
            })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            lint.linters.sqlfluff.args = {
                "lint",
                "--dialect=impala",
                "--format=json",
                "-",
            }

            lint.linters_by_ft = {
                sql = { "sqlfluff" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    {
        'mfussenegger/nvim-dap',
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
    {
        "simone-lungarella/randomize.nvim",
        config = function()
            require("randomize").setup()
        end,
    },
    -- {
    --     "simone-lungarella/mdrun.nvim",
    --     ft = {
    --         "markdown", "md"
    --     },
    --     init = function()
    --         vim.g.mdrun_no_default_maps = 1
    --     end,
    --     keys = {
    --         {
    --             "<leader>mr",
    --             function() require("mdrun").run() end,
    --             mode = "n",
    --             desc = "Run bash block under cursor",
    --         },
    --     },
    -- }
}

-- LSP — JDTLS has its own file configuration because lombok does not work out of the box.
vim.lsp.enable({ 'lua_ls', 'clangd', 'pyright', 'bashls', 'go', 'xml' })

-- Keymaps
vim.keymap.set('n', '<M-f>', function()
    local ok = require("conform").format({ bufnr = 0, lsp_fallback = true, timeout_ms = 3000 })
end, { desc = 'Format buffer' })

-- dq to add diagnostic to quickfix list while ignoring files under /target
vim.keymap.set('n', 'dq', function()
    local diagnostics = vim.diagnostic.get()

    diagnostics = vim.tbl_filter(function(d)
        local name = vim.api.nvim_buf_get_name(d.bufnr)
        return not name:match('/target/')
    end, diagnostics)

    vim.fn.setqflist({}, ' ', {
        title = 'Diagnostics',
        items = vim.diagnostic.toqflist(diagnostics),
    })

    vim.cmd.copen()
end, { desc = 'Diagnostics to quickfix' })

-- Diagnostic
vim.diagnostic.config({
    sign = false,
    virtual_text = false,
})

-- Color scheme
vim.cmd.colorscheme("nordfox")

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
