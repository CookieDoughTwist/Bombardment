--[[
    -- Entity --
]]

Entity = Class{}

function Entity:init(world, x, y, def, universe)
    
    local width = def.width
    local height = def.height
    local mass = def.mass
    local thrust = def.thrust
    local gimbal = def.gimbal
    local vectoring = def.vectoring
    local thrustLoc = def.thrustLoc
    local addons = def.addons

    -- initialize Box2D
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.shape = love.physics.newRectangleShape(width, height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.body:setMass(mass)
    self.body:setInertia(mass * height^2 / 3)  
    
    -- track orbiting body
    self.orbitingBody = nil
    self.greatestPull = 0

    --
    -- craft properties
    --

    -- verhicle properties
    self.thrust = thrust
    self.gimbal = gimbal
    self.vectoring = math.rad(vectoring)
    self.thrustLoc = thrustLoc
    self.hp = 50
    self.hpMax = 100
    if addons then
        self.addons = {}
        for k, addon_def in pairs(addons) do
            table.insert(self.addons, Addon(self, addon_def))
        end
    end

    -- C2: Command and Control
    self.c2 = C2(self, universe)

    -- control state
    self.thrusterOn = false
    self.throttle = 0.5
    self.rotateThrottle = 0
    self.stabilize = false

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
    self.allegiance = state.allegiance or 0
end

function Entity:update(dt)

    -- TODO: organize misc. variables 8/6/18 -AW
    self.thrusted = false
    
    self.c2:update(dt)

    if self.thrusterOn then
        self.thrusted = true
        self:move()
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

    -- update addons
    for k, addon in pairs(self.addons) do
        addon:update(dt)
    end

    -- reset greatest pull
    self.greatestPull = 0
end

-- called by Body
function Entity:exertGravity(g, ux, uy, body)

    -- apply force
    self.body:applyForce(ux * g, uy * g)

    -- check for greatest gravitational pull
    if g > self.greatestPull then
        self.orbitingBody = body
        self.greatestPull = g
    end
end

function Entity:render(camX, camY, bpm, showHitbox)

    -- get position in world coordinates and meters
    local x, y = self.body:getPosition()                -- meters

    -- convert to screen position in bits
    local lx = (x - camX) * bpm + VIRTUAL_WIDTH_2       -- bits
    local ly = (y - camY) * bpm + VIRTUAL_HEIGHT_2      -- bits
    -- TODO: formalize angle (resource images are pointed up),
    -- but the game points down 8/5/18 -AW
    local la = self.body:getAngle() + math.pi
    -- TODO: modularize zoom 8/4/18 -AW
    local iZoom = 0.125 * bpm -- meters/bit    
    local iWidth_2, iHeight_2 = getImageHalfDimensions('standard_craft')

    love.graphics.setColor(FULL_COLOR)
    love.graphics.draw(gTextures['standard_craft'], lx, ly, la, iZoom, iZoom, iWidth_2, iHeight_2)

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
            hardOff = -3
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
    -- apply thrust force
    self.body:applyForce(rotateVector(0, thrustF, rot))
    -- get thrust center of gravity offset
    local r = math.sqrt(self.thrustLoc[1]^2 + self.thrustLoc[2]^2)
    -- compute vectored torque
    local torque = r * thrustF * math.sin(rotV)
    -- apply thrust vectoring
    self.body:applyTorque(torque)
end

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
        return 0
    end

    local ovx, ovy = self.orbitingBody.body:getLinearVelocity()
    local vx, vy = self.body:getLinearVelocity()

    -- TODO: CHECK: this is might not be "orbital velocity" 8/5/18 -AW
    return math.sqrt((vx - ovx)^2 + (vy - ovy)^2)
end