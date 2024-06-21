GoldSpawner = Class {
    init = function(self, position, radius, interval)
        Spawner.init(self, position, radius, interval)
    end,
    __includes = { ResourceSpawner, Spawner },
    color = Colors.yellow,
}

function GoldSpawner:spawn()
    Gold(5, RandomPosInCircle(self.position, self.radius))
end

return GoldSpawner
