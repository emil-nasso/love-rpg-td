HealthOrb = Class {
    init = function(self, amount, pos)
        self.amount = amount
        self.pos = pos
        Items:addOnGround(self)
    end,
    autoPickup = true,
}

function HealthOrb:pickup()
    Ui:addDebugMessage("Picking up health orb")

    Player.health:regenerateAmount(self.amount)
    Items:removeFromGround(self)
end

function HealthOrb:draw(positionOverride)
    local pos = positionOverride or self.pos

    Ui:setColor(Ui.colors.black)
    love.graphics.circle("line", pos.x, pos.y, self.amount + 1)
    Ui:setColor(Ui.colors.red)
    love.graphics.circle("fill", pos.x, pos.y, self.amount)
end

return HealthOrb
