PlayerResource = Class {
    init = function(self, amount, max, regen)
        self.amount = amount
        self.max = max
        self.regen = regen
    end,
    amount = nil,
    max = nil,
    regen = nil,
}

function PlayerResource:percentage()
    return self.amount / self.max
end

function PlayerResource:regenerate(dt)
    if (self:isFull()) then
        return
    end
    self.amount = math.min(self.amount + self.regen * dt, self.max)
end

function PlayerResource:regenerateAmount(amount)
    if (self:isFull()) then
        return
    end
    self.amount = math.min(self.amount + amount, self.max)
end

function PlayerResource:drain(drainRate, dt)
    self.amount = math.max(self.amount - (drainRate * dt), 0)
end

function PlayerResource:use(amount)
    self.amount = math.max(self.amount - amount, 0)
end

function PlayerResource:isFull()
    return self.amount == self.max
end

function PlayerResource:isEmpty()
    return self.amount == 0
end

function PlayerResource:has(amount)
    return self.amount >= amount
end

function PlayerResource:increaseMax(amount)
    self.max = self.max + amount
end

function PlayerResource:increaseRegen(amount)
    self.regen = self.regen + amount
end

return PlayerResource
