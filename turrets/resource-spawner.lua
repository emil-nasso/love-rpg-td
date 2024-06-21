ResourceSpawner = Class {
    color = nil,
}

function ResourceSpawner:draw()
    Ui:setColor(self.color)
    love.graphics.circle("fill", self.position.x, self.position.y, 12)
    Ui:setColor(self.color, 0.1)
    love.graphics.circle("fill", self.position.x, self.position.y, self.radius)
    Ui:setColor(self.color, 0.5)
    love.graphics.circle("line", self.position.x, self.position.y, self.radius)
end

return ResourceSpawner
