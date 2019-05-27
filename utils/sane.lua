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


function sane.rgba2hex(rgb)
    return string.format("#%02x%02x%02x%02x", rgb.x*255, rgb.y*255, rgb.z*255, rgb.w*255)
end

function sane.rgb2hex(rgb)
    return string.format("#%02x%02x%02x", rgb.x*255, rgb.y*255, rgb.z*255)
end

function sane.button(node_name, action_id, action, click_func)
    local node = gui.get_node(node_name)
    local hit = gui.pick_node(node, action.x, action.y)
    if hit and action_id == hash("mouse-button-1") then
        if action.released then
            click_func()
        end
    end
    
end

local default_button_states = {}
local default_theme_funcs = {
    on_init = function(node_name, key)
        if not default_button_states[key] then
            local node_base = gui.get_node(node_name .. "_base")
            local node_inner = gui.get_node(node_name .. "_inner")
            default_button_states[key] = {
                node_base = node_base,
                node_inner = node_inner,
                size = gui.get_size(node_base),
                pos = gui.get_position(node_base),
                size_inner = gui.get_size(node_inner),
                pos_inner = gui.get_position(node_inner)
            }
        end
    end,
    on_hover = function(node_name, key)
        ---print("hover", node_name)
    end,
    on_down = function(node_name, key)
        local default_state = default_button_states[key]
        
        local new_pos = vmath.vector3(default_state.pos)
        local new_size = vmath.vector3(default_state.size)
        new_pos.y = new_pos.y - 2
        new_size.y = new_size.y - 2
        
        local new_inner_pos = vmath.vector3(default_state.pos_inner)
        local new_inner_size = vmath.vector3(default_state.size_inner)
        new_inner_pos.y = new_inner_pos.y - 1
        --new_inner_size.y = new_inner_size.y - 1

        gui.set_size(default_state.node_base, new_size)
        gui.set_position(default_state.node_base, new_pos)
        gui.set_size(default_state.node_inner, new_inner_size)
        gui.set_position(default_state.node_inner, new_inner_pos)
    end,
    on_up = function(node_name, key)
        local default_state = default_button_states[key]
        gui.set_size(default_state.node_base, default_state.size)
        gui.set_position(default_state.node_base, default_state.pos)
        gui.set_size(default_state.node_inner, default_state.size_inner)
        gui.set_position(default_state.node_inner, default_state.pos_inner)
    end
}
default_theme_funcs.on_leave = default_theme_funcs.on_up

function sane.set_default_gui_theme(theme_funcs)
    default_theme_funcs = theme_funcs
end

local current_node = nil
function sane.themed_button(self, node_name, action_id, action, click_func, theme_funcs)
    local theme_funcs = theme_funcs or default_theme_funcs

    local key = tostring(self) .. node_name
    theme_funcs.on_init(node_name, key)
    
    local node_base = gui.get_node(node_name .. "_base")
    local hit = gui.pick_node(node_base, action.x, action.y)
    if hit then
        theme_funcs.on_hover(node_name, key)
        current_node = key
        
        if action_id == hash("mouse-button-1") then
            if action.pressed then
                theme_funcs.on_down(node_name, key)
            end
            
            if action.released then
                theme_funcs.on_up(node_name, key)
                click_func()
            end
        end
    end

    if current_node == key and not hit then
        current_node = nil
        theme_funcs.on_leave(node_name, key)
    end

end

return sane