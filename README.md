# Notoxus Dotfiles 🌸

Portable dotfiles for my Wayland desktop, shared by my Arch Linux and NixOS
setups.

| Area | Current setup |
|---|---|
| Distribution | NixOS and Arch Linux |
| Compositor | Niri (primary), Umbriel (experimental) |
| Desktop shell | Noctalia v5 |
| Shell | Zsh, Starship, zoxide, and fzf |
| Terminal | Ghostty and tmux |

### Why Umbriel?

It shares the Noctalia ecosystem with Niri, and I also think it looks pretty
good. Umbriel support remains experimental, so it is not part of the default
installation set yet.

## Installation

Clone the repository for either installation path:

```sh
git clone https://github.com/notoxus/notoxus-dotfiles ~/dotfiles
cd ~/dotfiles
```

### Portable/manual installation

Use the component installer on systems that are not managed by the included
NixOS/Home Manager flake:

```sh
chmod +x ./install.sh
./install.sh list
```

### NixOS with Home Manager

Home Manager is integrated into the NixOS flake, so apply both layers together:

```sh
sudo nixos-rebuild switch --flake ./nixos-cfg#juosterben
```

Do not run the portable installer against files owned by Home Manager. The
equivalent repository command is:

```sh
./install.sh home-manager
```

## Requirements

| Component | Main requirements |
|---|---|
| `ghostty` | Ghostty and a Nerd Font |
| `zsh` | Standalone Zsh for non-Nix systems; Starship, fzf, zoxide, and plugins are optional |
| `starship` | Starship |
| `tmux` | tmux; Git and lm-sensors are optional |
| `fastfetch` | Fastfetch and a Nerd Font |
| `nvim` | Neovim and Git; fzf, ripgrep, and a C compiler are optional |
| `yazi` | Yazi and a Nerd Font |
| `btop` | btop |
| `niri` | Niri and Noctalia v5 |
| `noctalia` | Noctalia v5 |
| `umbriel` | Umbriel and Noctalia v5 |


### Check dependencies

Before getting started, inspect the default daily-driver components:

```sh
./install.sh check all
```

Specific:

```sh
./install.sh check <component 1> <component 2> <component ...>
```
See the [dependency installation guide](docs/requirements.md) for upstream
installation links.

### Copy files

Install the default daily-driver components:

```sh
./install.sh all
```

`btop`, `yazi`, and the experimental `umbriel` configuration remain opt-in and
can be deployed explicitly.

Specific:

```sh
./install.sh <component 1> <component 2> <component ...>
```

If an existing destination differs, it is moved to a
timestamped tree under `~/.dotfiles-backup/` before the new file is copied.

### Enable the Noctalia plugins

The `noctalia` component includes the local `notoxus/os-logo`,
`notoxus/bar-profiles`, `notoxus/media-island`, and
`notoxus/vietnamese-lunar-calendar` plugins. They are already enabled by the
tracked configuration, so deploying the component is normally enough:

```sh
./install.sh noctalia
```

The configuration also uses the community `ashur-d/wallpaper-widget` plugin.
Install that plugin through Noctalia's community plugin browser on a fresh
machine.

The lunar calendar plugin provides a Control Center shortcut, an attached
monthly calendar panel, and an optional Gregorian date widget that opens the
lunar calendar.

The icon-only Appearance widget is shown directly on every tracked bar. Click
it to choose a built-in theme, dark/light/automatic mode, and bar layout, then
apply all three together. You can also add its shortcut under Settings →
Control Center → Shortcuts, replacing one of the six existing shortcuts. The
five tracked profiles are `bottom`, `bottom-islands`, `top`, `top-islands`, and
`side`. Layouts without a top bar show active media in a top-center island
attached flush to the screen edge for 1.5 seconds after playback changes, with
playback-aware controls and an audio visualizer. The watcher then hides the
expanded overlay while the compact media pill remains in the main bar. The side
layout adds a visible macOS-style dock on the right, while top islands uses the
same dock auto-hidden.

