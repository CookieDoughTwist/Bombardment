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
    self.angle = 0---PI_4
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

function Addon:render(lx, ly, bpm, showHitbox, showRange)

    local entityAngle = self.entity.body:getAngle()
    local baseAngle = entityAngle + self.orientation
    local barrelAngle = baseAngle + self.angle
    local iZoom = IMAGE_MPB * bpm -- meters/bit

    local ax, ay = rotateVector(self.location[1], self.location[2], entityAngle)    
    local bx, by = ax * bpm + lx, ay * bpm + ly

    -- TODO: define this somewhere 8/6/18 -AW
    local turretRadius = 1

    love.graphics.setColor(FULL_COLOR)
    if self.base then

    else
        love.graphics.setColor(GRAY)
        drawArc('fill', 'pie', bx, by, turretRadius * bpm, baseAngle - PI_2, baseAngle + PI_2)
    end

    if self.barrel then
        love.graphics.setColor(FULL_COLOR)
        love.graphics.draw(gTextures['conventional_gun'], bx, by, barrelAngle, iZoom, iZoom, 3, 30)
    else
        love.graphics.setColor(GRAY)
        local barrel = {
            -0.25, 0,
            0.25, 0,
            0.25, 4,
            -0.25, 4,
        }
        rotateTable(barrel, barrelAngle)
        multiplyTable(barrel, bpm)
        addPointTable(barrel, {bx, by})        
        love.graphics.polygon('fill', barrel)
    end

    if showHitbox then
        love.graphics.setColor(200, 0, 200, 255)
        love.graphics.circle('fill', bx, by, turretRadius)
    end
    if showRange then
        love.graphics.setColor(163, 15, 128, 100)
        drawArc('fill', 'pie', bx, by, self.acceptableRange * bpm, baseAngle - self.arc_2, baseAngle + self.arc_2)
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

    -- cannot fire before cooldown (for now)
    if self.cycle > 0 then
        return
    end

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

function Addon:getBoresight()
    return 
end