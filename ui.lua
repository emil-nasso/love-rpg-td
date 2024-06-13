Ui = {
    colors = {
        yellow = { r = 1, g = 1, b = 0 },
        red = { r = 1, g = 0, b = 0 },
        black = { r = 0, g = 0, b = 0 },
        white = { r = 1, g = 1, b = 1 },
        blue = { r = 0, g = 0, b = 1 },
        green = { r = 0, g = 1, b = 0 },
        lightGray = { r = 0.7, g = 0.7, b = 0.7 },
        gray = { r = 0.5, g = 0.5, b = 0.5 },
        darkGray = { r = 0.3, g = 0.3, b = 0.3 },
    },
    fonts = {
        regularMedium = love.graphics.newFont('fonts/bitstream_vera_sans/Vera.ttf', 16),
        boldSmall = love.graphics.newFont('fonts/bitstream_vera_sans/VeraBd.ttf', 10),
        boldMedium = love.graphics.newFont('fonts/bitstream_vera_sans/VeraBd.ttf', 16),
        boldLarge = love.graphics.newFont('fonts/bitstream_vera_sans/VeraBd.ttf', 24),
    },
    sprites = {
        sprint = love.graphics.newImage('sprites/StoneSoup/gui/spells/air/swiftness_new.png'),
        shotgun = love.graphics.newImage('sprites/StoneSoup/gui/spells/earth/sandblast_new.png'),
        shockwave = love.graphics.newImage('sprites/StoneSoup/gui/spells/translocation/dispersal_new.png'),
        heal = love.graphics.newImage('sprites/StoneSoup/gui/spells/necromancy/regeneration_new.png'),
    },
    debugMessages = {},
    showDebug = true,
}
Ui.__index = Ui

function Ui:new(o)
    local ui = o or {}
    setmetatable(ui, Ui)
    return ui
end

function Ui:mousePositionVector()
    return Vector(love.mouse.getPosition())
end

function Ui:mouseWorldPositionVector()
    return self:mousePositionVector() + self:getCameraPosition()
end

function Ui:setColor(color, alpha)
    local alpha = alpha or 1
    local color = color or { r = 1, g = 1, b = 1}

    love.graphics.setColor(color.r, color.g, color.b, alpha)
end

function Ui:load()
    love.graphics.setFont(self.fonts.regularMedium)
    self:mouseMoved()
end

function Ui:update(dt)
    if self.mouseMoveCountdown > 0 then
        self.mouseMoveCountdown = self.mouseMoveCountdown - dt
    elseif self.mouseRecentlyMoved then
        self.mouseRecentlyMoved = false
    end
end

function Ui:keyPressed(key)
    if key == "f" then
        love.window.setMode(
            800,
            600,
            { resizable = false, fullscreen = not love.window.getFullscreen(), fullscreentype = "exclusive" }
        )
    end

    if key == "h" then
        self.showDebug = not self.showDebug
    end

    if key == "escape" or key == "q" then
        love.event.quit()
    end
end

function Ui:draw(offsetX, offsetY)
    if (self.showDebug) then
        self:drawDebug(offsetX, offsetY)
        self:drawMobsDebug(offsetX, offsetY)
        self:drawPhysics(offsetX, offsetY)
    end

    local windowH = love.graphics.getHeight()

    love.graphics.setFont(self.fonts.boldMedium)
    Ui:setColor(Ui.colors.black)
    love.graphics.print("Gold: " .. Items.goldCount, 10, windowH - 150)
    love.graphics.print("Level: " .. Player.level, 10, windowH - 125)

    local xpProgress = ((Player.xp - Player.currentLevelXp) / (Player.nextLevelXp - Player.currentLevelXp)) * 100
    self:drawPlayerBar(10, windowH - 100, xpProgress, "XP: " .. Player.xp .. "/" .. Player.nextLevelXp, Ui.colors.white)
    self:drawPlayerBar(10, windowH - 75, Player.health, "Health", Ui.colors.red)
    self:drawPlayerBar(10, windowH - 50, Player.mana, "Mana", Ui.colors.blue)
    self:drawPlayerBar(10, windowH - 25, Player.stamina, "Stamina", Ui.colors.yellow)

    Ui:setColor(nil)

    love.graphics.setFont(self.fonts.boldSmall)
    love.graphics.draw(self.sprites.sprint, 250, windowH - 50, 0, 1.2)
    love.graphics.printf("shift", 250, windowH - 15, 32 * 1.2, 'center')
    if (OpenDialog == nil and love.keyboard.isDown("lshift")) then
        Ui:setColor(Ui.colors.yellow)
        love.graphics.rectangle("line", 250, windowH - 50, 32 * 1.2, 32 * 1.2)
        Ui:setColor(nil)
    end

    love.graphics.draw(self.sprites.shockwave, 300, windowH - 50, 0, 1.2)
    love.graphics.printf("space", 300, windowH - 15, 32 * 1.2, 'center')
    if (OpenDialog == nil and love.keyboard.isDown("space")) then
        Ui:setColor(Ui.colors.yellow)
        love.graphics.rectangle("line", 300, windowH - 50, 32 * 1.2, 32 * 1.2)
        Ui:setColor(nil)
    end

    love.graphics.draw(self.sprites.shotgun, 350, windowH - 50, 0, 1.2)
    love.graphics.printf("2", 350, windowH - 15, 32 * 1.2, 'center')
    if (OpenDialog == nil and love.keyboard.isDown("2")) then
        Ui:setColor(Ui.colors.yellow)
        love.graphics.rectangle("line", 350, windowH - 50, 32 * 1.2, 32 * 1.2)
        Ui:setColor(nil)
    end

    love.graphics.draw(self.sprites.heal, 400, windowH - 50, 0, 1.2)
    love.graphics.printf("3", 400, windowH - 15, 32 * 1.2, 'center')
    if (OpenDialog == nil and love.keyboard.isDown("3")) then
        Ui:setColor(Ui.colors.yellow)
        love.graphics.rectangle("line", 400, windowH - 50, 32 * 1.2, 32 * 1.2)
        Ui:setColor(nil)
    end
