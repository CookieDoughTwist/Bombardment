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
    
    -- mass stored external to body (Box2D zeros out mass on kinematic objects)
    self.mass = mass
end

function Body:exertGravity(entity)
    local bx, by = self.body:getPosition()
    local ex, ey = entity.body:getPosition()
    local ebx, eby = bx - ex, by - ey
    -- TODO: clean-up some of the math to avoid repeat computations 8/1/18 -AW
    local r2 = ebx^2 + eby^2
    local g = G * self.mass * entity.body:getMass() / r2    
    local ux, uy = unitizeVector(ebx, eby)
    entity.body:applyForce(ux * g, uy * g)
end

function Body:update(dt)
    
end

