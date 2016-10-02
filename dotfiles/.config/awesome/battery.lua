local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local tooltip = require("tooltip")

local battery = {}
local data = {}

local function get_status()
    local fd = io.popen("acpi")
    local state = fd:read()
    fd:close()
    local status = string.match(state, ": [^,]+,")
    local capacity = string.match(state, "%d+%%"):sub(1, -2)
    local remaining = string.match(state, "%d+:%d+:%d+")
    return tonumber(capacity), status ~= ": Discharging,", remaining
end

local function get_brightness()
    local f = io.popen("xbacklight -get")
    local l = f:read()
    f:close()
    return l
end

local function set_brightness(level)
    awful.util.spawn_with_shell("xbacklight -set " .. level)
end

local function update_brightness_tooltip(self, b)
    local i, f = math.modf(b / data[self].round)
    b = data[self].round * (i + math.floor(f + 0.5))
    data[self].brightness_text:set_text(b)
end

local function brightness_change(self, delta, is_circular)
    local b = data[self].get_brightness()
    local i, f = math.modf(b / data[self].round)
    b = data[self].round * (i + math.floor(f + 0.5))
    b = b + delta
    if is_circular then
        b = b % 100
        if b == 0 then
            b = 100
        end
    end
    if b <= data[self].round then
        b = data[self].round
    elseif b > 100 then
        b = 100
    end
    data[self].set_brightness(b)
    update_brightness_tooltip(self, b)
end

local function update_battery(self, capacity, is_charging, remaining)
    if is_charging then
        if capacity < 20 then
            self:set_image(beautiful.battery_000ch)
        elseif capacity < 40 then
            self:set_image(beautiful.battery_020ch)
        elseif capacity < 60 then
            self:set_image(beautiful.battery_040ch)
        elseif capacity < 80 then
            self:set_image(beautiful.battery_060ch)
        elseif capacity < 100 then
            self:set_image(beautiful.battery_080ch)
        else
            self:set_image(beautiful.battery_100ch)
        end
    else
        if capacity < 20 then
            self:set_image(beautiful.battery_000)
        elseif capacity < 40 then
            self:set_image(beautiful.battery_020)
        elseif capacity < 60 then
            self:set_image(beautiful.battery_040)
        elseif capacity < 80 then
            self:set_image(beautiful.battery_060)
        elseif capacity < 100 then
            self:set_image(beautiful.battery_080)
        else
            self:set_image(beautiful.battery_100)
        end
    end
    if data[self].tooltip.wibox.visible then
        update_brightness_tooltip(self, data[self].get_brightness())
        local status = capacity .. "%"
        if is_charging then
            status = status .. " (charging)"
        end
        if remaining then
            status = status .. ", " .. remaining .. " remaining"
        end
        data[self].status_text:set_markup(status)
    end
end

function battery.widget(args)
    local self = wibox.widget.imagebox()
    data[self] = {
        get_status = args.get_status or function() return get_status() end,
        get_brightness = args.get_brightness or function() return get_brightness() end,
        set_brightness = args.set_brightness or function(b) set_brightness(b) end,
        layout = wibox.layout.fixed.vertical(),
        status_text = wibox.widget.textbox(),
        brightness_layout = wibox.layout.fixed.horizontal(),
        brightness_icon = wibox.widget.imagebox(),
        brightness_text = wibox.widget.textbox(),
        round = args.round or 25
    }

    data[self].tooltip = tooltip.create({
        widget = data[self].layout,
        hide_timer = args.hide_timer or 2,
        margin = args.margin,
        geometry = function(tooltip)
            tooltip.wibox:geometry({
                width = tooltip.margin * 2 + (args.width or 250),
                height = tooltip.margin * 2 + (args.height or 40)
            })
        end
    })

    if beautiful.battery_border_width then
        data[self].tooltip.wibox.border_width = beautiful.battery_border_width
    end
    if beautiful.battery_border_color then
        data[self].tooltip.wibox.border_color = beautiful.battery_border_color
    end
    if beautiful.battery_opacity then
        data[self].tooltip.wibox.opacity = beautiful.battery_opacity
    end
    if beautiful.battery_bg_color then
        data[self].tooltip.wibox:set_bg(beautiful.battery_bg_color)
    end
    if beautiful.battery_fg_color then
        data[self].tooltip.wibox:set_bg(beautiful.battery_fg_color)
    end

    data[self].brightness_icon:set_image(beautiful.brightness_icon)
    data[self].brightness_layout:add(data[self].brightness_icon)
    data[self].brightness_layout:add(data[self].brightness_text)
    data[self].layout:add(data[self].status_text)
    data[self].layout:add(data[self].brightness_layout)

    data[self].brightness_layout:buttons(awful.util.table.join(
        awful.button({ }, 1, function() brightness_change(self, data[self].round, true) end),
        awful.button({ }, 3, function() brightness_change(self, -data[self].round, true) end),
        awful.button({ }, 4, function() brightness_change(self, data[self].round) end),
        awful.button({ }, 5, function() brightness_change(self, -data[self].round) end)
    ))

    self:buttons(awful.util.table.join(
        awful.button({ }, 1, function()
            data[self].tooltip.toggle_visibility()
            update_battery(self, data[self].get_status())
        end)
    ))

    local timer = timer({ timeout = args.timer or 1 })
    timer:connect_signal("timeout", function()
        update_battery(self, data[self].get_status())
    end)
    timer:start()
    update_battery(self, data[self].get_status())
    return self
end

return battery
