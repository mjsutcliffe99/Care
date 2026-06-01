local json = require "care.third_party.json"
local viewport = require "care.gfx.viewport"

local Atlas = {}
Atlas.__index = Atlas

function Atlas:new(image_path,reg_path,scale)
    local self = setmetatable({
        image = love.graphics.newImage(image_path),
        register = reg_path and json.decode(love.filesystem.read(reg_path)) or {},
        quads = {},
        scale = scale or 1
    }, Atlas)
    self:gen_quads()
    self.image:setFilter(viewport.opts.scale_filter)
    return self
end

function Atlas:set_image(image_path)
    self.image = love.graphics.newImage(image_path)
end

function Atlas:set_register(reg_path)
    self.register = json.decode(love.filesystem.read(reg_path))
end

function Atlas:gen_quads()
    for name,coords in pairs(self.register) do
        self.quads[name] = love.graphics.newQuad(coords.x,coords.y,coords.w,coords.h,self.image:getDimensions())
    end
end

function Atlas:get_quad(name)
    return self.quads[name]
end

function Atlas:get_quads(names)
    local quads = {}
    for _,q in ipairs(names) do
        quads[#quads+1] = self:get_quad(q)
    end
    return quads
end

return Atlas