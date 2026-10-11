--- @module care.anim.system
--- @summary TODO.
--- @description
--- Blah blah blah.

local animation = require "care.anim.animation"
local instance  = require "care.anim.instance"
local atlas     = require "care.gfx.atlas"
local json      = require "care.third_party.json"

local system = {}

system.animations = {}
system.instances  = {}

-- import an animation
function system.import_single(anim_name,anim_atlas,x,y,w,h,frame_count,speed,on_complete)
    local quads = {}
    for i=1,frame_count do
        quads[i] = love.graphics.newQuad(x+w*(i-1), y, w, h, anim_atlas.image:getDimensions())
    end
    local new_anim = animation:new(anim_atlas,quads,w,h,frame_count,speed,on_complete)
    system.animations[anim_name] = new_anim
    return new_anim
end

--- @function care.anim.system.import
--- @summary Imports all animations from a json/png file pair
--- @description TODO: Explain the json format!
--- @param image_path string Path to the image file that contains the frames of one or more animations.
--- @param reg_path string Path to the json file that describes the animations.
--- @param speed number Playback speed of the animations, measured in seconds per frame.
--- @param scale number (Optional) Scaling factor applied the imported animation frames. (Useful for upscaling pixel art.) Defaults to 1 (i.e. real-size).
--- @return nil Nothing.
--- @example
--- TODO
function system.import(image_path,reg_path,speed,scale)
    scale = scale or 1
    local anim_atlas = atlas:new(image_path,nil,scale)
    local register = json.decode(love.filesystem.read(reg_path))
    for name,coords in pairs(register) do -- for each animation
        system.import_single(name,anim_atlas,coords.x,coords.y,coords.w,coords.h,coords.n,speed,nil)
    end
end

-- spawn an instance
function system.spawn(anim_name,x,y,repeats,speed,on_complete)
    local anim = system.get_anim(anim_name)
    local new_inst = instance:new(anim,repeats,speed,on_complete)
    system.instances[#system.instances+1] = new_inst
    new_inst:play(x,y)
    return new_inst
end

function system.get_anim(anim_name)
    return system.animations[anim_name]
end

function system.update(dt)
    local list = system.instances
    local n = #list
    -- update each anim instance:
    for read = 1,#list do
        local inst = list[read]
        inst:update(dt)
    end
    -- cull any now dead instances:
    n = #list
    local write = 1
    for read = 1,n do
        local inst = list[read]
        if (not inst.dead) then
            list[write] = inst
            write = write + 1
        end
    end
    for i = write,n do list[i] = nil end
end

function system.draw()
    for _,inst in ipairs(system.instances) do
        inst:draw()
    end
end

return system