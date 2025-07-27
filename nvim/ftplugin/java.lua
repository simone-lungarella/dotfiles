vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true

vim.opt.colorcolumn = '120'

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')
local jdtls_root = mason_path .. 'packages/jdtls'
local jdtls_config = jdtls_root .. '/config_linux'
local equinox_launcher = jdtls_root .. '/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar'

local config = {
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

	root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),

	settings = {
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
}

-- This starts a new client & server, or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
