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
    self.projectile = def.projectile
    self.fire_effect = def.fire_effect
    self.rotation_speed = def.rotation_speed

    -- TODO: modularize 8/7/18 -AW
    self.barrelLength = 4
    self.recoilDistance = 4    

    -- compute propeties
    self.cos_arc_2 = math.cos(self.arc_2)
    self.neutralBoresight = {rotateVector(0, -1, self.orientation)}

    -- state
    self.active = false
    self.angle = 0
    self.angleTarget = 0
    self.cycle = 0
    self.engaging = nil
    self.acceptableRange = 1E3
end

-- TODO: potentially consolidate common transcendental functions into state variables
-- which can refresh every update 8/6/18 -AW

function Addon:update(dt, spawnedEntities)

    -- tick cooldown cycle
    if self.cycle > 0 then
        -- prevent going below 0
        self.cycle = math.max(self.cycle - dt, 0)
    end

    -- update engagement code
    self:refreshEngagement()

    -- rotate barrel
    local angleDistance = self.angleTarget - self.angle
    local angleDelta = self.rotation_speed * dt

    if math.abs(angleDistance) < angleDelta then
        self.angle = self.angleTarget
    else
        self.angle = angleDistance > 0 and (self.angle + angleDelta) or (self.angle - angleDelta)
    end

    if self.engaging then
        self:fire(spawnedEntities)
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

    -- draw barrel first
    if self.barrel then
        local bimage = gTextures[self.barrel]
        local biWidth, biHeight = bimage:getDimensions()
        local cycleRatio = self.cycle / self.cooldown
        local recoilOffset = cycleRatio > 0.5 and -self.recoilDistance * math.sin(math.pi * (cycleRatio - 0.5) / 0.5) or 0
        love.graphics.setColor(FULL_COLOR)
        -- TODO: figure out why +8 works 8/7/18 -AW
        love.graphics.draw(bimage, bx, by, barrelAngle, iZoom, iZoom, biWidth / 2, biHeight + 8 + recoilOffset)
        if cycleRatio > 0.9 then
            local fimage = gTextures[self.fire_effect]
            local fiWidth, fiHeight = fimage:getDimensions()
            love.graphics.draw(fimage, bx, by, barrelAngle, iZoom, iZoom, fiWidth / 2, fiHeight + biHeight + 6)
        end        
    else
        love.graphics.setColor(LIGHT_GRAY)
        local barrel = {
            -0.25, 0,
            0.25, 0,
            0.25, -self.barrelLength,
            -0.25, -self.barrelLength,
        }
        rotateTable(barrel, barrelAngle)
        multiplyTable(barrel, bpm)
        addPointTable(barrel, {bx, by})        
        love.graphics.polygon('fill', barrel)
    end

    -- draw base over barrel
    if self.base then

    else
        love.graphics.setColor(GRAY)
        drawArc('fill', 'pie', bx, by, turretRadius * bpm, baseAngle - PI_2, baseAngle + PI_2)
    end

    if showHitbox then
        love.graphics.setColor(200, 0, 200, 200)
        love.graphics.circle('fill', bx, by, turretRadius)
    end
    if showRange then
        love.graphics.setColor(163, 15, 128, 150)
        drawArc('fill', 'pie', bx, by, self.acceptableRange * bpm, baseAngle - self.arc_2, baseAngle + self.arc_2)
    end

end

function Addon:engage(target)
    self.engaging = target
end

function Addon:refreshEngagement()
    
    -- check if engaging anything
    if not self.engaging then
        return
    end

    -- check if engaged target is destroyed
    if self.engaging.body:isDestroyed() then
        self.engaging = nil
        return
    end

    -- check if engaged target is still in range
    if not self:canEngage(self.engaging) then
        self.engaging = nil
        return
    end

    -- TODO: perhaps recycle some computations from previous checks 8/6/18 -AW
    if self.engaging then
        
        local px, py = self:getPosition()
        local tx, ty = self.engaging.body:getPosition()
        local bx, by = tx - px, ty - py
        local ta = math.atan2(by, bx) + PI_2
        local entityAngle = self.entity.body:getAngle()
        local baseAngle = entityAngle + self.orientation
        self.angleTarget = clampAngle(ta - baseAngle)
    end
end

function Addon:fire(spawnedEntities)

    -- cannot fire before cooldown (for now)
    if self.cycle > 0 then
        return
    end

    -- do not fire unless pointing where we want to
    if self.angle ~= self.angleTarget then
        return
    end

    -- FIRE!
    local lx, ly = self:getPosition()    
    local bx, by = self:getBoresight()
    local ex, ey = lx + bx * self.barrelLength, ly + by * self.barrelLength -- end of barrel
    local vx, vy = self.entity.body:getLinearVelocity()
    local state = {
        angle = self.entity.body:getAngle() + self.orientation + self.angle,
        dx = vx + bx * self.projectile_speed,
        dy = vy + by * self.projectile_speed,
        dr = 0,
        allegiance = 0
    }    

    local spawn = Entity(self.entity.body:getWorld(), ex, ey, ENTITY_DEFS[self.projectile])
    spawn:setState(state)
    -- TODO: less ghetto way to assign user data 8/7/18 -AW
    spawn.fixture:setUserData('projectile')
    table.insert(spawnedEntities, spawn)

    -- start cooldown
    self.cycle = self.cooldown
end

-- player input

function Addon:activate()
    self.active = true
end

function Addon:deactivate()
    self.active = false
    self.engaging = nil
    self.angleTarget = 0
end

--
-- query functions
--

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

function Addon:canEngage(target)
    return self:checkAcceptableRange(target) and self:checkArcRange(target)
end

function Addon:getPosition()
    local ex, ey = self.entity.body:getPosition()
    local ax, ay = rotateVector(self.location[1], self.location[2], self.entity.body:getAngle())
    return ex + ax, ey + ay
end

function Addon:getNeutralBoresight()
    return rotateVector(self.neutralBoresight[1], self.neutralBoresight[2], self.entity.body:getAngle())
end

function Addon:getBoresight()
    return rotateVector(self.neutralBoresight[1], self.neutralBoresight[2], self.entity.body:getAngle() + self.angle)
end 