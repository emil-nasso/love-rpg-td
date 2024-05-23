local anim8 = require 'libraries/anim8/anim8'
local vector = require 'libraries/hump/vector'

MobsManager = {
    mobs = {},
}
MobsManager.__index = MobsManager

function MobsManager:new(o)
    local mobs = o or {}
    setmetatable(mobs, MobsManager)
    return mobs
end

function MobsManager:load()
end

function MobsManager:remove(mob)
    mob.fixture:destroy()
    for i, value in ipairs(self.mobs) do
        if value == mob then
            table.remove(self.mobs, i)
            break
        end
    end
end

function MobsManager:add(mob)
    table.insert(self.mobs, mob)
end

function MobsManager:move(dt)
    for index, mob in pairs(self.mobs) do
        mob:move(dt)
    end
end

function MobsManager:applyShockwave(x, y)
    local originV = vector(x, y)
    for index, mob in pairs(self.mobs) do
        local mobV = vector(mob.body:getX(), mob.body:getY())
        local distanceToOrigin = mobV:dist(originV)

        if (distanceToOrigin < 200) then
            local forceV = -1 * (originV - mobV)
            forceV:normalizeInplace()

            local multiplier = ((200 - distanceToOrigin) / 200) * 500
            mob.body:applyLinearImpulse(forceV.x * multiplier, forceV.y * multiplier)
        end
    end
end

function MobsManager:draw()
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

return MobsManager
