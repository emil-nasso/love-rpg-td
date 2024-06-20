SpiderSpawner = Class {
    init = function(self, pos, radius, count)
        self.pos = pos
        self.radius = radius
        self.count = count
        self.animation = Anim8.newAnimation(Mobs.graphics.spawner.grid('1-7', 1), 0.2)

        self.timer = Timer.every(2, function()
            if (self.spawned < self.count) then
                Spider(RandomPosInCircle(self.pos, self.radius), self)
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
        Spider(RandomPosInCircle(self.pos, self.radius), self)
    end
end

return SpiderSpawner
