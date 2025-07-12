require('lualine').setup {
  options = {
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_x = { },
    lualine_a = {
      {
        'buffers',
      },
    },
    lualine_c = {},
  },
}
