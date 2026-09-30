---------------------------------------------------------------------------
-- Three Column Layout
-- Master window in center (50%), slaves alternate between left and right (25% each)
---------------------------------------------------------------------------

local awful = require("awful")

local three_column = {}
three_column.name = "threecolumn"
three_column.icon = "/home/aurel/.config/awesome/themes/tile3.png"

function three_column.arrange(p)
    local area = p.workarea
    local t = p.tag or screen[p.screen].selected_tag
    local clients = p.clients

    if #clients == 0 then return end

    -- Get usable area dimensions
    local wa = area

    if #clients == 1 then
        -- Single client takes full width (100%)
        local g = {
            x = wa.x,
            y = wa.y,
            width = wa.width,
            height = wa.height
        }
        p.geometries[clients[1]] = g
    elseif #clients == 2 then
        -- Two clients: 25% and 75%
        local left_width = math.floor(wa.width * 0.25)
        local right_width = wa.width - left_width

        -- First client on the left (25%)
        local g1 = {
            x = wa.x,
            y = wa.y,
            width = left_width,
            height = wa.height
        }
        p.geometries[clients[1]] = g1

        -- Second client on the right (75%)
        local g2 = {
            x = wa.x + left_width,
            y = wa.y,
            width = right_width,
            height = wa.height
        }
        p.geometries[clients[2]] = g2
    else
        -- Three or more clients: 25% - 50% - 25% layout
        local left_width = math.floor(wa.width * 0.25)
        local center_width = math.floor(wa.width * 0.50)
        local right_width = wa.width - left_width - center_width  -- Remaining space

        -- First client in center
        local center_height = wa.height
        local g = {
            x = wa.x + left_width,
            y = wa.y,
            width = center_width,
            height = center_height
        }
        p.geometries[clients[1]] = g

        -- Count remaining clients for left and right
        local remaining = #clients - 1
        local left_count = math.ceil(remaining / 2)
        local right_count = remaining - left_count

        -- Calculate heights for left and right columns
        local left_height = left_count > 0 and math.floor(wa.height / left_count) or 0
        local right_height = right_count > 0 and math.floor(wa.height / right_count) or 0

        -- Place clients alternating between left and right
        local left_idx = 0
        local right_idx = 0

        for i = 2, #clients do
            local client_idx = i - 2  -- 0-indexed for alternating

            if client_idx % 2 == 0 then
                -- Place in left column
                local g = {
                    x = wa.x,
                    y = wa.y + (left_idx * left_height),
                    width = left_width,
                    height = left_height
                }
                p.geometries[clients[i]] = g
                left_idx = left_idx + 1
            else
                -- Place in right column
                local g = {
                    x = wa.x + left_width + center_width,
                    y = wa.y + (right_idx * right_height),
                    width = right_width,
                    height = right_height
                }
                p.geometries[clients[i]] = g
                right_idx = right_idx + 1
            end
        end
    end
end

return three_column
