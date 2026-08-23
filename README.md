# Personal configuration files

## OS
I prefer to work on Linux machine (tile manager is mandatory) mainly from
terminal. I'm using Fedora on my personal machine and on my working machine.

## Neovim
I use [Neovim](https://github.com/neovim/neovim) for the vast majority of my
programming experience trying to have a very minimal set of plugins so to be
able to use `vim` too.

- junegunn/fzf;
- williamboman/mason;
- neovim/nvim-lspconfig;
- williamboman/mason-lspconfig;
- nvim-treesitter/nvim-treesitter;

- nvim-lualine/lualine;
- cameron-wags/rainbow_csv;

To keep my typing skills useful in different environments I have a very small
set of key remaps:

- `<M-f>`: `vim.lsp.buf.format`;
- `dq`: `:lua vim.diagnostic.setqflist()`;

## Tmux
Mainly using tmux as a terminal multiplexer.

## Hyprland
Tile manager GUI.

## Rofi
Simple launcher

## Waybar
Status bar for Sway.

## Kitty
Kitty as terminal emulator with no fancy configuration.
