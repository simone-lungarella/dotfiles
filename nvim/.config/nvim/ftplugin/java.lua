---@diagnostic disable: undefined-global

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true
vim.opt.colorcolumn = '120'

local jdtls = require("jdtls")

local lombok = vim.fn.expand(
    "~/.local/share/nvim/mason/packages/jdtls/lombok.jar"
)

jdtls.start_or_attach({
	cmd = {
        "jdtls",
        "--jvm-arg=-javaagent:" .. lombok,
    },
})
