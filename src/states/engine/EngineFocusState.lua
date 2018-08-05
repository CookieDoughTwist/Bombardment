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
    self.showHitbox = false
end

function EngineFocusState:enter(params)
    self.focusIdx = params.focusIdx or 1
    -- initialize camera coodinates to the first frame from hopping
    -- TODO: formalize initialization 8/4/18 -AW
    self.camX, self.camY = self.engine.universe.player[self.focusIdx].body:getPosition()
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
    if love.keyboard.isDown('q') then
        rotVal = rotVal - 1
    end
    if love.keyboard.isDown('e') then
        rotVal = rotVal + 1
    end
    player:rotate(rotVal)
    
    -- craft thrust    
    if love.keyboard.wasPressed('w') then
        player:toggleThruster()
    end
    if love.keyboard.isDown('lshift') then
        player:throttleUp()
    end
    if love.keyboard.isDown('lctrl') then
        player:throttleDown()
    end
    if love.keyboard.wasPressed('z') then
        player:throttleMax()
    end
    if love.keyboard.wasPressed('x') then
        player:throttleMin()
    end


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

    -- toggle hitboxes
    if love.keyboard.wasPressed('h') then
        self.showHitbox = not self.showHitbox
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

    -- render bodies
    for k, body in pairs(universe.bodies) do
        
        local x, y = body.body:getPosition()
        local r = body.shape:getRadius()

        -- only render if the body will appear on the screen
        if (x - self.camX)^2 + (y - self.camY)^2 + r < m2Range then
            body:render(self.camX, self.camY, bpm)
        end
    end

    -- render entities
    for k, entity in pairs(universe.entities) do

        local x, y = entity.body:getPosition()

        -- only render if the entity will appear on the screen
        if (x - self.camX)^2 + (y - self.camY)^2 < m2Range then
            entity:render(self.camX, self.camY, bpm, self.showHitbox)
        end
    end

    -- render UI
    local focusEntity = self.engine.universe.player[self.focusIdx]
    --print_r(focuseEntity)
    local orbVel = focusEntity:getOrbitalVelocity()
    love.graphics.setColor(FULL_COLOR)
    love.graphics.setFont(gFonts['casanovascotia32'])
    love.graphics.printf(string.format('%.2f m/s', orbVel), 0, 0, VIRTUAL_WIDTH, 'left')
end