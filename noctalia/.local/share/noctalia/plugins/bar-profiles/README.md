# Appearance Profiles for Noctalia

A compact Noctalia plugin that applies a built-in color scheme, theme mode,
and tracked bar profile together.

It provides:

- an Appearance bar widget
- an optional Control Center shortcut
- a panel for selecting a built-in palette or colors generated from the
  current wallpaper, dark/light/automatic mode, window corners, bar blur,
  and bar layout
- support for the tracked `bottom`, `top`, and `side` profiles

## Plugin

| Field | Value |
|---|---|
| Plugin ID | `notoxus/bar-profiles` |
| Panel | `notoxus/bar-profiles:profile-picker` |
| Shortcut | `notoxus/bar-profiles:profile-shortcut` |
| Bar widget | `notoxus/bar-profiles:switcher` |

The selected profile is written to
`~/.config/noctalia/bar-profile.toml`. Theme and mode changes are applied
through Noctalia's command interface when **Apply** is pressed. The wallpaper
palette uses Noctalia's `m3-content` generator and follows later wallpaper
changes automatically. The existing built-in palettes remain available, and
the tracked default palette is unchanged.

The panel's **Window corners** option applies either square or 20 px rounded
corners to Niri windows independently of the selected bar profile. **Bar blur**
enables or disables Niri blur for the Noctalia bar surfaces in any profile.

## Installation

Copy this directory to:

```text
~/.local/share/noctalia/plugins/bar-profiles/
```

Then enable **Appearance** under `Settings → Plugins` and add its widget or
Control Center shortcut where wanted.
