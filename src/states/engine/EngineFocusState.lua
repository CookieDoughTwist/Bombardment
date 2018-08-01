--[[
    -- Engine Focus State --
]]


EngineFocusState = Class{__includes = BaseState}

function EngineFocusState:init(engine)
    
    self.engine = engine
    self.engine.state = 'focus'
    self.camX = -100
    self.camY = 0
end

function EngineFocusState:enter(params)
    
end

function EngineFocusState:update(dt)

    local player = self.engine.universe.player

    if love.keyboard.isDown('a') then
        player:rotate(-1)
    elseif love.keyboard.isDown('d') then
        player:rotate(1)
    else
        player:rotate(0)
    end
    if love.keyboard.isDown('w') then
        player:move(1)
    elseif love.keyboard.isDown('s') then
        player:move(-1)
    else
        player:move(0)
    end
end

function EngineFocusState:render()
    
    local universe = self.engine.universe
    
    love.graphics.push()    
    
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    for k, body in pairs(universe.bodies) do
        love.graphics.setColor(100, 100, 100)
        love.graphics.circle('fill', body.body:getX(), body.body:getY(), body.shape:getRadius())
    end
    
    for k, entity in pairs(universe.entities) do
        love.graphics.setColor(128, 163, 15) -- set the drawing color to green for the ground
        love.graphics.polygon('fill', entity.body:getWorldPoints(entity.shape:getPoints()))
        
    end
    
    love.graphics.pop()
    
    -- UI
end

