-- TODO: extract images from tags

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local cmus = {}
local data = {}

local function set_geometry(self)
    local my_geo = data[self].wibox:geometry()
    local tw, th = data[self].text:fit(1200, 1200)
    local size = th > data[self].size and th or data[self].size
    local w, h = tw + size + data[self].margin * 3, size
    if my_geo.width ~= w or my_geo.height ~= h then
        data[self].wibox:geometry({ width = w, height = h })
    end
end

local function update_music_tooltip(self)
    local cmd = string.format("cmus-remote -C 'format_print %s'", data[self].tooltip_format)
    local fd = io.popen(cmd)
    local layout = fd:read("*all")
    fd:close()

    cmd = "dirname \"`cmus-remote -C 'format_print %f'`\""
    fd = io.popen(cmd)
    local filepath = fd:read()
    fd:close()

    if layout then
        local cover = beautiful.cmus_nocover
        for i, pattern in pairs(data[self].image_patterns) do
            local img = filepath .. '/' .. pattern
            if awful.util.file_readable(img) then
                cover = img
                break
            end
        end
        data[self].image:set_image(cover)
        data[self].text:set_markup(string.format('<span font_desc="Inconsolata LGC 10">%s</span>', awful.util.escape(string.sub(layout, 1, -2))))
    else
        data[self].wibox.visible = false
        return
    end
    set_geometry(self)
    awful.placement.no_offscreen(data[self].wibox)
end

local function update_music_widget(self)
    local cmd = string.format('cmus-remote -C \'format_print "%s"\'', data[self].format)
    local fd = io.popen(cmd)
    local layout = fd:read()
    fd:close()
    if layout then
        self:set_text(' ' .. layout .. ' ')
    else
        self:set_text(' ')
    end

    if data[self].wibox.visible then
        update_music_tooltip(self)
    end

end

function cmus.toggle_play_pause()
    awful.util.spawn_with_shell("cmus-remote -u")
end

function cmus.next()
    awful.util.spawn_with_shell("cmus-remote -n")
end

function cmus.prev()
    awful.util.spawn_with_shell("cmus-remote -r")
end

function cmus.focus()
    local clients = client.get()
    for i, c in pairs(clients) do
        if c.class == "cmus" then
            client.focus = c
            c:raise()
            awful.tag.viewonly(c:tags()[1])
            break
        end
    end
end

local function create_tooltip(self, args)
    data[self].space:set_strategy("exact")
    data[self].space:set_width(data[self].margin)
    data[self].text:set_align("left")
    data[self].text:set_valign("top")
    data[self].wibox.border_width = beautiful.cmus_border_width or beautiful.tooltip_border_width or beautiful.border_width or 1
    data[self].wibox.border_color = beautiful.cmus_border_color or beautiful.tooltip_border_color or beautiful.border_normal or "#ffffff"
    data[self].wibox.opacity = beautiful.cmus_opacity or beautiful.tooltip_opacity or 1
    data[self].wibox:set_fg(beautiful.cmus_fg_color or beautiful.tooltip_fg_color or beautiful.fg_focus or "#ffffff")
    data[self].wibox:set_bg(beautiful.cmus_bg_color or beautiful.tooltip_bg_color or beautiful.bg_focus or "#000000")
    data[self].wibox.visible = false
    data[self].wibox.ontop = true

    data[self].layout:add(data[self].image)
    data[self].layout:add(data[self].space)
    data[self].layout:add(data[self].text)

    data[self].margin_layout:set_top(data[self].margin)
    data[self].margin_layout:set_bottom(data[self].margin)
    data[self].margin_layout:set_left(data[self].margin)
    data[self].margin_layout:set_right(data[self].margin)
    data[self].margin_layout:set_widget(data[self].layout)

    data[self].wibox:set_widget(data[self].margin_layout)
end

function cmus.update()
    for self, data in pairs(data) do
        self.update()
    end
end

function cmus.widget(args)
    local self = wibox.widget.textbox()
    data[self] = {
        format = args and args.format or "%{?status=\\\">\\\"?▶?▮▮} %a - %02n. %t (%{position}/%{duration})",
        update = function() update_music_widget(self) end,
        wibox = wibox({ }),
        margin_layout = wibox.layout.margin(),
        layout = wibox.layout.fixed.horizontal(),
        space = wibox.layout.constraint(),
        image = wibox.widget.imagebox(),
        text = wibox.widget.textbox(),

        tooltip_format = args.tooltip_format or '"Artist: %a" "Album:  %l" "Track:  %n" "Title:  %t" "Genre:  %g" "Year:   %y"',
        margin = args.margin or 8,
        size = args.size or 128,
        image_patterns = args.image_patterns or {
            "cover.png",
            "cover.jpg"
        }
    }
    self:buttons(awful.util.table.join(
        awful.button({ }, 1, cmus.toggle_play_pause),
        awful.button({ }, 2, function()
            awful.placement.under_mouse(data[self].wibox)
            update_music_tooltip(self)
            data[self].wibox.visible = true
        end),
        awful.button({ }, 3, cmus.focus),
        awful.button({ }, 4, cmus.prev),
        awful.button({ }, 5, cmus.next)
    ))
    self:connect_signal("mouse::leave", function()
        data[self].wibox.visible = false
    end)

    if args.timeout and args.timeout == 0 then

    else
        local timer = timer({ timeout = args.timeout or 1 })
        timer:connect_signal("timeout", data[self].update)
        timer:start()
    end
    
    self.update = data[self].update
    create_tooltip(self, args)
    data[self].update()

    return self
end

return cmus
