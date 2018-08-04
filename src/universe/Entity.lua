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

    self.allegiance = 0
end

function Entity:setState(state, userData)
    self.body:setLinearVelocity(state.dx, state.dy)
    self.body:setAngularVelocity(state.dr)
    self.fixture:setUserData(userData or 'entity')
    self.allegiance = state.allegiance or 0
end

function Entity:update(dt)    
  
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