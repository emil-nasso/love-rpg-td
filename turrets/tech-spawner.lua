TechSpawner = Class {
    init = function(self, position, radius, interval)
        Spawner.init(self, position, radius, interval)
    end,
    __includes = { ResourceSpawner, Spawner },
    color = Colors.purple,
}

function TechSpawner:spawn()
    TechOrb(10, RandomPosInCircle(self.position, self.radius))
end

return TechSpawner
