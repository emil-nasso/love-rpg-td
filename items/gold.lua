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

    Ui:setColor(nil)

    local quad = love.graphics.newQuad((self.amount - 1) * 16, 0, 16, 16, Sprites.items.gold)
    love.graphics.draw(Sprites.items.gold, quad, pos.x - 8, pos.y - 8)
end

return Gold
