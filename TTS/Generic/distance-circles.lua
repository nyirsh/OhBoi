function onNumberTyped(pc, n)
    rangeShown = n > 0
    measureColor = Color.fromString(pc)
    measureRange = n

    scaleFactor = 1 / self.getScale().x

    if lastRange == measureRange then
        sphereRange = getCircleVectorPoints(measureRange - modelMeasureLineRadius + 0.05, 0.125, 1)[1].x * 2 /
                          scaleFactor
        Physics.cast({
            origin = self.getPosition(),
            direction = {0, 1, 0},
            type = 2,
            size = {sphereRange, sphereRange, sphereRange},
            max_distance = 0,
            debug = true
        })
    end
    lastRange = measureRange
    refreshVectors()
    Player[pc].broadcast(string.format("%d\"", measureRange))
end

function getCircleVectorPoints(radius, height, segments)
    local bounds = self.getBoundsNormalized()
    local result = {}
    local scaleFactorX = 1 / self.getScale().x
    local scaleFactorY = 1 / self.getScale().y
    local scaleFactorZ = 1 / self.getScale().z
    local steps = segments or 64
    local degrees, sin, cos, toRads = 360 / steps, math.sin, math.cos, math.rad
    local modelBase = state.base

    local mtoi = 0.0393701
    local baseX = modelBase.x * 0.5 * mtoi
    local baseZ = modelBase.z * 0.5 * mtoi

    for i = 0, steps do
        table.insert(result, {
            x = cos(toRads(degrees * i)) * ((radius + baseX) * scaleFactorX),
            z = sin(toRads(degrees * i)) * ((radius + baseZ) * scaleFactorZ),
            y = height * scaleFactorY
        })
    end

    return result
end

function refreshVectors(norotate)
    local op = getOwningPlayer()
    local circ = {}
    local scaleFactor = 1 / self.getScale().x

    local rotation = self.getRotation()

    local newLines = {{
        points = getCircleVectorPoints(0 - baseLineRadius, baseLineHeight),
        color = op and Color.fromString(op.color) or {0.5, 0.5, 0.5},
        thickness = baseLineRadius * 2 * scaleFactor
    }}

    if rangeShown then
        if measureRange > 0 then
            table.insert(newLines, {
                points = getCircleVectorPoints(measureRange - modelMeasureLineRadius + 0.05, 0.125),
                color = measureColor,
                thickness = modelMeasureLineRadius * 2 * scaleFactor,
                rotation = (norotate and {0, 0, 0} or {-rotation.x, 0, -rotation.z})
            })
        else
            for _, r in pairs(ranges) do
                local range = r.range
                table.insert(newLines, {
                    points = getCircleVectorPoints(range - modelMeasureLineRadius + 0.05, 0.125),
                    color = r.color,
                    thickness = modelMeasureLineRadius * 2 * scaleFactor,
                    rotation = (norotate and {0, 0, 0} or {-rotation.x, 0, -rotation.z})
                })
            end
        end
    end

    self.setVectorLines(newLines)
end
