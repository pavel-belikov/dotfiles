local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local tooltip = require("tooltip")
local gears = require("gears")
local mouse = mouse

local volume = {}

local data = {}

local function get_volume(amixer_cmd)
    local fd = io.popen(amixer_cmd)
    local status = fd:read("*all")
    fd:close()
    status = string.match(status, "%[%d+%%%] %[[^%]]+%]")
    if status then
    local volume = string.match(status, "%d+")
        local muted = not string.find(status, "on")
        return tonumber(volume), muted
    end
    return 0
end

local function set_volume(amixer_cmd, v)
    awful.util.spawn_with_shell(string.format(amixer_cmd, v))
end

local function mute(amixer_cmd)
    awful.util.spawn_with_shell(amixer_cmd)
end

local function set_volume_widget(self, volume, mute)
    if mute then
        self:set_image(data[self].img_muted)
    elseif volume == 0 then
        self:set_image(data[self].img_off)
    elseif volume <= 35 then
        self:set_image(data[self].img_low)
    elseif volume <= 90 then
        self:set_image(data[self].img_medium)
    else
        self:set_image(data[self].img_high)
    end

    if data[self].tooltip.wibox.visible then
        data[self].prev_value = volume
        data[self].slider.value = volume
    end
end

local function change_volume(self)
    local value = data[self].slider.value
    if value ~= (data[self].prev_value or -1) then
        data[self].set_volume(value)
        set_volume_widget(self, value, false)
    end
end

local function update_volume_widget(self)
    local volume, mute = data[self].get_volume()
    set_volume_widget(self, volume, mute)
end

local function create_tooltip(self, args)
    data[self].tooltip = tooltip.create({
        hide_timer = args.hide_timer or 2,
        widget = data[self].layout,
        geometry = function(tooltip)
            tooltip.wibox:geometry({
                width = tooltip.margin * 2 + data[self].width,
                height = tooltip.margin * 2 + data[self].height
            })
        end,
        margin = args.margin or 8
    })

    data[self].reversepb:set_widget(data[self].slider)
    data[self].reversepb:set_direction("west")
    data[self].layout:add(data[self].reversepb)

    self:buttons(awful.util.table.join(
        awful.button({ }, 1, function()
            data[self].tooltip.toggle_visibility()
            data[self].update()
        end),
        awful.button({ }, 2, function()
            data[self].tooltip.hide()
            awful.util.spawn_with_shell(data[self].external_mixer)
        end),
        awful.button({ }, 3, function()
            local volume, mute = data[self].get_volume()
            if mute then
                data[self].unmute()
            else
                data[self].mute()
            end
            set_volume_widget(self, volume, not mute)
        end)
    ))
    data[self].slider:connect_signal("property::value", function() change_volume(self) end)
end

function volume.widget(args)
    local self = wibox.widget.imagebox()
    data[self] = {
        get_volume = args.get_volume or function() return get_volume(args.get_cmd or "amixer sget Master") end,
        set_volume = args.set_volume or function(v) set_volume(args.set_cmd or "amixer sset Master %d%% unmute", v) end,
        mute = args.mute or function() mute(args.mute_cmd or "amixer sset Master mute") end,
        unmute = args.unmute or function() mute(args.unmute_cmd or "amixer sset Master unmute") end,
        update = function() update_volume_widget(self) end,
        external_mixer = args.mixer or "pavucontrol",
        round = args.round or 0.05,
        layout = wibox.layout.fixed.vertical(),
        reversepb = wibox.container.rotate(),
        slider = wibox.widget.slider(),
        height = args.height or 100,
        width = args.width or 10,

        img_muted = args.muted or beautiful.volume_muted,
        img_off = args.off or beautiful.volume_off,
        img_low = args.low or beautiful.volume_low,
        img_medium = args.medium or beautiful.volume_medium,
        img_high = args.high or beautiful.volume_high
    }

    data[self].slider.handle_shape = gears.shape.circle

    create_tooltip(self, args)
    if beautiful.volume_border_width then
        data[self].tooltip.wibox.border_width = beautiful.volume_border_width
    end
    if beautiful.volume_border_color then
        data[self].tooltip.wibox.border_color = beautiful.volume_border_color
    end
    if beautiful.volume_opacity then
        data[self].tooltip.wibox.opacity = beautiful.volume_opacity
    end
    if beautiful.volume_bg_color then
        data[self].tooltip.wibox:set_bg(beautiful.volume_bg_color)
    end
    if beautiful.volume_fg_color then
        data[self].tooltip.wibox:set_fg(beautiful.volume_fg_color)
    end
    data[self].update()
    local timer = timer({ timeout = args.timeout or 1 })
    timer:connect_signal("timeout", data[self].update)
    timer:start()
    return self
end

return volume
