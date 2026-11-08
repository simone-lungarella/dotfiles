# Dotfiles

My [Fedora](https://fedoraproject.org/) configuration: a minimal dark desktop and
a terminal-first workflow.

## What I use

- [**Hyprland**](https://github.com/hyprwm/Hyprland) — Wayland compositor with Lua configuration and scrolling layout.
- [**hyprpaper**](https://github.com/hyprwm/hyprpaper) / [**hyprlock**](https://github.com/hyprwm/hyprlock) — wallpaper and manual screen locking.
- [**Waybar**](https://github.com/Alexays/Waybar) / [**Rofi**](https://github.com/davatorium/rofi) — status bar and application launcher.
- [**Kitty**](https://github.com/kovidgoyal/kitty) / [**tmux**](https://github.com/tmux/tmux) — terminal and multiplexer; Waybar actions open tools in tmux.
- [**Neovim**](https://github.com/neovim/neovim) / [**Vim**](https://github.com/vim/vim) — editors, with [Mason](https://github.com/mason-org/mason.nvim), [LSP](https://github.com/neovim/nvim-lspconfig), [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter), and [Conform](https://github.com/stevearc/conform.nvim) in Neovim.
- [**Newsboat**](https://github.com/newsboat/newsboat) — RSS reader.
- [**IoskeleyMono**](https://github.com/ahatem/IoskeleyMono) with [**Nerd Fonts**](https://github.com/ryanoasis/nerd-fonts) glyphs — font throughout the desktop.
- [**GNU Stow**](https://www.gnu.org/software/stow/) — configuration symlinks.

Thanks to the authors and contributors behind these projects.

## New machine

### Install packages

For Fedora 45 with an existing desktop/login manager. Hyprland packages come
from the third-party [lionheartp/Hyprland Copr](https://copr.fedorainfracloud.org/coprs/lionheartp/Hyprland/);
check that it supports your Fedora release.

```bash
sudo dnf install git stow dnf5-plugins
sudo dnf copr enable lionheartp/Hyprland
sudo dnf --refresh install \
  hyprland hyprpaper hyprlock xdg-desktop-portal-hyprland \
  xdg-desktop-portal-gtk qt6-qtwayland \
  waybar kitty rofi dolphin \
  grim slurp wl-clipboard brightnessctl playerctl \
  pipewire wireplumber wiremix tmux newsboat btop \
  neovim vim-enhanced ripgrep gcc make unzip
```

After a Fedora upgrade, re-enable the Copr if needed and rerun the package install.

### Get and link the configs

```bash
git clone https://github.com/simone-lungarella/dotfiles.git ~/Projects/Personal/dotfiles
cd ~/Projects/Personal/dotfiles
mkdir -p ~/.config

stow --simulate --verbose --no-folding --target="$HOME" \
  hypr waybar kitty rofi tmux newsboat nvim vim bash
stow --verbose --no-folding --target="$HOME" \
  hypr waybar kitty rofi tmux newsboat nvim vim bash
```

If the preview reports conflicts, back up and move the conflicting files first.
Do not use `--adopt` to overwrite the repository with existing configs.

### Before logging in

- Download a Nerd Font build from [IoskeleyMono releases](https://github.com/ahatem/IoskeleyMono/releases),
  install the font files under `~/.local/share/fonts/`, then run `fc-cache -fv`.
  Check the installed family name with `fc-list : family` and adjust the configs
  if it differs from `IoskeleyMono Nerd Font`.
- Adjust monitor names, resolutions, and scales in
  `hypr/.config/hypr/hyprland.lua`.
- Add `~/Pictures/1-scenery-pink.png`, or change the wallpaper paths in
  `hyprpaper.conf` and `hyprlock.conf`. The image is not included; alternatives
  are under `imgs/`.
- Customize the Newsboat feeds and Waybar birthday script.

Select **Hyprland** at login. Waybar and hyprpaper start automatically.

### Neovim

Open Neovim and run `:Lazy restore` to install the recorded plugin versions.
Use `:Mason` to install language servers. Java needs a compatible JDK and JDTLS;
the config expects Lombok at
`~/.local/share/nvim/mason/packages/jdtls/lombok.jar`.
Install Prettier for YAML formatting and SQLFluff for SQL linting if needed.
