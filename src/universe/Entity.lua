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
    
    self.thrust = 1000
    self.rotThrust = 100
    
    self.fx = 0
    self.fy = 0
    self.fr = 0
end

function Entity:update(dt)    
    self.body:applyForce(self.fx, self.fy)
    self.body:applyTorque(self.fr)    
end

-- throttle is between -1 and 1
function Entity:move(throttle)
    local rot = self.body:getAngle()
    self.fx, self.fy = rotateVector(0, self.thrust * throttle, rot)
end

-- throttle is between -1 and 1
function Entity:rotate(throttle)
    self.fr = self.rotThrust * throttle
end