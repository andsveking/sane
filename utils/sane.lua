local sane = {}

function sane.hex2rgba(hex)
    hex = hex:gsub("#","")
    local r = tonumber("0x"..hex:sub(1,2)) / 255
    local g = tonumber("0x"..hex:sub(3,4)) / 255
    local b = tonumber("0x"..hex:sub(5,6)) / 255
    local a = tonumber("0x"..hex:sub(7,8)) / 255
    return vmath.vector4(r, g, b, a)
end

function sane.hex2rgb(hex)
    hex = hex:gsub("#","")
    local r = tonumber("0x"..hex:sub(1,2)) / 255
    local g = tonumber("0x"..hex:sub(3,4)) / 255
    local b = tonumber("0x"..hex:sub(5,6)) / 255
    return vmath.vector4(r, g, b, 1.0)
end

function sane.button(node_name, action_id, action, click_func)
    local node_base = gui.get_node(node_name .. "_base")

    local hit = gui.pick_node(node_base, action.x, action.y)

    if hit and action_id == hash("mouse-button-1") then
        local node_inner = gui.get_node(node_name .. "_inner")
        local node_label = gui.get_node(node_name .. "_label")

        if action.released then
            click_func()
        end
    end
    
end

return sane