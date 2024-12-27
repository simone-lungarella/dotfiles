-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#fab387", fg = "#000000", bold = true })

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 100 })
	end,
	group = highlight_group,
	pattern = "*",
})
