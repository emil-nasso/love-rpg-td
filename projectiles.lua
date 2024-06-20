Projectiles = Class {
    projectiles = {}
}

-- TODO: Remove angle?
function Projectiles:spawn(x, y, range, vector, angle, offset, color)
    local startX = x + (vector.x * offset)
    local startY = y + (vector.y * offset)
    local body = love.physics.newBody(World, startX, startY, "dynamic")
    local shape = love.physics.newCircleShape(5)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setCategory(CollisionCategories.projectile)
    fixture:setMask(CollisionCategories.projectile, CollisionCategories.lowTerrain)

    local direction = Vector(vector.x, vector.y)
    if (angle ~= 0) then
        direction:rotateInplace(angle)
    end

    body:setLinearVelocity(direction.x * 500, direction.y * 500)
    fixture:setUserData({ type = 'projectile' })

    local projectile = {
        origin = Vector(x, y),
        fixture = fixture,
        range = range,
        color = color or Ui.colors.red
    }
    table.insert(self.projectiles, projectile)
end

function Projectiles:update(dt)
    for _, projectile in ipairs(self.projectiles) do
        local pos = Vector(projectile.fixture:getBody():getX(), projectile.fixture:getBody():getY())
        if (projectile.origin:dist(pos) > projectile.range) then
            self:remove(projectile.fixture)
        end
    end
end

function Projectiles:remove(projectileFixture)
    Ui:addDebugMessage("Removing projectile")
    projectileFixture:destroy()
    for i, value in ipairs(self.projectiles) do
        if value.fixture == projectileFixture then
            table.remove(self.projectiles, i)
            break
        end
    end
end

function Projectiles:draw()
    for _, projectile in ipairs(self.projectiles) do
        Ui:setColor(projectile.color)
        love.graphics.circle("fill", projectile.fixture:getBody():getX(), projectile.fixture:getBody():getY(), 5)
    end
end

return Projectiles
