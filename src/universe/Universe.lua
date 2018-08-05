--[[
    -- The Universe --
]]

Universe = Class{}

function Universe:init()
    
    -- object tables
    self.bodies = {}    -- bodies are immune to physics (but can exert physics)
    self.entities = {}  -- entities have physics
    self.player = {}    -- entities of the player (also in entities)
    
    -- world with no inherent gravity
    self.world = love.physics.newWorld(0, 0)

    -- table of objects to be destroyed
    self.destroyedObjects = {}
    
    -- game time
    self.time = 0

    function beginContact(a, b, coll)

    end

    function endContact(a, b, coll)
    
    end

    function preSolve(a, b, coll)

    end

    function postSolve(a, b, coll, normalImpulse, tangentImpulse)

    end

    -- set collision callbacks
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
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
        val:setState(v)
        table.insert(self.entities, val)
    end

    for k, v in pairs(players) do
        local val = Entity(self.world, v.x, v.y, ENTITY_DEFS[v.def_key])
        val:setState(v, 'player')
        val.allegiance = 1
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
    
    -- update Box2D
    self.world:update(dt)
    
    -- update game time
    self.time = self.time + dt

    -- destroy objects queued for destruction
    for k, body in pairs(self.destroyedObjects) do
        if not body:isDestroyed() then
            body:destroy()
        end
    end
end

--
-- query functions
--

