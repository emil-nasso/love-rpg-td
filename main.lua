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
    Mobs = (require 'mobs'):new()

    Ui:load()
    Player:load()
    Mobs:load()

    for x = 1, 5, 1 do
        for y = 1, 5, 1 do
            Mobs:spawnSpider(300 + (x*25), 300 + (y*25))
        end
    end

    local spriteLayer = Map.layers["Sprites"]
    spriteLayer.player = Player

    spriteLayer.draw = function(self)
        Player.anim:draw(Player.spriteSheet, Player.x, Player.y, nil, 2, nil, 6, 9)
        for index, value in ipairs(Player.projectiles) do
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.circle("fill", value:getBody():getX(), value:getBody():getY(), 5)
        end
        Mobs:draw()
    end

    spriteLayer.update = function(self, dt)
        Player:update(dt)
    end

    local collisionsLayer = Map.layers["Collision"]
    for key, object in pairs(collisionsLayer.objects) do

        local body = love.physics.newBody(World, object.x + object.width/2, object.y + object.height/2, "static")
        local shape = love.physics.newRectangleShape(object.width, object.height)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setUserData({type='map-collidable'})
    end

    Map:removeLayer("Collision")
end

function love.update(dt)
    Map:update(dt)
    Mobs:move(dt)
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
    Player:keyPressed(key)
end

function love.mousemoved()
    Ui:mouseMoved()
end

function love.mousepressed(x, y, button)
    Ui:addDebugMessage("mousepressed btn " .. button)
    Ui:mouseMoved()
    if (button == 1) then
        Player:startShooting()
    elseif (button == 2) then
        local camera = Ui:getCameraPosition()
        Player:detonateShock(x + camera.x, y + camera.y)
    end
end

function love.mousereleased(x, y, button)
    Ui:addDebugMessage("mousereleased")
    if (button == 1) then
        Player:stopShooting()
    end
end

function beginContact(a, b, coll)
    Ui:addDebugMessage("begin-contact: '" .. (a:getUserData().type or '') .. "' and '" .. (b:getUserData().type or '') .. "'")

    local projectile = nil;
    if (a:getUserData().type == "projectile") then
       projectile = a
    elseif (b:getUserData().type == "projectile") then
        projectile = b
    end

    local mob = nil;
    if (a:getUserData().type == 'mob') then
        mob = a
    elseif (b:getUserData().type == 'mob') then
        mob = b
    end

    if (projectile) then
        Player:removeProjectile(projectile)
        Effects:addExplosion(projectile:getBody():getX(), projectile:getBody():getY())
    end

    if (projectile and mob) then
        local m = mob:getUserData()
        Mobs:hit(m, 20)
        Ui:addDebugMessage("Mob hit by projectile.")
    end
end

function endContact(a, b, coll)
    Ui:addDebugMessage("end-contact: '" .. (a:getUserData().type or '') .. "' and '" .. (b:getUserData().type or '') .. "'")
end
