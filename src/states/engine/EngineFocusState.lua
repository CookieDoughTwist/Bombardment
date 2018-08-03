--[[
    -- Engine Focus State --
]]


EngineFocusState = Class{__includes = BaseState}

function EngineFocusState:init(engine)
    
    self.engine = engine
    self.engine.state = 'focus'
    self.camX = VIRTUAL_WIDTH_2     -- meters
    self.camY = VIRTUAL_HEIGHT_2    -- meters
    self.zoom = 1                   -- meters/bit
    self.angle = 0
    self.centerPlayer = true
    self.alignPlayer = false
    self.focusIdx = 1
end

function EngineFocusState:enter(params)
    
end

function EngineFocusState:update(dt)

    --
    -- player control
    --

    -- focus craft cycling (select player craft)
    if love.keyboard.wasPressed('[') then
        -- decrement focus index
        self.focusIdx = self.focusIdx - 1
        -- wrap around to greatest index
        if self.focusIdx < 1 then
            self.focusIdx = #self.engine.universe.player
        end
    end
    if love.keyboard.wasPressed(']') then
        -- increment focus index
        self.focusIdx = self.focusIdx + 1
        -- wrap around to one
        if self.focusIdx > #self.engine.universe.player then
            self.focusIdx = 1
        end
    end

    -- currently focussed player craft
    local player = self.engine.universe.player[self.focusIdx]

    -- craft rotation
    local rotVal = 0    
    if love.keyboard.isDown('a') then
        rotVal = rotVal - 1
    end
    if love.keyboard.isDown('d') then
        rotVal = rotVal + 1
    end
    player:rotate(rotVal)
    
    -- craft thrust
    local movVal = 0
    if love.keyboard.isDown('w') then
        movVal = movVal + 1
    end
    if love.keyboard.isDown('s') then
        movVal = movVal - 1
    end
    player:move(movVal)
    
    --
    -- camera control
    --

    -- toggle camera pan lock
    if love.keyboard.wasPressed('y') then
        self.centerPlayer = not self.centerPlayer
    end

    -- check of locked to player
    if self.centerPlayer then
        self.camX, self.camY = player.body:getPosition()

    -- otherwise pan as normal
    else
        local x = 0
        local y = 0
        -- collect camera vector
        if love.keyboard.isDown('left') then
            x = - FOCUS_SCROLL_SPEED * self.zoom
        end
        if love.keyboard.isDown('right') then
            x = FOCUS_SCROLL_SPEED * self.zoom
        end
        if love.keyboard.isDown('up') then
            y = -FOCUS_SCROLL_SPEED * self.zoom
        end
        if love.keyboard.isDown('down') then
            y = FOCUS_SCROLL_SPEED * self.zoom
        end
        -- need to account for camera rotation
        x, y = rotateVector(x, y, self.angle)
        -- increment camera pan
        self.camX = self.camX + x
        self.camY = self.camY + y
    end

    -- camera zooming
    if love.wasPressed('decrement') then
        self.zoom = math.min(self.zoom * FOCUS_ZOOM_RATIO, FOCUS_ZOOM_MAX)
    end
    if love.wasPressed('increment') then
        self.zoom = math.max(self.zoom / FOCUS_ZOOM_RATIO, FOCUS_ZOOM_MIN)
    end

    -- camera rotation
    -- toggle camera alignment
    if love.keyboard.wasPressed('u') then
        self.alignPlayer = not self.alignPlayer
    end

    -- check for alignment lock
    if self.alignPlayer then
        self.angle = player.body:getAngle() - math.pi

    -- otherwise rotate as normal
    else
        if love.keyboard.isDown('pagedown') then
            self.angle = self.angle + FOCUS_ROTATION_SPEED
        end
        if love.keyboard.isDown('pageup') then
            self.angle = self.angle - FOCUS_ROTATION_SPEED
        end
    end

    -- toggle on map state
    if love.keyboard.wasPressed('m') then
        self.engine:changeState('map', {centerObject = player})
    end
end

function EngineFocusState:render()

    local universe = self.engine.universe
    local bpm = 1 / self.zoom                       -- bits per meter
    local m2Range = (RENDER_RANGE * self.zoom)^2    -- cull range sqaured in meters squared

    love.graphics.translate(VIRTUAL_WIDTH_2, VIRTUAL_HEIGHT_2)
    love.graphics.rotate(-self.angle)
    love.graphics.translate(-VIRTUAL_WIDTH_2, -VIRTUAL_HEIGHT_2)

    for k, body in pairs(universe.bodies) do
        love.graphics.setColor(100, 100, 100)
        local x, y = body.body:getPosition()
        local r = body.shape:getRadius()

        if (x-self.camX)^2 + (y-self.camY)^2 + r < m2Range then
            local lx = (x - self.camX) * bpm + VIRTUAL_WIDTH_2
            local ly = (y - self.camY) * bpm + VIRTUAL_HEIGHT_2
            local lr = r * bpm
            love.graphics.circle('fill', lx, ly, lr)
        end
    end

    for k, entity in pairs(universe.entities) do
        love.graphics.setColor(128, 163, 15)
        local x, y = entity.body:getPosition()

        if (x-self.camX)^2 + (y-self.camY)^2 < m2Range then
            local polyPoints = {entity.body:getWorldPoints(entity.shape:getPoints())}                        
            addPointTable(polyPoints, {-self.camX, -self.camY})
            multiplyTable(polyPoints, bpm)
            addPointTable(polyPoints, {VIRTUAL_WIDTH_2, VIRTUAL_HEIGHT_2})
            love.graphics.polygon('fill', polyPoints)
        end
    end
end

--[[
    original renderer here for temporary reference, love's btuiltin translate function
        cannot handle large scales and the zoom ordering exacerbates rounding errors
function EngineFocusState:render_old()
    
    local universe = self.engine.universe
    
    love.graphics.push()    
    
    local xBit = -math.floor(self.camX / self.zoom - VIRTUAL_WIDTH / 2)
    local yBit = -math.floor(self.camY / self.zoom - VIRTUAL_HEIGHT / 2)
    
    love.graphics.translate(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
    love.graphics.rotate(-self.angle)
    -- TODO: consolidate this translation 8/1/18 -AW
    love.graphics.translate(-VIRTUAL_WIDTH / 2, -VIRTUAL_HEIGHT / 2)
    love.graphics.translate(xBit, yBit)
    
    for k, body in pairs(universe.bodies) do
        love.graphics.setColor(100, 100, 100)
        local x = body.body:getX() / self.zoom
        local y = body.body:getY() / self.zoom
        local r = body.shape:getRadius() / self.zoom
        love.graphics.circle('fill', x, y, r)
    end
    
    for k, entity in pairs(universe.entities) do
        love.graphics.setColor(128, 163, 15)
        local polyPoints = {entity.body:getWorldPoints(entity.shape:getPoints())}
        multiplyTable(polyPoints, 1 / self.zoom)
        love.graphics.polygon('fill', polyPoints)
    end
    
    love.graphics.pop()
    
    -- UI
end

]]