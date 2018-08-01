--[[
    -- Engine Focus State --
]]


EngineFocusState = Class{__includes = BaseState}

function EngineFocusState:init(engine)
    
    self.engine = engine
    self.engine.state = 'focus'
    self.camX = -100
    self.camY = 0
    self.zoom = 1       -- meters/bit
end

function EngineFocusState:enter(params)
    
end

function EngineFocusState:update(dt)

    -- player control
    local player = self.engine.universe.player
    local rotVal = 0    
    if love.keyboard.isDown('a') then
        rotVal = rotVal - 1
    end
    if love.keyboard.isDown('d') then
        rotVal = rotVal + 1
    end
    player:rotate(rotVal)
    
    local movVal = 0
    if love.keyboard.isDown('w') then
        movVal = movVal + 1
    end
    if love.keyboard.isDown('s') then
        movVal = movVal - 1
    end
    player:move(movVal)
    
    -- camera panning
    if love.keyboard.isDown('left') then
        self.camX = self.camX - SCROLL_SPEED
    end
    if love.keyboard.isDown('right') then
        self.camX = self.camX + SCROLL_SPEED
    end
    if love.keyboard.isDown('up') then
        self.camY = self.camY - SCROLL_SPEED
    end
    if love.keyboard.isDown('down') then
        self.camY = self.camY + SCROLL_SPEED
    end

    -- camera zooming
    if love.keyboard.wasPressed('=') then
        self.zoom = math.min(ZOOM_RATIO * self.zoom, ZOOM_MAX)
    end
    if love.keyboard.wasPressed('-') then
        self.zoom = math.max(ZOOM_RATIO / self.zoom, ZOOM_MIN)
    end
end

function EngineFocusState:render()
    
    local universe = self.engine.universe
    
    love.graphics.push()    
    
    love.graphics.translate(-math.floor(self.camX / self.zoom), -math.floor(self.camY / self.zoom))
    
    for k, body in pairs(universe.bodies) do
        love.graphics.setColor(100, 100, 100)
        local x = body.body:getX()
        local y = body.body:getY()
        local r = body.shape:getRadius()
        love.graphics.circle('fill', x, y, r)
    end
    
    for k, entity in pairs(universe.entities) do
        love.graphics.setColor(128, 163, 15) -- set the drawing color to green for the ground
        local polyPoints = {entity.body:getWorldPoints(entity.shape:getPoints())}
        for n = 1, #polyPoints do
            polyPoints[n] = polyPoints[n] / self.zoom
        end
        love.graphics.polygon('fill', polyPoints)        
    end
    
    love.graphics.pop()
    
    -- UI
end

