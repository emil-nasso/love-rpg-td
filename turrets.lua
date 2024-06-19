Turrets = {
    shooters = {},
    pushers = {},
    graphics = {
        shooter = {
            sprite = love.graphics.newImage('sprites/shooter-turret.png'),
            toolbarQuad = love.graphics.newQuad(0, 0, 32, 32, love.graphics.newImage('sprites/shooter-turret.png')),
            grid = Anim8.newGrid(32, 32, 64, 32),
        }
    }
}

Turrets.__index = Turrets

function Turrets:deployShooter(mousePosition)
    local turret = {
        position = mousePosition + Ui:getCameraPosition(),
        direction = 0,
        animation = Anim8.newAnimation(self.graphics.shooter.grid('1-2', 1), 0.2),
    }

    turret.direction = self:directionToClosestMob(turret):angleTo(Vector(1, 0))

    Timer.every(0.5, function()
        local direction = self:directionToClosestMob(turret)

        Projectiles:spawn(turret.position.x, turret.position.y, 600, direction, 0, 30)
        turret.direction = direction:angleTo(Vector(1, 0))
    end)

    table.insert(self.shooters, turret)
end

function Turrets:directionToClosestMob(turret)
    local mob = Mobs:ClosestTo(turret.position.x, turret.position.y)

    if (mob == nil) then
        return
    end

    local direction = Vector(mob.body:getX(), mob.body:getY()) - turret.position
    direction:normalizeInplace()
    return direction
end

function Turrets:update(dt)
    for index, shooter in pairs(self.shooters) do
        shooter.animation:update(dt)
    end
end

function Turrets:draw()
    Ui:setColor(nil)
    for index, shooter in pairs(self.shooters) do
        shooter.animation:draw(self.graphics.shooter.sprite, shooter.position.x, shooter.position.y, shooter.direction, 1, 1, 16, 16)
        --love.graphics.draw(shooter.animation, shooter.position.x, shooter.position.y, shooter.direction, 1, 1, 16, 16)
    end
end

return Turrets
