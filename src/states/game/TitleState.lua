--[[

]]

TitleState = Class{__includes = BaseState}

function TitleState:init()

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
    
    love.graphics.draw(gTextures['spacelandbg'], 0, 0)
    
    love.graphics.setFont(gFonts['futureearth48'])
    
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('BOMBARDMENT', SHADOW_OFFSET, VIRTUAL_HEIGHT / 4 - 40 + SHADOW_OFFSET, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('BOMBARDMENT', 0, VIRTUAL_HEIGHT / 4 - 40, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['futureearth32'])
    
    love.graphics.printf('Press Enter', 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, 'center')
end
