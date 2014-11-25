local awful = require("awful")
local awful = require("awful")
local naughty = require("naughty")
module("sshagent")
local popup
local alert = true
local io
local image
local key_check


function get_k()
    local f = io.popen('ssh-add -l')
    local l = f:read()

    return l
end
function addAgentToWidget(mywidget, io_master, image_master)
    image = image_master
    io = io_master
    mywidget:add_signal('mouse::enter', function ()
        key_check()
        popup = naughty.notify({
            text = get_k(),
            timeout = 0,
            hover_timeout = 0.5
        })

    end)
    mywidget:add_signal('mouse::leave', function ()
        naughty.destroy(popup)
    end)
  mywidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function()
        awful.util.spawn("ssh-add")
    end)
  ))
  key_check =  function ()
        if get_k() == "The agent has no identities." then
            if alert then
                mywidget.image = image("/home/aurel/.config/awesome/themes/key-add.png")
                alert = false
                popup = naughty.notify({ preset = naughty.config.presets.critical,
                text = get_k(),
                title = "SSH Agent" })
            end
        else
            mywidget.image = image("/home/aurel/.config/awesome/themes/lock-icon.png")
            alert = true
        end
    end
    awful.hooks.timer.register(30, key_check)
    key_check()
end

