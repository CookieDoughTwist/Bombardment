--[[
    -- Entity --
]]

Entity = Class{}

function Entity:init(params)
    
    body = love.physics.newBody(params.world, params.x, params.y, 'dynamic')
    
    self.mass = params.mass
    self.radius = params.radius
    
end

function Entity:update(dt)
    
    
end