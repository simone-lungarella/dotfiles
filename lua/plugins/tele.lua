-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
if vim.g.borderStyle == "rounded" then
  borderChars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
end

local smallLayout = { horizontal = { width = 0.6, height = 0.6 } }

require("telescope").setup {
  defaults = {
    path_display = { "tail" },
    selection_caret = "  ",
    prompt_prefix = "",
    multi_icon = "󰒆 ",
    results_title = false,
    prompt_title = false,
    dynamic_preview_title = true,
    borderchars = borderChars,
    preview = false,
    cycle_layout_list = {
      "horizontal",
      { previewer = false, layout_strategy = "horizontal", layout_config = smallLayout },
    },
    layout_strategy = "horizontal",
    sorting_strategy = "ascending", -- so layout is consistent with prompt_position "top"
    layout_config = smallLayout,
    vimgrep_arguments = {
      "rg",
      "--no-config",
      "--vimgrep",
      "--smart-case",
      "--trim",
      ("--ignore-file=" .. vim.fs.normalize("~/.config/rg/ignore")),
    },
    file_ignore_patterns = {
      "%.png$", "%.svg", "%.gif", "%.icns", "%.jpe?g",
      "%.zip", "%.pdf", "%.git/", "addons/"
    },
  },
  pickers = {
    find_files = {
      find_command = {
        "rg",
        "--no-config",
        "--files",
        "--sortr=modified",
        ("--ignore-file=" .. vim.fs.normalize("~/.config/rg/ignore")),
      },
      path_display = { "filename_first" },
      layout_config = smallLayout,
    },
    live_grep = {
      disable_coordinates = true,
      preview = true,
      layout_config = { horizontal = { preview_width = 0.6 } },
    },
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
      vim.api.nvim_buf_call(ctx.buf, function()
        vim.fn.matchadd("TelescopeParent", "\t\t.*$")
        vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
      end)
  end,
})

local function filenameFirst(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then return tail end
  return string.format("%s\t\t%s", tail, parent)
end

require("telescope").setup {
  pickers = {
    find_files = {
      path_display = filenameFirst,
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = true,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sS', require('telescope.builtin').git_status, { desc = '' })

vim.api.nvim_set_keymap("n", "st", ":TodoTelescope<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader><tab>", "<Cmd>lua require('telescope.builtin').commands()<CR>", { noremap = false })
