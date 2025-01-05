-- Diagnostic keymapslsp
vim.keymap.set("n", "[d", vim.diagnostic.get_prev)
vim.keymap.set("n", "]d", vim.diagnostic.get_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- A function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { desc = desc, noremap = true, silent = true })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gh", vim.lsp.buf.hover, "Hover Documentation")

	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		if vim.lsp.buf.format then
			vim.lsp.buf.format()
		elseif vim.lsp.buf.formatting then
			vim.lsp.buf.formatting()
		end
	end, { desc = "Format current buffer with LSP" })
end

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = { "clangd", "pyright", "jdtls", "ltex" }

-- Ensure the servers above are installed
require("mason-lspconfig").setup({
	automatic_installation = true,
	ensure_installed = servers,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities()

for _, lsp in ipairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

require("lspconfig").gdscript.setup({})
require("lspconfig").ltex.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	dependencies = {
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = { enable = false },
		},
	},
})

-- Java configuration
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
local jdtls_root = mason_path .. "packages/jdtls"
local jdtls_config = jdtls_root .. "/config_linux"
local equinox_launcher = jdtls_root .. "/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar"
local path_to_java_debug = "~/Repositories/Personal/java-debug/com.microsoft.java.debug.plugin/target"

require("lspconfig").jdtls.setup({
	-- Add generic configuration such as code actions
	on_attach = on_attach,
	cmd = {
		"/usr/lib/jvm/java-21-openjdk-21.0.5.0.11-1.fc40.x86_64/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dosgi.checkConfiguration=true",
		"-Dosgi.sharedConfiguration.area=" .. jdtls_config,
		"-Dosgi.sharedConfiguration.area.readOnly=true",
		"-Dosgi.configuration.cascaded=true",
		"-Xms1G",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. jdtls_root .. "/lombok.jar",
		"-jar",
		equinox_launcher,
		"-configuration",
		jdtls_config,
		"-data",
		vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
	},
	settings = {
		eclipse = {
			downloadSources = true,
		},
		maven = {
			downloadSources = true,
		},
		implementationsCodeLens = {
			enabled = true,
		},
		referencesCodeLens = {
			enabled = true,
		},
		references = {
			includeDecompiledSources = true,
		},
		inlayHints = {
			parameterNames = {
				enabled = "all", -- literals, all, none
			},
		},
		java = {
			configuration = {
				--     -- java-11-openjdk.x86_64 (/usr/lib/jvm/java-11-openjdk-11.0.24.0.8-2.fc40.x86_64/bin/java)
				--     -- java-21-openjdk.x86_64 (/usr/lib/jvm/java-21-openjdk-21.0.4.0.7-2.fc40.x86_64/bin/java)
				--     -- java-1.8.0-openjdk.x86_64 (/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.422.b06-2.fc40.x86_64/jre/bin/java)
				--     -- /usr/lib/jvm/jdk8u422-b05
				--     -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
				--     -- And search for `interface RuntimeOption`
				--     -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/usr/lib/jvm/jdk8u422-b05",
					},
					{
						name = "JavaSE-11",
						path = "/usr/lib/jvm/java-11-openjdk-11.0.24.0.8-2.fc40.x86_64",
					},
					{
						name = "JavaSE-21",
						path = "/usr/lib/jvm/java-21-openjdk-21.0.5.0.11-1.fc40.x86_64",
					},
				},
			},
		},
	},
	init_options = {
		bundles = {
			vim.fn.glob(path_to_java_debug .. "com.microsoft.java.debug.plugin-0.53.0.jar"),
		},
	},
})
