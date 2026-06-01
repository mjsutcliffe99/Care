local viewport = require "care.gfx.viewport"

local mouse = {}

mouse.x = 0
mouse.y = 0
mouse.atlas = nil
mouse.cursor = nil
mouse.hotspot = {x=0,y=0}
mouse.visible = true -- Virtual mouse visibility (use love.mouse.setVisible to set the "real" mouse visibility)

function mouse.moved(x,y,dx,dy) -- update cached mouse position
    mouse.x = math.floor((x - viewport.offset_x) / viewport.scale)
    mouse.y = math.floor((y - viewport.offset_y) / viewport.scale)
end

function mouse.get_position()
    return mouse.x,mouse.y
end

function mouse.set_cursor(atlas,quad_name,hotx,hoty)
    mouse.atlas  = atlas
    mouse.cursor = atlas:get_quad(quad_name)
    if (hotx and hoty) then mouse.hotspot = {x=hotx,y=hoty} end
end

function mouse.draw()
    if (mouse.atlas and mouse.cursor and mouse.visible) then love.graphics.draw(mouse.atlas.image,mouse.cursor,mouse.x-mouse.hotspot.x,mouse.y-mouse.hotspot.y) end
end

return mouse