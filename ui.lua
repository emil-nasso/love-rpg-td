Ui = Class {
    fontSize = {
        s = 10,
        m = 12,
        l = 16,
        xl = 24,
    },
    debugMessages = {},
    showDebug = true,
}

function Ui:setColor(color, alpha)
    alpha = alpha or 1
    color = color or { r = 1, g = 1, b = 1 }

    love.graphics.setColor(color.r, color.g, color.b, alpha)
end

function Ui:setFont(size)
    love.graphics.setFont(Font.Vera(size))
end

function Ui:setBoldFont(size)
    love.graphics.setFont(Font.VeraBd(size))
end

function Ui:mousePositionVector()
    return Vector(love.mouse.getPosition())
end

function Ui:mouseWorldPositionVector()
    return self:mousePositionVector() + self:getCameraPosition()
end

function Ui:load()
    Ui:setFont(Ui.fontSize.l)
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

    if key == "escape" then
        love.event.quit()
    end
end

function Ui:draw()
    local windowH = love.graphics.getHeight()

    -- Player stats
    Ui:setColor(Colors.white, 0.3)
    love.graphics.rectangle("fill", 0, windowH - 160, 250, 160, 10, 10)
    Ui:setBoldFont(Ui.fontSize.l)
    Ui:setColor(Colors.black)
    love.graphics.print("Gold: " .. Player.gold, 10, windowH - 150)
    love.graphics.print("Level: " .. Player.level, 10, windowH - 125)

    -- Print stats small and simplistic in the sidebar and only show bars in the UI
    local xpProgress = ((Player.xp - Player.currentLevelXp) / (Player.nextLevelXp - Player.currentLevelXp))
    self:drawPlayerBar(10, windowH - 125, xpProgress, "XP: " .. Player.xp .. "/" .. Player.nextLevelXp, Colors.white)
    self:drawPlayerBar(10, windowH - 100, Player.health:percentage(), "Health", Colors.red)
    self:drawPlayerBar(10, windowH - 75, Player.mana:percentage(), "Mana", Colors.blue)
    self:drawPlayerBar(10, windowH - 50, Player.tech:percentage(), "Tech", Colors.purple)
    self:drawPlayerBar(10, windowH - 25, Player.stamina:percentage(), "Stamina", Colors.yellow)

    Ui:setColor(nil)

    -- Toolbar
    Ui:setBoldFont(Ui.fontSize.s)

    -- Shooter turret
    self:drawToolbarIcon(Sprites.toolbar.shooter_turret, 700, windowH - 100, "1")

    -- Sprint
    self:drawToolbarIcon(Sprites.toolbar.sprint, 750, windowH - 100, "lshift")

    -- Shockwave
    self:drawToolbarIcon(Sprites.toolbar.shockwave, 800, windowH - 100, "space")

    -- Shotgun
    self:drawToolbarIcon(Sprites.toolbar.shotgun, 850, windowH - 100, "q")
end

function Ui:drawToolbarIcon(sprite, x, y, key)
    self:setColor(Colors.black, 0.5)
    love.graphics.rectangle("fill", x, y, 32, 32)
    self:setColor(nil)

    love.graphics.draw(sprite, x, y, 0)
    love.graphics.printf(key, x, y + 35, 32, 'center')
    if (OpenDialog == nil and love.keyboard.isDown(key)) then
        Ui:setColor(Colors.yellow)
        love.graphics.rectangle("line", x - 2, y - 2, 36, 36)
        Ui:setColor(nil)
    end
end

function Ui:drawPlayerBar(x, y, percentage, label, color)
    Ui:setBoldFont(Ui.fontSize.l)

    Ui:setColor(Colors.black)
    love.graphics.rectangle("fill", x, y, 110, 20, 5)

    Ui:setColor(color)
    love.graphics.rectangle("fill", x + 5, y + 5, percentage * 100, 10)

    Ui:setColor(Colors.black)
    love.graphics.print(label, x + 115, y)
end

function Ui:drawSidebarBar(x, y, w, h, percentage, color)
    Ui:setColor(color)
    love.graphics.rectangle("fill", x, y, w * percentage, h)
end

