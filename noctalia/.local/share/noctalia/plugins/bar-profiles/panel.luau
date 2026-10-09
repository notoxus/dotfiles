--!nonstrict
local appearance = require("./common.luau")

local profileFiles = {}
local profileLabels = {}
local selectedProfile = 0
local selectedTheme = 0
local selectedMode = 0
local selectedCorners = 0
local selectedBarBlur = false

local function indexOf(values, wanted)
    for index, value in ipairs(values) do
        if value == wanted then return index - 1 end
    end
    return 0
end

local function selectRow(label, options, selectedIndex, onChange)
    return ui.row({ gap = 16, align = "center" }, {
        ui.label({ text = label, flexGrow = 1 }),
        ui.select({
            options = options,
            selectedIndex = selectedIndex,
            width = 240,
            controlSize = "md",
            onChange = onChange,
        }),
    })
end

local function render()
    panel.render(ui.column({ gap = 12, padding = 18 }, {
        ui.row({ align = "center", justify = "space_between" }, {
            ui.label({ text = "Appearance", fontSize = 20, fontWeight = "bold", color = "primary", flexGrow = 1 }),
            ui.button({ glyph = "x", variant = "ghost", onClick = "closePanel" }),
        }),
        ui.label({
            color = "on_surface/0.7",
        }),
        ui.separator({ spacing = 2 }),
        selectRow("Theme", appearance.themeOptions, selectedTheme, "selectTheme"),
        selectRow("Mode", { "Dark", "Light", "Auto" }, selectedMode, "selectMode"),
        selectRow("Window corners", appearance.cornerOptions, selectedCorners, "selectCorners"),
        selectRow("Bar", profileLabels, selectedProfile, "selectProfile"),
        ui.spacer({ flexGrow = 1 }),
        ui.row({ gap = 8, align = "center" }, {
            ui.label({ text = "Bar blur", flexGrow = 1 }),
            ui.toggle({ checked = selectedBarBlur, onChange = "selectBarBlur" }),
            ui.spacer({ flexGrow = 1 }),
            ui.button({ text = "Cancel", variant = "ghost", onClick = "closePanel" }),
            ui.button({ text = "Apply", glyph = "check", variant = "primary", onClick = "applyAppearance" }),
        }),
    }))
end

function onOpen(context)
    local err
    profileFiles, err = appearance.profileFiles()
    profileLabels = {}

    if err ~= nil or #profileFiles == 0 then
        noctalia.notifyError("Appearance", err and tostring(err) or "No bar profiles found")
        panel.close()
        return
    end

    for _, name in ipairs(profileFiles) do
        table.insert(profileLabels, appearance.labelFor(name))
    end

    selectedProfile = indexOf(profileFiles, appearance.currentProfile())
    selectedTheme = indexOf(appearance.themeOptions, appearance.currentTheme())
    selectedMode = indexOf(appearance.themeModes, appearance.currentMode())
    selectedCorners = indexOf(appearance.cornerOptions, appearance.currentWindowCornerMode())
    selectedBarBlur = appearance.currentBarBlurMode() == "Blur"
    render()
end

function selectTheme(index, text)
    selectedTheme = tonumber(index) or 0
    render()
end

function selectMode(index, text)
    selectedMode = tonumber(index) or 0
    render()
end

function selectCorners(index, text)
    selectedCorners = tonumber(index) or 0
    render()
end

function selectBarBlur(value)
    selectedBarBlur = value == "true"
    render()
end

function selectProfile(index, text)
    selectedProfile = tonumber(index) or 0
    render()
end

function closePanel()
    panel.close()
end

function applyAppearance()
    local profile = profileFiles[selectedProfile + 1]
    local theme = appearance.themeOptions[selectedTheme + 1]
    local mode = appearance.themeModes[selectedMode + 1]
    local cornerMode = appearance.cornerOptions[selectedCorners + 1]
    local barBlur = selectedBarBlur and "Blur" or "Off"
    local previousProfile = appearance.currentProfile()
    local previousCorners = appearance.currentWindowCornerMode()
    local previousBarBlur = appearance.currentBarBlurMode()
    local themeCommand = appearance.themeCommand(theme)

    if profile == nil or themeCommand == nil or mode == nil or cornerMode == nil then
        noctalia.notifyError("Appearance", "One of the selected options is invalid")
        return
    end

    local ok, err = appearance.applyProfile(profile)
    if not ok then
        noctalia.notifyError("Appearance", tostring(err))
        return
    end

    local styleOk, styleErr = appearance.applyWindowAppearance(cornerMode, barBlur)
    if not styleOk then
        if previousProfile ~= nil then appearance.applyProfile(previousProfile) end
        noctalia.notifyError("Appearance", tostring(styleErr))
        return
    end

    -- Both theme commands persist their settings and reload Noctalia. Keep the
    -- sequence in one detached shell so it survives the plugin being reloaded.
    local command =
        themeCommand ..
        " && noctalia msg theme-mode-set " .. mode ..
        " && noctalia msg config-reload" ..
        " && sleep 0.5" ..
        " && noctalia msg bar-hide media-island >/dev/null 2>&1 || true"

    if not noctalia.runAsync({ "sh", "-c", command }) then
        if previousProfile ~= nil then appearance.applyProfile(previousProfile) end
        if previousProfile ~= nil and previousCorners ~= nil and previousBarBlur ~= nil then
            appearance.applyWindowAppearance(previousCorners, previousBarBlur)
        end
        noctalia.notifyError("Appearance", "Could not start the apply command")
        return
    end

    noctalia.notify("Appearance", "Applying " .. theme .. ", " .. mode .. ", " .. appearance.labelFor(profile))
    panel.close()
end
