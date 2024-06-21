Gold = Class {
    init = function(self, amount, pos)
        self.amount = amount
        self.pos = pos
        Items:addOnGround(self)
    end,
    autoPickup = true,
}

function Gold:pickup()
    Ui:addDebugMessage("Picking up gold")

    Items:removeFromGround(self)
    Player.gold = Player.gold + self.amount
end

function Gold:draw(positionOverride)
    local pos = positionOverride or self.pos

    Ui:setColor(Colors.black)
    love.graphics.circle("line", pos.x, pos.y, self.amount + 1)
    Ui:setColor(Colors.yellow)
    love.graphics.circle("fill", pos.x, pos.y, self.amount)
end

return Gold
