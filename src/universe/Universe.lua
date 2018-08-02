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
end

function Universe:loadScenario(scenarioName)
    local scenario_def = SCENARIO_DEFS[scenarioName]
    local bodies = scenario_def.bodies
    local entities = scenario_def.entities
    local player = scenario_def.player

    for k, v in paris(bodies) do
        local val = Body(self.world, v.x, v.y, BODY_DEFS[k])
        table.insert(self.bodies, body)
    end

    for k, v in paris(bodies) do
        local val = Entity(self.world, v.x, v.y, ENTITY_DEFS[k])
        table.insert(self.entities, entity)
    end

    for k, v in paris(bodies) do
        local val = Entity(self.world, v.x, v.y, ENTITY_DEFS[k])
        table.insert(self.entities, entity)
    end
    
    self.player = Entity(self.world, player.x, player.y, ENTITY_DEFS['cal_ship_10_50_10000'])    
    table.insert(self.entities, self.player)
    self.player.body:setLinearVelocity(0, 19)
    
    --local body = Body(self.world, 0, 0, BODY_DEFS['cal_roid_100_10000000'])
    --table.insert(self.bodies, body)
    local body = Body(self.world, 400, 400, BODY_DEFS['cal_roid_100_10000000'])
    table.insert(self.bodies, body)
end

function Universe:update(dt)
    
    -- apply gravity
    for k, entity in pairs(self.entities) do
        for k, body in pairs(self.bodies) do
            body:exertGravity(entity)
        end
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