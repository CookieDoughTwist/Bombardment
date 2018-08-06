--[[
    -- Addon --
]]

Addon = Class{}

function Addon:init(entity, config)

    self.entity = entity
    self.location = config.location
    self.orientation = config.orientation
    def = ADDON_DEFS[config.def_key]
    self.cooldown = def.cooldown
    self.projectile_speed = def.projectile_speed
    self.arc_2 = def.arc_2
    self.base = def.base
    self.barrel = def.barrel

    -- compute propeties
    self.cos_arc_2 = math.cos(self.arc_2)
    self.neutralBoresight = {rotateVector(0, 1, self.orientation)}

    -- state
    self.active = true
    self.angle = 0
    self.cycle = 0
    self.engaging = nil
    self.acceptableRange = 1E3
end

-- TODO: potentially consolidate common transcendental functions into state variables
-- which can refresh every update 8/6/18 -AW

function Addon:update(dt)

    if self.cycle > 0 then
        self.cycle = self.cycle - dt
    end

    self:refreshEngagement()

    if self.engaging then
        self:fire()
    end
end

function Addon:render(lx, ly, entityAngle, bpm, showRange)

    local baseAngle = entityAngle + self.orientation

    local ax, ay = rotateVector(self.location[1], self.location[2], entityAngle)
    --local ax, ay = self:getPosition()
    local bx, by = ax * bpm + lx, ay * bpm + ly
    love.graphics.setColor(FULL_COLOR)
    if self.base then
    else
        love.graphics.circle('fill', bx, by, 5)
        --love.graphics.arc('fill', bx, by, 5)
    end
    if self.barrel then
    else

    end


    if showRange then
        love.graphics.setColor(163, 128, 15, 100)
        love.graphics.arc('fill', bx, by, self.acceptableRange * bpm, baseAngle - self.arc_2, baseAngle + self.arc_2)
    end

end

function Addon:engage(target)
    self.engaging = target
end

function Addon:refreshEngagement()

    if not self.target then
        return
    end

    local target = self.target

    if not self:checkArcRange(target) or not self:checkAcceptableRange(target) then
        self.target = nil
    end
end

function Addon:fire()
    self.cycle = self.cooldown
end

function Addon:checkArcRange(target)

    local px, py = self:getPosition()
    local tx, ty = target.body:getPosition()

    local ux, uy = unitizeVector(tx - px, ty - py)
    local bx, by = self:getNeutralBoresight()

    return ux * bx + uy * by > self.cos_arc_2
end

function Addon:checkAcceptableRange(target)

    local px, py = self:getPosition()
    local tx, ty = target.body:getPosition()

    return getVectorMag(tx - px, ty - py) < self.acceptableRange
end

function Addon:getPosition()
    local ex, ey = self.entity.body:getPosition()
    local ax, ay = rotateVector(self.location[1], self.location[2], self.entity.body:getAngle())
    return ex + ax, ey + ay
end

function Addon:getNeutralBoresight()
    return rotateVector(self.neutralBoresight[1], self.neutralBoresight[1], self.entity.body:getAngle())
end