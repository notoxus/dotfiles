# OS Logo for Noctalia

A small Noctalia bar widget that reads `/etc/os-release` once and displays the
current Linux distribution logo.

The widget prefers the icon named by the distribution's `LOGO` field and falls
back to a Nerd Font glyph for common distributions or a generic Linux mark.
Hovering shows the OS name and shortcut hints; clicking opens Noctalia's
launcher.

## Plugin

| Field | Value |
|---|---|
| Plugin ID | `notoxus/os-logo` |
| Bar widget | `notoxus/os-logo:bar` |

## Installation

Copy this directory to:

```text
~/.local/share/noctalia/plugins/os-logo/
```

Then enable **OS Logo** under `Settings → Plugins` and add the widget to a bar.
A Nerd Font is recommended for the portable fallback glyphs.
