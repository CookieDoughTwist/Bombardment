--[[

]]

Engine = Class{}

function Engine:init(index)

    -- holds the state of the universe
    self.universe = Universe()

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

    -- state machine updated first
    -- player controls are dictated by state
    self.stateMachine:update(dt)

    self.universe:update(dt)
end

function Engine:render()
    
    -- state machine handles all rendering
    self.stateMachine:render()
end