function Ui:drawSidebar()
    self:setColor(nil)
    love.graphics.draw(Sprites.sidebar, SIDEBAR_LEFT, 0)

    local levelProgress = Player:levelProgress()
    -- Xp progress bar
    self:drawSidebarBar(SIDEBAR_LEFT + 14, 306, 272, 4, levelProgress, Colors.yellow)

    Ui:setBoldFont(Ui.fontSize.l)
    -- Current level
    love.graphics.print(Player.level, SIDEBAR_LEFT + 75, 285)

    -- Level progress percentage
    love.graphics.print(math.floor(levelProgress * 100) .. '%', SIDEBAR_LEFT + 250, 285)

    -- Gold amount
    love.graphics.print(Player.gold, SIDEBAR_LEFT + 67, 9)

    Ui:setFont(Ui.fontSize.m)
    Ui:setColor(Colors.black)
    -- Left stats
    love.graphics.printf(
        "XP: " .. math.floor(Player.xp) .. "/" .. Player.nextLevelXp .. "\n" ..
        "Health: " .. math.floor(Player.health.amount) .. "/" .. Player.health.max .. "\n" ..
        "Mana: " .. math.floor(Player.mana.amount) .. "/" .. Player.mana.max .. "\n" ..
        "Stamina: " .. math.floor(Player.stamina.amount) .. "/" .. Player.stamina.max .. "\n" ..
        "Tech: " .. math.floor(Player.tech.amount) .. "/" .. Player.tech.max .. "\n",
        SIDEBAR_LEFT + 10,
        320,
        140
    )
    -- Right stats
    love.graphics.printf(
        "Health regen: " .. math.floor(Player.health.regen) .. "/s" .. "\n" ..
        "Mana regen: " .. math.floor(Player.mana.regen) .. "/s" .. "\n" ..
        "Stamina regen: " .. math.floor(Player.stamina.regen) .. "/s" .. "\n" ..
        "\n" ..
        "Speed: " .. math.floor(Player.speed) .. "\n",
        SIDEBAR_LEFT + 145,
        320,
        140
    )
end

-- Draw the fixed position parts of the debug
function Ui:drawDebugUi()
    Ui:setBoldFont(Ui.fontSize.s)

    -- Debug message
    Ui:setColor(Colors.black)
    for index, value in ipairs(self.debugMessages) do
        love.graphics.print(value, 5, index * 10 - 5)
    end

    -- Static messages
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

    Ui:setColor(Colors.black, 0.2)
    love.graphics.rectangle("fill", 1100, 0, 200, #messages * 20 + 20)

    Ui:setColor(Colors.white, 0.7)
    for i, message in ipairs(messages) do
        love.graphics.print(message, 1105, y + ((i - 1) * 10))
    end

    Ui:setColor(nil)
end

function Ui:drawMobsDebug(offsetX, offsetY)
    Ui:setColor(Colors.yellow)
    for _, mob in pairs(Mobs.mobs) do
        love.graphics.line(
            mob.body:getX() + offsetX,
            mob.body:getY() + offsetY,
            mob.body:getX() + offsetX + mob.movementV.x * 25,
            mob.body:getY() + offsetY + mob.movementV.y * 25
        )
    end

    -- Draw spawners
    for _, spawner in pairs(Mobs.spawners) do
        DrawingSpawners = true
        Ui:setColor(Colors.red)
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

function Ui:drawWorldDebug()
    Ui:setColor(Colors.red)
    local pos = Player:vector()
    love.graphics.line(pos.x - 20, pos.y, pos.x + 20, pos.y)
    love.graphics.line(pos.x, pos.y - 20, pos.x, pos.y + 20)
end

function Ui:drawPhysics(offsetX, offsetY)
    Ui:setColor(Colors.white)
    local offset = Vector(offsetX, offsetY)
    for _, body in pairs(World:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            local shapeType = shape:getType()

            if shapeType == "circle" then
                local point = Vector(body:getWorldPoints(shape:getPoint())) + offset
                love.graphics.circle("line", point.x, point.y, shape:getRadius())
            elseif shapeType == "polygon" then
                love.graphics.polygon("line", OffsetPoints({ body:getWorldPoints(shape:getPoints()) }, offset))
            elseif shapeType == "edge" then
                love.graphics.line(OffsetPoints({ body:getWorldPoints(shape:getPoints()) }, offset))
            elseif shapeType == "chain" then
                love.graphics.line(OffsetPoints({ body:getWorldPoints(shape:getPoints()) }, offset))
            end
        end
    end
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

function Ui:mousePosition()
    return Vector(love.mouse.getPosition())
end

function Ui:mouseMoved()
    self.mousePos = Vector(love.mouse.getPosition())
    local camera = self.getCameraPosition(Player)
    self.mousePos = Vector(self.mousePos.x + camera.x, self.mousePos.y + camera.y)
    self.mouseMoveCountdown = 2
    self.mouseRecentlyMoved = true
end

return Ui
