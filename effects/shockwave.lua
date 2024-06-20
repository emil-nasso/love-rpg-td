Shockwave = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        Timer.tween(0.5, self, { radius = 100 }, 'linear', function()
            self.completed = true
        end)
    end,
    type = 'shockwave',
    x = 0,
    y = 0,
    radius = 1,
    completed = false
}

function Shockwave:draw()
    Ui:setColor(Ui.colors.white)
    love.graphics.setLineWidth(5)
    love.graphics.circle("line", self.x, self.y, self.radius, 16)
    Ui:setColor(Ui.colors.white, 0.5)
    love.graphics.circle("fill", self.x, self.y, self.radius - 1)

    love.graphics.setLineWidth(1)
end

return Shockwave
