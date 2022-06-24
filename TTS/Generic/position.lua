function savePosition(p, r)
    local savePos = {
        position = p or self.getPosition(),
        rotation = r or self.getRotation()
    }
    state.savePos = savePos
    saveState()
    self.highlightOn(Color(0.19, 0.63, 0.87), 0.5)
end

function loadPosition()
    local sp = state.savePos
    if sp then
        self.setPositionSmooth(sp.position, false, true)
        self.setRotationSmooth(sp.rotation, false, true)
        self.highlightOn(Color(0.87, 0.43, 0.19), 0.5)
    end
end
