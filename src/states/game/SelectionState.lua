--[[
    -- Selection State --
]]


SelectionState = Class{__includes = BaseState}

function SelectionState:init()

    -- currently selected menu item
    self.currentMenuItem = 1

    self.transitionAlpha = 0
    
    self.options = SELECTIONS_START
    
    
    self.canInput = true
end

function SelectionState:enter(params)

end

function SelectionState:update(dt)

    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('title')
    end

    if self.canInput then
        
        -- change menu selection
        if love.keyboard.wasPressed('up') and
            self.currentMenuItem ~= 1 then
            self.currentMenuItem = self.currentMenuItem - 1
            gSounds['reselect']:stop()
            gSounds['reselect']:play()
        end
        
        if love.keyboard.wasPressed('down') and
            self.currentMenuItem ~= #self.options then
            self.currentMenuItem = self.currentMenuItem + 1
            gSounds['reselect']:stop()
            gSounds['reselect']:play()
        end
        
        -- switch to another state via one of the menu options
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.currentMenuItem > #self.options then
                gStateMachine:change('start')
            else                
                -- tween, using Timer, the transition rect's alpha to 255, then
                -- transition to the BeginGame state after the animation is over
                Timer.tween(T_TRANSITION, {
                    [self] = {transitionAlpha = 255}
                }):finish(function()
                    gStateMachine:change('play', {
                        index = self.currentMenuItem
                    })
                end)
            end

            self.canInput = false
        end
    end
end

function SelectionState:render()
   
    -- TODO: render background here 7/24/18 -AW
   
    -- keep the background darker than normal
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    drawSelectionsText('Main Menu', -200)
    drawMenu(self.currentMenuItem, 12, self.options)

    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

