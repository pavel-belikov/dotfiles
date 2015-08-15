local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local tooltip = {}

local function geometry(self)
    local w, h = self.margin_layout:fit(600, 600)
    self.wibox:geometry({width = w, height = h})
end

function tooltip.create(args)
    local self = {
        wibox = wibox({}),
        margin_layout = wibox.layout.margin(),
        hide_timer = args.hide_timer and timer({timeout = args.hide_timer}) or nil,
        margin = args.margin or 8,
        data = args.data
    }
    self.geometry = args.geometry and
            function() args.geometry(self) end or
            function() geometry(self) end
    self.show = function()
        self.wibox.visible = true
        self.geometry()
        awful.placement.under_mouse(self.wibox)
        awful.placement.no_offscreen(self.wibox)
        if self.hide_timer then
            self.hide_timer:start()
        end
    end
    self.hide = function()
        self.wibox.visible = false
        if self.hide_timer then
            self.hide_timer:stop()
        end
    end
    self.toggle_visibility = function()
        if self.wibox.visible then
            self.hide()
        else
            self.show()
        end
    end
    self.wibox.visible = false
    self.wibox.ontop = true
    self.wibox.border_width = beautiful.tooltip_border_width or beautiful.border_width or 5
    self.wibox.border_color = beautiful.tooltip_border_color or beautiful.border_normal or '#2D2D2D'
    self.wibox.opacity = beautiful.tooltip_opacity or 1
    self.wibox:set_bg(beautiful.tooltip_bg_color or beautiful.bg_focus or '#1D1D1D')
    self.wibox:set_fg(beautiful.tooltip_fg_color or beautiful.fg_focus or "#ffffff")
    self.margin_layout:set_top(self.margin)
    self.margin_layout:set_bottom(self.margin)
    self.margin_layout:set_left(self.margin)
    self.margin_layout:set_right(self.margin)
    self.margin_layout:set_widget(args.widget)
    self.wibox:set_widget(self.margin_layout)

    if self.hide_timer then
        self.hide_timer:connect_signal("timeout", self.hide)
        self.wibox:connect_signal("mouse::enter",
        function()
            self.hide_timer:stop()
        end)
        self.wibox:connect_signal("mouse::leave",
        function() 
            self.hide_timer:again()
        end)
    end
    return self
end

return tooltip
