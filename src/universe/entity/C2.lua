--[[
    -- C2: Command and Control --
]]

C2 = Class{}

function C2:init(entity, universe)

    self.entity = entity
    self.universe = universe
    self.engagementRange = 1E4
end

function C2:update(dt)

    -- retrieve sensor data
    local sensedEntities = self:pullSensor()

    -- current craft position
    local lx, ly = self.entity.body:getPosition()

    -- identify targets in engagement range
    local engagementTable = {}
    for k, entity in pairs(sensedEntities) do
        if entity.allegiance < 0 then
            local ex, ey = entity.body:getPosition()
            if getVectorMag(lx - ex, ly - ey) < self.engagementRange then
                table.insert(engagementTable, entity)
            end
        end
    end

    local availableWeapons = {}

    for k, addon in pairs(self.entity.addons) do
        table.insert(availableWeapons, addon)
    end


end

-- TODO: update this function to be an actual sensor 8/6/18 -AW
function C2:pullSensor()

    local sensedEntities = {}
    for k, v in pairs(self.universe.entities) do
        table.insert(sensedEntities, v)
    end
    return sensedEntities
end