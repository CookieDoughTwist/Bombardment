--[[
    -- Engine Focus State --
]]


EngineFocusState = Class{__includes = BaseState}

function EngineFocusState:init(engine)
    
    self.engine = engine
    self.engine.state = 'focus'
    self.camX = VIRTUAL_WIDTH / 2   -- meters
    self.camY = VIRTUAL_HEIGHT / 2  -- meters
    self.zoom = 1                   -- meters/bit
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
        self.camX = self.camX - SCROLL_SPEED * self.zoom
    end
    if love.keyboard.isDown('right') then
        self.camX = self.camX + SCROLL_SPEED * self.zoom
    end
    if love.keyboard.isDown('up') then
        self.camY = self.camY - SCROLL_SPEED * self.zoom
    end
    if love.keyboard.isDown('down') then
        self.camY = self.camY + SCROLL_SPEED * self.zoom
    end

    -- camera zooming
    if love.wasPressed('decrement') then
        self.zoom = math.min(self.zoom * ZOOM_RATIO, ZOOM_MAX)
    end
    if love.wasPressed('increment') then
        self.zoom = math.max(self.zoom / ZOOM_RATIO, ZOOM_MIN)
    end
end

function EngineFocusState:render()
    
    local universe = self.engine.universe
    
    love.graphics.push()    
    
    local xBit = -math.floor(self.camX / self.zoom - VIRTUAL_WIDTH / 2)
    local yBit = -math.floor(self.camY / self.zoom - VIRTUAL_HEIGHT / 2)

    love.graphics.translate(xBit, yBit)
    
    for k, body in pairs(universe.bodies) do
        love.graphics.setColor(100, 100, 100)
        local x = body.body:getX() / self.zoom
        local y = body.body:getY() / self.zoom
        local r = body.shape:getRadius() / self.zoom
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

