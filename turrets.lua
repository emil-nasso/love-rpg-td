Turrets = Class {
    turrets = {},
    graphics = {
        shooter = {
            sprite = Sprites.turrets.shooter,
            toolbarQuad = love.graphics.newQuad(0, 0, 32, 32, Sprites.turrets.shooter),
            grid = Anim8.newGrid(32, 32, 64, 32),
        }
    }
}

function Turrets:deployShooter(mousePosition)
    table.insert(self.turrets, Shooter(mousePosition + Ui:getCameraPosition()))
end

function Turrets:deployGoldSpawner(mousePosition)
    table.insert(self.turrets, GoldSpawner(mousePosition + Ui:getCameraPosition(), 200, 1))
end

function Turrets:deployHealthSpawner(mousePosition)
    table.insert(self.turrets, HealthSpawner(mousePosition + Ui:getCameraPosition(), 200, 1))
end

function Turrets:deployManaSpawner(mousePosition)
    table.insert(self.turrets, ManaSpawner(mousePosition + Ui:getCameraPosition(), 200, 1))
end

function Turrets:deployTechSpawner(mousePosition)
    table.insert(self.turrets, TechSpawner(mousePosition + Ui:getCameraPosition(), 200, 1))
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
