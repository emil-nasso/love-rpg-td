local vector = require 'libraries/hump/vector'

Ui = {
    colors = {
        yellow = { r = 1, g = 1, b = 0 },
        red = { r = 1, g = 0, b = 0 },
        black = { r = 0, g = 0, b = 0 },
        white = { r = 1, g = 1, b = 1 },
        blue = { r = 0, g = 0, b = 1 },
    },
    fonts = {
        regularMedium = love.graphics.newFont('fonts/bitstream_vera_sans/Vera.ttf', 16),
        boldMedium = love.graphics.newFont('fonts/bitstream_vera_sans/VeraBd.ttf', 16),
    }
}
Ui.__index = Ui

function Ui:new(o)
    local ui = o or {}
    setmetatable(ui, Ui)
    return ui
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

    if key == "escape" or key == "q" then
        love.event.quit()
    end
end

function Ui:draw(offsetX, offsetY)
    self:drawDebug(offsetX, offsetY)
    self:drawPlayerBar(10, love.graphics.getHeight() - 75, Player.health, "Health", Ui.colors.red)
    self:drawPlayerBar(10, love.graphics.getHeight() - 50, Player.health, "Mana", Ui.colors.blue)
    self:drawPlayerBar(10, love.graphics.getHeight() - 25, Player.stamina, "Stamina", Ui.colors.yellow)
end

function Ui:drawPlayerBar(x, y, percentage, label, color)
    love.graphics.setFont(self.fonts.boldMedium)

    love.graphics.setColor(self.colors.black.r, self.colors.black.g, self.colors.black.b, 1)
    love.graphics.rectangle("fill", x, y, 110, 20, 5)

    love.graphics.setColor(color.r, color.g, color.b, 1)
    love.graphics.rectangle("fill", x + 5, y + 5, percentage, 10)

    love.graphics.setColor(self.colors.black.r, self.colors.black.g, self.colors.black.b, 1)
    love.graphics.print(label, x + 115, y)
end

function Ui:drawDebug(offsetX, offsetY)
    love.graphics.setFont(Ui.fonts.regularMedium)

    local y = 5;
    local messages = {
        "Mouse: " .. FormatCoord(self.mousePos),
        "Mouse move countdown: " .. self.mouseMoveCountdown,
        "Player: " .. FormatCoord(Player),
        "Direction degrees: " .. string.format("%.2f", Player.viewingAngle),
        "Moving direction: " .. FormatCoord(Player.movingDirection),
        "Resolution: " .. FormatCoord(vector(love.graphics.getWidth(), love.graphics.getHeight())),
        "FPS: " .. love.timer.getFPS(),
    }

    love.graphics.setColor(Ui.colors.black.r, Ui.colors.black.g, Ui.colors.black.b, 0.2)
    love.graphics.rectangle("fill", 0, 0, 275, #messages * 20 + 20)

    love.graphics.setColor(Ui.colors.white.r, Ui.colors.white.g, Ui.colors.white.b, 0.4)

    for i, message in ipairs(messages) do
        love.graphics.print(message, 5, y + ((i - 1) * 20))
    end

    local pos = vector(Player.x, Player.y) + vector(offsetX, offsetY)
    -- Player location crosshair
    love.graphics.setColor(Ui.colors.red.r, Ui.colors.red.g, Ui.colors.red.b, 1)
    love.graphics.line(pos.x-20, pos.y, pos.x+20, pos.y)
    love.graphics.line(pos.x, pos.y-20, pos.x, pos.y+20)
end

function Ui:drawPhysics(offsetX, offsetY)
    local offset = vector(offsetX, offsetY)
    for i1, body in pairs(World:getBodies()) do
        for i2, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            local shapeType = shape:getType()

            if shapeType == "circle" then
                local point = vector(body:getWorldPoints(shape:getPoint())) + offset
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

    local camera = vector(math.floor(Player.x - windowW / 2), math.floor(Player.y - windowH / 2))

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
    self.mousePos = vector(love.mouse.getPosition())
    local camera = self.getCameraPosition(Player)
    self.mousePos = vector(self.mousePos.x + camera.x, self.mousePos.y + camera.y)
    self.mouseMoveCountdown = 2
    self.mouseRecentlyMoved = true
end

function FormatCoord(coord)
    return '( ' .. string.format("%.2f", coord.x) .. ', ' .. string.format("%.2f", coord.y) .. ' )'
end

return Ui
