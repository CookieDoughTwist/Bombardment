--[[
    -- Play State --
]]


PlayState = Class{__includes = BaseState}

function PlayState:init()
    
    self.engine = nil
    
    self.canInput = true
end

function PlayState:enter(params)
    local index = params.index
    self.engine = Engine(SELECTIONS_TAGS[index])
end

function PlayState:update(dt)

    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('select')
    end

    self.engine:update(dt)
end

function PlayState:render()
    self.engine:render()
end

