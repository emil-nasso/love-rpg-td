HealthSpawner = Class {
    init = function(self, position, radius, interval)
        Spawner.init(self, position, radius, interval)
    end,
    __includes = { ResourceSpawner, Spawner },
    color = Colors.red,
}

function HealthSpawner:spawn()
    HealthOrb(5, RandomPosInCircle(self.position, self.radius))
end

return HealthSpawner
