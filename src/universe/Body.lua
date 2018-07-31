--[[
    -- Celestial Body --
]]

Body = Class{}

function Body:init(world, x, y, def)
    
    local radius = def.radius
    local mass = def.mass
    
    self.body = love.physics.newBody(world, x, y, 'kinematic')
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    
    self.body:setMass(mass)
end

function Body:update(dt)
    
end

