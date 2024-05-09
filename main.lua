function love.load()
    love.window.setTitle("Emils gejm")
    love.window.setMode(800, 600, { resizable = false })
    love.graphics.setDefaultFilter("nearest", "nearest")

    love.physics.setMeter(32)
    World = love.physics.newWorld(0, 0, true)
    World:setCallbacks(beginContact, endContact)

    Ui = (require 'ui'):new()
    Player = (require 'player'):new()
    Map = (require 'libraries/sti')('map.lua')

    Ui:load()
    Player:load()

    -- TODO: Lägga in Sprites lagret i Tiled, så att man kan ha det i rätt renderingsordning
    local spriteLayer = Map.layers["Sprites"]
    spriteLayer.player = Player

    spriteLayer.draw = function(self)
        Player.anim:draw(Player.spriteSheet, Player.x, Player.y, nil, 2, nil, 6, 9)
    end

    spriteLayer.update = function(self, dt)
        Player:update(dt)
    end

    local collisionsLayer = Map.layers["Collision"]
    for key, object in pairs(collisionsLayer.objects) do

        local body = love.physics.newBody(World, object.x + object.width/2, object.y + object.height/2, "static")
        local shape = love.physics.newRectangleShape(object.width, object.height)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setUserData("map-collidable")
    end

    Map:removeLayer("Collision")
end

function love.update(dt)
    Map:update(dt)
    Ui:update(dt)
    World:update(dt)
end

function love.draw()
    local camera = Ui:getCameraPosition()

    Map:draw(-camera.x, -camera.y)
    Ui:draw(-camera.x, -camera.y)
    Ui:drawPhysics(-camera.x, -camera.y)

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
    Player:shoot()
end

function beginContact(a, b, coll)
    Ui:addDebugMessage("begin-contact: '" .. (a:getUserData() or '') .. "' and '" .. (b:getUserData() or '') .. "'")

    if (a:getUserData() == "projectile") then
        a:destroy()
    end

    if (b:getUserData() == "projectile") then
        b:destroy()
    end
end

function endContact(a, b, coll)
    Ui:addDebugMessage("end-contact: '" .. (a:getUserData() or '') .. "' and '" .. (b:getUserData() or '') .. "'")
end
