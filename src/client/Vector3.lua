--- @class Vector3
Vector3 = setmetatable({}, Vector3)

Vector3.__index = Vector3

Vector3.__call = function()
    return "Vector3"
end

function Vector3.new(x, y, z)
    local _Vector3 = {
        X = x + 0.0,
        y = y + 0.0,
        Z = z + 0.0
    }
    
    return setmetatable(_Vector3, Vector3)
end