The OS logo replaces the separate launcher icon on every profile. Hover it for
the OS name and shortcut hints; left-click it to open the Noctalia launcher.

Log out and back in after enabling a plugin for the first time. A config reload
may not create a newly added plugin entry until the Noctalia session restarts.

### Install the tmux plugins

The tmux component declares `tmux-cpu`, `tmux-resurrect`, and
`tmux-continuum`. After installing TPM from the dependency guide, copy the
component, start tmux, then press `Ctrl+B` followed by `I`:

```sh
./install.sh tmux
tmux
```

### Terminal workflow

The `fastfetch` and `nvim` configurations are deployed by `all`. `btop` and
`yazi` remain opt-in components:

```sh
./install.sh btop
./install.sh yazi
```

`Mod + E` opens Nautilus. Run `y` in Zsh to launch Yazi and continue in the
directory selected there; quit Yazi with `q` to change directory or `Q` to keep
the current one.

### Optional command-line tools

`./install.sh check zsh` also reports the optional `eza`, `lazygit`, `bat`,
`delta`, and `dust` utilities. Nothing is installed automatically. When `eza`
is present, Zsh provides:

```sh
tree
```

which runs `eza --tree --icons`.

On Arch Linux:

```sh
sudo pacman -Syu eza lazygit bat git-delta dust
```

### Desktop applications

The NixOS Home Manager package list already includes OBS Studio, Rnote, Gaphor,
RustDesk, and Eclipse. Add optional applications such as LibreOffice or Zotero
to [`nixos-cfg/home/packages.nix`](nixos-cfg/home/packages.nix) when wanted.

BentoPDF handles PDFs, while Fcitx5 Lotus (Nguyen Ky) provides Vietnamese
input:

- [BentoPDF](https://github.com/alam00000/bentopdf)
- [fcitx5-lotus](https://github.com/LotusInputMethod/fcitx5-lotus)

### Symlink files

Use symlinks only when the repository should act as the live configuration.
Each component mirrors its destination relative to `$HOME`.

Example:

```text
ghostty/.config/ghostty/config.ghostty
                     ↓
~/.config/ghostty/config.ghostty
```

```sh
./install.sh --link all
```

```sh
./install.sh --link <component 1> <component 2> <component ...>
```

Preview either mode without changing `$HOME`:

```sh
./install.sh --dry-run all
./install.sh --link --dry-run <component 1> <component 2> <component ...>
```

## Repository layout

| Component | Purpose |
|---|---|
| `btop` | Resource monitor |
| `fastfetch` | Terminal system snapshot |
| `ghostty` | Primary terminal |
| `niri` | Primary compositor |
| `nixos-cfg` | Host-specific NixOS and Home Manager configuration |
| `nvim` | Neovim configuration |
| `noctalia` | Shell and bar for Niri and Umbriel |
| `starship` | Shell prompt |
| `tmux` | Terminal multiplexer |
| `umbriel` | Experimental compositor |
| `yazi` | Terminal file manager |
| `zsh` | Standalone shell configuration and the `keys` helper for non-Nix systems |

## Configuration ownership

The `zsh` component is the portable, manually installed shell setup for
non-NixOS systems such as Arch Linux. On NixOS, Home Manager owns Zsh and its
generated files under `~/.config/zsh`; use `./install.sh home-manager` instead of
installing the standalone component there.

The remaining standalone component files are portable sources shared with
non-NixOS systems. The files under `nixos-cfg` contain the current machine's
username, host name, hardware configuration, and package choices, so review
them before applying the flake on another machine.

[Git and GitHub SSH setup guide](docs/git-ssh-setup.md)

## Doing workflow effectively

After installing the standalone `zsh` component:

See [workflow notes](docs/workflow.md) for shell, tmux, clipboard, and compositor
details.
