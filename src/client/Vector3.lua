--- @class Vector3
Vector3 = setmetatable({}, Vector3)

Vector3.__index = Vector3

Vector3.__call = function()
    return "Vector3"
end

--- Creates an instance of the `Vector3` class
--- @param x number
--- @param y number
--- @param z number
function Vector3.new(x, y, z)
    local _Vector3 = {
        X = x + 0.0,
        Y = y + 0.0,
        Z = z + 0.0
    }

    return setmetatable(_Vector3, Vector3)
end

--- Gets the distance between two Vector3
---@param pos Vector3
---@return number
function Vector3:DistanceTo(pos)
    return #(pos:Native() - self:Native())
end

function Vector3:Native()
    return vector3(self.X, self.Y, self.Z)
end
