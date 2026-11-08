# Personal configuration files

## Fedora / Hyprland quick start

These are my Fedora dotfiles, mostly for terminal applications and the Hyprland
Wayland desktop. The desktop configuration was last checked on **Fedora 45** with
**Hyprland 0.57.1**, **hyprpaper 0.8.5**, and **Waybar 0.15.0**.

### 1. Install or restore the desktop after a Fedora upgrade

My Hyprland packages come from the third-party
[lionheartp/Hyprland Copr](https://copr.fedorainfracloud.org/coprs/lionheartp/Hyprland/).
Fedora upgrades can leave third-party repositories disabled or packages removed.
Check that the Copr has builds for the new Fedora release before enabling it;
do not point the new system at an older Fedora release's repository.

```bash
sudo dnf install git stow dnf5-plugins
sudo dnf copr enable lionheartp/Hyprland
sudo dnf --refresh install \
  hyprland hyprpaper hyprlock xdg-desktop-portal-hyprland \
  xdg-desktop-portal-gtk qt6-qtwayland \
  waybar kitty rofi dolphin \
  grim slurp wl-clipboard brightnessctl playerctl \
  pipewire wireplumber wiremix tmux newsboat btop
```

This uses `dnf install` to restore missing packages; `dnf reinstall` is not needed
just because Fedora was upgraded. If an upgrade still needs to be completed,
review `sudo dnf upgrade --refresh` separately. Do not blindly accept package
removals or add `--allowerasing` to resolve dependency conflicts.

The commands above do not install or replace a login manager. On my existing
Fedora GNOME installation, I log out and select **Hyprland** from GDM's session
menu. Keep GNOME available as a fallback while checking a new Hyprland release.

### 2. Link configuration files (first setup only)

```bash
git clone <your-dotfiles-repository-url> ~/Projects/Personal/dotfiles
cd ~/Projects/Personal/dotfiles
mkdir -p ~/.config

# Preview first: Stow will report conflicts rather than overwrite regular files.
stow --simulate --verbose --target="$HOME" hypr waybar kitty rofi tmux newsboat
stow --verbose --target="$HOME" hypr waybar kitty rofi tmux newsboat
```

Skip cloning if the repository already exists. If Stow reports conflicts, back
up and move the conflicting files/directories out of the way, then repeat the
preview. Avoid `stow --adopt`: it imports the existing files into this repository
and can overwrite the configuration you intended to deploy.

Optional editor/shell configurations use the same layout:

```bash
stow --simulate --verbose --target="$HOME" nvim vim bash
# After reviewing conflicts:
stow --verbose --target="$HOME" nvim vim bash
```

Once linked, edits under `~/.config` update this checkout directly. A Fedora
upgrade normally does not require linking again. The `install` and `setup` files
are currently placeholders, not automated installation scripts.

### 3. Check machine-specific settings

- **Monitors:** edit `hypr/.config/hypr/hyprland.lua`. The current setup uses
  `eDP-1` (2880×1800 at 90 Hz, scale 2) and `HDMI-A-1` (2560×1080 at 144 Hz,
  scale 1). Use `hyprctl monitors all` inside Hyprland to find actual output names
  and modes. Workspace-to-monitor rules are currently commented out.
- **Wallpaper:** put your image at `~/Pictures/1-scenery-pink.png`, or change the
  paths in both `hyprpaper.conf` and `hyprlock.conf`. That image is **not included**
  in this repository; alternative images are available under `imgs/`.
- **Fonts:** install **IoskeleyMono Nerd Font** for Hyprland, Waybar, Kitty, Rofi,
  and the lock screen, or change the font names in their configs. User fonts go
  under `~/.local/share/fonts/`; run `fc-cache -fv`
  after installing them. Nerd Font glyphs are used for bar icons.
- **Waybar helpers:** customize birthdays in
  `waybar/.config/waybar/scripts/bdays.sh` and feeds in
  `newsboat/.config/newsboat/urls`. Audio clicks open `wiremix` in tmux, so keep a
  tmux session running for that action (and the other tmux-based bar actions).

### 4. Log in and verify

Select Hyprland at login. The Lua startup hook launches Waybar and hyprpaper;
do not also enable separate services for them, or they may run twice.

```bash
rpm -q hyprland hyprpaper waybar
hyprctl configerrors
hyprctl monitors
pgrep -a -x waybar
pgrep -a -x hyprpaper
```

Useful shortcuts: **Super+T** opens Kitty, **Super+D** opens Rofi,
**Super+1…9 / Super+0** changes workspace, and **Print** copies a selected screen
region to the clipboard. Run `hyprlock` to lock the screen; no automatic idle
locking is configured here.

### Upgrade troubleshooting

- **Hyprland missing from the login menu:** check `dnf repolist --enabled` and
  `rpm -q hyprland`, then restore the Copr/packages using step 1. Log out after
  installation so the login manager can discover the session.
- **Default wallpaper instead of my image:** hyprpaper 0.8.x uses
  `wallpaper { monitor = ...; path = ...; }` blocks (see the actual multiline
  config), not the old `preload` / `wallpaper = monitor,path` syntax. Check that
  the image exists and run hyprpaper in a terminal to see errors. Stop the
  existing instance with `pkill -x hyprpaper` before launching a replacement.
- **Clicking workspace numbers does nothing:** Waybar 0.15.0's
  `hyprland/workspaces` uses legacy IPC commands incompatible with Hyprland Lua
  mode. This configuration uses **`ext/workspaces`** with `"on-click": "activate"`
  instead; persistent workspaces are intentionally not configured.
- **Old scripts fail to change workspace:** use Lua dispatcher syntax:
  `hyprctl dispatch 'hl.dsp.focus({ workspace = 2 })'`, not
  `hyprctl dispatch workspace 2`.
- **Reload after editing:** `hyprctl reload` reloads Hyprland;
  `pkill -SIGUSR2 -x waybar` reloads Waybar. Restart hyprpaper after editing its
  configuration. Reloading Hyprland does not rerun the startup hook.

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
Wayland tiling compositor, configured in Lua with the scrolling layout.

## Rofi
Simple launcher with a black/white/gray palette. The theme file keeps the
historical name `nord.rasi`, but no longer uses Nord accent colors.

## Waybar
Status bar for Hyprland, using `ext/workspaces` for clickable workspace buttons.

## Kitty
Kitty with a black background and grayscale interface, matching Rofi and tmux.
The ANSI palette retains colors for readable command output, errors, and diffs.
