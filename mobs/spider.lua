Spider = {
    type='mob',
    speed=100,
    maxHealth=100,
}

Spider.__index = Spider
Spider.spriteSheet = love.graphics.newImage('sprites/LPC_Spiders/spider01.png')
Spider.grid = Anim8.newGrid(64, 64, Spider.spriteSheet:getWidth(), Spider.spriteSheet:getHeight())

function Spider.spawn(x, y, spawner)
    local spider = {
        health=100,
        movementV=Vector(0, 0),
        animations={},
        spawner=spawner,
    }

    spider.animations.up = Anim8.newAnimation(Spider.grid('5-10', 1), 0.2)
    spider.animations.left = Anim8.newAnimation(Spider.grid('5-10', 2), 0.2)
    spider.animations.down = Anim8.newAnimation(Spider.grid('5-10', 3), 0.2)
    spider.animations.right = Anim8.newAnimation(Spider.grid('5-10', 4), 0.2)
    spider.animation = spider.animations.up
    spider.animation:gotoFrame(1)

    spider.body = love.physics.newBody(World, x, y, "dynamic")
    spider.body:setLinearDamping(2)
    spider.shape = love.physics.newCircleShape(15)
    spider.fixture = love.physics.newFixture(spider.body, spider.shape, 1)
    spider.fixture:setUserData(spider)

    setmetatable(spider, Spider)

    Mobs:add(spider)
    return spider
end

function Spider:hit(damage)
    -- Needed to handle multiple hit collisions being resolved at the same time
    if (self.health <= 0) then
        return
    end
    Ui:addDebugMessage("Removing mob")

    self.health = self.health - damage
    if (self.health <= 0) then
        Gold.spawn(math.random(1, 10), self.body:getX() + 16, self.body:getY() + 16)
        Player:gainXp(10)
        Mobs:remove(self)
        if (self.spawner) then
            self.spawner.spawned = self.spawner.spawned - 1
        end
    end
end

function Spider:move(dt)
    local playerV = Vector(Player.physics.body:getX(), Player.physics.body:getY())
    local mobV = Vector(self.body:getX(), self.body:getY())
    local distanceToPlayer = mobV:dist(playerV)
    local movementV = Vector(0, 0)

    if (distanceToPlayer < 200 and distanceToPlayer > 50) then
        movementV = playerV - mobV
        movementV:normalizeInplace()
        self.body:applyForce(movementV.x * self.speed, movementV.y * self.speed)

        local viewingAngle = math.deg(movementV:angleTo(Vector(1, 0)))
        if (viewingAngle <= 45 and viewingAngle >= -45) then
            self.animation = self.animations.right
        elseif (viewingAngle <= 135 and viewingAngle >= 45) then
            self.animation = self.animations.down
        elseif (viewingAngle <= -135 or viewingAngle >= 135) then
            self.animation = self.animations.left
        else
            self.animation = self.animations.up
        end

        self.animation:resume()
        self.animation:update(dt)
    else
        self.animation:gotoFrame(1)
        self.animation:pause()
    end

    self.movementV = movementV
end

return Spider
