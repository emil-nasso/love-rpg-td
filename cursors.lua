Cursors = {
    cursors = {
        arrow = love.mouse.getSystemCursor('arrow'),
        pointer = love.mouse.getSystemCursor('hand'),
        crosshair = love.mouse.getSystemCursor('crosshair'),
    },
    pointer = false,
}
Cursors.__index = Cursors

function Cursors:setDialogPointerCursor()
    self.pointer = true
end

function Cursors:draw()
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

return Cursors
