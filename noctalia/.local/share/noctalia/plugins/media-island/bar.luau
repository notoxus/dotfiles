--!nonstrict
-- The media-state service publishes the active MPRIS playback state so every
-- island control stays in sync without its own polling loop.

local playing = false

local function render()
    barWidget.setGlyph(playing and "media-pause" or "media-play")
    barWidget.setText("")
    barWidget.setTooltip({
        { key = "Media", value = playing and "Pause" or "Play" },
    })
end

local function syncPlayer(player)
    local nextPlaying = type(player) == "table" and player.playing == true
    if nextPlaying ~= playing then
        playing = nextPlaying
        render()
    end
end

function update()
    noctalia.setUpdateInterval(1000)
    render()
end

-- A service may publish before this widget is created (notably after a bar
-- reload). Subscribe first, then hydrate from the latest value so the control
-- does not remain on the default Play glyph until the next MPRIS transition.
noctalia.state.watch("player", syncPlayer)
syncPlayer(noctalia.state.get("player"))
