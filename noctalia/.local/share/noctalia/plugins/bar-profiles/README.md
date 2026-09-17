# Appearance Profiles for Noctalia

A compact Noctalia plugin that applies a built-in color scheme, theme mode,
and tracked bar profile together.

It provides:

- an Appearance bar widget
- an optional Control Center shortcut
- a panel for selecting theme, dark/light/automatic mode, and bar layout
- support for the tracked `bottom`, `bottom-islands`, `top`, `top-islands`, and
  `side` profiles

## Plugin

| Field | Value |
|---|---|
| Plugin ID | `notoxus/bar-profiles` |
| Panel | `notoxus/bar-profiles:profile-picker` |
| Shortcut | `notoxus/bar-profiles:profile-shortcut` |
| Bar widget | `notoxus/bar-profiles:switcher` |

The selected profile is written to
`~/.config/noctalia/bar-profile.toml`. Theme and mode changes are applied
through Noctalia's command interface when **Apply** is pressed.

## Installation

Copy this directory to:

```text
~/.local/share/noctalia/plugins/bar-profiles/
```

Then enable **Appearance** under `Settings → Plugins` and add its widget or
Control Center shortcut where wanted.
