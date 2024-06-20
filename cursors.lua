Cursors = Class {
    cursors = {
        arrow = love.mouse.getSystemCursor('arrow'),
        pointer = love.mouse.getSystemCursor('hand'),
        crosshair = love.mouse.getSystemCursor('crosshair'),
        sizeall = love.mouse.getSystemCursor('sizeall'),
    },
    pointer = false,
}

function Cursors:setPointerCursor()
    self.pointer = true
end

function Cursors:draw()
    if (self.pointer) then
        love.mouse.setCursor(self.cursors.pointer)
        self.pointer = false
    elseif (OpenDialog) then
        love.mouse.setCursor(self.cursors.arrow)
    elseif (love.keyboard.isDown(1)) then
        love.mouse.setCursor(self.cursors.sizeall)
    else
        love.mouse.setCursor(self.cursors.crosshair)
    end
end

return Cursors
