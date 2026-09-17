# Vietnamese Lunar Calendar for Noctalia

A small Noctalia v5 plugin for the **Vietnamese lunar calendar**.

It provides:

- a Control Center shortcut named **Âm lịch**
- a floating monthly calendar panel
- lunar day/month shown below each Gregorian date
- leap-month marker (`N`)
- Can Chi year name
- common Vietnamese traditional festivals
- an optional bar widget showing the Gregorian date as `17 Sep`

## Plugin

| Field | Value |
|---|---|
| Plugin ID | `notoxus/vietnamese-lunar-calendar` |
| Panel | `notoxus/vietnamese-lunar-calendar:calendar` |
| Shortcut | `notoxus/vietnamese-lunar-calendar:calendar-shortcut` |
| Bar widget | `notoxus/vietnamese-lunar-calendar:lunar` (display example: `17 Sep`) |
| Time zone used for lunar calculation | UTC+7 |

## Installation

For local development, copy this directory to:

```text
~/.local/share/noctalia/plugins/vietnamese-lunar-calendar/
```

Then reload Noctalia and enable **Vietnamese Lunar Calendar** in:

```text
Settings → Plugins
```

Or enable it from the command line:

```bash
noctalia msg plugins enable notoxus/vietnamese-lunar-calendar
```

Add the **Âm lịch** shortcut in:

```text
Settings → Control Center → Shortcuts
```

Optionally add the lunar widget to the bar.

You can open the panel directly with:

```bash
noctalia msg panel-toggle notoxus/vietnamese-lunar-calendar:calendar
```

## Nix / Home Manager

You can also deploy the plugin directory declaratively:

```nix
xdg.dataFile."noctalia/plugins/vietnamese-lunar-calendar".source =
  ./vietnamese-lunar-calendar;
```

## Notes

The conversion is calculated locally. The plugin does not use the network,
does not spawn processes and has no external dependencies.

Traditional festival labels are intentionally lightweight; regional/religious
observances can be added later without changing the calendar conversion logic.
