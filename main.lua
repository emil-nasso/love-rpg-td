function love.load()
    love.window.setTitle("Emils gejm")
    love.window.setMode(800, 600, { resizable = false })
    love.graphics.setDefaultFilter("nearest", "nearest")

    Ui = (require 'ui'):new()
    Player = (require 'player'):new()
    Map = (require 'libraries/sti')('map.lua')

    Ui:load()
    Player:load()

    -- TODO: Lägga in Sprites lagret i Tiled, så att man kan ha det i rätt renderingsordning
    local spriteLayer = Map:addCustomLayer("Sprites", 4)
    spriteLayer.player = Player

    spriteLayer.draw = function(self)
        Player.anim:draw(Player.spriteSheet, Player.x, Player.y, nil, 2, nil, 6, 9)
    end

    spriteLayer.update = function(self, dt)
        Player:update(dt)
    end
end

function love.update(dt)
    Map:update(dt)
    Ui:update(dt)
end

function love.draw()
    local camera = Ui:getCameraPosition()

    Map:draw(-camera.x, -camera.y)
    Ui:draw()

    love.graphics.setColor(1, 1, 1, 1) -- reset colors
end

function love.keypressed(key)
    Ui:keyPressed(key)
end

function love.mousemoved()
    Ui:mouseMoved()
end

function love.mousepressed()
    Ui:mouseMoved()
end
