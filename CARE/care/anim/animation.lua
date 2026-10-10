--- @class care.anim.Animation
--- @summary A frame-based sprite animation.
--- @description
--- Represents an animation defined as a sequence of frames drawn from a texture atlas.
--- The animation may then be drawn in individual instances, with their own independently
--- controlled playback states and settings, via [care.anim.Instance].
---
--- Animation objects are created using [care.anim.Animation.new].
---
--- Not to be confused with its parent module, [care.anim].
local Animation = {}
Animation.__index = Animation

--- @function care.anim.Animation.new
--- @summary Creates a new animation object.
--- @description
--- Creates an animation object from a sequence of quads referencing regions of a texture atlas.
--- @param atlas love.Drawable Texture atlas containing the animation frames.
--- @param quads love.Quad[] Sequence of quads defining the animation frames.
--- @param w number Width of each animation frame, in pixels.
--- @param h number Height of each animation frame, in pixels.
--- @param frame_count number Number of frames in the animation.
--- @param speed number Duration of each frame, in seconds.
--- @param on_complete function (Optional) Function called upon completion of the animation (before the on_complete callbacks of its instances - see care.anim.Instance).
--- @return animation care.anim.Animation The newly created animation object.
--- @example
--- local animation = care.anim.Animation.new(atlas, quads, 64, 64, 8, 0.1, function()
---     score = score + 1
--- end)
function Animation.new(atlas,quads,w,h,frame_count,speed,on_complete)
    local self = setmetatable({
        atlas       = atlas,
        quads       = quads,
        width       = w,
        height      = h,
        frame_count = frame_count,
        speed       = speed,
        on_complete = on_complete
    }, Animation)
    return self
end

--- @method care.anim.Animation:setSpeed
--- @summary Sets the default playback speed of the animation.
--- @description
--- Individual instances (see [care.anim.Instance]) of the animation may optionally ignore this and set its own playback speed.
--- @param speed number Duration of each frame, in seconds.
--- @return nil Nothing.
--- @example
--- animation:setSpeed(0.05)
function Animation:setSpeed(speed)
    self.speed = speed
end

return Animation