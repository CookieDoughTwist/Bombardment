--[[
    -- Entity --
]]

Entity = Class{}

function Entity:init(world, x, y, def, universe)
    
    local resource = def.resource
    local width = def.width
    local height = def.height
    local mass = def.mass
    local thrust = def.thrust
    local gimbal = def.gimbal
    local vectoring = def.vectoring
    local thrustLoc = def.thrustLoc
    local addons = def.addons

    -- resources
    self.resource = resource

    -- initialize Box2D
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.shape = love.physics.newRectangleShape(width, height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.body:setMass(mass)
    self.body:setInertia(mass * height^2 / 3)  

    -- TODO: remove this (it's here for explosions for now) 8/8/18 -AW
    self.height = height
    
    -- track statistics
    self.orbitingBody = nil
    self.greatestPull = 0
    self.gx = 0
    self.gy = 0
    self.lgx = 0
    self.lgy = 0
    self.thrustX, self.thrustY = 0, 0

    -- existential state
    self.active = true
    self.remove = false
    self.exploding = false
    self.explodeTime = 1

    --
    -- craft properties
    --

    -- verhicle properties
    self.thrust = thrust
    self.gimbal = gimbal
    self.vectoring = vectoring
    self.thrustLoc = thrustLoc
    self.hp = 100
    self.hpMax = 100
    self.addons = {}
    if addons then
        for k, addon_def in pairs(addons) do
            table.insert(self.addons, Addon(self, addon_def))
        end
    end

    self.AI = false

    -- C2: Command and Control
    if universe then
        self.c2 = C2(self, universe)

        -- TODO: super ghetto way to do thruster sounds 8/8/18 -AW
        self.thrustSound = love.audio.newSource('resources/sounds/interaction/chemical_thruster.wav')
    end

    -- control state
    -- FIXME: reenable after submission (don't want to confuse people) 8/8/18 -AW 
    --self.thrusterOn = false
    self.thrusterOn = true
    self.throttle = 0.0
    self.rotateThrottle = 0
    -- FIXME: reenable after submission (don't want to confuse people) 8/8/18 -AW 
    --self.stabilize = false
    self.stabilize = true

    -- object hostility
    self.allegiance = 0

    -- misc.
    self.thrusted = false
end

function Entity:setState(state)
    self.body:setAngle(state.angle)
    self.body:setLinearVelocity(state.dx, state.dy)
    self.body:setAngularVelocity(state.dr)
    self.fixture:setUserData('entity')
    self.body:setUserData(self)
    self.allegiance = state.allegiance or 0
end

function Entity:update(dt)

    -- apply gravity
    self.body:applyForce(self.gx, self.gy)

    -- save gravity vector
    self.lgx = self.gx
    self.lgy = self.gy

    -- reset gravity tracking for next update
    self.greatestPull = 0
    self.gx = 0
    self.gy = 0

    if self.exploding then
        self:updateExplosion(dt)
    end

    -- TODO: modularize updates for boring objects 8/7/18 -AW
    if not self.c2 then
        return {}
    end

    -- TODO: cleaner way to make entities do nothing 8/8/18 -AW
    if not self.active then
        return {}
    end

    -- TODO: organize misc. variables 8/6/18 -AW
    self.thrusted = false

    self.c2:update(dt)

    if self.thrusterOn then
        self.thrusted = true
        self:move()

        self.thrustSound:setVolume(self.throttle / 2)
        if not self.thrustSound:isPlaying() then
            self.thrustSound:play()
        end
    elseif self.thrustSound:isPlaying() then
            self.thrustSound:stop()
    end

    -- gimbal torque
    if self.rotateThrottle == 0 and self.stabilize then
        -- TODO: improve "stabilization algorithm" lol 8/5/18 -AW
        local rotVel = self.body:getAngularVelocity()        
        local torque = rotVel < 0 and self.gimbal or -self.gimbal
        self.body:applyTorque(torque)
    else
        self.body:applyTorque(self.gimbal * self.rotateThrottle)
    end

    local spawnedEntities = {}

    -- update addons
    for k, addon in pairs(self.addons) do
        addon:update(dt, spawnedEntities)
    end

    return spawnedEntities
end

function Entity:render(camX, camY, bpm, showHitbox)

    -- get position in world coordinates and meters
    local x, y = self.body:getPosition()                -- meters

    -- convert to screen position in bits
    local lx = (x - camX) * bpm + VIRTUAL_WIDTH_2       -- bits
    local ly = (y - camY) * bpm + VIRTUAL_HEIGHT_2      -- bits
    local la = self.body:getAngle()
    local iZoom = IMAGE_MPB * bpm -- meters/bit

    -- TODO: smarter explosion render logic (probably create a particle class) 8/8/18 -AW
    if self.exploding then
        local eZoom = self.height * bpm / 16
        local etag = 'small_orange_explosion'
        love.graphics.setColor(FULL_COLOR)
        if self.explodeTime > 0.5 then
            love.graphics.draw(gTextures[etag], gFrames[etag][1], lx, ly, la, eZoom, eZoom, 8, 8)
        else
            local eRatio = self.explodeTime / 0.5
            local idx = 6 - math.ceil(5 * eRatio)
            love.graphics.draw(gTextures[etag], gFrames[etag][idx], lx, ly, la, eZoom, eZoom, 8, 8)
        end
        return
    end

    if self.resource then
        local tag = self.resource
        local iWidth_2, iHeight_2 = getImageHalfDimensions(tag)

        love.graphics.setColor(FULL_COLOR)
        love.graphics.draw(gTextures[tag], lx, ly, la, iZoom, iZoom, iWidth_2, iHeight_2)
    else
        -- force hitbox drawing if no graphic
        showHitbox = true
    end

    -- draw engine activity if on
    if self.thrusted then

        -- choose exhaust sprite based on engine level
        local iTag = nil
        -- TODO: remove hard coding 8/5/18 -AW
        local hardOff = 0
        local plumeScale = 1                
        if self.throttle == 0 then
            iTag = nil
        elseif self.throttle < 1 then
            iTag = 'medium_plume'
            plumeScale = self.throttle
        else
            iTag = 'large_plume'
            hardOff = 3
        end

        -- check if any sprite is chosen
        if iTag then
            -- plume angle
            local pa = self.body:getAngle() - self.rotateThrottle * self.vectoring
            local px, py = rotateVector(self.thrustLoc[1], self.thrustLoc[2] + hardOff, pa)
            local tx, ty = px * bpm + lx, py * bpm + ly            
            local hiWidth_2, hiHeight_2 = getImageHalfDimensions(iTag)
            love.graphics.draw(gTextures[iTag], tx, ty, pa, iZoom * plumeScale, iZoom * plumeScale, hiWidth_2, hiHeight_2)
        end
    end

    -- draw addons
    if self.addons then
        for k, addon in pairs(self.addons) do
            addon:render(lx, ly, bpm, showHitbox, showHitbox)
        end
    end

    if showHitbox then
        local polyPoints = {self.body:getWorldPoints(self.shape:getPoints())}                        
        addPointTable(polyPoints, {-camX, -camY})
        multiplyTable(polyPoints, bpm)
        addPointTable(polyPoints, {VIRTUAL_WIDTH_2, VIRTUAL_HEIGHT_2})
        love.graphics.setColor(128, 163, 15, 150)
        love.graphics.polygon('fill', polyPoints)
    end
end

-- called by Body
function Entity:exertGravity(g, ux, uy, body)

    local gx, gy = ux * g, uy * g

    self.gx = self.gx + gx
    self.gy = self.gy + gy

    -- check for greatest gravitational pull
    if g > self.greatestPull then
        self.orbitingBody = body
        self.greatestPull = g
    end
end

--
-- craft functions
--

-- throttle is between -1 and 1
function Entity:move()
    
    -- engine thrust vector angle
    local rotV = self.rotateThrottle * self.vectoring
    -- total engine rotation relative to universe
    local rot = self.body:getAngle() - rotV
    -- thrust force
    local thrustF = self.thrust * self.throttle
    self.thrustX, self.thrustY = rotateVector(0, -thrustF, rot)
    -- apply thrust force
    self.body:applyForce(self.thrustX, self.thrustY)
    -- get thrust center of gravity offset
    local r = math.sqrt(self.thrustLoc[1]^2 + self.thrustLoc[2]^2)
    -- compute vectored torque
    local torque = r * thrustF * math.sin(rotV)
    -- apply thrust vectoring
    self.body:applyTorque(torque)
end

function Entity:damage(points)
    self.hp = self.hp - points
end

function Entity:kill()

    -- need to separate types from entity
    if self.fixture:getUserData() == 'projectile' then
        self.remove = true
    elseif self.active then
        gSounds['explosion1']:stop()
        gSounds['explosion1']:play()
    end

    self.active = false
    self.exploding = true
    -- no colliding with anything
    self.fixture:setGroupIndex(0)

    -- TODO: super ghetto, formalize sound handling 8/8/18 -AW
    if self.thrustSound then
        self.thrustSound:stop()
    end
end

function Entity:destroy()

    if not self.body:isDestroyed() then
        self.body:destroy()
    end
end

function Entity:updateExplosion(dt)
    if self.explodeTime <= 0 then
        self.remove = true
        self.active = false
    end

    self.explodeTime = self.explodeTime - dt
end

-- user functions

-- throttle is between -1 and 1
function Entity:rotate(throttle)
    self.rotateThrottle = throttle    
end

function Entity:toggleThruster()
    self.thrusterOn = not self.thrusterOn
end

function Entity:throttleDown()
    -- TODO: rework to for nonzero minimum throttle 8/5/18 -AW
    self.throttle = math.max(self.throttle - CRAFT_THROTTLE_RATE, 0)
end

function Entity:throttleUp()
    -- TODO: rework to for nonzero minimum throttle 8/5/18 -AW
    self.throttle = math.min(self.throttle + CRAFT_THROTTLE_RATE, 1)
end

function Entity:throttleMax()
    self.throttle = 1
end

function Entity:throttleMin()
    self.throttle = 0
end

function Entity:toggleStabilization()
    self.stabilize = not self.stabilize
end

--
-- query functions
--

function Entity:getOrbitalVelocity()

    if not self.orbitingBody then
        return 0, 0
    end

    local ovx, ovy = self.orbitingBody.body:getLinearVelocity()
    local vx, vy = self.body:getLinearVelocity()

    -- TODO: CHECK: this is might not be "orbital velocity" 8/5/18 -AW
    --return math.sqrt((vx - ovx)^2 + (vy - ovy)^2)
    return vx - ovx, vy - ovy
end