SpiderSpawner = Class {
    init = function(self, pos, radius, count)
        self.pos = pos
        self.radius = radius
        self.count = count
        self.animation = Anim8.newAnimation(Mobs.graphics.spawner.grid('1-7', 1), 0.2)

        self.timer = Timer.every(2, function()
            if (self.spawned < self.count) then
                local angle = math.random() * math.pi * 2
                local distance = math.random() * radius
                local x = pos.x + math.cos(angle) * distance
                local y = pos.y + math.sin(angle) * distance
                Spider(x, y, self)
                self.spawned = self.spawned + 1
            end
        end)
    end,
    pos = nil,
    radius = nil,
    count = nil,
    mobType = 'spider',
    spawned = 0,
    timer = nil,
    animation = nil,
}

function SpiderSpawner:initialSpawn()
    for _ = 1, self.count do
        local angle = math.random() * math.pi * 2
        local distance = math.random() * self.radius
        local x = self.pos.x + math.cos(angle) * distance
        local y = self.pos.y + math.sin(angle) * distance
        Spider(x, y, self)
    end
end

return SpiderSpawner
