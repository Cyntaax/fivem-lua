--- @class Vehicle
Vehicle = setmetatable({}, Vehicle)

Vehicle.__index = Vehicle

Vehicle.__call = function()
    return "Vehicle"
end

function Vehicle.new(handle)
    local _Vehicle = {
        Handle = handle,
        PassengerCapacity = GetVehicleMaxNumberOfPassengers(handle),
    }

    return setmetatable(_Vehicle, Vehicle)
end

function Vehicle:Model(model)
    if model == nil then
        return GetEntityModel(self.Handle)
    end
    local pos = self:Position()
    local heading = self:Heading()
    self:Delete(true)
    local newveh = World:CreateVehicle(model,pos, heading,true)

    self.Handle = newveh.Handle
end

---@param wait boolean Whether to actually wait for the vehicle to delete
function Vehicle:Delete(wait)
    SetEntityAsMissionEntity(self.Handle)
    if wait == true then
        DeleteVehicle(self.Handle)
        while DoesEntityExist(self.Handle) do
            Citizen.Wait(5)
        end
        return
    end

    DeleteVehicle(self.Handle)
end


--- @return Vector3
function Vehicle:Position(pos)
    if type(pos) == "table" then
        if pos.X and pos.Y and pos.Z then
            SetEntityCoords(self.Handle, pos.X, pos.Y, pos.Z)
            return
        end
        Error.new("Invalid position"):Print()
    end

    local _pos = GetEntityCoords(self.Handle)
    return Vector3.new(_pos.x, _pos.y, _pos.z)
end

function Vehicle:Heading(heading)
    if type(heading) == "number" then
        SetEntityHeading(self.Handle, heading + 0.0)
        return self:Heading()
    end

    return GetEntityHeading(self.Handle)
end

function Vehicle:GetNetworkOwner()
    return NetPlayer.new(GetPlayerServerId(NetworkGetEntityOwner(self.Handle)))
end

--- opens a vehicle door
--- @param door VehicleDoor the door to open
--- @param loosely boolean to open the door loosely (Optional. Default: false)
--- @param instantly boolean to open the door instantly (Optional. Default true)
function Vehicle:OpenDoor(door, loosely, instantly)
    SetVehicleDoorOpen(self.Handle, door, loosely or false, instantly or false)
end

--- gets the first free seat of the vehicle
--- @return number the the index of the free seat
function Vehicle:GetFreeSeat()
    local maxSeats, freeSeat = self.PassengerCapacity

    for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(self.Handle, i) then
            freeSeat = i
            break
        end
    end
end

function Vehicle:Plate(plate)
    if type(plate) == "string" then
        SetVehicleNumberPlateText(self.Handle, plate)
        return self:Plate()
    end

    return GetVehicleNumberPlateText(self.Handle)
end

function Vehicle:EngineHealth(health)
    if type(health) == "number" then
        SetVehicleEngineHealth(self.Handle, health + 0.0)
        return self:EngineHealth()
    end

    return GetVehicleEngineHealth(self.Handle)
end

function Vehicle:BodyHealth(health)
    if type(health) == "number" then
        SetVehicleBodyHealth(self.Handle, health + 0.0)
        return self:BodyHealth()
    end
    return GetVehicleBodyHealth(self.Handle)
end

function Vehicle:TankHealth(health)
    if type(health) == "number" then
        SetVehiclePetrolTankHealth(self.Handle, health + 0.0)
        return self:TankHealth()
    end
    return GetVehiclePetrolTankHealth(self.Handle)
end

function Vehicle:FuelLevel(fuel)
    if type(fuel) == "number" then
        SetVehicleFuelLevel(self.Handle, fuel + 0.0)
        return self:FuelLevel()
    end

    return GetVehicleFuelLevel(self.Handle)
end

function Vehicle:DirtLevel(dirt)
    if type(dirt) == "number" then
        SetVehicleDirtLevel(self.Handle, dirt)
        return self:DirtLevel()
    end

    return GetVehicleDirtLevel(self.Handle)
end

function Vehicle:GetProperties()
    local _data = {}

    _data.StandardMods = {}

    for k,v in pairs(VehicleMod) do
        if not table.contains(ToggleMods, k) then
            _data.StandardMods[k] = GeVehicleMod(self.Handle, v)
        else
            _data.StandardMods[k] = IsToggleModOn(self.Handle, v)
        end
    end

    _data.Levels = {
        fuel = self:FuelLevel(),
        dirt = self:DirtLevel()
    }

    _data.Health = {
        body = self:BodyHealth(),
        engine = self:EngineHealth(),
        tank = self:TankHealth()
    }
    local c1, c2 = GetVehicleColours(self.Handle)
    local pearlColor, wheelColor = GetVehicleExtraColours(self.Handle)
    _data.Colors = {
        primary = c1,
        secondary = c2,
        pearl = pearlColor,
        wheels = wheelColor
    }

    _data.Extras = {}

    for i = 0, 12 do
        local state = IsVehicleExtraTurnedOn(self.Handle, i) == 1
        _data.Extras[tostring(i)] = state
    end

    _data.Wheels = GetVehicleWheelType(self.Handle)
    _data.windowTint = GetVehicleWindowTint(self.Handle)
    _data.XenonColor = GetVehicleXenonLightsColour(self.Handle)

    _data.Neons = {}

    _data.Neons.Enabled = {}

    for i = 0, 3 do
        table.insert(_data.Neons.Enabled, IsVehicleNeonLightEnabled(self.Handle, i))
    end

    _data.Neons.Color = table.pack(GetVehicleNeonLightsColour(self.Handle))

    _data.TireSmokeColor = table.pack(GetVehicleTyreSmokeColor(self.Handle))

    _data.Livery = GetVehicleLivery(self.Handle)
end



--- @class VehicleDoor
VehicleDoor = {
    FrontLeft = 0,
    FrightRight = 1,
    BackLeft = 2,
    BackRight = 3,
    Hood = 4,
    Trunk = 5,
    Back = 6,
    Back2 = 7
}

VehicleMod = {
    Spoiler = 0,
    FrontBumper = 1,
    RearBumper = 2,
    SideSkirt = 3,
    Exhaust = 4,
    Chassis = 5,
    Grille = 6,
    Hood = 7,
    Fender = 8,
    RightFender = 9,
    Roof = 10,
    Engine = 11,
    Brakes = 12,
    Transmission = 13,
    Horns = 14,
    Suspension = 15,
    Armor = 16,
    Turbo = 18,
    TireSmoke = 20,
    Xenon = 22,
    FrontWheels = 23,
    BackWheels = 24,
    PlateHolder = 25,
    VanityPlate = 26,
    Trim = 27,
    Ornaments = 28,
    Dashboard = 29,
    Dial = 30,
    DoorSpeaker = 31,
    Seats = 32,
    SteeringWheel = 33,
    Shifter = 34,
    Plaque = 35,
    Speakers = 36,
    Trunk = 37,
    Hydraulics = 38,
    EngineBlock = 39,
    AirFilter = 40,
    Struts = 41,
    ArchCover = 42,
    Aerials = 43,
    Trim = 44,
    Tank = 45,
    Windows = 46,
    Livery = 48
}

ToggleMods = {
    "Turbo",
    "TireSmoke",
    "Xenon"
}
