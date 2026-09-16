--!nonstrict
local profiles = require("./common.luau")

local function render()
    local current = profiles.currentProfile()
    local label = current and profiles.labelFor(current) or "Bar"
    barWidget.setGlyph("layout-dashboard")
    barWidget.setText(label)
    barWidget.setTooltip("Bar profile: " .. label .. "\nLeft click: next\nRight click: choose")
end

function update()
    noctalia.setUpdateInterval(2000)
    render()
end

local function cycle(direction)
    local files = profiles.profileFiles()
    if #files == 0 then
        noctalia.notifyError("Bar Profiles", "No profiles found")
        return
    end

    local current = profiles.currentProfile()
    local index = 1
    for i, name in ipairs(files) do
        if name == current then index = i break end
    end

    index = ((index - 1 + direction) % #files) + 1
    local name = files[index]
    local ok, err = profiles.applyProfile(name)
    if not ok then
        noctalia.notifyError("Bar Profiles", tostring(err))
        return
    end

    noctalia.notify("Bar Profiles", "Switched to " .. profiles.labelFor(name))
    noctalia.runAsync("noctalia msg config-reload")
end

function onClick() cycle(1) end
function onRightClick() noctalia.togglePanel("notoxus/bar-profiles:profile-picker") end
function onScroll(axis, steps, startsGesture)
    if axis ~= "vertical" or not startsGesture then return end
    cycle(steps > 0 and 1 or -1)
end
