HeroText = Class {
    init = function(self, text)
        self.text = text
        Timer.tween(5, self, { opacity = 0 }, 'in-expo', function()
            self.completed = true
        end)
    end,
    text = '',
    type = 'hero',
    opacity = 1,
    completed = false,
}

function HeroText:draw()
    local screenH = love.graphics.getHeight()
    local screenW = love.graphics.getWidth()
    Ui:setBoldFont(Ui.fontSize.l)
    Ui:setColor(Ui.colors.white, self.opacity)
    love.graphics.printf(self.text, 0, screenH / 2 - 100, screenW, 'center')
end

return HeroText
