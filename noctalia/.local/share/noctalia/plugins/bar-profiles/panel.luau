--!nonstrict
local profiles = require("./common.luau")

local function render()
    local files, err = profiles.profileFiles()
    local current = profiles.currentProfile()

    local children = {
        ui.row({ align = "center", justify = "space_between" }, {
            ui.label({ text = "Bar Profiles", fontSize = 18, fontWeight = "bold", color = "primary", flexGrow = 1 }),
            ui.button({ glyph = "x", variant = "ghost", onClick = "closePanel" }),
        }),
        ui.label({
            text = "Switch the active Noctalia bar layout.",
            color = "on_surface/0.7",
        }),
        ui.separator({ spacing = 6 }),
    }

    if err ~= nil then
        table.insert(children, ui.label({ text = "Cannot read profiles: " .. tostring(err), color = "error" }))
    elseif #files == 0 then
        table.insert(children, ui.label({ text = "No profiles found in ~/.config/noctalia/profiles/", color = "on_surface/0.7" }))
    else
        local buttons = {}
        for _, name in ipairs(files) do
            local selected = name == current
            table.insert(buttons, ui.button({
                key = name,
                text = profiles.labelFor(name),
                glyph = selected and "check" or "layout-dashboard",
                variant = selected and "primary" or "outline",
                selected = selected,
                controlSize = "lg",
                contentAlign = "start",
                onClick = function()
                    local ok, applyErr = profiles.applyProfile(name)
                    if not ok then
                        noctalia.notifyError("Bar Profiles", tostring(applyErr))
                        return
                    end
                    noctalia.notify("Bar Profiles", "Switched to " .. profiles.labelFor(name))
                    panel.close()
                    noctalia.runAsync("noctalia msg config-reload")
                end,
            }))
        end
        table.insert(children, ui.scroll({ gap = 8, flexGrow = 1 }, buttons))
    end

    table.insert(children, ui.row({ gap = 8, justify = "end" }, {
        ui.button({ text = "Open folder", glyph = "folder", variant = "ghost", onClick = "openProfilesFolder" }),
        ui.button({ text = "Reload", glyph = "refresh", variant = "secondary", onClick = "reloadConfig" }),
    }))

    panel.render(ui.column({ gap = 10, padding = 14, fill = "surface" }, children))
end

function onOpen(context) render() end
function closePanel() panel.close() end
function reloadConfig() noctalia.runAsync("noctalia msg config-reload") end
function openProfilesFolder()
    noctalia.runAsync('xdg-open "' .. profiles.profilesDir() .. '"')
end
