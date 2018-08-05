--[[
    -- Entity --
]]

Entity = Class{}

function Entity:init(world, x, y, def)
    
    local width = def.width
    local height = def.height
    local mass = def.mass

    -- initialize Box2D
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.shape = love.physics.newRectangleShape(width, height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.body:setMass(mass)    
    
    -- verhicle properties
    self.thrust = 1000000
    self.rotThrust = 100

    -- thruster state
    self.thrusterOn = false
    self.throttle = 0
    self.thrustLoc = {0, -33}

    -- object hostility
    self.allegiance = 0

    -- track orbiting body
    self.orbitingBody = nil
    self.greatestPull = 0
end

function Entity:setState(state, userData)
    self.body:setLinearVelocity(state.dx, state.dy)
    self.body:setAngularVelocity(state.dr)
    self.fixture:setUserData(userData or 'entity')
    self.allegiance = state.allegiance or 0
end

function Entity:update(dt)    

    self:move()

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
    local x, y = self.body:getPosition()

    -- convert to screen position in bits
    local lx = (x - camX) * bpm + VIRTUAL_WIDTH_2
    local ly = (y - camY) * bpm + VIRTUAL_HEIGHT_2
    -- TODO: formalize angle (resource images are pointed up),
    -- but the game points down 8/5/18 -AW
    local la = self.body:getAngle() + math.pi
    -- TODO: modularize zoom 8/4/18 -AW
    local iZoom = 0.125 * bpm -- meters/bit    
    local iWidth_2, iHeight_2 = getImageHalfDimensions('standard_craft')

    love.graphics.setColor(FULL_COLOR)
    love.graphics.draw(gTextures['standard_craft'], lx, ly, la, iZoom, iZoom, iWidth_2, iHeight_2)

    if self.throttle > 0 then

        local px, py = rotateVector(self.thrustLoc[1], self.thrustLoc[2], la + math.pi)
        local tx = px * bpm + lx
        local ty = py * bpm + ly
        local hiWidth_2, hiHeight_2 = getImageHalfDimensions('large_plume')
        love.graphics.draw(gTextures['large_plume'], tx, ty, la, iZoom, iZoom, hiWidth_2, hiHeight_2)
    end

    if showHitbox then                
        local polyPoints = {self.body:getWorldPoints(self.shape:getPoints())}                        
        addPointTable(polyPoints, {-camX, -camY})
        multiplyTable(polyPoints, bpm)
        addPointTable(polyPoints, {VIRTUAL_WIDTH_2, VIRTUAL_HEIGHT_2})
        love.graphics.setColor(128, 163, 15, 200)
        love.graphics.polygon('fill', polyPoints)
    end
end

--
-- craft functions
--

-- throttle is between -1 and 1
function Entity:move()
    
    local rot = self.body:getAngle()
    self.body:applyForce(rotateVector(0, self.thrust * self.throttle, rot))
end

-- throttle is between -1 and 1
function Entity:rotate(throttle)
    self.body:applyTorque(self.rotThrust * throttle)
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