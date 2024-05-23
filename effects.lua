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

function Effects:addHeroText(text)
    local hero = {
        type = 'hero',
        text = text,
        opacity = 1,
    }
    table.insert(self.effects, hero)

    Timer.tween(5, hero, {opacity=0}, 'in-expo', function ()
        hero.completed = true
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
    local screenH = love.graphics.getHeight()
    for i, effect in ipairs(self.effects) do
        if effect.completed then
            table.remove(self.effects, i)
        else
            if (effect.type == 'explosion') then
                Ui:setColor(effect, effect.alpha)
                love.graphics.circle("fill", effect.x + offsetX, effect.y + offsetY, effect.radius)
            elseif (effect.type == 'shockwave') then
                Ui:setColor(Ui.colors.white)
                love.graphics.setLineWidth(5)
                love.graphics.circle("line", effect.x + offsetX, effect.y + offsetY, effect.radius, 16)
                Ui:setColor(Ui.colors.white, 0.5)
                love.graphics.circle("fill", effect.x + offsetX, effect.y + offsetY, effect.radius - 1)

                love.graphics.setLineWidth(1)
            elseif (effect.type == 'hero') then
                love.graphics.setFont(Ui.fonts.boldMedium)
                Ui:setColor(Ui.colors.white, effect.opacity)
                love.graphics.printf(effect.text, 0, screenH / 2, 800, 'center')
            end
        end
    end
end

return Effects
