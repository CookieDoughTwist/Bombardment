--[[

]]

Engine = Class{}

function Engine:init(index)

    -- holds the state of the universe
    self.universe = Universe()
    --self.universe:loadScenario('simple_orbit')
    --self.universe:loadScenario('multi_orbit')
    self.universe:loadScenario('test_planetoid')
    --self.universe:loadScenario('no_bodies')

    self.state = ''
    self.stateMachine = StateMachine {
        ['focus'] = function() return EngineFocusState(self) end,
        ['map'] = function() return EngineMapState(self) end
    }

    self:changeState('focus', {})
end

function Engine:changeState(name, params)
    
    self.stateMachine:change(name, params)
end

function Engine:update(dt)

    -- update the universe
    -- only responsible for incrementing physics
    self.universe:update(dt)

    -- state machine handles all external inputs
    -- this includes player control (any changes applied next step)
    self.stateMachine:update(dt)
end

function Engine:render()
    
    -- state machine handles all rendering
    self.stateMachine:render()
end