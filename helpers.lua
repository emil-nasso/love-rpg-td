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
