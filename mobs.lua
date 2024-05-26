Mobs = {
    mobs = {},
}
Mobs.__index = Mobs

function Mobs:load()
end

function Mobs:remove(mob)
    mob.fixture:destroy()
    for i, value in ipairs(self.mobs) do
        if value == mob then
            table.remove(self.mobs, i)
            break
        end
    end
end

function Mobs:add(mob)
    table.insert(self.mobs, mob)
end

function Mobs:move(dt)
    for _, mob in pairs(self.mobs) do
        mob:move(dt)
    end
end

function Mobs:ClosestTo(x, y)
    local closestMob = nil
    local closestDistance = 9999999
    for _, mob in pairs(self.mobs) do
        local mobV = Vector(mob.body:getX(), mob.body:getY())
        local distance = mobV:dist(Vector(x, y))
        if (distance < closestDistance) then
            closestDistance = distance
            closestMob = mob
        end
    end

    return closestMob
end

function Mobs:applyShockwave(x, y)
    local originV = Vector(x, y)
    for index, mob in pairs(self.mobs) do
        local mobV = Vector(mob.body:getX(), mob.body:getY())
        local distanceToOrigin = mobV:dist(originV)

        if (distanceToOrigin < 200) then
            local forceV = -1 * (originV - mobV)
            forceV:normalizeInplace()

            local multiplier = ((200 - distanceToOrigin) / 200) * 500
            mob.body:applyLinearImpulse(forceV.x * multiplier, forceV.y * multiplier)
        end
    end
end

function Mobs:draw()
    for index, mob in pairs(self.mobs) do
        Ui:setColor(nil)
        mob.animation:draw(mob.spriteSheet, mob.body:getX(), mob.body:getY(), nil, 1, nil, 32, 32)

        if (mob.health < mob.maxHealth) then
            Ui:setColor(Ui.colors.black)
            love.graphics.rectangle("fill", mob.body:getX() - 20, mob.body:getY() - 25, 40, 6)
            Ui:setColor(Ui.colors.red)
            love.graphics.rectangle("fill", mob.body:getX() - 19, mob.body:getY() - 24, 38 * (mob.health/mob.maxHealth), 4)
        end
    end
end

return Mobs
