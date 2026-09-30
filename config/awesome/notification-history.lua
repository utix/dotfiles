local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")

local notification_history = {}
local max_notifications = 50 -- Maximum number of notifications to keep

-- Popup widget
local popup = nil
local popup_visible = false

-- Store notification in history
local function store_notification(n)
    -- Create a copy of the notification data
    local notification_data = {
        title = n.title or "Notification",
        text = n.text or n.message or "",
        icon = n.icon,
        timestamp = os.time(),
        app_name = n.app_name or "System",
        urgency = n.urgency or "missing"  -- Store notification level
    }

    -- Insert at the beginning (most recent first)
    table.insert(notification_history, 1, notification_data)

    -- Limit the history size
    if #notification_history > max_notifications then
        table.remove(notification_history, #notification_history)
    end
end

-- Hook into naughty.notify to capture notifications
-- This works across different AwesomeWM versions
local original_notify = naughty.notify
naughty.notify = function(args)
    local notification = original_notify(args)
    if args then
        store_notification(args)
    end
    return notification
end

-- Create the popup widget
local function create_popup()
    local screen_geometry = awful.screen.focused().geometry
    local popup_width = math.min(600, screen_geometry.width * 0.8)
    local popup_height = math.min(800, screen_geometry.height * 0.8)

    -- Create scrollable notification list
    local notification_list = wibox.widget {
        layout = wibox.layout.fixed.vertical,
        spacing = 10,
    }

    -- Populate the list
    if #notification_history == 0 then
        notification_list:add(wibox.widget {
            markup = "<span foreground='#888888'>No notifications yet</span>",
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox,
        })
    else
        for i, notif in ipairs(notification_history) do
            local time_str = os.date("%H:%M:%S", notif.timestamp)
            local date_str = os.date("%Y-%m-%d", notif.timestamp)

            -- Determine background color based on urgency level
            local bg_color = beautiful.bg_normal or "#222222"
            if notif.urgency == "critical" then
                bg_color = "#8B2252"  -- Dark pink for critical notifications
            end

            -- Create notification entry
            local notif_widget = wibox.widget {
                {
                    {
                        {
                            markup = string.format("<b>%s</b> <span size='small' foreground='#888888'>%s - %s</span>",
                            gears.string.xml_escape(notif.title),
                                time_str, gears.string.xml_escape(notif.app_name)),
                            widget = wibox.widget.textbox,
                        },
                        {
                            text = notif.text,
                            widget = wibox.widget.textbox,
                        },
                        layout = wibox.layout.fixed.vertical,
                        spacing = 5,
                    },
                    margins = 10,
                    widget = wibox.container.margin,
                },
                bg = bg_color,
                fg = beautiful.fg_normal or "#ffffff",
                shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, 5)
                end,
                widget = wibox.container.background,
            }

            notification_list:add(notif_widget)
        end
    end

    -- Create a scrollable container
    local scrollable = wibox.widget {
        notification_list,
        layout = wibox.layout.fixed.vertical,
    }

    -- Create the popup
    popup = awful.popup {
        widget = {
            {
                {
                    markup = "<b>Notification History</b>",
                    align = "center",
                    widget = wibox.widget.textbox,
                },
                {
                    markup = string.format("<span size='small'>%d notifications</span>", #notification_history),
                    align = "center",
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.vertical,
                spacing = 5,
            },
            {
                {
                    scrollable,
                    layout = wibox.layout.fixed.vertical,
                },
                forced_height = popup_height - 100,
                widget = wibox.container.constraint,
            },
            layout = wibox.layout.fixed.vertical,
            spacing = 15,
        },
        border_color = beautiful.border_focus or "#535d6c",
        border_width = 2,
        ontop = true,
        placement = awful.placement.centered,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        visible = false,
        preferred_positions = "top",
        preferred_anchors = "middle",
        offset = { y = 10 },
        minimum_width = popup_width,
        maximum_width = popup_width,
        minimum_height = popup_height,
        maximum_height = popup_height,
    }

    -- Add mouse bindings to close on click outside
    popup:buttons(gears.table.join(
        awful.button({}, 1, function()
            popup.visible = false
            popup_visible = false
        end)
    ))
end

-- Toggle notification history popup
local function toggle_history()
    if popup_visible then
        if popup then
            popup.visible = false
        end
        popup_visible = false
    else
        -- Recreate popup with current notifications
        create_popup()
        popup.visible = true
        popup_visible = true
    end
end

-- Clear notification history
local function clear_history()
    notification_history = {}
    if popup_visible then
        toggle_history()
        toggle_history()
    end
end

return {
    toggle = toggle_history,
    clear = clear_history,
    get_count = function() return #notification_history end,
}
