--- @class care.anim.Animation
--- @summary Summary.
--- @description Description.
---
--- Not to be confused with its parent, [care.anim].
local Animation = {}
Animation.__index = Animation

--- @function care.anim.Animation.new
--- @summary Summary.
--- @param atlas number param number 1.
--- @param quads number param number 2.
--- @param w number param number 3.
--- @param h number param number 4.
--- @param frame_count number param number 5.
--- @param speed number param number 6.
--- @param on_complete number param number 7.
--- @return animation care.anim.Animation description here.
--- @example
--- TODO
function Animation.new(atlas,quads,w,h,frame_count,speed,on_complete)
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

--- @method care.anim.Animation:setSpeed
--- @summary Summary.
--- @param speed number The animation speed.
--- @return nil Nothing.
--- @example
--- TODO
function Animation:setSpeed(speed)
    self.speed = speed
end

return Animation