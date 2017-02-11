theme = {}

local awful = require("awful")
prefix = awful.util.getdir("config")

theme.font          = "Droid Sans 10"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#008cff"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#f0f0f0"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#aaaaaa"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.tasklist_bg_focus = "#0060ff"

-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]

-- Display the taglist squares
theme.taglist_squares_sel   = prefix .. "/themes/simplicity/taglist/squarefw.png"
theme.taglist_squares_unsel = prefix .. "/themes/simplicity/taglist/squarew.png"

theme.tooltip_bg_color = "#1D1D1D"
theme.tooltip_border_width = 5
theme.tooltip_border_color = "#2D2D2D"

theme.calendar_bg_color = "#1D1D1D"
theme.calendar_border_width = 5
theme.calendar_border_color = "#2D2D2D"

theme.cmus_fg_color = "#ffff70"
theme.cmus_bg_color = "#101010"
theme.cmus_border_width = 2
theme.cmus_border_color = "#5D5D5D"

theme.volume_bg_color = "#2D2D2D"
theme.volume_border_width = 0
theme.volume_background = "#0024ff"
theme.volume_color = "#008cff"

theme.battery_000 = prefix .. "/themes/simplicity/panel/battery-000.svg"
theme.battery_000ch = prefix .. "/themes/simplicity/panel/battery-000-charging.svg"
theme.battery_020 = prefix .. "/themes/simplicity/panel/battery-020.svg"
theme.battery_020ch = prefix .. "/themes/simplicity/panel/battery-020-charging.svg"
theme.battery_040 = prefix .. "/themes/simplicity/panel/battery-040.svg"
theme.battery_040ch = prefix .. "/themes/simplicity/panel/battery-040-charging.svg"
theme.battery_060 = prefix .. "/themes/simplicity/panel/battery-060.svg"
theme.battery_060ch = prefix .. "/themes/simplicity/panel/battery-060-charging.svg"
theme.battery_080 = prefix .. "/themes/simplicity/panel/battery-080.svg"
theme.battery_080ch = prefix .. "/themes/simplicity/panel/battery-080-charging.svg"
theme.battery_100 = prefix .. "/themes/simplicity/panel/battery-100.svg"
theme.battery_100ch = prefix .. "/themes/simplicity/panel/battery-100-charging.svg"

theme.brightness_icon = prefix .. "/themes/simplicity/panel/brightness.svg"
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = prefix .. "/themes/simplicity/submenu.png"
theme.menu_height = 20
theme.menu_width  = 250

theme.titlebar_close_button_normal = prefix .. "/themes/simplicity/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = prefix .. "/themes/simplicity/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = prefix .. "/themes/simplicity/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = prefix .. "/themes/simplicity/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = prefix .. "/themes/simplicity/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = prefix .. "/themes/simplicity/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = prefix .. "/themes/simplicity/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = prefix .. "/themes/simplicity/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = prefix .. "/themes/simplicity/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = prefix .. "/themes/simplicity/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = prefix .. "/themes/simplicity/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = prefix .. "/themes/simplicity/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = prefix .. "/themes/simplicity/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = prefix .. "/themes/simplicity/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = prefix .. "/themes/simplicity/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = prefix .. "/themes/simplicity/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = prefix .. "/themes/simplicity/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = prefix .. "/themes/simplicity/titlebar/maximized_focus_active.png"

theme.wallpaper = prefix .. "/themes/simplicity/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = prefix .. "/themes/simplicity/layouts/fairhw.png"
theme.layout_fairv = prefix .. "/themes/simplicity/layouts/fairvw.png"
theme.layout_floating  = prefix .. "/themes/simplicity/layouts/floatingw.png"
theme.layout_magnifier = prefix .. "/themes/simplicity/layouts/magnifierw.png"
theme.layout_max = prefix .. "/themes/simplicity/layouts/maxw.png"
theme.layout_fullscreen = prefix .. "/themes/simplicity/layouts/fullscreenw.png"
theme.layout_tilebottom = prefix .. "/themes/simplicity/layouts/tilebottomw.png"
theme.layout_tileleft   = prefix .. "/themes/simplicity/layouts/tileleftw.png"
theme.layout_tile = prefix .. "/themes/simplicity/layouts/tilew.png"
theme.layout_tiletop = prefix .. "/themes/simplicity/layouts/tiletopw.png"
theme.layout_spiral  = prefix .. "/themes/simplicity/layouts/spiralw.png"
theme.layout_dwindle = prefix .. "/themes/simplicity/layouts/dwindlew.png"

theme.awesome_icon = prefix .. "/icons/awesome16.png"
theme.launcher_icon = prefix .. "/themes/simplicity/debian.png"

theme.cmus_nocover = prefix .. "/themes/simplicity/notifications/nocover.png"

theme.volume_off = prefix .. "/themes/simplicity/panel/audio-volume-off.svg"
theme.volume_low = prefix .. "/themes/simplicity/panel/audio-volume-low.svg"
theme.volume_medium = prefix .. "/themes/simplicity/panel/audio-volume-medium.svg"
theme.volume_high = prefix .. "/themes/simplicity/panel/audio-volume-high.svg"
theme.volume_muted = prefix .. "/themes/simplicity/panel/audio-volume-muted.svg"

theme.mail = prefix .. "/themes/simplicity/panel/mail.svg"
theme.mail_new = prefix .. "/themes/simplicity/panel/mail-new.svg"

theme.icon_theme = nil

theme.poweroff = prefix .. "/themes/simplicity/panel/system-poweroff.svg"
theme.reboot = prefix .. "/themes/simplicity/panel/system-reboot.svg"

theme.slider_bar_border_width = 0
theme.slider_handle_border_color = "#f0f0f0"
theme.slider_handle_border_width = 2
theme.slider_handle_width = 12
theme.slider_bar_height = 5
theme.slider_bar_color = "#008cff"

return theme

