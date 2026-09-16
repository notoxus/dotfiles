--!nonstrict
-- Noctalia passes the active MPRIS playing state alongside native PipeWire
-- spectrum updates, so the glyph follows playback without polling D-Bus.

local playing = false

local function render()
    barWidget.setGlyph(playing and "media-pause" or "media-play")
    barWidget.setText("")
    barWidget.setTooltip({
        { key = "Media", value = playing and "Pause" or "Play" },
    })
end

function update()
    noctalia.setUpdateInterval(1000)
    -- These settings are consumed by the native PluginWidget host before the
    -- Luau entry runs; reading them here also keeps manifest lint explicit.
    noctalia.getConfig("audio_spectrum")
    noctalia.getConfig("audio_spectrum_bands")
    render()
end

function onAudioSpectrum(values, state)
    local nextPlaying = string.match(state or "", ",([01])$") == "1"
    if nextPlaying ~= playing then
        playing = nextPlaying
        render()
    end
end
