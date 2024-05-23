local vector = require 'libraries/hump/vector'

Gold = {
    type='gold',
    autoPickup=true,
}

Gold.__index = Gold
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

function Gold:spawn(amount, x, y)
    local gold = {
        amount=amount,
        x=x,
        y=y,
        sprite=Gold.sprites[amount],
    }

    setmetatable(gold, Gold)

    ItemsManager:addOnGround(gold)

    return gold
end

function Gold:vector()
    return vector(self.x, self.y)
end

function Gold:pickup()
    Ui:addDebugMessage("Picking up gold")

    ItemsManager:removeFromGround(self)
    ItemsManager.goldCount = ItemsManager.goldCount + self.amount
end

return Gold
