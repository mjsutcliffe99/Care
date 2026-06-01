local Animation = {}
Animation.__index = Animation

function Animation:new(atlas,quad_names,speed,on_complete)
    local self = setmetatable({
        atlas       = atlas,                       -- atlas from which the quads read
        quads       = atlas:get_quads(quad_names), -- sequence of frames
        speed       = speed,                       -- seconds per frame
        on_complete = on_complete                  -- function called upon completion of animation (before instance's on_complete)
    }, Animation)
    return self
end

return Animation