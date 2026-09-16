--!nonstrict
local appearance = require("./common.luau")

local profileFiles = {}
local profileLabels = {}
local selectedProfile = 0
local selectedTheme = 0
local selectedMode = 0

local function indexOf(values, wanted)
    for index, value in ipairs(values) do
        if value == wanted then return index - 1 end
    end
    return 0
end

local function selectRow(label, options, selectedIndex, onChange)
    return ui.row({ gap = 12, align = "center" }, {
        ui.label({ text = label, flexGrow = 1 }),
        ui.select({
            options = options,
            selectedIndex = selectedIndex,
            width = 230,
            controlSize = "md",
            onChange = onChange,
        }),
    })
end

local function render()
    panel.render(ui.column({ gap = 14, padding = 16, fill = "surface" }, {
        ui.row({ align = "center", justify = "space_between" }, {
            ui.label({ text = "Appearance", fontSize = 18, fontWeight = "bold", color = "primary", flexGrow = 1 }),
            ui.button({ glyph = "x", variant = "ghost", onClick = "closePanel" }),
        }),
        ui.label({
            text = "Choose a palette, color mode, and bar layout. Changes are applied together.",
            color = "on_surface/0.7",
        }),
        ui.separator({ spacing = 4 }),
        selectRow("Theme", appearance.builtinThemes, selectedTheme, "selectTheme"),
        selectRow("Mode", { "Dark", "Light", "Auto" }, selectedMode, "selectMode"),
        selectRow("Bar", profileLabels, selectedProfile, "selectProfile"),
        ui.spacer({ flexGrow = 1 }),
        ui.row({ gap = 8, justify = "end" }, {
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
    selectedTheme = indexOf(appearance.builtinThemes, appearance.currentTheme())
    selectedMode = indexOf(appearance.themeModes, appearance.currentMode())
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

function selectProfile(index, text)
    selectedProfile = tonumber(index) or 0
    render()
end

function closePanel()
    panel.close()
end

function applyAppearance()
    local profile = profileFiles[selectedProfile + 1]
    local theme = appearance.builtinThemes[selectedTheme + 1]
    local mode = appearance.themeModes[selectedMode + 1]
    local previousProfile = appearance.currentProfile()

    if profile == nil or theme == nil or mode == nil then
        noctalia.notifyError("Appearance", "One of the selected options is invalid")
        return
    end

    local ok, err = appearance.applyProfile(profile)
    if not ok then
        noctalia.notifyError("Appearance", tostring(err))
        return
    end

    -- Both theme commands persist their settings and reload Noctalia. Keep the
    -- sequence in one detached shell so it survives the plugin being reloaded.
    local command =
        "noctalia msg color-scheme-set builtin " .. string.format("%q", theme) ..
        " && noctalia msg theme-mode-set " .. mode ..
        " && noctalia msg config-reload" ..
        " && sleep 0.5" ..
        " && noctalia msg bar-hide media-island >/dev/null 2>&1 || true"

    if not noctalia.runAsync({ "sh", "-c", command }) then
        if previousProfile ~= nil then appearance.applyProfile(previousProfile) end
        noctalia.notifyError("Appearance", "Could not start the apply command")
        return
    end

    noctalia.notify("Appearance", "Applying " .. theme .. ", " .. mode .. ", " .. appearance.labelFor(profile))
    panel.close()
end
