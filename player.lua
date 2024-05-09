local anim8 = require 'libraries/anim8/anim8'
local vector = require 'libraries/hump/vector'

Player = {
    x = 100,
    y = 100,
    speed = 250,
    stamina = 100,
    staminaDrain = 50,
    staminaRecovery = 25,
    health = 100,
    mana = 100,
    viewingAngle = 0,
    viewingDirection = vector(0, 0),
    movingDirection = vector(0, 0),
    projectiles = {},
    physics = {
        body = nil,
        shape = nil,
        fixture = nil
    }
}
Player.__index = Player

function Player:new(o)
    local player = o or {}
    setmetatable(player, Player)
    return player
end

function Player:load()
    self.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    self.grid = anim8.newGrid(12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}
    self.animations.down = anim8.newAnimation(self.grid('1-4', 1), 0.2)
    self.animations.left = anim8.newAnimation(self.grid('1-4', 2), 0.2)
    self.animations.right = anim8.newAnimation(self.grid('1-4', 3), 0.2)
    self.animations.up = anim8.newAnimation(self.grid('1-4', 4), 0.2)

    self.anim = self.animations.left

    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.shape = love.physics.newCircleShape(10)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
    self.physics.fixture:setUserData("player")
end

function Player:shoot()
    -- TODO: Första skottet är supersnabbt, av någon anledning
    local startX = self.x + (self.viewingDirection.x * 20)
    local startY = self.y + (self.viewingDirection.y * 20)
    local projectile = love.physics.newBody(World, startX, startY, "dynamic")
    local shape = love.physics.newCircleShape(5)
    local fixture = love.physics.newFixture(projectile, shape, 10)

    projectile:applyForce(self.viewingDirection.x * 15000, self.viewingDirection.y * 15000)
    fixture:setUserData("projectile")

    table.insert(self.projectiles, projectile)
end

function Player:update(dt)
    self.x = self.physics.body:getX()
    self.y = self.physics.body:getY()

    self.viewingDirection = vector(Ui.mousePos.x - Player.x, Ui.mousePos.y - Player.y)
    self.viewingDirection:normalizeInplace()
    self.viewingAngle = math.deg(self.viewingDirection:angleTo(vector(1, 0)))

    local movingSpeed = Player.speed
    self.movingDirection = vector(0, 0)

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
    local isMoving = self.movingDirection ~= vector(0, 0)

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

    if isMoving then
        Player.physics.body:setLinearVelocity(self.movingDirection.x * movingSpeed, self.movingDirection.y * movingSpeed)
    else
        Player.anim:gotoFrame(2)
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
