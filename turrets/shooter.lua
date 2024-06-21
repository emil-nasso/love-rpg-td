Shooter = Class {
    init = function(self, position)
        self.position = position
        self.animation = Anim8.newAnimation(Turrets.graphics.shooter.grid('1-2', 1), 0.2)
        self.direction = Turrets:directionToClosestMob(self, self.detectionRange):angleTo(Vector(1, 0))

        Timer.every(0.5, function()
            local direction = Turrets:directionToClosestMob(self, self.detectionRange)

            if (direction) then
                Projectiles:spawn(self.position.x, self.position.y, 600, direction, 0, 30)
                self.direction = direction:angleTo(Vector(1, 0))
            end
        end)
    end,
    detectionRange = 500,
    position = nil,
    direction = 0,
    animation = nil,
}

function Shooter:update(dt)
    self.animation:update(dt)
end

function Shooter:draw()
    Ui:setColor(nil)
    self.animation:draw(Turrets.graphics.shooter.sprite, self.position.x, self.position.y, self.direction, 1, 1, 16, 16)
end

return Shooter
