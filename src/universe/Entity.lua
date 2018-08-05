--[[
    -- Entity --
]]

Entity = Class{}

function Entity:init(world, x, y, def)
    
    local width = def.width
    local height = def.height
    local mass = def.mass
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.shape = love.physics.newRectangleShape(width, height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    
    self.body:setMass(mass)    
    
    self.thrust = 1000000
    self.rotThrust = 100

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

    -- reset greatest pull
    self.greatestPull = 0
end

-- throttle is between -1 and 1
function Entity:move(throttle)
    local rot = self.body:getAngle()
    self.body:applyForce(rotateVector(0, self.thrust * throttle, rot))
end

-- throttle is between -1 and 1
function Entity:rotate(throttle)
    self.body:applyTorque(self.rotThrust * throttle)
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
    local x, y = self.body:getPosition()

    local lx = (x - camX) * bpm + VIRTUAL_WIDTH_2
    local ly = (y - camY) * bpm + VIRTUAL_HEIGHT_2
    local la = self.body:getAngle() + math.pi
    -- TODO: modularize zoom 8/4/18 -AW
    local iZoom = 0.125 * bpm -- meters/bit
    local cimage = gTextures['standard_craft']
    local iWidth, iHeight = cimage:getDimensions()
    local iWidth_2, iHeight_2 = iWidth / 2, iHeight / 2

    love.graphics.setColor(FULL_COLOR)
    love.graphics.draw(gTextures['standard_craft'], lx, ly, la, iZoom, iZoom, iWidth_2, iHeight_2)
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