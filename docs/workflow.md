# Workflow notes

## Shell

```text
Zsh
├── Starship                  prompt
├── zoxide                    directory jumping (`z`, `zi`)
├── fzf                       history, file, and directory search
├── zsh-autosuggestions       history and context-aware completion
└── zsh-syntax-highlighting   command-line highlighting
```

Reload the configuration with:

```sh
source ~/.config/zsh/.zshrc
```

## Shortcut discovery

```sh
keys n
keys g
keys t
```

- `keys n` opens Niri's keybinding overlay.
- `keys g` searches Ghostty's default keybindings with fzf.
- `keys t` searches tmux's prefix keybindings with fzf when run inside tmux.
- `Mod+Shift+Esc` opens Niri's built-in keybinding overlay.

For easier comparison...Let's see [keybinds-cheetsheet.md](docs/keybinds-cheetsheet.md) for the compact Niri, tmux, and Neovim keymap.

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

## Noctalia v5

Niri and Umbriel both launch the native Noctalia v5 executable and use
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
bottom bar: concave screen-edge corners and rounded inner corners. The
`noctalia-media-island` watcher reveals it for 1.5 seconds when playback
starts or the track changes during playback, then hides the whole overlay.
It includes artwork, track information, playback-aware controls, and a native
PipeWire audio visualizer.
Its opacity follows the selected bar profile. Top-bar profiles keep media
within the main bar instead. On bottom profiles, the persistent collapsed state
is a compact media pill with a hover-scroll title and a live audio visualizer inside
the main bar; only the short expanded state uses the attached top-edge surface.

The profile list is deliberately limited to `bottom`, `bottom-islands`, `top`,
`top-islands`, and `side`. The side profile pairs its left bar with a visible
right-side app dock. Top islands uses the same right-side dock with pointer
auto-hide enabled.

The OS logo is also the launcher button. Hover it for the OS name and shortcut
hints, or left-click it to open the launcher (`Mod+Ctrl+Enter`).
