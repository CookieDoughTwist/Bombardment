--[[
    -- The Universe --
]]

Universe = Class{}

function Universe:init()
    
    -- object tables
    self.bodies = {}    -- bodies are immune to physics (but can exert physics)
    self.entities = {}  -- entities have physics
    
    self.world = love.physics.newWorld(0, 0)
    
    self.time = 0
    
    self.player = Entity(self.world, 500, 500, ENTITY_DEFS['cal_ship_10_50_10000'])    
    table.insert(self.entities, self.player)
    
    local body = Body(self.world, 0, 0, BODY_DEFS['cal_roid_100_10000000'])
    table.insert(self.bodies, body)
end

function Universe:update(dt)
    
    -- update the celestial bodies
    for k, body in pairs(self.bodies) do
        body:update(dt)
    end
    
    -- update entities
    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end
    
    self.world:update(dt)
    
    self.time = self.time + dt
end