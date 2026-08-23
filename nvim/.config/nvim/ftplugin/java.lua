---@diagnostic disable: undefined-global

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true
vim.opt.colorcolumn = '120'

local jdtls_cmd = vim.fn.stdpath('data') .. '/mason/bin/jdtls'
local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

local lombok_agent = '--jvm-arg=-javaagent=' .. vim.fn.stdpath('data') .. '/mason/share/jdtls/lombok.jar'
lombok_agent = lombok_agent:gsub('%-javaagent=', '-javaagent:')

-- Find java-debug and java-test bundles
local bundles = {}
local mason_path = vim.fn.stdpath('data') .. '/mason/packages'
local java_debug_path = mason_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'
local java_test_path = mason_path .. '/java-test/extension/server/*.jar'

-- Add java-debug adapter
vim.list_extend(bundles, vim.split(vim.fn.glob(java_debug_path), '\n'))

-- Add java-test bundles (excluding specific jars that shouldn't be loaded as bundles)
for _, bundle in ipairs(vim.split(vim.fn.glob(java_test_path), '\n')) do
    if not vim.endswith(bundle, 'com.microsoft.java.test.runner-jar-with-dependencies.jar')
        and not vim.endswith(bundle, 'junit-platform-console-standalone.jar')
        and not vim.endswith(bundle, 'jacocoagent.jar') then
        table.insert(bundles, bundle)
    end
end

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
    init_options = {
        bundles = bundles,
    },
    on_attach = function(client, bufnr)
        -- Setup jdtls with DAP
        require('jdtls').setup_dap({ hotcodereplace = 'auto' })
        require('jdtls.dap').setup_dap_main_class_configs()
    end,
}

require('jdtls').start_or_attach(config)
