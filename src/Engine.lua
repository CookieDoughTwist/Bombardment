--[[

]]

Engine = Class{}

function Engine:init(index)

    -- holds the state of the universe
    self.universe = Universe()
    self.universe:loadScenario('simple_orbit')

    self.state = ''
    self.stateMachine = StateMachine {
        ['focus'] = function() return EngineFocusState(self) end
    }
    
    self:changeState('focus', {})
end

function Engine:changeState(name, params)
    
    self.stateMachine:change(name, params)
end

function Engine:update(dt)

    -- state machine handles all external inputs
    -- this includes player control
    self.stateMachine:update(dt)

    -- update the universe
    -- only responsible for incrementing physics
    self.universe:update(dt)
end

function Engine:render()
    
    -- state machine handles all rendering
    self.stateMachine:render()
end