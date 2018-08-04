--[[
    -- Engine Map State --
]]


EngineMapState = Class{__includes = BaseState}

function EngineMapState:init(engine)
    
    self.engine = engine
    self.engine.state = 'map'
    self.camX = 0                   -- meters
    self.camY = 0                   -- meters
    self.zoom = MAP_ZOOM_MIN        -- meters/bit
    self.angle = 0
    self.centerObject = nil
end

function EngineMapState:enter(params)
    self.centerObject = params.centerObject
end

function EngineMapState:update(dt)
    --
    -- camera control
    --

    -- camera zooming
    if love.wasPressed('decrement') then
        self.zoom = math.min(self.zoom * MAP_ZOOM_RATIO, MAP_ZOOM_MAX)
    end
    if love.wasPressed('increment') then
        self.zoom = math.max(self.zoom / MAP_ZOOM_RATIO, MAP_ZOOM_MIN)
    end

    -- camera position update
    if self.centerObject then
        self.camX, self.camY = self.centerObject.body:getPosition()
    end

    -- toggle off map state
    if love.keyboard.wasPressed('m') then
        self.engine:changeState('focus', {})
    end
end

function EngineMapState:render()

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
            love.graphics.circle('fill', lx, ly, r)
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