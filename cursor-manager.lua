CursorManager = {}
CursorManager.__index = CursorManager

function CursorManager:new()
    local cursorManager = {
        cursors = {
            arrow = love.mouse.getSystemCursor('arrow'),
            pointer = love.mouse.getSystemCursor('hand'),
            crosshair = love.mouse.getSystemCursor('crosshair'),
        },
        pointer = false,
    }
    setmetatable(cursorManager, CursorManager)
    return cursorManager
end

function CursorManager:setDialogPointerCursor()
    self.pointer = true
end

function CursorManager:draw()
    if (OpenDialog) then
        if (self.pointer) then
            love.mouse.setCursor(self.cursors.pointer)
            self.pointer = false
        else
            love.mouse.setCursor(self.cursors.arrow)
        end
    else
        love.mouse.setCursor(self.cursors.crosshair)
    end
end

return CursorManager
