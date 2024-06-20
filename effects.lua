Effects = Class {
    effects = {},
}

function Effects:addExplosion(x, y)
    table.insert(self.effects, Explosion(x, y))
end

function Effects:addHeroText(text)
    table.insert(self.effects, HeroText(text))
end

function Effects:addShockwave(x, y)
    table.insert(self.effects, Shockwave(x, y))
end

function Effects:update(dt)
    Timer.update(dt)
end

function Effects:draw()
    for i, effect in ipairs(self.effects) do
        if effect.completed then
            table.remove(self.effects, i)
        else
            effect:draw()
        end
    end
end

return Effects