end

function Ui:drawPlayerBar(x, y, percentage, label, color)
    love.graphics.setFont(self.fonts.boldMedium)

    Ui:setColor(Ui.colors.black)
    love.graphics.rectangle("fill", x, y, 110, 20, 5)

    Ui:setColor(color)
    love.graphics.rectangle("fill", x + 5, y + 5, percentage, 10)

    Ui:setColor(Ui.colors.black)
    love.graphics.print(label, x + 115, y)
end

function Ui:drawDebug(offsetX, offsetY)
    love.graphics.setFont(Ui.fonts.boldSmall)

    local y = 5;
    local messages = {
        "Mouse: " .. FormatCoord(self.mousePos),
        "Mouse move countdown: " .. string.format("%.2f", self.mouseMoveCountdown),
        "Player: " .. FormatCoord(Player:vector()),
        "Direction degrees: " .. string.format("%.2f", Player.viewingAngle),
        "Moving direction: " .. FormatCoord(Player.movingDirection),
        "Resolution: " .. FormatCoord(Vector(love.graphics.getWidth(), love.graphics.getHeight())),
        "FPS: " .. love.timer.getFPS(),
    }

    Ui:setColor(Ui.colors.black, 0.2)
    love.graphics.rectangle("fill", 600, 0, 200, #messages * 20 + 20)

    Ui:setColor(Ui.colors.white, 0.7)
    for i, message in ipairs(messages) do
        love.graphics.print(message, 605, y + ((i - 1) * 10))
    end

    local pos = Player:vector() + Vector(offsetX, offsetY)
    -- Player location crosshair
    Ui:setColor(Ui.colors.red)
    love.graphics.line(pos.x-20, pos.y, pos.x+20, pos.y)
    love.graphics.line(pos.x, pos.y-20, pos.x, pos.y+20)

    Ui:setColor(Ui.colors.black)
    for index, value in ipairs(self.debugMessages) do
        love.graphics.print(value, 5, index * 10 - 5)
    end
end

function Ui:drawMobsDebug(offsetX, offsetY)
    Ui:setColor(Ui.colors.yellow)
    for index, mob in pairs(Mobs.mobs) do
        love.graphics.line(
            mob.body:getX() + offsetX,
            mob.body:getY() + offsetY,
            mob.body:getX() + offsetX + mob.movementV.x * 25,
            mob.body:getY() + offsetY + mob.movementV.y * 25
        )
    end

    -- Draw spawners
    for index, spawner in pairs(Mobs.spawners) do
        DrawingSpawners = true
        Ui:setColor(Ui.colors.red)
        love.graphics.circle("line", spawner.pos.x + offsetX, spawner.pos.y + offsetY, spawner.radius)
    end

    Ui:setColor(nil)
end

function Ui:addDebugMessage(message)
    table.insert(self.debugMessages, message)
    if (#self.debugMessages > 10) then
        table.remove(self.debugMessages, 1)
    end
end

function Ui:drawPhysics(offsetX, offsetY)
    Ui:setColor(Ui.colors.white)
    local offset = Vector(offsetX, offsetY)
    for i1, body in pairs(World:getBodies()) do
        for i2, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            local shapeType = shape:getType()

            if shapeType == "circle" then
                local point = Vector(body:getWorldPoints(shape:getPoint())) + offset
                love.graphics.circle("line", point.x, point.y, shape:getRadius())
            elseif shapeType == "polygon" then
                love.graphics.polygon("line", OffsetPoints({body:getWorldPoints(shape:getPoints())}, offset))
            elseif shapeType == "edge" then
                love.graphics.line(OffsetPoints({body:getWorldPoints(shape:getPoints())}, offset))
            elseif shapeType == "chain" then
                love.graphics.line(OffsetPoints({body:getWorldPoints(shape:getPoints())}, offset))
            end
        end
    end
end

function OffsetPoints(points, offset)
    local result = {}
    for i3 = 1, #points, 2 do
        local x = points[i3] + offset.x
        local y = points[i3 + 1] + offset.y
        table.insert(result, x)
        table.insert(result, y)
    end
    return result
end

function Ui:getCameraPosition()
    local windowW = love.graphics.getWidth()
    local windowH = love.graphics.getHeight()

    local camera = Vector(math.floor(Player:getX() - windowW / 2), math.floor(Player:getY() - windowH / 2))

    -- Left border
    if camera.x < 0 then
        camera.x = 0
    end

    -- Top border
    if camera.y < 0 then
        camera.y = 0
    end

    -- -- Get width/height of background
    local mapW = Map.width * Map.tilewidth
    local mapH = Map.height * Map.tileheight

    -- -- Right border
    if camera.x > (mapW - windowW) then
        camera.x = (mapW - windowW)
    end

    -- Bottom border
    if camera.y > (mapH - windowH) then
        camera.y = (mapH - windowH)
    end

    return camera
end

function Ui:mouseMoved()
    self.mousePos = Vector(love.mouse.getPosition())
    local camera = self.getCameraPosition(Player)
    self.mousePos = Vector(self.mousePos.x + camera.x, self.mousePos.y + camera.y)
    self.mouseMoveCountdown = 2
    self.mouseRecentlyMoved = true
end

function FormatCoord(coord)
    return '( ' .. string.format("%.2f", coord.x) .. ', ' .. string.format("%.2f", coord.y) .. ' )'
end

return Ui
