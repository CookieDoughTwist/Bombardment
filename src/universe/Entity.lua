--[[
    -- Entity --
]]

Entity = Class{}

function Entity:init(params)
    
    self.body = love.physics.newBody(params.world, 10, 10, 'dynamic')
    self.shape = love.physics.newRectangleShape(10, 10)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    
    self.mass = params.mass
    self.radius = params.radius
    
    self.ddx = 0
    self.ddy = 0
end

function Entity:update(dt)    
    self.body:applyForce(self.ddx, self.ddy)
end