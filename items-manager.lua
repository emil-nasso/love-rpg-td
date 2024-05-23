local vector = require 'libraries/hump/vector'

ItemsManager = {
    goldCount = 0,
    ground = {},
    inventory = {},
}
ItemsManager.__index = ItemsManager

function ItemsManager:new(o)
    local itemsManager = o or {}
    setmetatable(itemsManager, ItemsManager)
    return itemsManager
end

function ItemsManager:load()
end

function ItemsManager:update(dt)
    local player = Player:vector()

    for index, item in pairs(self.ground) do
        local itemV = item:vector()
        local distanceToPlayer = itemV:dist(player)

        if (distanceToPlayer < 50) then
            if item.autoPickup then
                item:pickup()
            end
        end
    end
end

function ItemsManager:removeFromGround(item)
    for i, value in ipairs(self.ground) do
        if value == item then
            table.remove(self.ground, i)
            break
        end
    end
end

function ItemsManager:lootGround(x, y, distance)
    local player = vector(x, y)
    local looted = {}

    for index, item in pairs(self.ground) do
        local itemV = item:vector()
        local distanceToPlayer = itemV:dist(player)

        if (distanceToPlayer < distance) then
            table.insert(looted, item)
        end
    end
    return looted
end

function ItemsManager:addOnGround(item)
    table.insert(self.ground, item)
end

function ItemsManager:drawGroundItems()
    for index, item in pairs(self.ground) do
        Ui:setColor(nil)
        love.graphics.draw(item.sprite, item.x, item.y, nil, 1, nil, 32, 32)
    end
end

return ItemsManager
