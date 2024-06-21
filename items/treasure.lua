Treasure = Class {
    init = function(self, type, pos)
        self.type = type
        self.pos = pos
        Items:addOnGround(self)
    end,
    type = nil,
    types = {
        coal = 1,
        ruby = 5,
        diamond = 10,
    },
    autoPickup = true,
}

function Treasure:pickup()
    Items:removeFromGround(self)
    Player.treasure[self.type] = Player.treasure[self.type] + 1
end

function Treasure:draw(positionOverride)
    local pos = positionOverride or self.pos

    Ui:setColor(nil)

    local sprite = nil
    if self.type == "coal" then
        sprite = Sprites.items.coal
    elseif self.type == "ruby" then
        sprite = Sprites.items.ruby
    elseif self.type == "diamond" then
        sprite = Sprites.items.diamond
    end

    love.graphics.draw(sprite, pos.x - 8, pos.y - 8)
end

return Treasure
