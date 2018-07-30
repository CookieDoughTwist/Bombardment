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
    
    self.player = Entity({world = self.world})
    
    table.insert(self.entities, self.player)
end

function Universe:update(dt)
    
    if love.keyboard.isDown('left') then
        self.player.ddx = -100
        self.player.ddy = 0
    elseif love.keyboard.isDown('right') then
        self.player.ddx = 100
        self.player.ddy = 0
    elseif love.keyboard.isDown('up') then
        self.player.ddx = 0
        self.player.ddy = -100
    elseif love.keyboard.isDown('down') then
        self.player.ddx = 0
        self.player.ddy = 100
    else
        self.player.ddx = 0
        self.player.ddy = 0
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