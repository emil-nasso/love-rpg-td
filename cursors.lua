Cursors = {
    cursors = {
        arrow = love.mouse.getSystemCursor('arrow'),
        pointer = love.mouse.getSystemCursor('hand'),
        crosshair = love.mouse.getSystemCursor('crosshair'),
    },
    pointer = false,
}
Cursors.__index = Cursors

function Cursors:setPointerCursor()
    self.pointer = true
end

function Cursors:draw()
    if (self.pointer) then
        love.mouse.setCursor(self.cursors.pointer)
        self.pointer = false
    elseif (OpenDialog) then
        love.mouse.setCursor(self.cursors.arrow)
    else
        love.mouse.setCursor(self.cursors.crosshair)
    end
end

return Cursors
