--!nonstrict
local profiles = require("./common.luau")

local function render()
    shortcut.setLabel("Appearance")
    shortcut.setIcon("palette")
    shortcut.setActive(false)
    shortcut.setEnabled(true)
end

render()
noctalia.state.watch("profile", function(_) render() end)

function onClick()
    noctalia.togglePanel("notoxus/bar-profiles:profile-picker")
end

function onRightClick()
    noctalia.togglePanel("notoxus/bar-profiles:profile-picker")
end
