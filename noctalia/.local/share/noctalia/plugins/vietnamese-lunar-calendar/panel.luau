--!nonstrict
local lunar = require("./lunar.luau")

local WEEKDAYS = { "T2", "T3", "T4", "T5", "T6", "T7", "CN" }
local MONTH_NAMES = {
    "Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4",
    "Tháng 5", "Tháng 6", "Tháng 7", "Tháng 8",
    "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12",
}

local viewMonth = tonumber(noctalia.formatTime("%m"))
local viewYear = tonumber(noctalia.formatTime("%Y"))

local function today()
    return tonumber(noctalia.formatTime("%d")),
        tonumber(noctalia.formatTime("%m")),
        tonumber(noctalia.formatTime("%Y"))
end

local function goMonth(delta)
    viewMonth = viewMonth + delta

    if viewMonth < 1 then
        viewMonth = 12
        viewYear = viewYear - 1
    elseif viewMonth > 12 then
        viewMonth = 1
        viewYear = viewYear + 1
    end
end

local function lunarText(l)
    if l.day == 1 then
        return string.format("%d/%d%s", l.day, l.month, l.leap and "N" or "")
    end
    return tostring(l.day)
end

local function render()
    local todayDay, todayMonth, todayYear = today()

    local children = {}

    table.insert(children, ui.row({
        align = "center",
        justify = "space_between",
    }, {
        ui.button({
            glyph = "chevron-left",
            variant = "ghost",
            tooltip = "Tháng trước",
            onClick = function()
                goMonth(-1)
                render()
            end,
        }),
        ui.column({ align = "center", gap = 2 }, {
            ui.label({
                text = MONTH_NAMES[viewMonth] .. " " .. tostring(viewYear),
                fontSize = 20,
                fontWeight = "bold",
            }),
            ui.label({
                text = "Âm lịch Việt Nam · UTC+7",
                fontSize = 12,
                color = "on_surface/0.6",
            }),
        }),
        ui.button({
            glyph = "chevron-right",
            variant = "ghost",
            tooltip = "Tháng sau",
            onClick = function()
                goMonth(1)
                render()
            end,
        }),
    }))

    local weekdayNodes = {}
    for i, name in ipairs(WEEKDAYS) do
        table.insert(weekdayNodes, ui.label({
            key = "weekday-" .. tostring(i),
            text = name,
            fontSize = 12,
            fontWeight = "bold",
            textAlign = "center",
            flexGrow = 1,
            color = i >= 6 and "primary" or "on_surface/0.7",
        }))
    end
    table.insert(children, ui.row({ gap = 4 }, weekdayNodes))

    local firstWeekday = lunar.weekdayMondayFirst(1, viewMonth, viewYear)
    local days = lunar.daysInSolarMonth(viewMonth, viewYear)

    local cell = 1
    for week = 1, 6 do
        local row = {}

        for weekday = 1, 7 do
            local day = cell - firstWeekday + 1

            if day < 1 or day > days then
                table.insert(row, ui.box({
                    key = "blank-" .. tostring(week) .. "-" .. tostring(weekday),
                    height = 64,
                    flexGrow = 1,
                }))
            else
                local l = lunar.solarToLunar(day, viewMonth, viewYear, 7)
                local festival = lunar.festival(l)
                local isToday =
                    day == todayDay
                    and viewMonth == todayMonth
                    and viewYear == todayYear

                local dayChildren = {
                    ui.label({
                        text = tostring(day),
                        fontSize = 16,
                        fontWeight = isToday and "bold" or "medium",
                        textAlign = "center",
                        color = isToday and "primary" or "on_surface",
                    }),
                    ui.label({
                        text = lunarText(l),
                        fontSize = 11,
                        textAlign = "center",
                        color = festival and "primary" or "on_surface/0.55",
                    }),
                }

                if festival then
                    table.insert(dayChildren, ui.label({
                        text = festival,
                        fontSize = 9,
                        maxLines = 1,
                        textAlign = "center",
                        color = "primary",
                    }))
                end

                table.insert(row, ui.column({
                    key = "day-" .. tostring(day),
                    gap = 1,
                    padding = 5,
                    minHeight = 64,
                    flexGrow = 1,
                    radius = 10,
                    fill = isToday and "primary/0.12"
                        or festival and "surface_variant/0.55"
                        or "transparent",
                    border = isToday and "primary" or "transparent",
                    borderWidth = isToday and 1 or 0,
                    align = "center",
                    justify = "center",
                }, dayChildren))
            end

            cell = cell + 1
        end

        table.insert(children, ui.row({ gap = 4 }, row))

        if cell - firstWeekday > days then
            break
        end
    end

    local selectedLunar = lunar.solarToLunar(todayDay, todayMonth, todayYear, 7)
    local festival = lunar.festival(selectedLunar)

    table.insert(children, ui.separator({ spacing = 4 }))

    table.insert(children, ui.row({
        align = "center",
        justify = "space_between",
        gap = 8,
    }, {
        ui.column({ gap = 2, flexGrow = 1 }, {
            ui.label({
                text = string.format(
                    "Hôm nay: %02d/%02d/%d · %02d/%02d%s âm lịch",
                    todayDay,
                    todayMonth,
                    todayYear,
                    selectedLunar.day,
                    selectedLunar.month,
                    selectedLunar.leap and " nhuận" or ""
                ),
                fontSize = 13,
                fontWeight = "medium",
            }),
            ui.label({
                text = "Năm " .. lunar.yearCanChi(selectedLunar.year)
                    .. (festival and (" · " .. festival) or ""),
                fontSize = 12,
                color = "on_surface/0.65",
            }),
        }),
        ui.button({
            text = "Hôm nay",
            glyph = "calendar-event",
            variant = "secondary",
            controlSize = "sm",
            onClick = function()
                viewMonth = todayMonth
                viewYear = todayYear
                render()
            end,
        }),
    }))

    panel.render(ui.column({
        gap = 10,
        padding = 14,
    }, children))
end

function onOpen(context)
    render()
end

function update()
    render()
end
