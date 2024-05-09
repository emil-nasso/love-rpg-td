function love.load()
    love.window.setTitle("Emils gejm")
    love.window.setMode(800, 600, { resizable = false })
    love.graphics.setDefaultFilter("nearest", "nearest")

    love.physics.setMeter(32)
    World = love.physics.newWorld(0, 0, true)
    World:setCallbacks(beginContact, endContact)

    Timer = require 'libraries/hump/timer'
    Ui = (require 'ui'):new()
    Player = (require 'player'):new()
    Map = (require 'libraries/sti')('map.lua')
    Effects = (require 'effects'):new()

    Ui:load()
    Player:load()

    -- TODO: Lägga in Sprites lagret i Tiled, så att man kan ha det i rätt renderingsordning
    local spriteLayer = Map.layers["Sprites"]
    spriteLayer.player = Player

    spriteLayer.draw = function(self)
        Player.anim:draw(Player.spriteSheet, Player.x, Player.y, nil, 2, nil, 6, 9)
        for index, value in ipairs(Player.projectiles) do
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.circle("fill", value:getBody():getX(), value:getBody():getY(), 5)
        end
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
    Effects:update(dt)
end

function love.draw()
    local camera = Ui:getCameraPosition()

    Map:draw(-camera.x, -camera.y)
    Effects:draw(-camera.x, -camera.y)
    Ui:draw(-camera.x, -camera.y)

    love.graphics.setColor(1, 1, 1, 1) -- reset colors
end

function love.keypressed(key)
    Ui:keyPressed(key)
end

function love.mousemoved()
    Ui:mouseMoved()
end

function love.mousepressed()
    Ui:addDebugMessage("mousepressed")
    Ui:mouseMoved()
    Player:startShooting()
    --Player:shoot()
end

function love.mousereleased()
    Ui:addDebugMessage("mousereleased")
    Player:stopShooting()
end

function beginContact(a, b, coll)
    Ui:addDebugMessage("begin-contact: '" .. (a:getUserData() or '') .. "' and '" .. (b:getUserData() or '') .. "'")

    if (a:getUserData() == "projectile") then
        Player:removeProjectile(a)
        Effects:addExplosion(a:getBody():getX(), a:getBody():getY())
    end
    if (b:getUserData() == "projectile") then
        Player:removeProjectile(b)
        Effects:addExplosion(b:getBody():getX(), b:getBody():getY())
    end
end

function endContact(a, b, coll)
    Ui:addDebugMessage("end-contact: '" .. (a:getUserData() or '') .. "' and '" .. (b:getUserData() or '') .. "'")
end
