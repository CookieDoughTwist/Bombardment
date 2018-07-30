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
    
    local universe = self.engine.universe
    
    for k, entity in pairs(universe.entities) do
        love.graphics.setColor(128, 163, 15) -- set the drawing color to green for the ground
        love.graphics.polygon("fill", entity.body:getWorldPoints(entity.shape:getPoints()))
        
    end
end

