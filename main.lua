require('helpers')
Anim8 = require 'libraries/anim8/anim8'
Vector = require 'libraries/hump/vector'
OpenDialog = nil
CollisionCategories = {
    default = 1,
    projectile = 2,
    highTerrain = 3,
    lowTerrain = 4,
}

function love.load()
    require 'player'
    require 'ui'
    require 'effects'
    require 'mobs'
    require 'Items'
    require 'cursors'
    require 'turrets'
    require 'npcs'
    require 'projectiles'

    math.randomseed(os.time())
    love.window.setTitle("Emils gejm")
    love.window.setMode(800, 600, { resizable = false })
    love.graphics.setDefaultFilter("nearest", "nearest")

    love.physics.setMeter(32)
    World = love.physics.newWorld(0, 0, true)
    World:setCallbacks(beginContact, endContact)

    Mobs:load()
    Spider = (require 'mobs/spider')
    Gold = (require 'items/gold')

    Timer = require 'libraries/hump/timer'
    Map = (require 'libraries/sti')('map.lua')

    for _, object in pairs(Map.layers["HighTerrain"].objects) do
        local body = love.physics.newBody(World, object.x + object.width/2, object.y + object.height/2, "static")
        local shape = love.physics.newRectangleShape(object.width, object.height)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setCategory(CollisionCategories.highTerrain)
        fixture:setUserData({type='high-terrain'})
    end

    for _, object in pairs(Map.layers["LowTerrain"].objects) do
        local body = love.physics.newBody(World, object.x + object.width/2, object.y + object.height/2, "static")
        local shape = love.physics.newRectangleShape(object.width, object.height)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setCategory(CollisionCategories.lowTerrain)
        fixture:setMask(CollisionCategories.projectile)
        fixture:setUserData({type='low-terrain'})
    end

    local playerStartPosition = Vector()
    local gunnarStartPosition = Vector()
    for _, object in pairs(Map.layers["Spawns"].objects) do
        if object.properties.type == 'player' then
            playerStartPosition = Vector(object.x, object.y)
        end

        if object.properties.type == 'npc' then
            gunnarStartPosition = Vector(object.x, object.y)
        end

        if object.properties.type == 'spider' then
            Spider.spawn(object.x, object.y)
        end

        if object.properties.type == 'spawner' then
            XYZ = object
            local radius = object.width / 2
            Mobs:addSpawner(Vector(object.x + radius, object.y + radius), radius)
        end
    end

    Map:removeLayer("HighTerrain")
    Map:removeLayer("LowTerrain")
    Map:removeLayer("Spawns")

    Player:load(playerStartPosition)
    Ui:load()
    Items:load()
    Npcs:load(gunnarStartPosition)

    -- TODO: No constructors needed for the dialogs
    LootDialog = (require 'ui/loot-dialog'):new()
    DeployTurretDialog = (require 'ui/deploy-turret-dialog'):new()
    DialogueDialog = (require 'ui/dialogue-dialog'):new()

    local spriteLayer = Map.layers["Sprites"]
    spriteLayer.player = Player

    spriteLayer.draw = function(self)
        Items:drawGroundItems()
        Player.anim:draw(Player.spriteSheet, Player:getX(), Player:getY(), nil, 2, nil, 6, 9)
        Mobs:draw()
        Turrets:draw()
        Npcs:draw()
        Projectiles:draw()
    end

    spriteLayer.update = function(self, dt)
        Player:update(dt)
    end
end

function love.update(dt)
    require("libraries/lovebird/lovebird").update()
    Map:update(dt)
    Mobs:move(dt)
    Ui:update(dt)
    World:update(dt)
    Effects:update(dt)
    Items:update(dt)
    Projectiles:update(dt)
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

    Cursors:draw()
end

function love.keypressed(key)
    if OpenDialog then
        OpenDialog:keyPressed(key)
    else
        if key == 'e' then
            local looted = Items:lootGround(Player:getX(), Player:getY(), 300)
            if (#looted > 0) then
                LootDialog:open(looted)
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
    local cameraPosition = Ui:getCameraPosition()
    local worldPosition = Vector(x, y) + cameraPosition
    local npc = Npcs:getNpcAt(worldPosition)

    if (OpenDialog) then
        OpenDialog:mousePressed(x, y, button)
    elseif (npc) then
        DialogueDialog:open(npc.name, npc.dialogue)
    else
        Ui:addDebugMessage("mousepressed btn " .. button)
        Ui:mouseMoved()
        if (button == 1) then
            Player:startShooting()
        elseif (button == 2) then
            if (OpenDialog == nil) then
                DeployTurretDialog:open(Ui:mousePositionVector())
            end
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
        Projectiles:remove(projectile)
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
