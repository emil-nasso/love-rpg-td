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

function HeroText:draw(screenW, screenH)
    love.graphics.setFont(Ui.fonts.boldMedium)
    Ui:setColor(Ui.colors.white, self.opacity)
    love.graphics.printf(self.text, 0, screenH / 2 - 100, screenW, 'center')
end

return HeroText
