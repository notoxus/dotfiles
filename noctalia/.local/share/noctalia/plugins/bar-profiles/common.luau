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

local function labelFor(name)
    if name == nil then return "None" end
    local stem = string.gsub(name, "%.toml$", "")
    return string.gsub(stem, "[-_]+", " ")
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

return {
    profilesDir = profilesDir,
    profileFiles = profileFiles,
    currentProfile = currentProfile,
    labelFor = labelFor,
    applyProfile = applyProfile,
}
