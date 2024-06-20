function FormatCoord(coord)
    return '( ' .. string.format("%.2f", coord.x) .. ', ' .. string.format("%.2f", coord.y) .. ' )'
end

function OffsetPoints(points, offset)
    local result = {}
    for i3 = 1, #points, 2 do
        local x = points[i3] + offset.x
        local y = points[i3 + 1] + offset.y
        table.insert(result, x)
        table.insert(result, y)
    end
    return result
end

function RandomPosInCircle(centerPos, radius)
    local angle = math.random() * math.pi * 2
    local distance = math.random() * radius

    local x = centerPos.x + math.cos(angle) * distance
    local y = centerPos.y + math.sin(angle) * distance

    return Vector(x, y)
end
