--[[

]]

TitleState = Class{__includes = BaseState}

function TitleState:init()
    
    self.title = 'BOMBARDMENT'
    self.canInput = true
end

function TitleState:update(dt)
    
    
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    
    if self.canInput then

    end

    
    
end

function TitleState:render()
    
end
