TechOrb = Class {
    init = function(self, amount, pos)
        self.amount = amount
        self.pos = pos
        Items:addOnGround(self)
    end,
    autoPickup = true,
}

function TechOrb:pickup()
    Ui:addDebugMessage("Picking up tech orb")

    Player.tech:regenerateAmount(self.amount)
    Items:removeFromGround(self)
end

function TechOrb:draw(positionOverride)
    local pos = positionOverride or self.pos

    Ui:setColor(Colors.purple)
    love.graphics.circle("fill", pos.x, pos.y, self.amount)
    Ui:setColor(Colors.black)
    love.graphics.circle("line", pos.x, pos.y, self.amount)
end

return TechOrb
