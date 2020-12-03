--- @class Ped
Ped = setmetatable({}, Ped)

Ped.__index = Ped

Ped.__call = function()
    return "Ped"
end

--- Creates a new instance of the `Ped` class.
function Ped.new(handle)
    local _Ped = {
        Handle = handle,
        Appearance = {
        }
    }

    for k,v in pairs(PedComponent) do
        _Ped.Appearance[k] = function()
            local texture = GetPedTextureVariation(_Ped.Handle, v)
            local drawable = GetPedDrawableVariation(_Ped.Handle, v)
            return drawable, texture
        end

        _Ped.Appearance["Set" .. k] = function(drawable, texture)
            SetPedComponentVariation(_Ped.Handle, v, drawable, texture, 0)
        end
    end

    return setmetatable(_Ped, Ped)
end

--- gets the ped's current appearance data and forms a json object
--- @return string a stringified json object of the ped appearance data
function Ped:AppearanceJSON()
    local tmpTable = {}
    for k,v in pairs(PedComponent) do
        local drawable, texture = self.Appearance[k]()
        tmpTable[k] = {
            drawables = drawable,
            textures = texture
        }
    end
    return json.encode(tmpTable)
end

--- Gets or sets the ped's current health
--- @param health number | nil value to set current health to.
--- If `nil`, returns the peds health
--- @return number the ped's current health
function Ped:Health(health)
    if type(health) ~= "number" then
        return GetEntityHealth(self.Handle)
    end
    SetEntityHealth(self._Handle, health + 0.0)
    return self:Health()
end

--- Gets or sets the ped's current position
--- @param position Vector3 | nil the position to set. If `nil`, returns the current position
--- @return Vector3
function Ped:Position(position)
    if type(position) ~= "table" then
        local rawpos = GetEntityCoords(self._Handle)
        local posVec = Vector3.new(rawpos.x, rawpos.y, rawpos.z)
        return posVec
    end

    SetEntityCoords(self.Handle, position.x, position.y, position.z)
end

--- Gets or sets the ped's current armor
--- @param armor number | nil the value to set current armor to. If `nil`, returns the current armor
function Ped:Armor(armor)
    if type(armor) ~= "number" then
        return GetPedArmour(self.Handle)
    end

    SetPedArmour(self.Handle, armor)
end

PedComponent = {
    Face = 0,
    Mask = 1,
    Hair = 2,
    Torso = 3,
    Leg = 4,
    Bag = 5,
    Shoes = 6,
    Accessory = 7,
    Undershirt = 8,
    Kevlar = 9,
    Badge = 10,
    Torso2 = 11
}