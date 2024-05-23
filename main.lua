function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Emils gejm")
    love.window.setMode(800, 600, { resizable = false })
    love.graphics.setDefaultFilter("nearest", "nearest")

    love.physics.setMeter(32)
    World = love.physics.newWorld(0, 0, true)
    World:setCallbacks(beginContact, endContact)

    Spider = (require 'mobs/spider')
    Gold = (require 'items/gold')
    LootDialog = (require 'ui/loot-dialog')

    Timer = require 'libraries/hump/timer'
    Ui = (require 'ui'):new()
    Player = (require 'player'):new()
    Map = (require 'libraries/sti')('map.lua')
    Effects = (require 'effects'):new()
    MobsManager = (require 'mobs-manager'):new()
    ItemsManager = (require 'items-manager'):new()

    CollisionCategories = {
        default = 1,
        projectile = 2,
        wall = 3,
    }

    OpenDialog = nil

    Ui:load()
    Player:load()
    MobsManager:load()
    ItemsManager:load()

    for x = 1, 5, 1 do
        for y = 1, 5, 1 do
            Spider:spawn(300 + (x*25), 300 + (y*25))
        end
    end

    local spriteLayer = Map.layers["Sprites"]
    spriteLayer.player = Player

    spriteLayer.draw = function(self)
        ItemsManager:drawGroundItems()
        Player.anim:draw(Player.spriteSheet, Player.x, Player.y, nil, 2, nil, 6, 9)
        MobsManager:draw()

        for index, value in ipairs(Player.projectiles) do
            Ui:setColor(Ui.colors.red)
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
        fixture:setCategory(CollisionCategories.wall)
        fixture:setMask(CollisionCategories.projectile)
        fixture:setUserData({type='map-collidable'})
    end

    Map:removeLayer("Collision")
end

function love.update(dt)
    Map:update(dt)
    MobsManager:move(dt)
    Ui:update(dt)
    World:update(dt)
    Effects:update(dt)
    ItemsManager:update(dt)
end

function love.draw()
    local camera = Ui:getCameraPosition()

    Map:draw(-camera.x, -camera.y)
    Effects:draw(-camera.x, -camera.y)
    Ui:draw(-camera.x, -camera.y)

    if (OpenDialog) then
        OpenDialog:draw()
    end

    Ui:setColor(nil)
end

function love.keypressed(key)
    if OpenDialog then
        OpenDialog:keyPressed(key)
    else
        if key == 'e' then
            local looted = ItemsManager:lootGround(Player:getX(), Player:getY(), 300)
            if (#looted > 0) then
                OpenDialog = LootDialog:new(looted)
            end
        end
        Ui:keyPressed(key)
        Player:keyPressed(key)
    end
end

function love.mousemoved()
    if (OpenDialog) then
        --OpenDialog:mouseMoved()
    else
        Ui:mouseMoved()
    end
end

function love.mousepressed(x, y, button)
    if (OpenDialog) then
        OpenDialog:mousePressed(x, y, button)
    else
        Ui:addDebugMessage("mousepressed btn " .. button)
        Ui:mouseMoved()
        if (button == 1) then
            Player:startShooting()
        elseif (button == 2) then
            local camera = Ui:getCameraPosition()
            Player:detonateShock(x + camera.x, y + camera.y)
        end
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
        local mob = mob:getUserData()
        mob:hit(45)
        Ui:addDebugMessage("Mob hit by projectile.")
    end
end

function endContact(a, b, coll)
    Ui:addDebugMessage("end-contact: '" .. (a:getUserData().type or '') .. "' and '" .. (b:getUserData().type or '') .. "'")
end
