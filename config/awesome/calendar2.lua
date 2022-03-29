-- original code made by Bzed and published on http://awesome.naquadah.org/wiki/Calendar_widget
-- modified by Marc Dequènes (Duck) <Duck@DuckCorp.org> (2009-12-29), under the same licence,
-- and with the following changes:
--   + transformed to module
--   + the current day formating is customizable

local string = string
--local print = print
local tostring = tostring
local os = os
local io_m
local capi = {
    mouse = mouse,
    screen = screen,
    image = image
}
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
--module("calendar2")
local M = {
  calendar = {1, 2, 3}
}
local current_day_format = "<u>%s</u>"
local locales = {'America/Los_Angeles', 'Europe/Paris', 'Australia/Melbourne', 'Asia/Shanghai'}
local locale_pos = 4 -- Set China as current default
local locale = locales[locale_pos]
function displayMonth(month,year,weekStart)
        local t,wkSt=os.time{year=year, month=month+1, day=0},weekStart or 1
        local d=os.date("*t",t)
        local mthDays,stDay=d.day,(d.wday-d.day-wkSt+1)%7

        --print(mthDays .."\n" .. stDay)
        local lines = "    "

        for x=0,6 do
                lines = lines .. os.date("%a ",os.time{year=2006,month=1,day=x+wkSt})
        end

        lines = lines .. "\n" .. os.date(" %V",os.time{year=year,month=month,day=1})

        local writeLine = 1
        while writeLine < (stDay + 1) do
                lines = lines .. "    "
                writeLine = writeLine + 1
        end
        local f = io_m.popen("TZ='"..locale.."' date +%Y-%m-%d")
        local s = f:read('*line')
        for d=1,mthDays do
                local x = d
                local t = os.time{year=year,month=month,day=d}
                if writeLine == 8 then
                        writeLine = 1
                        lines = lines .. "\n" .. os.date(" %V",t)
                end
                if s == os.date("%Y-%m-%d", t) then
                        x = string.format(current_day_format, d)
                end
                if (#(tostring(d)) == 1) then
                        x = " " .. x
                end
                lines = lines .. "  " .. x
                writeLine = writeLine + 1
        end
        local f = io_m.popen("TZ='"..locale.."' date +%H:%M")
        local s = f:read('*a')
        local header = os.date("%B %Y  ",os.time{year=year,month=month,day=1})..s

        return header .. "\n\n" .. lines
end

function M.switchNaughtyMonth(self, switchMonths)
        naughty.notify({
                text = "coucou feature"
              })
       if (#self.calendar < 3) then return end
       local swMonths = switchMonths or 1
       self.calendar[1] = self.calendar[1] + swMonths
       self.calendar[3].box.widgets[2].text = string.format('<span font_desc="%s">%s</span>', "monospace", displayMonth(M.calendar[1], M.calendar[2], 2))
       self.calendar[3].box.widgets[1].image = capi.image("/home/aurel/.config/awesome/themes/"..locale..".png")
end

function M.addCalendarToWidget(self, mywidget, io_master, custom_current_day_format)
  io_m = io_master
  if custom_current_day_format then current_day_format = custom_current_day_format end
  mywidget.calendar = M.calendar
  mywidget:connect_signal('mouse::enter', function (s)
        local month, year = os.date('%m'), os.date('%Y')
        s.calendar = { month, year,
        naughty.notify({
                text = string.format('<span font_desc="%s">%s</span>', "monospace", displayMonth(month, year, 2, locale)),
                icon="/home/aurel/.config/awesome/themes/"..locale..".png",
                timeout = 0,
                hover_timeout = 0.5,
                position="top_right",
                screen = capi.mouse.screen
        })
  }
  end)
  mywidget:connect_signal('mouse::leave', function () naughty.destroy(self.calendar[3]) end)
  mywidget:connect_signal("button::press", function(s, lx, ly, button, mods, metadata)
    naughty.notify({
      text = "press cal".. s.calendar[1]
    })
  end)
  mywidget:connect_signal("button::press",
    function(_, _, _, button, mods)
      naughty.notify({
        text = "press" .. button
      })
        if button == 1 then
        self:switchNaughtyMonth(-1)
        end
        if button == 3 then
       --   switchNaughtyMonth(1)
        naughty.notify({
                text = "coucou"
              })
        end
      naughty.notify({
        text = "press2"
      })
        naughty.notify({
                text = "coucou"
              })
    end)

  mywidget:buttons(gears.table.join(
    awful.button({ }, 1, function()
        naughty.notify({
                text = "foufou"
              })
        --switchNaughtyMonth(-1)
    end),
    awful.button({'Control' }, 1, function()
        if locale_pos < #locales then
            locale_pos = locale_pos + 1
        else
            locale_pos = 1
        end
        locale = locales[locale_pos]
        switchNaughtyMonth(0)
    end),
    awful.button({'Control' }, 2, function()
        if locale_pos <= 1  then
            locale_pos = #locales
        else
            locale_pos = locale_pos - 1
        end
        locale = locales[locale_pos]
        switchNaughtyMonth(0)
    end),
    awful.button({ }, 3, function()
        switchNaughtyMonth(1)
    end),
    awful.button({ }, 4, function()
        switchNaughtyMonth(-1)
    end),
    awful.button({ }, 5, function()
        switchNaughtyMonth(1)
    end),
    awful.button({ 'Shift' }, 1, function()
        switchNaughtyMonth(-12)
    end),
    awful.button({ 'Shift' }, 3, function()
        switchNaughtyMonth(12)
    end),
    awful.button({ 'Shift' }, 4, function()
        switchNaughtyMonth(-12)
    end),
    awful.button({ 'Shift' }, 5, function()
        switchNaughtyMonth(12)
    end)
  ))
end

return M
