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
    local player = self.engine.universe.player[self.focusIdx]
    if player then
        self.camX, self.camY = player.body:getPosition()
    end
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

    if player then

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
        -- FIXME: reenable after submission (don't want to confuse people) 8/8/18 -AW   
        --[[
        if love.keyboard.wasPressed('w') then
            player:toggleThruster()
        end]]
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

        -- toggle stabilization
        if love.keyboard.wasPressed('t') then
            player:toggleStabilization()
        end

        -- addon control
        -- TODO: reconfigure hotkeys 8/7/18 -AW
        for n = 1, 9 do
            if love.keyboard.wasPressed(tostring(n)) and player.addons[n] then
                if love.keyboard.isDown('lalt') or love.keyboard.isDown('ralt') then
                    player.addons[n]:deactivate()
                else
                    player.addons[n]:activate()
                end
            end
        end
    end

    --
    -- camera control
    --

    -- toggle camera pan lock
    if love.keyboard.wasPressed('y') then
        self.centerPlayer = not self.centerPlayer
    end

    -- check of locked to player
    if player and self.centerPlayer then
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
    local iZoom = IMAGE_MPB * bpm

    -- push potential rotation of scene
    love.graphics.push()

    love.graphics.translate(VIRTUAL_WIDTH_2, VIRTUAL_HEIGHT_2)
    love.graphics.rotate(-self.angle)
    love.graphics.translate(-VIRTUAL_WIDTH_2, -VIRTUAL_HEIGHT_2)

    -- draw background
    local bgimage = gTextures[self.engine.background]
    local bgWidth_2, bgHeigh_2 = getImageHalfDimensions(self.engine.background)
    local iZoom_damp = BACKGROUND_DAMPING^(math.log(iZoom)/math.log(2))
    local bgZoom = BACKGROUND_ZOOM * iZoom_damp
    love.graphics.setColor(FULL_COLOR)
    love.graphics.draw(bgimage, VIRTUAL_WIDTH_2, VIRTUAL_HEIGHT_2, self.engine.backgroundOrientation, bgZoom, bgZoom, bgWidth_2, bgHeigh_2)
    -- darken background for clarity
    love.graphics.setColor(0, 0, 0, 150)
    love.graphics.rectangle('fill', -VIRTUAL_WIDTH_2, -VIRTUAL_HEIGHT_2, 2 * VIRTUAL_WIDTH, 2 * VIRTUAL_HEIGHT)

    -- render bodies
    for k, body in pairs(universe.bodies) do
        
        local x, y = body.body:getPosition()
        local r = body.shape:getRadius()

        -- only render if the body will appear on the screen
        -- TODO: check this formula 8/8/18 -AW
        if (x - self.camX)^2 + (y - self.camY)^2 < m2Range + r^2 then
            body:render(self.camX, self.camY, bpm, self.showHitbox)
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

    -- revert scene rotation as UI never tilts
    love.graphics.pop()

    -- render UI
    local fEntity = self.engine.universe.player[self.focusIdx]
    if fEntity then

        -- draw HP
        love.graphics.setColor(SKY_BLUE)
        love.graphics.rectangle('fill', 10, 10, 500, 80, 15, 15)
        local hpRatio = fEntity.hp / fEntity.hpMax
        if hpRatio > 0.5 then
            local cRatio = (hpRatio - 0.5) / 0.5
            love.graphics.setColor(255 - 255 * cRatio, 255, 0)
        elseif hpRatio > 0 then
            local cRatio = hpRatio / 0.5
            love.graphics.setColor(255, 255 * cRatio, 0)        
        else
            -- prevent overkill damage from being displayed
            hpRatio = 0
        end
        love.graphics.rectangle('fill', 20, 55, 470 * hpRatio, 20)
        love.graphics.setFont(gFonts['casanovascotia32'])
        love.graphics.setColor(FULL_COLOR)
        love.graphics.printf('ARMOR', 20, 10, VIRTUAL_WIDTH, 'left')        
        local ovx, ovy = fEntity:getOrbitalVelocity()
        local orbVel = getVectorMag(ovx, ovy)
        love.graphics.setFont(gFonts['casanovascotia32'])
        love.graphics.setColor(FULL_COLOR)
        love.graphics.printf(string.format('Orbital Velocity: %.2f m/s', orbVel), 10, 100, VIRTUAL_WIDTH, 'left')

        -- draw throttle bar
        

        -- draw key vectors
        -- TODO: modularize this entire section! 8/8/18 -AW
        local dialR = 100
        local outerR = 1.5 * dialR
        local labelR = 1.25 * dialR

        love.graphics.setFont(gFonts['cmunbi32'])

        local cx, cy = VIRTUAL_WIDTH_2, 5 * VIRTUAL_HEIGHT / 6
        love.graphics.setColor(SKY_BLUE_2)
        love.graphics.setLineWidth(10)
        -- draw the dial
        love.graphics.circle('line', cx, cy, dialR)
        love.graphics.circle('fill', cx, cy, outerR)        

        -- gravity vector
        local gx, gy = fEntity.lgx, fEntity.lgy
        -- thrust vector
        local tx, ty = fEntity.thrustX, fEntity.thrustY
        -- acceleration unit vector
        local ax, ay = unitizeVector(gx + tx, gy + ty)
        ax, ay = rotateVector(ax, ay, -self.angle)
        love.graphics.setColor(CRIMSON)
        love.graphics.line(cx, cy, cx + ax * dialR, cy + ay * dialR)
        local xx, yy = cx + ax * labelR, cy + ay * labelR
        love.graphics.printf('a', xx - VIRTUAL_WIDTH_2, yy - 24, VIRTUAL_WIDTH, 'center')

        -- bearing vector
        love.graphics.setLineWidth(5)
        local bearingAngle = fEntity.body:getAngle()
        local ux, uy = rotateVector(0, -1, bearingAngle)
        ux, uy = rotateVector(ux, uy, -self.angle)
        love.graphics.setColor(DARK_ORANGE)
        love.graphics.line(cx, cy, cx + ux * dialR, cy + uy * dialR)
        local xx, yy = cx + ux * labelR, cy + uy * labelR
        love.graphics.printf('θ', xx - VIRTUAL_WIDTH_2, yy - 24, VIRTUAL_WIDTH, 'center')
        -- velocity vector
        local uvx, uvy = unitizeVector(ovx, ovy)    -- from orbital velocity calculation
        uvx, uvy = rotateVector(uvx, uvy, -self.angle)
        love.graphics.setColor(ROYAL_PURPLE)
        love.graphics.line(cx, cy, cx + uvx * dialR, cy + uvy * dialR)
        local xx, yy = cx + uvx * labelR, cy + uvy * labelR
        love.graphics.printf('v', xx - VIRTUAL_WIDTH_2, yy - 24, VIRTUAL_WIDTH, 'center')

        -- draw dial cap
        love.graphics.setColor(CRIMSON)
        love.graphics.circle('fill', cx, cy, 10)
    end

    if universe.victory then
        love.graphics.setFont(gFonts['casanovascotia64'])
        love.graphics.setColor(FULL_COLOR)
        love.graphics.printf('VICTORY', 0, VIRTUAL_HEIGHT / 8, VIRTUAL_WIDTH, 'center')
    elseif universe.defeat then
        love.graphics.setFont(gFonts['casanovascotia64'])
        love.graphics.setColor(FULL_COLOR)
        love.graphics.printf('DEFEAT', 0, VIRTUAL_HEIGHT / 8, VIRTUAL_WIDTH, 'center')
    end

    -- show pause
    if self.engine.paused then
        love.graphics.setFont(gFonts['casanovascotia64'])
        love.graphics.setColor(FULL_COLOR)
        love.graphics.printf('GAME PAUSED', 0, 7 * VIRTUAL_HEIGHT / 8, VIRTUAL_WIDTH, 'center')
    end
end