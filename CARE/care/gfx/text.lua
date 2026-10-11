local text = {}

text.fonts  = {} -- loaded fonts
text.colors = {  -- defined colours --TEMP: should probably move this somewhere more general than text.lua as it can also be used for colouring things beyond text
    white = {1,1,1,1},
    black = {0,0,0,1},
    red   = {1,0,0,1},
    green = {0,1,0,1},
    blue  = {0,0,1,1}
}

function text.load_font(name,path,size)
    text.fonts[name] = love.graphics.newFont(path,size)
end

function text.set_font(name)
    love.graphics.setFont(text.fonts[name])
end

local function parse_color(value)
    if (text.colors[value]) then return text.colors[value] end

    local hex = value:match("^#(%x+)$")
    
    if (hex and (#hex == 6 or #hex == 8)) then
        return {
            tonumber(hex:sub(1, 2), 16) / 255,
            tonumber(hex:sub(3, 4), 16) / 255,
            tonumber(hex:sub(5, 6), 16) / 255,
            #hex == 8 and tonumber(hex:sub(7, 8), 16) / 255 or 1
        }
    end

    return nil
end

function text.regiser_color(name,col)
    text.colors[name] = parse_color(col)
end

function text.get_color(name)
    return text.colors[name]
end

function text.print(str,x,y,limit,align,color)
    local def_col = color or {love.graphics.getColor()}
    local cur_col = def_col

    local segments = {}
    local pos = 1

    while (true) do
        local a, b, value = str:find("%[color=([^%]]+)%]", pos)
        local ra, rb = str:find("%[reset%]", pos)

        -- Find the next recognised tag
        if (ra and (not a or ra<a)) then
            a, b = ra, rb
            value = "default"
        end

        if (not a) then
            table.insert(segments, cur_col)
            table.insert(segments, str:sub(pos))
            break
        end

        -- Add text before the tag
        if (a > pos) then
            table.insert(segments, cur_col)
            table.insert(segments, str:sub(pos, a - 1))
        end

        -- Change colour
        if (value == "default") then cur_col = def_col
        else cur_col = parse_color(value) or cur_col
        end

        pos = b + 1
    end

    love.graphics.printf(segments,x,y,limit,align)
end

return text