Player = {
    xp = 0,
    level = 1,
    currentLevelXp = 0,
    nextLevelXp = 100,
    speed = 250,
    stamina = 100,
    staminaDrain = 50,
    staminaRecovery = 25,
    health = 100,
    mana = 100,
    manaRecovery = 50,
    viewingAngle = 0,
    viewingDirection = Vector(0, 0),
    movingDirection = Vector(0, 0),
    physics = {
        body = nil,
        shape = nil,
        fixture = nil
    },
    shootingTimerHandle = nil,
}
Player.__index = Player

function Player:load(startPosition)
    self.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    self.grid = Anim8.newGrid(12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}
    self.animations.down = Anim8.newAnimation(self.grid('1-4', 1), 0.2)
    self.animations.left = Anim8.newAnimation(self.grid('1-4', 2), 0.2)
    self.animations.right = Anim8.newAnimation(self.grid('1-4', 3), 0.2)
    self.animations.up = Anim8.newAnimation(self.grid('1-4', 4), 0.2)

    self.anim = self.animations.left

    self.physics.body = love.physics.newBody(World, startPosition.x, startPosition.y, "dynamic")
    self.physics.shape = love.physics.newCircleShape(10)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
    self.physics.fixture:setUserData({type = 'player'})
end

function Player:vector()
    return Vector(self:getX(), self:getY())
end

function Player:getX()
    return self.physics.body:getX()
end

function Player:getY()
    return self.physics.body:getY()
end

function Player:startShooting()
    self.shootingTimerHandle = Timer.every(0.1, function()
        self:shoot()
    end)
end

function Player:stopShooting()
    if (self.shootingTimerHandle) then
        Timer.cancel(self.shootingTimerHandle)
        self.shootingTimerHandle = nil
    end
end

function Player:shoot()
    Projectiles:spawn(self:getX(), self:getY(), 600, self.viewingDirection, 0, 20)
end

function Player:shootShotgun()
    if (self.mana < 25) then
        return
    end
    self.mana = self.mana - 25

    local angles = {
        math.rad(-15),
        math.rad(-10),
        math.rad(-5),
        math.rad(0),
        math.rad(5),
        math.rad(10),
        math.rad(15),
    }

    for i, angle in ipairs(angles) do
        Projectiles:spawn(self:getX(), self:getY(), 200, self.viewingDirection, angle, 20)
    end
end

function Player:gainXp(xp)
    self.xp = self.xp + xp
    if (self.xp >= self.nextLevelXp) then
        self.level = self.level + 1
        self.currentLevelXp = self.nextLevelXp
        self.nextLevelXp = self.nextLevelXp + (self.nextLevelXp * 1.5)
        Effects:addHeroText("You gained a level!\nYou are now level " .. self.level .. ".")
    end
end

function Player:keyPressed(key)
    if (key == 'space') then
        self:detonateShock(self:getX(), self:getY())
    elseif (key == '2') then
        self:shootShotgun()
    end
end

function Player:detonateShock(x, y)
    if (self.mana >= 50) then
        self.mana = self.mana - 50
        Effects:addShockwave(x, y)
        Mobs:applyShockwave(x, y)
    end
end

function Player:update(dt)
    self.viewingDirection = Vector(Ui.mousePos.x - self:getX(), Ui.mousePos.y - self:getY())
    self.viewingDirection:normalizeInplace()
    self.viewingAngle = math.deg(self.viewingDirection:angleTo(Vector(1, 0)))

    local movingSpeed = Player.speed
    self.movingDirection = Vector(0, 0)

    if love.keyboard.isDown("d") then
        self.movingDirection.x = 1
    end

    if love.keyboard.isDown("a") then
        self.movingDirection.x = -1
    end

    if love.keyboard.isDown("s") then
        self.movingDirection.y = 1
    end

    if love.keyboard.isDown("w") then
        self.movingDirection.y = -1
    end

    self.movingDirection:normalizeInplace()
    local isMoving = self.movingDirection ~= Vector(0, 0)

    if love.keyboard.isDown("lshift") and isMoving then
        if (Player.stamina > 0) then
            movingSpeed = movingSpeed * 2
            Player.stamina = Player.stamina - Player.staminaDrain * dt
        end
    else
        if (Player.stamina < 100) then
            Player.stamina = Player.stamina + Player.staminaRecovery * dt
        end
    end

    if (self.mana < 100) then
        self.mana = self.mana + self.manaRecovery * dt
        if (self.mana > 100) then
            self.mana = 100
        end
    end

    if isMoving then
        Player.physics.body:setLinearVelocity(self.movingDirection.x * movingSpeed, self.movingDirection.y * movingSpeed)
        Player.anim:resume()
    else
        Player.anim:gotoFrame(2)
        Player.anim:pause()
        Player.physics.body:setLinearVelocity(0, 0)
    end

    Player.anim:update(dt)

    if Ui.mouseRecentlyMoved then
        if (self.viewingAngle <= 45 and self.viewingAngle >= -45) then
            Player.anim = Player.animations.right
        elseif (self.viewingAngle <= 135 and self.viewingAngle >= 45) then
            Player.anim = Player.animations.down
        elseif (self.viewingAngle <= -135 or self.viewingAngle >= 135) then
            Player.anim = Player.animations.left
        else
            Player.anim = Player.animations.up
        end
    else
        if (self.movingDirection.x == 1) then
            Player.anim = Player.animations.right
        elseif (self.movingDirection.x == -1) then
            Player.anim = Player.animations.left
        elseif (self.movingDirection.y == 1) then
            Player.anim = Player.animations.down
        elseif (self.movingDirection.y == -1) then
            Player.anim = Player.animations.up
        end
    end
end

return Player
