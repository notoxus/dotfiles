--!nonstrict
local function configDir()
    local root = noctalia.getenv("NOCTALIA_CONFIG_HOME")
    if root == nil or root == "" then root = noctalia.getenv("XDG_CONFIG_HOME") end
    if root == nil or root == "" then root = "~/.config" end
    return noctalia.expandPath(root .. "/noctalia")
end

local function selectorPath()
    return configDir() .. "/bar-profile.toml"
end

local function profilesDir()
    return configDir() .. "/profiles"
end

local function windowCornersPath()
    local root = noctalia.getenv("XDG_CONFIG_HOME")
    if root == nil or root == "" then root = "~/.config" end
    return noctalia.expandPath(root .. "/niri/cfg/window-corners.kdl")
end

local function validProfileFile(name)
    return string.match(name, "^[%w%._%-]+%.toml$") ~= nil
end

local function profileFiles()
    local names, err = noctalia.listDir(profilesDir())
    if names == nil then return {}, err end

    local out = {}
    for _, name in ipairs(names) do
        if validProfileFile(name) then table.insert(out, name) end
    end
    table.sort(out)
    return out, nil
end

local function currentProfile()
    local raw = noctalia.readFile(selectorPath())
    if raw == nil then return nil end
    return string.match(raw, 'profiles/([%w%._%-]+%.toml)')
end

local function currentWindowCornerMode()
    local content = noctalia.readFile(windowCornersPath()) or ""
    local radius = tonumber(string.match(content, "geometry%-corner%-radius%s+(%d+)")) or 0
    return radius > 0 and "Rounded" or "Square"
end

local function currentBarBlurMode()
    local content = noctalia.readFile(windowCornersPath()) or ""
    local enabled =
        string.match(content, "appearance%-bar%-blur=on") or
        string.match(content, "appearance%-island%-blur=on")
    return enabled and "Blur" or "Off"
end

local function applyWindowAppearance(cornerMode, blurMode)
    if cornerMode ~= "Square" and cornerMode ~= "Rounded" then
        return false, "invalid window-corner mode"
    end
    if blurMode ~= "Off" and blurMode ~= "Blur" then
        return false, "invalid bar blur mode"
    end
    local radius = cornerMode == "Rounded" and 20 or 0
    local content =
        "// Managed by notoxus/bar-profiles Appearance controls.\n" ..
        "// appearance-bar-blur=" .. (blurMode == "Blur" and "on" or "off") .. "\n" ..
        "window-rule {\n" ..
        "    geometry-corner-radius " .. radius .. "\n" ..
        "}\n"
    if blurMode == "Blur" then
        content = content ..
            "layer-rule {\n" ..
            '    match namespace=r#"^noctalia-bar-(main|media-island)$"#\n' ..
            "    background-effect {\n" ..
            "        blur true\n" ..
            "    }\n" ..
            "}\n"
    end
    local path = windowCornersPath()
    if noctalia.readFile(path) == content then return true, nil end

    local ok, err = noctalia.writeFile(path, content)
    if not ok then return false, err or "failed to write Niri window-corner rule" end
    if not noctalia.runAsync({ "niri", "msg", "action", "load-config-file" }) then
        return false, "could not reload Niri configuration"
    end
    return true, nil
end

local function labelFor(name)
    if name == nil then return "None" end
    local stem = string.gsub(name, "%.toml$", "")
    -- string.gsub returns both the result and the replacement count. Capture
    -- the result so callers such as table.insert receive exactly one value.
    local label = string.gsub(stem, "[-_]+", " ")
    return label
end

local function applyProfile(name)
    if not validProfileFile(name) then
        return false, "invalid profile filename"
    end

    local files = profileFiles()
    local found = false
    for _, candidate in ipairs(files) do
        if candidate == name then found = true break end
    end
    if not found then return false, "profile file does not exist" end

    local content =
        "# Managed by notoxus/bar-profiles. Change layouts from its Control Center tile.\n" ..
        "[include]\n" ..
        'files = ["profiles/' .. name .. '"]\n'

    local ok, err = noctalia.writeFile(selectorPath(), content)
    if not ok then return false, err or "failed to write selector" end

    noctalia.state.set("profile", name)
    return true, nil
end

local BUILTIN_THEMES = {
    "Ayu",
    "Catppuccin",
    "Dracula",
    "Eldritch",
    "Gruvbox",
    "Kanagawa",
    "Noctalia",
    "Nord",
    "Rosé Pine",
    "Tokyo-Night",
}

local WALLPAPER_THEME = "Wallpaper colors"
local WALLPAPER_SCHEME = "m3-content"
local THEME_OPTIONS = {}
for _, theme in ipairs(BUILTIN_THEMES) do
    table.insert(THEME_OPTIONS, theme)
end
table.insert(THEME_OPTIONS, WALLPAPER_THEME)

local THEME_MODES = { "dark", "light", "auto" }

local function currentTheme()
    if noctalia.getSetting("theme.source") == "wallpaper" then
        return WALLPAPER_THEME
    end
    return noctalia.getSetting("theme.builtin") or "Noctalia"
end

local function currentMode()
    return noctalia.getSetting("theme.mode") or "dark"
end

local function themeCommand(theme)
    if theme == WALLPAPER_THEME then
        return "noctalia msg color-scheme-set wallpaper " .. WALLPAPER_SCHEME
    end

    for _, builtin in ipairs(BUILTIN_THEMES) do
        if builtin == theme then
            return "noctalia msg color-scheme-set builtin " .. string.format("%q", builtin)
        end
    end

    return nil
end

return {
    profilesDir = profilesDir,
    profileFiles = profileFiles,
    currentProfile = currentProfile,
    labelFor = labelFor,
    applyProfile = applyProfile,
    currentWindowCornerMode = currentWindowCornerMode,
    currentBarBlurMode = currentBarBlurMode,
    applyWindowAppearance = applyWindowAppearance,
    cornerOptions = { "Square", "Rounded" },
    themeOptions = THEME_OPTIONS,
    themeCommand = themeCommand,
    themeModes = THEME_MODES,
    currentTheme = currentTheme,
    currentMode = currentMode,
}
