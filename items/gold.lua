Gold = Class {
    init = function(self, amount, pos)
        self.amount = amount
        self.pos = pos
        self.sprite = Gold.sprites[amount]
        Items:addOnGround(self)
    end,
    type = 'gold',
    autoPickup = true,
}

Gold.sprites = {}
Gold.sprites[1] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_1.png')
Gold.sprites[2] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_2.png')
Gold.sprites[3] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_3.png')
Gold.sprites[4] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_4.png')
Gold.sprites[5] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_5.png')
Gold.sprites[6] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_6.png')
Gold.sprites[7] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_7.png')
Gold.sprites[8] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_8.png')
Gold.sprites[9] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_9.png')
Gold.sprites[10] = love.graphics.newImage('sprites/StoneSoup/item/gold/gold_pile_10.png')

function Gold:pickup()
    Ui:addDebugMessage("Picking up gold")

    Items:removeFromGround(self)
    Player.gold = Player.gold + self.amount
end

return Gold
