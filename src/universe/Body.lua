--[[
    -- Celestial Body --
]]

Body = Class{}

function Body:init(world, x, y, def)
    
    local radius = def.radius
    local mass = def.mass
    local resource = def.resource
    
    self.body = love.physics.newBody(world, x, y, 'kinematic')
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    
    self.resource = resource
    self.orientation = math.random() * TWO_PI

    -- mass stored external to body (Box2D zeros out mass on kinematic objects)
    self.mass = mass
end

function Body:setState(state)
    --self.body:setLinearVelocity(state.dx, state.dy)
    --self.body:setAngularVelocity(state.dr)
    self.fixture:setUserData('body')
    self.body:setUserData(self)
end

function Body:exertGravity(entity)
    local bx, by = self.body:getPosition()
    local ex, ey = entity.body:getPosition()
    local ebx, eby = bx - ex, by - ey
    -- TODO: clean-up some of the math to avoid repeat computations 8/1/18 -AW
    local r2 = ebx^2 + eby^2
    local g = G * self.mass * entity.body:getMass() / r2    
    local ux, uy = unitizeVector(ebx, eby)
    entity:exertGravity(g, ux, uy, self)    
end

function Body:update(dt)
    
end

function Body:render(camX, camY, bpm, showHitbox)
    local x, y = self.body:getPosition()
    local r = self.shape:getRadius()
    local lx = (x - camX) * bpm + VIRTUAL_WIDTH_2
    local ly = (y - camY) * bpm + VIRTUAL_HEIGHT_2
    local lr = r * bpm    
    if self.resource then
        local cimage = gTextures[self.resource]
        local iWidth_2, iHeight_2 = getImageHalfDimensions(self.resource)
        local iZoom = lr / iWidth_2
        love.graphics.setColor(FULL_COLOR)
        love.graphics.draw(cimage, lx, ly, self.orientation, iZoom, iZoom, iWidth_2, iHeight_2)
    else
        love.graphics.setColor(100, 100, 100)
        love.graphics.circle('fill', lx, ly, lr)
    end

    if showHitbox then
        love.graphics.setColor(100, 100, 100, 100)
        love.graphics.circle('fill', lx, ly, lr)
    end
end