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

---@param vec Vector3
---@return Vector3
function Vector3:Subtract(vec)
    return Vector3.new(self.X - vec.X, self.Y - vec.Y, self.Z - vec.Z)
end

---@param vec Vector3|number
function Vector3:Add(vec)
    ---@type number|nil
    local fvec = tonumber(vec)
    if type(fvec) == "number" then
        return Vector3.new(self.X + fvec, self.Y + fvec, self.Z + fvec)
    end
    return Vector3.new(self.X + vec.X, self.Y + vec.Y, self.Z + vec.Z)
end

function Vector3:Multiply(vec)
    local fvec = tonumber(vec)
    if type(fvec) == "number" then
        return Vector3.new(self.X * fvec, self.Y * fvec, self.Z * fvec)
    end

    return Vector3.new(self.X * vec.X, self.Y * vec.Y, self.Z * vec.Z)
end

function Vector3:Divide(vec)
    local fvec = tonumber(vec)
    if type(fvec) == "number" then
        return Vector3.new(self.X / vec, self.Y / vec, self.Z / vec)
    end
    return Vector3.new(self.X / vec.X, self.Y / vec.Y, self.Z / vec.Z)
end

function Vector3:DotProduct(vec)
    return self.X * vec.X + self.Y + vec.Y, self.Z + vec.Z
end

function Vector3:CrossProduct(vec)
    local x = self.Y * vec.Z - self.Z * vec.Y;
    local y = self.Y * vec.x - self.Z * vec.Y;
    local z = self.Y * vec.y - self.Z * vec.X;

    return Vector3.new(x,y,z)
end

function Vector3:DistanceSquared(vec)
    local nvec = self:Subtract(vec)
    return self:DotProduct(nvec)
end

function Vector3:Length()
    return self:DistanceSquared(self)
end

function Vector3:Normalize()
    return self:Divide(self, self:Length())
end

---@class Vec3
Vec3 = {
    ---@type number
    x = 0,
    ---@type number
    x = 0,
    ---@type number
    x = 0
}
