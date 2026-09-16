--!nonstrict
local profiles = require("./common.luau")

local function render()
    local current = profiles.currentProfile()
    shortcut.setLabel(current and profiles.labelFor(current) or "Bar Profiles")
    shortcut.setIcon("layout-dashboard")
    shortcut.setActive(false)
    shortcut.setEnabled(true)
end

render()
noctalia.state.watch("profile", function(_) render() end)

function onClick()
    noctalia.togglePanel("notoxus/bar-profiles:profile-picker")
end

function onRightClick()
    noctalia.openSettings()
end
