local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local mail = {
    accounts = {},
    total_unread = 0
}
local data = {}

function mail.update(account, open, count)
    mail.accounts[account] = mail.accounts[account] or {
        count = 0
    }
    local delta = count - mail.accounts[account].count
    mail.accounts[account].count = count
    mail.accounts[account].open = open or mail.accounts[account].open
    mail.total_unread = mail.total_unread + delta
    local text = ""
    if mail.total_unread > 1 then
        text = string.format(" [%d] ", mail.total_unread)
    end
    for self, data in pairs(data) do
        if mail.total_unread == 0 then
            data.imagebox:set_image(data.mail_icon)
        else
            data.imagebox:set_image(data.mail_new_icon)
        end
        data.textbox:set_text(text)
    end
end

function mail.notify(account, open, count)
    naughty.notify({ timeout = 0,
                     icon = mail.icon_new or beautiful.mail_new,
                     icon_size = 48,
                     title = "New mail (" .. count  .. ")",
                     text = account })
end 

function mail.notify_one(account, open, subject, from, to, text)
    naughty.notify({ timeout = 0,
                     icon = mail.icon_new or beautiful.mail_new,
                     icon_size = 48,
                     title = subject or "(no subject)",
                     text = (from and from .. "\n" or "") .. (text or "") })
end


function mail.widget(args)
    local self = wibox.layout.fixed.horizontal()

    data[self] = {
        imagebox = wibox.widget.imagebox(),
        textbox = wibox.widget.textbox(),
        mail_icon = args.mail_icon or beautiful.mail,
        mail_new_icon = args.mail_new_icon or beautiful.mail_new,
    }

    self:add(data[self].imagebox)
    self:add(data[self].textbox)

    self:buttons(awful.util.table.join(
        awful.button({ }, 1, function()
            for acc, data in pairs(mail.accounts) do
                if data.count >= 1 then
                    awful.util.spawn_with_shell(data.open)
                end
            end
         end),
        awful.button({ }, 2, function() end)
    ))

    data[self].imagebox:set_image(data[self].mail_icon)

    return self
end

return mail
