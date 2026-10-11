--- @class care.anim.Instance
--- @summary An independent instance of an animation defined by [care.anim.Animation].
--- @description
--- Represents an individual instance of an animation defined by [care.anim.Animation],
--- with its own independent playback state, position, and other settings.
local Instance = {}
Instance.__index = Instance

--- @function care.anim.Instance.new
--- @summary Creates a new instance of an animation.
--- @description
--- Creates a new instance of the animation provided by a care.anim.Animation object.
--- @param anim care.anim.Animation Reference animation that this instance plays.
--- @param repeats boolean (Optional) Whether the animation repeats after completion (or otherwise is deleted). Defaults to false if not specified.
--- @param speed number (Optional) Playback speed of the animation, measured in seconds per frame. If not specified, the default speed specified in the care.anim.Animation object will be used.
--- @param on_complete function (Optional) Function called upon completion of this instance of the animation (after the on_complete callback of its associated care.anim.Animation).
--- @return animation care.anim.Animation The newly created animation object.
--- @example
--- TODO
function Instance.new(anim,repeats,speed,on_complete)
    local self = setmetatable({
        anim         = anim,
        repeats      = repeats~=nil and repeats or false,
        speed        = speed or anim.speed,
        frame        = 1,                                 -- current frame number (1-indexed)
        t            = 0,                                 -- frame timer
        x            = 0,                                 -- centred x-position
        y            = 0,                                 -- centred y-position
        on_complete  = on_complete,                       -- function called upon completion of animation (after animation:on_complete)
        on_keyframes = {},                                -- For each frame i, on_keyframe[i] is either nil or a function that triggers on that frame
        dead         = false                              -- animation instance marked for deletion?
    }, Instance)
    return self
end

function Instance:play(x,y)
    self.x,self.y = x,y
    self.dead = false
    self.frame = 1
end

function Instance:set_position(x,y)
    self.x,self.y = x,y
end

function Instance:set_speed(speed)
    self.speed = speed or anim.speed
end

function Instance:finish()
    if (self.anim.on_complete) then self.anim.on_complete() end
    if (self.on_complete) then self.on_complete() end
    if (not self.repeats) then self.dead = true end
    -- TODO: log anim finish here (in verbose debug mode)
end

function Instance:delete()
    self.dead = true
end

function Instance:reset()
    self.dead  = false
    self.frame = 1
    --self.t     = 0
end

function Instance:set_on_keyframe(frame_num,func)
    self.on_keyframes[frame_num] = func
end

-- returns true if proceeding as normal, returns false if animation has ended
function Instance:update(dt)
    if (self.dead or self.frame<1) then return false end

    self.t = self.t + dt
    --self.frame = math.floor((self.t/self.speed))+1
    if (self.t > self.speed) then
        self.frame = self.frame+1
        self.t = self.t - self.speed
        -- keyframe animation:
        if (self.on_keyframes[self.frame]) then self.on_keyframes[self.frame]() end
    end

    -- end of animation cycle:
    if (self.frame>#self.anim.quads) then
        self:finish()
        if (self.repeats) then self.frame = 1 else self.frame = #self.anim.quads; return false end
    end
    return true
end

function Instance:draw()
    if (self.dead or self.frame<1 or self.frame>#self.anim.quads) then return end
    local quad = self.anim.quads[self.frame]
    local _, _, w, h = quad:getViewport()
    love.graphics.draw(self.anim.atlas.image,quad,self.x,self.y,0,self.anim.atlas.scale,self.anim.atlas.scale,math.floor(w/2),math.floor(h/2))
end

return Instance