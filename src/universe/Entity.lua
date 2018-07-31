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
    
    self.thrust = 0
    
    self.fx = 0
    self.fy = 0
    self.fr = 0
end

function Entity:update(dt)    
    self.body:applyForce(self.fx, self.fy)
    self.body:applyTorque(self.fr)
end

function Entity:thrust(dt)
    local rot = self.body:getAngle()
    
end