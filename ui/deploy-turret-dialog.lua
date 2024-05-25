DeployTurretDialog = {}
DeployTurretDialog.__index = DeployTurretDialog

function DeployTurretDialog.new()
    local buttonTheme = {
        alpha = 0.7,
        border = Ui.colors.lightGray,
        background = Ui.colors.white,
        text = Ui.colors.black,
        hover = Ui.colors.lightGray,
        font = Ui.fonts.regularMedium,
    }

    local dialog = {
        mousePosition = nil,
        x = 200,
        y = 100,
        w = 400,
        h = 300,
        buttons = {
            shooter = {
                text="[1] Shooter",
                x=0, y=30, w=110, h=40,
                action=function(self) DeployTurretDialog:deployShooter() end,
                theme=buttonTheme,
            },
            pusher = {
                text="[2] Pusher",
                x=0, y=75, w=110, h=40,
                action=function(self) DeployTurretDialog:deployPusher() end,
                theme=buttonTheme,
            },
        },
    }

    setmetatable(dialog, DeployTurretDialog)
    return dialog
end

function DeployTurretDialog:open(mousePosition)
    self.mousePosition = mousePosition
    OpenDialog = self
end

function DeployTurretDialog:deployPusher()
    TurretManager:deployPusher(self.mousePosition)
    self:close()
end

function DeployTurretDialog:deployShooter()
    TurretManager:deployShooter(self.mousePosition)
    self:close()
end

function DeployTurretDialog:atX(x)
    return x + self.x
end

function DeployTurretDialog:atY(y)
    return y + self.y
end

function DeployTurretDialog:gridCoord(col, row)
    local x1 = self:atX(12 + (col * 48))
    local y1 = self:atY(50 + (row * 48))
    return x1, y1, x1 + 40, y1 + 40
end

function DeployTurretDialog:keyPressed(key)
    if key == 'escape' then
        self:close()
    elseif key == '1' then
        self:deployShooter()
    elseif key == '2' then
        self:deployPusher()
    end
end

function DeployTurretDialog:close()
    OpenDialog = nil
end

function DeployTurretDialog:mousePressed(x, y, button)
    for index, button in pairs(self.buttons) do
        if self:buttonIsHoovered(button) then
            button.action(self)
            break;
        end
    end
end

function DeployTurretDialog:buttonIsHoovered(button)
    local x1, y1 = self:atX(button.x), self:atY(button.y)
    local x2, y2 = x1 + button.w, y1 + button.h

    local mouseX, mouseY = love.mouse.getPosition()

    return mouseX > x1 and mouseX < x2 and mouseY > y1 and mouseY < y2
end

function DeployTurretDialog:draw()
    -- Title
    love.graphics.setFont(Ui.fonts.boldLarge)
    Ui:setColor(Ui.colors.white, 0.8)
    love.graphics.print("Turret", self:atX(10), self:atY(0))

    -- Buttons
    for index, button in pairs(self.buttons) do
        self:drawButton(button)
    end
end

function DeployTurretDialog:drawButton(button)
    local x, y = self:atX(button.x), self:atY(button.y)

    if self:buttonIsHoovered(button) then
        Ui:setColor(button.theme.hover, button.theme.alpha)
        love.graphics.rectangle('fill', x, y, button.w, button.h, 6)
    else
        Ui:setColor(button.theme.background, button.theme.alpha)
        love.graphics.rectangle('fill', x, y, button.w, button.h, 6)
    end

    Ui:setColor(button.theme.border, button.theme.alpha)
    love.graphics.rectangle('line', x, y, button.w, button.h, 6)

    Ui:setColor(button.theme.text, button.theme.alpha)
    love.graphics.setFont(button.theme.font)
    love.graphics.print(button.text, x+10, y+10)
end

return DeployTurretDialog
