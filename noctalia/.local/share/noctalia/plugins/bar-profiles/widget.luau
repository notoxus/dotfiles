--!nonstrict
local profiles = require("./common.luau")

local function render()
    local current = profiles.currentProfile()
    local label = current and profiles.labelFor(current) or "Unknown"
    barWidget.setGlyph("palette")
    barWidget.setText("")
    barWidget.setTooltip({
        { key = "Theme", value = profiles.currentTheme() },
        { key = "Mode", value = profiles.currentMode() },
        { key = "Bar", value = label },
        { key = "Click", value = "Customize appearance" },
    })
end

function update()
    noctalia.setUpdateInterval(2000)
    render()
end

function onClick() noctalia.togglePanel("notoxus/bar-profiles:profile-picker") end
function onRightClick() noctalia.togglePanel("notoxus/bar-profiles:profile-picker") end
