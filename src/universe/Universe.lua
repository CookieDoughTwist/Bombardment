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

    -- table of objects destroyed
    self.destroyedObjects = {}
    
    -- game state
    self.time = 0    
    self.victory = false
    self.defeat = false

    -- TODO: some of what we're doing here can actually be more easily achieved by using
    -- the inputted coll object (a contact object in Box2D) 8/8/18 -AW
    function beginContact(a, b, coll)

        local types = {}
        types[a:getUserData()] = true
        types[b:getUserData()] = true

        if types['body'] and types['entity'] then

            local entityFixture = a:getUserData() == 'entity' and a or b
            local entityBody = entityFixture:getBody()
            local bodyFixture = a:getUserData() == 'body' and a or b
            local bodyBody = bodyFixture:getBody()
            -- TODO: better collision judgement (in case fast rotation) 8/7/18 -AW
            local mag = getBodyRelVelMag(entityBody, bodyBody)
            local mom = mag * entityBody:getMass()
            local entity = entityBody:getUserData()
            entity:damage(mom * DAMAGE_FROM_MOMENTUM)
            --table.insert(self.destroyedObjects, entityFixture:getBody())

        elseif types['entity'] and types['projectile'] then

            local entityFixture = a:getUserData() == 'entity' and a or b
            local entityBody = entityFixture:getBody()
            local projFixture = a:getUserData() == 'projectile' and a or b
            local projBody = projFixture:getBody()
            local entity = entityBody:getUserData()
            local proj = projBody:getUserData()
            -- FIXME: this is a really dumb way to do damage 8/8/18 -AW
            entity:damage(2)
            proj:damage(100)
            local psound = gSounds[CONVENTIONAL_HIT_SOUNDS[math.random(#CONVENTIONAL_HIT_SOUNDS)]]
            psound:stop()
            psound:play()

        elseif types['entity'] then

            local bodyA = a:getBody()
            local bodyB = b:getBody()
            local mag = getBodyRelVelMag(bodyA, bodyB)
            local momA = mag * bodyA:getMass()
            local momB = mag * bodyB:getMass()
            local entityA = bodyA:getUserData()
            local entityB = bodyB:getUserData()
            --entityA:damage(momB * DAMAGE_FROM_MOMENTUM)
            --entityB:damage(momA * DAMAGE_FROM_MOMENTUM)
            -- FIXME: this is a really dumb way to do damage 8/8/18 -AW
            entityA:damage(0.1 * mag)
            entityB:damage(0.1 * mag)
            local psound = gSounds[CONVENTIONAL_HIT_SOUNDS[math.random(#CONVENTIONAL_HIT_SOUNDS)]]
            psound:stop()
            psound:play()
        elseif types['projectile'] then            
        else
            error('Logic fault! Unhandled collision case...')
        end
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
        val:setState(v)
        table.insert(self.bodies, val)
    end

    for k, v in pairs(entities) do
        -- TODO: modular way to split crafts 8/8/18 -AW
        if v.craft then
            local val = Entity(self.world, v.x, v.y, ENTITY_DEFS[v.def_key], self)
            val:setState(v)
            val.AI = true
            table.insert(self.entities, val)
        else
            local val = Entity(self.world, v.x, v.y, ENTITY_DEFS[v.def_key])
            val:setState(v)
            table.insert(self.entities, val)
        end
    end

    for k, v in pairs(players) do
        local val = Entity(self.world, v.x, v.y, ENTITY_DEFS[v.def_key], self)
        val:setState(v)
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
        local spawnedEntities = entity:update(dt)
        -- TODO: is this the best way to add new entities? 8/7/18 -AW
        for l, spawn in pairs(spawnedEntities) do
            table.insert(self.entities, spawn)
        end
    end
    
    -- update Box2D
    self.world:update(dt)
    
    -- update game time
    self.time = self.time + dt

    -- remove dead entities
    -- TODO: figure out how table.remove works with for loops x_x
    -- 8/8/18 -AW
    for n = #self.entities, 1, -1 do
        entity = self.entities[n]
        if entity.hp <= 0 then
            entity:kill()
        end
    end

    for n = #self.entities, 1, -1 do
        entity = self.entities[n]
        if entity.remove then
            entity:destroy()
            table.insert(self.destroyedObjects, entity)
            table.remove(self.entities, n)
        end
    end

    -- also remove dead entities from player table
    for n = #self.player, 1, -1 do
        entity = self.player[n]
        if entity.remove then
            table.remove(self.player, n)
        end
    end

    -- TODO: less ghetto way to do objectives 8/7/18 -AW
    local noEnemies = true
    local noPlayers = true

    for k, entity in pairs(self.entities) do
        if entity.allegiance < 0 then
            noEnemies = false
        elseif entity.allegiance > 0 then
            noPlayers = false
        end
    end

    -- TODO: less ghetto way to do objectives 8/7/18 -AW
    if noEnemies then
        self.victory = true
    elseif noPlayers then
        self.defeat = true
    end
end

--
-- query functions
--

