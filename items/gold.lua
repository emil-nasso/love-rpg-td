Gold = Class {
    init = function(self, amount, pos)
        self.amount = amount
        self.pos = pos
        Items:addOnGround(self)
    end,
    type = 'gold',
    autoPickup = true,
}

function Gold:pickup()
    Ui:addDebugMessage("Picking up gold")

    Items:removeFromGround(self)
    Player.gold = Player.gold + self.amount
end

function Gold:draw(positionOverride)
    local pos = positionOverride or self.pos

    Ui:setColor(Ui.colors.black)
    love.graphics.circle("line", pos.x, pos.y, self.amount + 1)
    Ui:setColor(Ui.colors.yellow)
    love.graphics.circle("fill", pos.x, pos.y, self.amount)
end

return Gold
