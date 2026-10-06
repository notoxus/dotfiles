# Workflow notes

## Shell

NixOS uses the Nix Flakes and Home Manager modules under `[My nix config](https://github.com/notoxus/nix)`.

## Shortcut discovery

```sh
keys g
keys t
```

- `keys g` searches Ghostty's default keybindings with fzf.
- `keys t` searches tmux's prefix keybindings with fzf when run inside tmux.
- `Mod+Shift+Esc` opens Niri's built-in keybinding overlay.

See [keybinds-cheatsheet.md](keybinds-cheatsheet.md) for a compact Niri, tmux,
and Neovim keymap.

## Ghostty and tmux

Ghostty owns terminal shortcuts and clipboard integration. tmux owns sessions,
windows, panes, and copy-mode history. Its prefix is `Ctrl+B`.

- Drag normally to select with tmux; releasing the mouse copies the selection.
- Hold `Shift` while dragging to use Ghostty's native selection.
- `Ctrl+Shift+C` and `Ctrl+Shift+V` remain Ghostty's copy/paste shortcuts.
- In tmux copy-mode, press `v` to select and `y` to copy.

Install TPM plugins with `Ctrl+B`, then `I`; update them with `Ctrl+B`, then
`U`. Reload the tmux configuration with:

```sh
tmux source-file ~/.config/tmux/tmux.conf
```
## tmux status bar troubleshooting

If the right side of the status bar shows only icons, or `--` for the
temperature, a dependency is missing. This is common on a fresh install.

| Symptom | Cause | Fix |
|---|---|---|
| CPU and RAM show icons but no numbers | The `tmux-cpu` plugin isn't installed. Cloning TPM alone doesn't install plugins. | Inside tmux press `Ctrl+B`, then `Shift+I`. |
| Temperature shows `--` | The `sensors` command is missing. | Install lm-sensors (see below), then run `sensors` once to confirm. |
| `Prefix + I` does nothing | TPM isn't in the right place. | Check that `~/.config/tmux/plugins/tpm/tpm` exists. |

Check what is installed:

```sh
ls ~/.config/tmux/plugins    # expect: tpm tmux-cpu tmux-resurrect tmux-continuum
command -v sensors
```

If `Prefix + I` fails, install the plugins from a shell inside tmux:

```sh
~/.config/tmux/plugins/tpm/bin/install_plugins
tmux source-file ~/.config/tmux/tmux.conf
```

### Installing lm-sensors

The package name and the command differ: the command is `sensors`.

- Arch Linux: `sudo pacman -S lm_sensors`
- NixOS: add `lm_sensors` to `home.packages` and rebuild.

On AMD CPUs, `sensors` should print a `Tctl` line, which `cpu-temp.sh` reads.
Intel CPUs report `Package id 0` instead.

## Noctalia v5

Niri launches the native Noctalia v5 executable and use
`noctalia msg` for shell controls. After deploying the configuration, validate
it with:

```sh
noctalia config validate
```

Noctalia stores changes made in its settings UI under
`~/.local/state/noctalia/settings.toml`. Those state overrides take precedence
over the tracked `~/.config/noctalia/config.toml` values.

Bar layouts live under `~/.config/noctalia/profiles/`. The active layout is
selected by `bar-profile.toml`. Click the icon-only Appearance widget to choose
a built-in theme, dark/light/automatic mode, and bar layout; nothing changes
until `Apply` is pressed. The same panel can optionally be added under Settings
→ Control Center → Shortcuts. If a selected profile does not appear, remove
stale bar overrides from the Noctalia Settings UI state.

Profiles whose main bar is on the bottom or side include a top-center media
island attached flush to the screen edge. Its 42 px geometry mirrors the normal
bottom bar: concave screen-edge corners and rounded inner corners. Native bar
auto-hide lets it open from the top screen edge, while the
`noctalia-media-island` watcher also reveals it for 1.5 seconds when playback
starts or the track changes during playback. The watcher temporarily suspends
native auto-hide for that interval, then hides the overlay and restores normal
edge-triggered auto-hide.
It includes artwork, track information, playback-aware controls, and a native
PipeWire audio visualizer.
Clicking the compact media pill briefly opens the expanded island by default;
the Media Island plugin has an override for opening Noctalia's full Media panel
instead. Clicking the native media content in the expanded island also opens
that full panel attached directly below the island. The island uses Noctalia's
maximum 3 px panel overlap to keep their shared seam closed. A Media Island
plugin override can make this second click use Noctalia's default panel
location instead.
Its opacity follows the selected bar profile. Top-bar profiles keep media
within the main bar instead. On bottom profiles, the persistent collapsed state
is a compact media pill plus a live audio visualizer inside the main bar. Long
titles scroll on hover by default, and a plugin override can keep them moving
continuously; only the short expanded state uses the attached top-edge surface.
The pill uses Noctalia's native pixel-based marquee. Play/Pause updates its
control in place and does not reload the bar.

The profile list is deliberately limited to `bottom`, `bottom-islands`, `top`,
`top-islands`, and `side`. The side profile pairs its left bar with a visible
right-side app dock. Top islands uses the same right-side dock with pointer
auto-hide enabled.

The OS logo is also the launcher button. Hover it for the OS name and shortcut
hints, or left-click it to open the launcher (`Mod+Ctrl+Enter`).
