-- Diagnostic keymapslsplsp
vim.keymap.set('n', '[d', vim.diagnostic.get_prev)
vim.keymap.set('n', ']d', vim.diagnostic.get_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- A function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { desc = desc, noremap = true, silent = true })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gh', vim.lsp.buf.hover, 'Hover Documentation')

  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
end

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = { 'clangd', 'pyright', 'jdtls' }

local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink = require 'blink.cmp'
capabilities = blink.get_lsp_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').tinymist.setup({
  settings = {
    formatterMode = "typstyle"
  }
})

require('lspconfig').lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
}

local function is_api_spec(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:match 'openapi:%s*3' or line:match 'swagger:%s*2' then
      return true
    end
  end
  return false
end

require('lspconfig').bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require('lspconfig').lemminx.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require('lspconfig').spectral.setup {
  settings = {
    -- rulesetFile = 'https://italia.github.io/api-oas-checker/rulesets/spectral-full.yml',
    -- rulesetFile = 'https://github.com/italia/api-oas-checker-rules/releases/latest/download/spectral-full.yml',
    rulesetFile = 'https://github.com/italia/api-oas-checker-rules/releases/latest/download/spectral.yml',
    enable = true,
    run = 'onType',
    validateLanguages = { 'yaml', 'yml' },
  },
  on_attach = function(client, bufnr)
    if not is_api_spec(bufnr) then
      client.stop()
    end
    print 'Spectral enabled — found ­API YAML file'
  end,
}

-- Java configuration
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')
local jdtls_root = mason_path .. 'packages/jdtls'
local jdtls_config = jdtls_root .. '/config_linux'
local equinox_launcher = jdtls_root .. '/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar'
local path_to_java_debug = '~/Repositories/Personal/java-debug/com.microsoft.java.debug.plugin/target'

require('lspconfig').jdtls.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end,
  cmd = {
    '/usr/lib/jvm/java-21-openjdk/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dosgi.checkConfiguration=true',
    '-Dosgi.sharedConfiguration.area=' .. jdtls_config,
    '-Dosgi.sharedConfiguration.area.readOnly=true',
    '-Dosgi.configuration.cascaded=true',
    '-Xms1G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. jdtls_root .. '/lombok.jar',
    '-jar',
    equinox_launcher,
    '-configuration',
    jdtls_config,
    '-data',
    vim.fn.stdpath 'cache' .. '/jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
  },
  settings = {
    eclipse = {
      downloadSources = true,
    },
    maven = {
      downloadSources = true,
    },
    implementationsCodeLens = {
      enabled = false,
    },
    referencesCodeLens = {
      enabled = false,
    },
    references = {
      includeDecompiledSources = false,
    },
    inlayHints = {
      parameterNames = {
        enabled = 'literals', -- literals, all, none
      },
    },
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-1.8',
            path = '/usr/lib/jvm/jdk8u422-b05',
          },
          {
            name = 'JavaSE-21',
            path = '/usr/lib/jvm/java-21-openjdk',
          },
        },
      },
    },
  },
  init_options = {
    bundles = {
      vim.fn.glob(path_to_java_debug .. 'com.microsoft.java.debug.plugin-0.53.0.jar'),
    },
  },
}

