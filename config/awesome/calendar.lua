local string = {format = string.format}
local os = {date = os.date, time = os.time}
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local tooltip = require("tooltip")

local calendar = {}
local calendar_box

local function days_in_month(month, year)
    local last_day = os.date("*t", os.time({month = month + 1, year = year, day = 0}))
    return last_day.day
end

local function fill_calendar(self)
    local res = "\n"
    if self.show_wday then
        if self.show_week then
            daystr = string.format(self.format_week_spacing, "")
            daystr = string.format(self.format_wday, daystr)
            res = string.format("%s%s", res, daystr)
        end
        for i = 1, 7 do
            daystr = string.format(self.format_wday_spacing, os.date("%a", os.time{year=1, month=1, day=i + (self.start_wday - 2)}))
            daystr = string.format(self.format_wday, daystr)
            res = string.format("%s%s", res, daystr)
        end
        res = res .. "\n"
    end

    local now = os.date("*t")
    local time = os.time({month = self.month, year = self.year, day = 1})
    local gen_start = os.date("*t", time)
    local has_cur_day = (gen_start.month == now.month and gen_start.year == now.year)
    local month_days = days_in_month(self.month, self.year)
    local prev_month_days = days_in_month(self.month - 1, self.year)
    local wday = gen_start.wday - self.start_wday + 1
    local day = 1
    local week = tonumber(os.date("%V", time))
    local daystr

    self.month_text:set_markup(os.date('<span font="10">%B</span>', time))
    self.year_text:set_markup(os.date('<span font="10">%Y</span>', time))

    daystr = string.format(self.format_week_spacing, week)
    res = res .. string.format(self.format_week, daystr)

    if wday <= 0 then
        wday = wday + 7
    end
    for i = 1, wday - 1 do
        daystr = string.format(self.format_prev_month_spacing, prev_month_days - (wday - i - 1))
        res = res .. string.format(self.format_prev_month, daystr)
    end

    while day <= month_days do
        daystr = string.format(self.format_day_spacing, day)
        if has_cur_day and day == now.day then
            daystr = string.format(self.format_current_day, daystr)
        end
        daystr = string.format(self.format_day[(self.start_wday + wday - 2) % 7 + 1], daystr)
        res = res .. daystr
        if wday == 7 then
            wday = 1
            week = week + 1
            if day < month_days then
                daystr = string.format(self.format_week_spacing, week)
                res = string.format("%s\n" .. self.format_week, res, daystr)
            end
        else
            wday = wday + 1
        end
        day = day + 1
    end

    self.calendar_text:set_markup('<span font_desc="Inconsolata LGC 10">' .. res .. '</span>')
end

local function set_geometry(self)
    local my_geo = self.wibox:geometry()

    local cw, ch = self.data.calendar_text:fit(600, 600)
    local mw, mh = self.data.month_layout:fit(600, 600)
    local yw, yh = self.data.year_layout:fit(600, 600)
    local hw = mw + yw + 5

    local n_w, n_h = self.data.main_layout:fit(hw > cw and hw or cw, 600)
    n_w = n_w + 2 * self.margin
    n_h = n_h + 2 * self.margin
    if my_geo.width ~= n_w or my_geo.height ~= n_h then
        self.wibox:geometry({ width = n_w, height = n_h })
    end
end

local function move_date(self, months)
    self.month = self.month + months
    fill_calendar(self)
    self.tooltip.geometry()
end

local function move_today(self)
    self.month = os.date("%m")
    self.year = os.date("%Y")
    move_date(self, 0)
end

local function create_calendar_box(args)
    local self = {
        main_layout = wibox.layout.fixed.vertical(),

        header_layout = wibox.layout.align.horizontal(),
        month_layout = wibox.layout.fixed.horizontal(),
        month_prev = wibox.widget.textbox(),
        month_next = wibox.widget.textbox(),
        month_text = wibox.widget.textbox(),
        year_layout = wibox.layout.fixed.horizontal(),
        year_prev = wibox.widget.textbox(),
        year_next = wibox.widget.textbox(),
        year_text = wibox.widget.textbox(),

        calendar_text = wibox.widget.textbox(),

        show_week = args.show_week or true,
        show_wday = args.show_wday or true,
        start_wday = (args.start_wday or 1) + 1,
        format_week_spacing = args.format_week_spacing or "%2s",
        format_wday_spacing = args.format_week_spacing or " %3s",
        format_day_spacing = args.format_day_spacing or " %2s ",
        format_prev_month_spacing = args.format_day_spacing or " %2s ",
        format_current_day = args.format_current_day or '<span background="#0D5077">%s</span>',
        format_day = {
            args.format_day0 or '<span foreground="#ff4040">%s</span>',
            args.format_day1 or '%s',
            args.format_day2 or '%s',
            args.format_day3 or '%s',
            args.format_day4 or '%s',
            args.format_day5 or '%s',
            args.format_day6 or '<span foreground="#ff4040">%s</span>'
        },
        format_week = args.format_week or '<span background="#0D5077">%s</span>',
        format_wday = args.format_wday or '<span background="#0D5077">%s</span>',
        format_prev_month = args.format_wday or '<span foreground="#303030">%s</span>',

        month = 0,
        year = 0
    }

    self.month_layout:add(self.month_prev)
    self.month_layout:add(self.month_text)
    self.month_layout:add(self.month_next)

    self.year_layout:add(self.year_prev)
    self.year_layout:add(self.year_text)
    self.year_layout:add(self.year_next)

    self.month_prev:set_text('  ◀  ')
    self.month_prev:buttons(awful.util.table.join(
        awful.button({ }, 1, function() move_date(calendar_box, -1) end)))
    self.month_next:set_text('  ▶  ')
    self.month_next:buttons(awful.util.table.join(
        awful.button({ }, 1, function() move_date(calendar_box, 1) end)))
    self.year_prev:set_text('  ◀  ')
    self.year_prev:buttons(awful.util.table.join(
        awful.button({ }, 1, function() move_date(calendar_box, -12) end)))
    self.year_next:set_text('  ▶  ')
    self.year_next:buttons(awful.util.table.join(
        awful.button({ }, 1, function() move_date(calendar_box, 12) end)))

    self.header_layout:set_left(self.month_layout)
    self.header_layout:set_right(self.year_layout)

    self.main_layout:add(self.header_layout)
    self.main_layout:add(self.calendar_text)

    self.tooltip = tooltip.create({
        widget = self.main_layout,
        margin = args.margin or 4,
        data = self,
        geometry = function(tooltip)
            set_geometry(tooltip)
        end
    })

    return self
end

function calendar.register(widget, args)
    if not calendar_box then
        calendar_box = create_calendar_box(args)
    end

    widget:buttons(awful.util.table.join(
        awful.button({ }, 1, function()
            move_today(calendar_box)
            calendar_box.tooltip.toggle_visibility()
        end),
        awful.button({ }, 2, function()
            move_today(calendar_box)
        end),
        awful.button({ }, 3, function()
            move_today(calendar_box)
            calendar_box.tooltip.toggle_visibility()
        end)
    ))

end

return calendar
