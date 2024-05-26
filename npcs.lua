Npcs = {
    npcs = {}
}
Npcs.__index = Npcs

function Npcs:load()
    local pos = Vector(200, 50)
    local physics = {}
    physics.body = love.physics.newBody(World, pos.x, pos.y, "static")
    physics.shape = love.physics.newCircleShape(20)
    physics.fixture = love.physics.newFixture(physics.body, physics.shape)
    physics.fixture:setUserData({type = 'npc'})
    self:add({
        pos = pos,
        r = 20,
        name = "Gunnar",
        dialogue = {
            text = "Hi! Is there anything I can do for you today?",
            options = {
                {
                    option = "I want to buy something.",
                    text = "What would you like to buy?",
                    options = {
                        {option="Carrots - 10 gold", text="I'm all out, sorry."},
                        {option="Banana - 20 gold", text="Too yellow. No can do."},
                        {option="Candy - 30 gold", text="Are you crazy?! It's not saturday!"},
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
    for index, npc in pairs(self.npcs) do
        if (pos:dist(npc.pos) <= 20) then
            return npc
        end
    end
    return nil
end

function Npcs:draw()
    local mouse = Ui:mouseWorldPositionVector()
    for index, npc in pairs(self.npcs) do
        Ui:setColor(Ui.colors.yellow)
        love.graphics.circle('fill', npc.pos.x, npc.pos.y, npc.r)
        if (mouse:dist(npc.pos) <= 20) then
            Cursors:setPointerCursor()
        end
    end
end

return Npcs
