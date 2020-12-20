---@class Camera
Camera = setmetatable({}, Camera)

Camera.__index = Camera

Camera.__call = function()
    return "Camera"
end

function Camera.new(handle)
    local _Camera = {
        Handle = handle
    }

    return setmetatable(_Camera, Camera)
end

---@param position Vector3
---@return Vector3
function Camera:Position(position)
    if position == nil then
        local pos = GetCamCoord(self.Handle)
        return Vector3.new(pos.x, pos.y, pos.z)
    end

    SetCamCoord(self.Handle,position.X, position.Y, position.Z)
    return self:Position()
end

---@param rotation Vector3
---@return Vector3
function Camera:Rotation(rotation)
    if rotation == nil then
        local rot = GetCamRot(self.Handle, 2)
        return Vector3.new(rot.x, rot.y, rot.z)
    end

    SetCamRot(self.Handle, rotation.X, rotation.Y, rotation.Z)
    return self:Rotation()
end

---@return Vector3
function Camera:ForwardVector()
    local rotation = self:Rotation():Multiply(math.pi / 180)
    local normalized = Vector3.new(
            -math.sin(rotation.X) * math.abs(math.cos(rotation.X)),
    math.cos(rotation.Z * math.abs(math.cos(rotation.X))),
    math.sin(rotation.X))

    return Vector3.new(normalized.X, normalized.Y, normalized.Z)
end

function Camera:FieldOfView(fov)
    if fov == nil then
        return GetCamFov(self.Handle)
    end

    SetCamFov(self.Handle, fov)
    return self:FieldOfView()
end

---@param target Ped|Vehicle|Vector3
function Camera:PointAt(target, offset)
    if type(target) == "table" then
        if not target.__call then
            print("Error")
            return
        end
        if target.__call() == "Ped" or target.__call() == "Vehicle" then
            PointCamAtEntity(self.Handle, target.Handle, offset.X, offset.y, offset.Z, true)
        elseif target.__call() == "Vector3" then
            PointCamAtCoord(self.Handle, target.X, target.Y, target.Z)
        end
    end
end

function Camera:StopPointing()
    StopCamPointing(self.Handle)
end

function Camera:InterpTo(to, duration, easePosition, easeRotation)
    SetCamActiveWithInterp(to.Handle, self.Handle, duration, tonumber(easePosition) or 0, tonumber(easeRotation) or 0)
end

function Camera:Active(val)
    if type(val) == "boolean" then
        SetCamActive(self.Handle, val)
        return self:Active()
    end

    return IsCamActive(self.Handle)
end

function Camera:IsInterpolating()
    return IsCamInterpolating(self.Handle)
end
