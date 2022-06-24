string.startswith = function(self, str)
    return self:find('^' .. str) ~= nil
end

string.endswith = function(self, str)
    return self:find(str .. "$") ~= nil
end
