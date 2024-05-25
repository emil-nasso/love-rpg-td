local anim8 = require 'libraries/anim8/anim8'
local vector = require 'libraries/hump/vector'

TurretManager = {
    shooters = {},
    pushers = {},
}

TurretManager.__index = TurretManager

function TurretManager:deployShooter(mousePosition)
    table.insert(self.shooters, {x=mousePosition.x, y=mousePosition.y})
end

function TurretManager:deployPusher(mousePosition)
    table.insert(self.pushers, {x=mousePosition.x, y=mousePosition.y})
end

function TurretManager:draw()
    for index, shooter in pairs(self.shooters) do
        love.graphics.setColor(255, 0, 0)
        love.graphics.circle('fill', shooter.x, shooter.y, 20)
    end

    for index, pusher in pairs(self.pushers) do
        love.graphics.setColor(0, 0, 255)
        love.graphics.circle('fill', pusher.x, pusher.y, 20)
    end
end

return TurretManager
