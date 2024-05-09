Effects = {
    explosions = {},
    timer = nil,
}
Effects.__index = Effects

function Effects:new(o)
    local effects = o or {}
    setmetatable(effects, Effects)
    return effects
end

function Effects:addExplosion(x, y)
    local explosion = {
        x = x,
        y = y,
        radius = 1,
        alpha = 1,
        completed = false,
        r = 1,
        g = 0,
        b = 0,
    }
    table.insert(self.explosions, explosion)

    Timer.tween(1, explosion, {radius = 40, g = 1, alpha = 0}, 'out-cubic', function ()
        explosion.completed = true
    end)
end

function Effects:update(dt)
    Timer.update(dt)
end

function Effects:draw(offsetX, offsetY)
    for i, explosion in ipairs(self.explosions) do
        if explosion.completed then
            table.remove(self.explosions, i)
        else
            love.graphics.setColor(explosion.r, explosion.g, explosion.b, explosion.alpha)
            love.graphics.circle("fill", explosion.x + offsetX, explosion.y + offsetY, explosion.radius)
        end
    end
end

return Effects
