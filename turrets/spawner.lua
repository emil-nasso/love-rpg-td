Spawner = Class {
    init = function(self, position, radius, interval)
        self.position = position
        self.radius = radius

        Timer.every(interval, function() self:spawn() end)
    end,
    position = nil,
    radius = 100,
}

function Spawner:spawn()
    error("Spawner:spawn() must be overridden")
end

function Spawner:update(dt)
end

function Spawner:draw()
    error("Spawner:spawn() must be overridden")
end

return Spawner
