--[[
    -- Engine Focus State --
]]


EngineFocusState = Class{__includes = BaseState}

function EngineFocusState:init(engine)
    
    self.engine = engine
    self.engine.state = 'focus'
end

function EngineFocusState:enter(params)
    
end

function EngineFocusState:update(dt)

    
end

function EngineFocusState:render()
    
end

