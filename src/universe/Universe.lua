--[[
    -- The Universe --
]]

Universe = Class{}

function Universe:init()
    
    -- object tables
    self.bodies = {}    -- bodies are immune to physics (but can exert physics)
    self.entities = {}  -- entities have physics
    self.player = {}    -- entities of the player (also in entities)
    
    self.world = love.physics.newWorld(0, 0)
    
    self.time = 0
end

function Universe:loadScenario(scenarioName)
    local scenario_def = SCENARIO_DEFS[scenarioName]
    local bodies = scenario_def.bodies
    local entities = scenario_def.entities
    local players = scenario_def.player

    for k, v in pairs(bodies) do
        local val = Body(self.world, v.x, v.y, BODY_DEFS[v.def_key])
        table.insert(self.bodies, val)
    end

    for k, v in pairs(entities) do
        local val = Entity(self.world, v.x, v.y, ENTITY_DEFS[v.def_key])
        val.body:setLinearVelocity(v.dx, v.dy)
        val.body:setAngularVelocity(v.dr)
        table.insert(self.entities, val)
    end

    for k, v in pairs(players) do
        local val = Entity(self.world, v.x, v.y, ENTITY_DEFS[v.def_key])
        val.body:setLinearVelocity(v.dx, v.dy)
        val.body:setAngularVelocity(v.dr)        
        table.insert(self.entities, val)
        table.insert(self.player, val)
    end
    
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
        x, y = entity.body:getLinearVelocity()
    end
    
    self.world:update(dt)
    
    self.time = self.time + dt
end