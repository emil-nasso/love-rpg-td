Npcs = Class {
    npcs = {}
}

function Npcs:load(gunnarPosition)
    local physics = {}
    physics.body = love.physics.newBody(World, gunnarPosition.x, gunnarPosition.y, "static")
    physics.shape = love.physics.newCircleShape(20)
    physics.fixture = love.physics.newFixture(physics.body, physics.shape)
    physics.fixture:setUserData({ type = 'npc' })
    self:add({
        pos = gunnarPosition,
        r = 20,
        name = "Gunnar",
        sprite = love.graphics.newImage('sprites/StoneSoup/monster/boggart_new.png'),
        dialogue = {
            text = "Hi! Is there anything I can do for you today?",
            options = {
                {
                    option = "I want to buy something.",
                    text = "What would you like to buy?",
                    options = {
                        { option = "Carrots - 10 gold", text = "I'm all out, sorry." },
                        { option = "Banana - 20 gold", text = "Too yellow. No can do." },
                        { option = "Candy - 30 gold", text = "Are you crazy?! It's not saturday!" },
                    }
                }
            }
        }
    })
end

function Npcs:add(item)
    table.insert(self.npcs, item)
end

function Npcs:getNpcAt(pos)
    for _, npc in pairs(self.npcs) do
        if (pos:dist(npc.pos) <= 20) then
            return npc
        end
    end
    return nil
end

function Npcs:draw()
    local mouse = Ui:mouseWorldPositionVector()
    for _, npc in pairs(self.npcs) do
        Ui:setColor(Ui.colors.white)
        love.graphics.rectangle('fill', npc.pos.x - 22, npc.pos.y - 35, 45, 14)
        love.graphics.setFont(Ui.fonts.boldSmall)
        Ui:setColor(Ui.colors.black)
        love.graphics.print(npc.name, npc.pos.x - 20, npc.pos.y - 35)

        Ui:setColor()
        love.graphics.draw(npc.sprite, npc.pos.x, npc.pos.y, nil, 1, 1, npc.sprite:getWidth() / 2,
            npc.sprite:getHeight() / 2)
        if (mouse:dist(npc.pos) <= 20) then
            Cursors:setPointerCursor()
        end
    end
end

return Npcs
