ManaSpawner = Class {
    init = function(self, position, radius, interval)
        Spawner.init(self, position, radius, interval)
    end,
    __includes = { ResourceSpawner, Spawner },
    color = Colors.blue,
}

function ManaSpawner:spawn()
    ManaOrb(5, RandomPosInCircle(self.position, self.radius))
end

return ManaSpawner
