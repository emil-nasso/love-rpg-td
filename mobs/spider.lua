Spider = Class {
    init = function(self, pos, spawner)
        self.health = 100
        self.movementV = Vector(0, 0)
        self.animations = {}
        self.spawner = spawner

        self.animations.up = Anim8.newAnimation(Spider.grid('5-10', 1), 0.2)
        self.animations.left = Anim8.newAnimation(Spider.grid('5-10', 2), 0.2)
        self.animations.down = Anim8.newAnimation(Spider.grid('5-10', 3), 0.2)
        self.animations.right = Anim8.newAnimation(Spider.grid('5-10', 4), 0.2)
        self.animation = self.animations.up
        self.animation:gotoFrame(1)

        self.body = love.physics.newBody(World, pos.x, pos.y, "dynamic")
        self.body:setLinearDamping(2)
        self.shape = love.physics.newCircleShape(15)
        self.fixture = love.physics.newFixture(self.body, self.shape, 1)
        self.fixture:setUserData(self)

        Mobs:add(self)
    end,
    type = 'mob',
    speed = 100,
    maxHealth = 100,
}

Spider.spriteSheet = Sprites.LPC_Spiders.spider01
Spider.grid = Anim8.newGrid(64, 64, Spider.spriteSheet:getWidth(), Spider.spriteSheet:getHeight())

function Spider:hit(damage)
    -- Needed to handle multiple hit collisions being resolved at the same time
    if (self.health <= 0) then
        return
    end
    Ui:addDebugMessage("Removing mob")

    self.health = self.health - damage
    if (self.health <= 0) then
        Gold(math.random(1, 10), self:lootDropPosition())
        ManaOrb(math.random(1, 10), self:lootDropPosition())
        HealthOrb(math.random(1, 10), self:lootDropPosition())
        Player:gainXp(10)
        Mobs:remove(self)
        if (self.spawner) then
            self.spawner.spawned = self.spawner.spawned - 1
        end
    end
end

function Spider:lootDropPosition()
    return RandomPosInCircle(Vector(self.body:getX() + 15, self.body:getY() + 15), 15)
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
