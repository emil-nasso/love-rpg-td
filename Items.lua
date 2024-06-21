Items = Class {
    ground = {},
    inventory = {},
}

function Items:update(dt)
    local player = Player:vector()

    for _, item in pairs(self.ground) do
        local distanceToPlayer = item.pos:dist(player)

        if (distanceToPlayer < Player.itemPickupDistance) then
            if item.autoPickup then
                item:pickup()
            end
        elseif (distanceToPlayer < Player.itemAttractionDistance) then
            local directionToPlayer = player - item.pos
            item.pos = item.pos + directionToPlayer:normalized() * Player.itemAttractionSpeed * dt
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

    for _, item in pairs(self.ground) do
        local distanceToPlayer = item.pos:dist(player)

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
    Ui:setColor(nil)
    for _, item in pairs(self.ground) do
        item:draw()
    end
end

return Items
