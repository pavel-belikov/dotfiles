local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local mouse = mouse

local volume = {}

local data = {}

local function get_volume(amixer_cmd)
    local fd = io.popen(amixer_cmd)
    local status = fd:read("*all")
    fd:close()
    status = string.match(status, "%[%d+%%%] %[[^%]]+%]")
    local volume = string.match(status, "%d+")
    local muted = not string.find(status, "on")
    return tonumber(volume), muted
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

    if data[self].wibox.visible then
        data[self].progressbar:set_value(volume / 100)
    end
end

local function change_volume(self)
    local coords = mouse.coords()
    local g = data[self].wibox:geometry()
    local m = data[self].margin
    if coords.x >= g.x + m / 2 and coords.x < g.x + g.width - m / 2 and
       coords.y >= g.y + m / 2 and coords.y < g.y + g.height - m / 2 then
        local v = (coords.y - g.y - m) / (g.height - 2 * m)
        local i, f = math.modf(v / data[self].round)
        v = data[self].round * (i + math.floor(f + 0.5)) * 100
        if v <= 0 then
            v = 0
        elseif v >= 100 then
            v = 100
        end
        data[self].set_volume(v)
        set_volume_widget(self, v, false)
    end
end

local function update_volume_widget(self)
    local volume, mute = data[self].get_volume()
    set_volume_widget(self, volume, mute)
end

local function toggle_visibility(self)
    if data[self].wibox.visible then
        data[self].wibox.visible = false
    else
        awful.placement.under_mouse(data[self].wibox)
        awful.placement.no_offscreen(data[self].wibox)
        data[self].wibox.visible = true
        update_volume_widget(self)
    end
end

local function create_tooltip(self, args)
    data[self].wibox.ontop = true
    data[self].wibox.visible = false

    data[self].progressbar:set_vertical(true)
    data[self].progressbar:set_background_color(args.background or beautiful.volume_background or "#0024ff")
    data[self].progressbar:set_color(args.color or beautiful.volume_color or "#008cff")
    data[self].progressbar:set_height(data[self].height)

    data[self].reversepb:set_widget(data[self].progressbar)
    data[self].reversepb:set_direction("south")
    data[self].layout:add(data[self].reversepb)

    data[self].margin_layout:set_top(data[self].margin)
    data[self].margin_layout:set_bottom(data[self].margin)
    data[self].margin_layout:set_left(data[self].margin)
    data[self].margin_layout:set_right(data[self].margin)
    data[self].margin_layout:set_widget(data[self].layout)
    data[self].wibox:set_widget(data[self].margin_layout)

    self:buttons(awful.util.table.join(
        awful.button({ }, 1, function() toggle_visibility(self) end),
        awful.button({ }, 2, function()
            if data[self].wibox.visible then
                data[self].wibox.visible = false
            end
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
    data[self].wibox:buttons(awful.util.table.join(
        awful.button({ }, 1, function() change_volume(self) end)
    ))
    data[self].wibox:geometry({
        width = data[self].margin * 2 + data[self].width,
        height = data[self].margin * 2 + data[self].height
    })

    data[self].hide_timer:connect_signal("timeout", function()
        data[self].wibox.visible = false
        data[self].hide_timer:stop()
    end)

    data[self].wibox:connect_signal("mouse::enter", function() data[self].hide_timer:stop() end)

    data[self].wibox:connect_signal("mouse::leave", function() data[self].hide_timer:again() end)
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
        wibox = wibox({ }),
        margin_layout = wibox.layout.margin(),
        layout = wibox.layout.fixed.vertical(),
        reversepb = wibox.layout.rotate(),
        progressbar = awful.widget.progressbar(),
        margin = args.margin or 8,
        height = args.height or 100,
        width = args.width or 10,
        hide_timer = timer({ timeout = args.hide_timer or 2}),
        img_muted = args.muted or beautiful.volume_muted,
        img_off = args.off or beautiful.volume_off,
        img_low = args.low or beautiful.volume_low,
        img_medium = args.medium or beautiful.volume_medium,
        img_high = args.high or beautiful.volume_high
    }
    create_tooltip(self, args)
    data[self].update()
    timer = timer({ timeout = args.timeout or 1 })
    timer:connect_signal("timeout", data[self].update)
    timer:start()
    self:connect_signal("mouse::leave", function() data[self].hide_timer:start() end)
    return self
end

return volume
