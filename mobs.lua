local anim8 = require 'libraries/anim8/anim8'
local vector = require 'libraries/hump/vector'

Mobs = {
    mobs= {},
    currentId = 1,
}
Mobs.__index = Mobs

function Mobs:new(o)
    local mobs = o or {}
    setmetatable(mobs, Mobs)
    return mobs
end

function Mobs:load()
end

function Mobs:remove(mob)
    Ui:addDebugMessage("Removing mob")
    mob.fixture:destroy()
    for i, value in ipairs(self.mobs) do
        if value == mob then
            table.remove(self.mobs, i)
            break
        end
    end
end

function Mobs:spawn(x, y)
    local mob = {type='mob', speed=100, movementV=vector(0, 0)}
    mob.body = love.physics.newBody(World, x, y, "dynamic")
    mob.body:setLinearDamping(2)
    mob.shape = love.physics.newCircleShape(10)
    mob.fixture = love.physics.newFixture(mob.body, mob.shape, 1)
    mob.fixture:setUserData(mob)

    table.insert(self.mobs, mob)
end

function Mobs:move(dt)
    for index, mob in pairs(self.mobs) do
        local playerV = vector(Player.physics.body:getX(), Player.physics.body:getY())
        local mobV = vector(mob.body:getX(), mob.body:getY())
        local distanceToPlayer = mobV:dist(playerV)
        local movementV = vector(0, 0)

        if (distanceToPlayer < 200 and distanceToPlayer > 50) then
            movementV = playerV - mobV
            movementV:normalizeInplace()
            mob.body:applyForce(movementV.x * mob.speed, movementV.y * mob.speed)
        end

        mob.movementV = movementV
    end
end

function Mobs:applyShockwave(x, y)
    local originV = vector(x, y)
    for index, mob in pairs(self.mobs) do
        local mobV = vector(mob.body:getX(), mob.body:getY())
        local distanceToOrigin = mobV:dist(originV)

        if (distanceToOrigin < 200) then
            local forceV = -1 * (originV - mobV)
            forceV:normalizeInplace()

            local multiplier = ((200 - distanceToOrigin) / 200) * 100
            mob.body:applyLinearImpulse(forceV.x * multiplier, forceV.y * multiplier)
        end
    end
end

function Mobs:draw()
    for index, mob in pairs(self.mobs) do
        love.graphics.setColor(Ui.colors.blue.r, Ui.colors.blue.g, Ui.colors.blue.b, 1)
        love.graphics.circle("fill", mob.body:getX(), mob.body:getY(), 5)
    end
end

return Mobs
