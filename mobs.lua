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
    self.spider = {}
    self.spider.spriteSheet = love.graphics.newImage('sprites/LPC_Spiders/spider01.png')
    self.spider.grid = anim8.newGrid(64, 64, self.spider.spriteSheet:getWidth(), self.spider.spriteSheet:getHeight())

    self.spider.animations = {}
    self.spider.animations.up = anim8.newAnimation(self.spider.grid('5-10', 1), 0.2)
    self.spider.animations.left = anim8.newAnimation(self.spider.grid('5-10', 2), 0.2)
    self.spider.animations.down = anim8.newAnimation(self.spider.grid('5-10', 3), 0.2)
    self.spider.animations.right = anim8.newAnimation(self.spider.grid('5-10', 4), 0.2)
end

function Mobs:hit(mob, damage)
    Ui:addDebugMessage("Removing mob")

    mob.health = mob.health - damage
    if (mob.health <= 0) then

        mob.fixture:destroy()
        for i, value in ipairs(self.mobs) do
            if value == mob then
                table.remove(self.mobs, i)
                break
            end
        end
    end
end

function Mobs:spawnSpider(x, y)
    local mob = {type='mob', speed=100, health=100, maxHealth=100, movementV=vector(0, 0)}
    mob.body = love.physics.newBody(World, x, y, "dynamic")
    mob.body:setLinearDamping(2)
    mob.shape = love.physics.newCircleShape(15)
    mob.fixture = love.physics.newFixture(mob.body, mob.shape, 1)
    mob.fixture:setUserData(mob)

    mob.animations = {}
    mob.animations.left = self.spider.animations.left:clone()
    mob.animations.right = self.spider.animations.right:clone()
    mob.animations.up = self.spider.animations.up:clone()
    mob.animations.down = self.spider.animations.down
    mob.animation = mob.animations.left
    mob.animation:gotoFrame(1)

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

            local viewingAngle = math.deg(movementV:angleTo(vector(1, 0)))
            if (viewingAngle <= 45 and viewingAngle >= -45) then
                mob.animation = mob.animations.right
            elseif (viewingAngle <= 135 and viewingAngle >= 45) then
                mob.animation = mob.animations.down
            elseif (viewingAngle <= -135 or viewingAngle >= 135) then
                mob.animation = mob.animations.left
            else
                mob.animation = mob.animations.up
            end

            mob.animation:resume()
            mob.animation:update(dt)
        else
            mob.animation:gotoFrame(1)
            mob.animation:pause()
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
        love.graphics.setColor(1, 1, 1, 1) -- reset colors
        mob.animation:draw(self.spider.spriteSheet, mob.body:getX(), mob.body:getY(), nil, 1, nil, 32, 32)

        if (mob.health < mob.maxHealth) then
            love.graphics.setColor(Ui.colors.black.r, Ui.colors.black.g, Ui.colors.black.b, 1)
            love.graphics.rectangle("fill", mob.body:getX() - 20, mob.body:getY() - 25, 40, 6)
            love.graphics.setColor(Ui.colors.red.r, Ui.colors.red.g, Ui.colors.red.b, 1)
            love.graphics.rectangle("fill", mob.body:getX() - 19, mob.body:getY() - 24, 38 * (mob.health/mob.maxHealth), 4)
        end
    end
end

return Mobs
