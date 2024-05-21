Effects = {
    effects = {},
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
        type = 'explosion',
        x = x,
        y = y,
        radius = 1,
        alpha = 1,
        completed = false,
        r = 1,
        g = 0,
        b = 0,
    }
    table.insert(self.effects, explosion)

    Timer.tween(1, explosion, {radius = 40, g = 1, alpha = 0}, 'out-cubic', function ()
        explosion.completed = true
    end)
end

function Effects:addShockwave(x, y)
    local shockwave = {
        type = 'shockwave',
        x = x,
        y = y,
        radius = 1,
        completed = false
    }
    table.insert(self.effects, shockwave)

    Timer.tween(0.5, shockwave, {radius = 100}, 'linear', function ()
        shockwave.completed = true
    end)
end

function Effects:update(dt)
    Timer.update(dt)
end

function Effects:draw(offsetX, offsetY)
    for i, effect in ipairs(self.effects) do
        if effect.completed then
            table.remove(self.effects, i)
        else
            if (effect.type == 'explosion') then
                love.graphics.setColor(effect.r, effect.g, effect.b, effect.alpha)
                love.graphics.circle("fill", effect.x + offsetX, effect.y + offsetY, effect.radius)
            elseif (effect.type == 'shockwave') then
                love.graphics.setColor(Ui.colors.white.r, Ui.colors.white.g, Ui.colors.white.b, 1)
                love.graphics.setLineWidth(5)
                love.graphics.circle("line", effect.x + offsetX, effect.y + offsetY, effect.radius, 16)
                love.graphics.setColor(Ui.colors.white.r, Ui.colors.white.g, Ui.colors.white.b, 0.5)
                love.graphics.circle("fill", effect.x + offsetX, effect.y + offsetY, effect.radius - 1)

                love.graphics.setLineWidth(1)
            end
        end
    end
end

return Effects
