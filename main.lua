require('helpers')

-- Libraries
Timer = require 'libraries.hump.timer'
Map = require('libraries.sti')('map.lua')
Sprites = require('libraries.cargo.cargo').init('sprites')

-- Classes
Class = require "libraries.hump.class"
Anim8 = require 'libraries.anim8.anim8'
Vector = require 'libraries.hump.vector'
Spider = require 'mobs.spider'
Gold = require 'items.gold'
LootDialog = require 'ui.loot-dialog'
DialogueDialog = require 'ui.dialogue-dialog'
HeroText = require 'effects.hero-text'
Explosion = require 'effects.explosion'
Shockwave = require 'effects.shockwave'
Shooter = require 'turrets.shooter'
SpiderSpawner = require 'spawners.spider-spawner'
PlayerResource = require 'util.player-resource'

-- Managers
Player = (require 'player')()
Ui = (require 'ui')()
Effects = (require 'effects')()
Mobs = (require 'mobs')()
Items = (require 'items')()
Cursors = (require 'cursors')()
Turrets = (require 'turrets')()
Npcs = (require 'npcs')()
Projectiles = (require 'projectiles')()

-- Constants
WORLD_WIDTH = 1300
WORLD_HEIGHT = 900
WINDOW_WIDTH = 1600
WINDOW_HEIGHT = 900
SIDEBAR_LEFT = 1300

-- Global variables
OpenDialog = nil
CollisionCategories = {
    default = 1,
    projectile = 2,
    highTerrain = 3,
    lowTerrain = 4,
}

function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Emils gejm")
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { resizable = false })
    love.graphics.setDefaultFilter("nearest", "nearest")

    love.physics.setMeter(32)
    World = love.physics.newWorld(0, 0, true)
    World:setCallbacks(BeginContact, EndContact)

    Map:resize(WORLD_WIDTH, WORLD_HEIGHT)

    for _, object in pairs(Map.layers["HighTerrain"].objects) do
        local body = love.physics.newBody(World, object.x + object.width / 2, object.y + object.height / 2, "static")
        local shape = love.physics.newRectangleShape(object.width, object.height)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setCategory(CollisionCategories.highTerrain)
        fixture:setUserData({ type = 'high-terrain' })
    end

    for _, object in pairs(Map.layers["LowTerrain"].objects) do
        local body = love.physics.newBody(World, object.x + object.width / 2, object.y + object.height / 2, "static")
        local shape = love.physics.newRectangleShape(object.width, object.height)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setCategory(CollisionCategories.lowTerrain)
        fixture:setMask(CollisionCategories.projectile)
        fixture:setUserData({ type = 'low-terrain' })
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
            Spider(object.x, object.y)
        end

        if object.properties.type == 'spawner' then
            local radius = object.width / 2
            Mobs:addSpiderSpawner(
                Vector(object.x + radius, object.y + radius),
                radius,
                object.properties.count
            )
        end
    end

    Map:removeLayer("HighTerrain")
    Map:removeLayer("LowTerrain")
    Map:removeLayer("Spawns")

    Player:load(playerStartPosition)
    Ui:load()
    Npcs:load(gunnarStartPosition)

    local spriteLayer = Map.layers["Sprites"]
    spriteLayer.player = Player

    spriteLayer.draw = function(self)
        Mobs:drawSpawners()
        Items:drawGroundItems()
        Player.anim:draw(Player.spriteSheet, Player:getX(), Player:getY(), nil, 2, nil, 6, 9)
        Mobs:drawMobs()
        Turrets:draw()
        Npcs:draw()
        Projectiles:draw()
    end

    spriteLayer.update = function(self, dt)
        Player:update(dt)
    end

    -- Add effects layer
    Map:addCustomLayer("Effects", #Map.layers + 1)
    local effectsLayer = Map.layers["Effects"]

    function effectsLayer:draw()
        Effects:draw()
    end

    -- Add debug layer
    Map:addCustomLayer("Debug", #Map.layers + 1)
    local debugLayer = Map.layers["Debug"]

    function debugLayer:draw()
        if (Ui.showDebug) then
            Ui:drawMobsDebug(0, 0)
            Ui:drawPhysics(0, 0)
            Ui:drawWorldDebug()
        end
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
    Turrets:update(dt)
    Mobs:update(dt)
end

function love.draw()
    local camera = Ui:getCameraPosition()

    Map:draw(-camera.x, -camera.y)
    Ui:draw()

    if (OpenDialog) then
        OpenDialog:draw()
    end

    Ui:drawSidebar()

    Ui:setColor(nil)

    Cursors:draw()

    if (Ui.showDebug) then
        Ui:drawDebugUi()
    end
end

function love.keypressed(key)
    if OpenDialog then
        OpenDialog:keyPressed(key)
    else
        if key == 'e' then
            local looted = Items:lootGround(Player:getX(), Player:getY(), 300)
            if (#looted > 0) then
                OpenDialog = LootDialog(looted)
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
    local mousePosition = Vector(x, y)
    local npc = Npcs:getNpcAt(worldPosition)

    if (love.keyboard.isDown('1')) then
        Turrets:deployShooter(mousePosition)
        return
    end

    if (OpenDialog) then
        OpenDialog:mousePressed(x, y, button)
    elseif (npc) then
        OpenDialog = DialogueDialog(npc.name, npc.dialogue)
    else
        Ui:addDebugMessage("mousepressed btn " .. button)
        Ui:mouseMoved()
        if (button == 1) then
            Player:startShooting()
        end
    end
end

function love.mousereleased(x, y, button)
    Ui:addDebugMessage("mousereleased")
    if (button == 1) then
        Player:stopShooting()
    end
end

function BeginContact(a, b, coll)
    Ui:addDebugMessage("begin-contact: '" ..
        (a:getUserData().type or '') .. "' and '" .. (b:getUserData().type or '') .. "'")

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

function EndContact(a, b, coll)
    Ui:addDebugMessage("end-contact: '" ..
        (a:getUserData().type or '') .. "' and '" .. (b:getUserData().type or '') .. "'")
end
