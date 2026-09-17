# Media Island for Noctalia

A playback-aware control widget used by this dotfiles repository's temporary
media island.

The external `noctalia-media-island` watcher reveals the island when playback
starts or the current track changes, then hides it after 1.5 seconds. The
widget follows MPRIS playback state through Noctalia's native audio-spectrum
updates, and left-clicking it toggles playback.

## Plugin

| Field | Value |
|---|---|
| Plugin ID | `notoxus/media-island` |
| Bar widget | `notoxus/media-island:playback-toggle` |

## Advanced settings

The original widget exposes only the two technical settings required by its
native playback-state stream: `audio_spectrum` and `audio_spectrum_bands`.

## Installation

Copy this directory to:

```text
~/.local/share/noctalia/plugins/media-island/
```

Then enable **Media Island** under `Settings → Plugins` and add the playback
widget to a bar.
