local animation = require "care.anim.animation"
local instance  = require "care.anim.instance"

local system = {}

system.animations = {}
system.instances  = {}

-- import an animation
function system.import(anim_name,atlas,quad_names,speed,on_complete)
    local new_anim = animation:new(atlas,quad_names,speed,on_complete)
    system.animations[anim_name] = new_anim
    return new_anim
end

-- spawn an instance
function system.spawn(anim_name,speed,on_complete)
    local anim = system.animations[anim_name]
    local new_inst = instance:new(anim,speed,on_complete)
    system.instances[#system.instances+1] = new_inst
    local x,y = love.math.random(1,1280),love.math.random(1,720) --TEMP
    new_inst:play(x,y) --TEMP (x,y bit)
    return new_inst
end

function system.get_anim(anim_name)
    return system.animations[anim_name]
end

function system.update(dt)
    local list = system.instances
    local n = #list
    local write = 1
    for read = 1,n do
        local inst = list[read]
        inst:update(dt)
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