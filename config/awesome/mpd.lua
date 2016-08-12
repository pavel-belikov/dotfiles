-- TODO: extract images from tags

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local mpd = {}
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

function split(str, pat)
   local t = {} 
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
          table.insert(t, cap)
      end
      last_end = e + 1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

local function mpd_status(format)
    local cmd = string.format("mpc -f '%s'", format)
    local fd = io.popen(cmd)
    local status = fd:read("*all")
    fd:close()
    if not status then
        return nil
    end
    local out = split(status, "\n")
    local play = out[#out - 1]
    return table.concat(out, "\n", 1, #out - 2), play and string.find(play, "[playing]", 1, true), string.match(play or "0:00/0:00", "%d+:%d+/%d+:%d+")
end

local function update_music_widget(self)
    local format, playing, pos = mpd_status(data[self].format)
    if format and pos then
        self:set_text(string.format(' %s %s (%s) ', playing and '▶' or '▮▮', format, pos))
    else
        self:set_text(' ')
    end
end

function mpd.toggle_play_pause()
    awful.util.spawn_with_shell("mpc toggle")
    mpd.update()
end

function mpd.next()
    awful.util.spawn_with_shell("mpc next")
    mpd.update()
end

function mpd.prev()
    awful.util.spawn_with_shell("mpc prev")
    mpd.update()
end

local function focus(self)
    local clients = client.get()
    for i, c in pairs(clients) do
        if c.class == data[self].client_wmclass then
            client.focus = c
            c:raise()
            awful.tag.viewonly(c:tags()[1])
            break
        end
    end
end

function mpd.update()
    for self, data in pairs(data) do
        self.update()
    end
end

function mpd.widget(args)
    local self = wibox.widget.textbox()
    data[self] = {
        client_wmclass = args.client_wmclass,
        format = args.format or "%artist% - %track%. %title%",
        update = function() update_music_widget(self) end
    }
    self:buttons(awful.util.table.join(
        awful.button({ }, 1, mpd.toggle_play_pause),
        awful.button({ }, 3, function() focus(self) end),
        awful.button({ }, 4, mpd.prev),
        awful.button({ }, 5, mpd.next)
    ))

    if args.timeout and args.timeout == 0 then

    else
        local timer = timer({ timeout = args.timeout or 1 })
        timer:connect_signal("timeout", data[self].update)
        timer:start()
    end
    
    self.update = data[self].update
    data[self].update()

    return self
end

return mpd
