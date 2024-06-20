Explosion = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        Timer.tween(1, self, { radius = 40, g = 1, alpha = 0 }, 'out-cubic', function()
            self.completed = true
        end)
    end,
    type = 'explosion',
    x = 0,
    y = 0,
    radius = 1,
    alpha = 1,
    completed = false,
    r = 1,
    g = 0,
    b = 0,
}

function Explosion:draw()
    Ui:setColor(self, self.alpha)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Explosion
