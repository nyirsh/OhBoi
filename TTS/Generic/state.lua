state = {}

function saveState()
    self.script_state = JSON.encode(state)
end

function loadState()
    state = JSON.decode(self.script_state)
end
