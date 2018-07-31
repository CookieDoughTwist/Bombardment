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
    
    self.player = Entity(self.world, 500, 500, ENTITY_DEFS['player'])
    
    table.insert(self.entities, self.player)
end

function Universe:update(dt)
    
    if love.keyboard.isDown('left') then
        self.player:rotate(-1)
    elseif love.keyboard.isDown('right') then
        self.player:rotate(1)
    else
        self.player:rotate(0)
    end
    if love.keyboard.isDown('up') then
        self.player:move(1)
    elseif love.keyboard.isDown('down') then
        self.player:move(-1)
    else
        self.player:move(0)
    end
    
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