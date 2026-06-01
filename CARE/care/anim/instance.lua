-- Instance of an animation
local Instance = {}
Instance.__index = Instance

function Instance:new(anim,speed,on_complete)
    local self = setmetatable({
        anim        = anim,                        -- animation reference (of type Anim)
        speed       = speed or anim.speed,         -- seconds per frame (overrides anim speed if non-nil)
        frame       = 0,                           -- current frame number (1-indexed)
        t           = 0,                           -- frame timer
        x           = 0,                           -- centred x-position
        y           = 0,                           -- centred y-position
        on_complete = on_complete,                 -- function called upon completion of animation (after animation:on_complete)
        dead        = false                        -- animation instance marked for deletion?
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
    self.dead = true
end

function Instance:update(dt)
    if (self.dead or self.frame<1) then return
    elseif (self.frame>#self.anim.quads) then
        self:finish()
        return
    end
    self.t = self.t + dt
    --self.frame = math.floor((self.t/self.speed))+1
    if (self.t > self.speed) then
        self.frame = self.frame+1
        self.t = self.t - self.speed
    end
end

function Instance:draw()
    if (self.dead or self.frame<1 or self.frame>#self.anim.quads) then return end
    local quad = self.anim.quads[self.frame]
    local _, _, w, h = quad:getViewport()
    local x, y = self.x-math.floor(w/2)*self.anim.atlas.scale, self.y-math.floor(h/2)*self.anim.atlas.scale
    love.graphics.draw(self.anim.atlas.image,quad,x,y,0,self.anim.atlas.scale,self.anim.atlas.scale)
end

return Instance