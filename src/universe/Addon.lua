--[[
    -- Addon --
]]

Addon = Class{}

function Addon:init(entity, def)

    self.entity = entity
    self.location = def.location
    self.orientation = def.orientation
    self.def = ADDON_DEFS[def.def_key]
end

function Addon:update(dt)

end

function Addon:render(lx, ly, entityAngle, bpm)

    local totalAngle = self.orientation + entityAngle

    local ax, ay = rotateVector(self.location[1], self.location[2], totalAngle)
    local bx, by = ax * bpm + lx, ay * bpm + ly
    love.graphics.setColor(FULL_COLOR)
    if self.def.base then
    else
        love.graphics.circle('fill', bx, by, 5)
        --love.graphics.arc('fill', bx, by, 5)
    end
    if self.def.barrel then
    else

    end
end