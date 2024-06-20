Turrets = Class {
    turrets = {},
    graphics = {
        shooter = {
            sprite = love.graphics.newImage('sprites/shooter-turret.png'),
            toolbarQuad = love.graphics.newQuad(0, 0, 32, 32, love.graphics.newImage('sprites/shooter-turret.png')),
            grid = Anim8.newGrid(32, 32, 64, 32),
        }
    }
}

function Turrets:deployShooter(mousePosition)
    table.insert(self.turrets, Shooter(mousePosition + Ui:getCameraPosition()))
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
    for _, turret in pairs(self.turrets) do
        turret:update(dt)
    end
end

function Turrets:draw()
    Ui:setColor(nil)
    for _, turret in pairs(self.turrets) do
        turret:draw()
    end
end

return Turrets
