---@diagnostic disable: undefined-global

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true
vim.opt.colorcolumn = '120'

local jdtls_cmd = vim.fn.stdpath('data') .. '/mason/bin/jdtls'
local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

local lombok_agent = '--jvm-arg=-javaagent=' .. vim.fn.stdpath('data') .. '/mason/share/jdtls/lombok.jar'
lombok_agent = lombok_agent:gsub('%-javaagent=', '-javaagent:')

local config = {
    cmd = {
        jdtls_cmd,
        '--jvm-arg=-Xms1G',
        '--jvm-arg=--add-opens=java.base/java.util=ALL-UNNAMED',
        '--jvm-arg=--add-opens=java.base/java.lang=ALL-UNNAMED',

        -- Lombok agent (forwarded to the JVM by the wrapper)
        lombok_agent,

        '-data', workspace_dir,
    },
    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),
}

require('jdtls').start_or_attach(config)
