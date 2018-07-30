--[[

]]

Engine = Class{}

function Engine:init()

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
    
    -- state machine updated last
    self.stateMachine:update(dt)
end

function Engine:render()
    
    -- state machine rendered last
    self.stateMachine:render()
end