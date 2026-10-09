--- @module care.anim.animation
--- @summary TODO.
--- @description
--- TODO.
---
--- Not to be confused with its parent, [care.anim].

local Animation = {}
Animation.__index = Animation

function Animation:new(atlas,quads,w,h,frame_count,speed,on_complete)
    local self = setmetatable({
        atlas       = atlas,                       -- atlas from which the quads read
        quads       = quads,                       -- sequence of frames
        width       = w,                           -- width of an animation frame
        height      = h,                           -- height of an animation frame
        frame_count = frame_count,                 -- number of frames in the animation
        speed       = speed,                       -- seconds per frame
        on_complete = on_complete                  -- function called upon completion of animation (before instance's on_complete)
    }, Animation)
    return self
end

return Animation