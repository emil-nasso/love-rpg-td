Items = {
    goldCount = 0,
    ground = {},
    inventory = {},
}
Items.__index = Items

function Items:load()
end

function Items:update(dt)
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

function Items:removeFromGround(item)
    for i, value in ipairs(self.ground) do
        if value == item then
            table.remove(self.ground, i)
            break
        end
    end
end

function Items:lootGround(x, y, distance)
    local player = Vector(x, y)
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

function Items:addOnGround(item)
    table.insert(self.ground, item)
end

function Items:drawGroundItems()
    for index, item in pairs(self.ground) do
        Ui:setColor(nil)
        love.graphics.draw(item.sprite, item.x, item.y, nil, 1, nil, 32, 32)
    end
end

return Items
