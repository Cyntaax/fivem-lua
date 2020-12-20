ErrorCache = {}

--- @class Error
Error = setmetatable({}, Error)

Error.__index = Error

Error.__call = function()
    return "Error"
end

--- Creates a new instance of the `Error` class
--- @param message string The content of this error message
function Error.new(message)
    local _Error = {
        Message = message
    }
    table.insert(ErrorCache, message)
    return setmetatable(_Error, Error)
end

--- Prints the error message
function Error:Print()
    print("^1" .. self.Message)
end

Events:On('errors_get' .. GetCurrentResourceName(), function(cb)
    cb(ErrorCache)
end)


Events = {}

--- Creates a non-networked event
--- @param eventName string Th name of the event
--- @param eventHandler fun(...):nil The handler for this event
function Events:On(eventName, eventHandler)
    AddEventHandler(eventName, eventHandler)
end

--- Creates a networked event
--- @param eventName string The name of the event
--- @param eventHandler fun(...):nil The handler for this event
function Events:OnNet(eventName, eventHandler)
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, eventHandler)
end

--- Triggers a non-networked event
--- @param eventName string The event to trigger
function Events:Emit(eventName, ...)
    TriggerEvent(eventName, ...)
end

--- Triggers a networked event
--- @param eventName string The event to trigger
function Events:EmitNet(eventName, ...)
    TriggerServerEvent(eventName, ...)
end



Marker = setmetatable({}, Marker)

Marker.__index = Marker

Marker.__call = function()
    return "Marker"
end

--- @param markerType MarkerType
--- @param color table e.g. { 255, 255, 255, 255 } 
--- @param position table
--- @param direction table
--- @param rotation table
--- @param scale table
--- @param bobble boolean
--- @param faceCamera boolean
--- @param param19 boolean
--- @param textureDict string
--- @param textureName string
--- @param drawOnEntity boolean
function Marker.new(
        markerType,
        color,
        position,
        direction,
        scale,
        rotation,
        bobble,
        faceCamera,
        param19,
        textureDict,
        textureName,
        drawOnEntity
)
    _Marker = {
        _Color = color or { 255.0, 255.0, 255.0, 255.0 },
        _MarkerType = markerType or MarkerType.CircleSkinny,
        _Position = position or {},
        _Direction = direction or {},
        _Rotation = rotation or 0,
        _Bobble = bobble or false,
        _FaceCamera = faceCamera or false,
        _Param19 = param19 or 0,
        _Rotate = rotate or 0,
        _TextureDict = textureDict or "",
        _TextureName = textureName or "",
        _DrawOnEntity = drawOnEntity or false,
        _Scale = scale or { 1.0, 1.0, 1.0 },
        _Drawing = false
    }
    
    return setmetatable(_Marker, Marker)
end

function table.valsToFloat(input)
    for i = 1, #input, 1 do
        if type(input[i]) == "number" then
            input[i] = input[i] + 0.0
        end
    end
    
    return input
end

--- Draws the marker. Creates its own thread, only needs run once.
function Marker:Draw()
    if self._Drawing == true then
        return
    end
    
    self._Drawing = true
    Citizen.CreateThread(function()
        while self._Drawing == true do
            Citize.Wait(0)
            DrawMarker(
                    self._MarkerType,
                    self._Position[1],
                    self._Position[2],
                    self._Position[3],
                    self._Direction[1],
                    self._Direction[2],
                    self._Direction[3],
                    self._Rotation[1],
                    self._Rotation[2],
                    self._Rotation[3],
                    self._Scale[1],
                    self._Scale[2],
                    self._Scale[3],
                    self._Color[1],
                    self._Color[2],
                    self._Color[3],
                    self._Color[4],
                    self._Bobble,
                    self._FaceCamera,
                    self._Param19,
                    self._TextureDict,
                    self._TextureName,
                    self._DrawOnEntity
            )
        end
    end)
end

--- Stops the marker from being drawn
function Marker:Destroy()
    self._Drawing = false
end

--- Gets or sets the color of the marker
--- @param color table | nil the current color value. If `nil`, returns the current color value
function Marker:Color(color)
    if color == nil then
        return self._Color
    end

    if type(color) == "table" then
        if #color ~= 4 then
            print("^1Error setting color:^0 Requires 4 fields, but got " .. #color)
            return
        end
        
        color = table.valsToFloat(color)
        
        self._Color = color
        
        return self._Color
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(color) .. ")")
    end
end

function Marker:Position(position)
    if position == nil then
        return self._Position
    end

    if type(position) == "table" then
        if #position ~= 3 then
            print("^1Error setting color:^0 Requires 3 fields, but got " .. #position)
            return
        end

        position = table.valsToFloat(position)

        self._Position = position

        return self._Position
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(position) .. ")")
    end
end

function Marker:Direction(direction)
    if direction == nil then
        return self._Direction
    end

    if type(direction) == "table" then
        if #direction ~= 3 then
            print("^1Error setting color:^0 Requires 3 fields, but got " .. #direction)
            return
        end

        direction = table.valsToFloat(direction)

        self._Direction = direction

        return self._Direction
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(direction) .. ")")
    end
end

function Marker:Scale(scale)
    if scale == nil then
        return self._Scale
    end

    if type(scale) == "table" then
        if #scale ~= 3 then
            print("^1Error setting color:^0 Requires 3 fields, but got " .. #scale)
            return
        end

        scale = table.valsToFloat(scale)

        self._Scale = scale

        return self._Scale
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(scale) .. ")")
    end
end

local testMarker = Marker.new(MarkerType.CarSymbol)

testMarker:Draw()

function Marker:Rotation(rotation)
    if rotation == nil then
        return self._Rotation
    end

    if type(rotation) == "table" then
        if #rotation ~= 3 then
            print("^1Error setting color:^0 Requires 3 fields, but got " .. #rotation)
            return
        end

        rotation = table.valsToFloat(rotation)

        self._Rotation = rotation

        return self._Rotation
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(rotation) .. ")")
    end
end

function Marker:Bobble(bobble)
    if bobble == nil then
        return self._Bobble
    end

    if type(bobble) == "boolean" then
        self._Bobble = bobble
        return self._Bobble
    else
        print("^Error: Invalid type.^0 Expected (boolean) got (" .. type(bobble) .. ")")
    end
end

function Marker:FaceCamera(faceCamera)
    if faceCamera == nil then
        return self._FaceCamera
    end

    if type(faceCamera) == "boolean" then
        self._FaceCamera = faceCamera
        return self._FaceCamera
    else
        print("^Error: Invalid type.^0 Expected (boolean) got (" .. type(faceCamera) .. ")")
    end
end

function Marker:Rotate(rotate)
    if rotate == nil then
        return self._Rotate
    end

    if type(rotate) == "boolean" then
        self._Rotate = rotate
        return self._Rotate
    else
        print("^Error: Invalid type.^0 Expected (boolean) got (" .. type(rotate) .. ")")
    end
end

function Marker:MarkerType(markerType)
    if markerType == nil then
        return self._MarkerType
    end

    if type(markerType) == "number" then
        local valid = false
        for k,v in pairs(MarkerType) do
            if v == markerType then
                valid = true
                break
            end
        end

        if valid == false then
            print("^1Error: Marker type not found")
            return
        end
        
        self._MarkerType = markerType
    end
end



local marker = Marker.new(
        MarkerType.CircleSkinny,
        { 255, 255, 255, 255 },
        { 0, 0, 0 },
        { 0, 0, 0 },
        { 1.0, 1.0, 1.0 },
        { 0.0, 0.0, 0.0 },
        false,
        false
)

--- @class MarkerType
MarkerType = {
    --- [Image Reference](https://docs.fivem.net/markers/0.png)
    UpsideDownCone = 0,
    --- [Image Reference](https://docs.fivem.net/markers/1.png)
    VerticalCylinder = 1,
    --- [Image Reference](https://docs.fivem.net/markers/2.png)
    ThickChevronUp = 2,
    --- [Image Reference](https://docs.fivem.net/markers/3.png)
    ThinChevronUp = 3,
    --- [Image Reference](https://docs.fivem.net/markers/4.png)
    CheckeredFlagRect = 4,
    --- [Image Reference](https://docs.fivem.net/markers/5.png)
    CheckeredFlagCircle = 5,
    --- [Image Reference](https://docs.fivem.net/markers/6.png)
    VerticleCircle = 6,
    --- [Image Reference](https://docs.fivem.net/markers/7.png)
    PLaneModel = 7,
    --- [Image Reference](https://docs.fivem.net/markers/8.png)
    LostMCTransparent = 8,
    --- [Image Reference](https://docs.fivem.net/markers/9.png)
    LostMC = 9,
    --- [Image Reference](https://docs.fivem.net/markers/10.png)
    Number0 = 10,
    --- [Image Reference](https://docs.fivem.net/markers/11.png)
    Number1 = 11,
    --- [Image Reference](https://docs.fivem.net/markers/12.png)
    Number2 = 12,
    --- [Image Reference](https://docs.fivem.net/markers/13.png)
    Number3 = 13,
    --- [Image Reference](https://docs.fivem.net/markers/14.png)
    Number4 = 14,
    --- [Image Reference](https://docs.fivem.net/markers/15.png)
    Number5 = 15,
    --- [Image Reference](https://docs.fivem.net/markers/16.png)
    Number6 = 16,
    --- [Image Reference](https://docs.fivem.net/markers/17.png)
    Number7 = 17,
    --- [Image Reference](https://docs.fivem.net/markers/18.png)
    Number8 = 18,
    --- [Image Reference](https://docs.fivem.net/markers/19.png)
    Number9 = 19,
    --- [Image Reference](https://docs.fivem.net/markers/20.png)
    ChevronUpx1 = 20,
    --- [Image Reference](https://docs.fivem.net/markers/21.png)
    ChevronUpx2 = 21,
    --- [Image Reference](https://docs.fivem.net/markers/22.png)
    ChevronUpx3 = 22,
    --- [Image Reference](https://docs.fivem.net/markers/23.png)
    HorizontalCircleFat = 23,
    --- [Image Reference](https://docs.fivem.net/markers/24.png)
    ReplayIcon = 24,
    --- [Image Reference](https://docs.fivem.net/markers/25.png)
    CircleSkinny = 25,
    --- [Image Reference](https://docs.fivem.net/markers/26.png)
    CircleSkinny_Arrow = 26,
    --- [Image Reference](https://docs.fivem.net/markers/27.png)
    HorizontalSplitArrowCircle = 27,
    --- [Image Reference](https://docs.fivem.net/markers/28.png)
    DebugSphere = 28,
    --- [Image Reference](https://docs.fivem.net/markers/29.png)
    DollarSign = 29,
    --- [Image Reference](https://docs.fivem.net/markers/30.png)
    HorizontalBars = 30,
    --- [Image Reference](https://docs.fivem.net/markers/31.png)
    WolfHead = 31,
    --- [Image Reference](https://docs.fivem.net/markers/32.png)
    QuestionMark = 32,
    --- [Image Reference](https://docs.fivem.net/markers/33.png)
    PlaneSymbol = 33,
    --- [Image Reference](https://docs.fivem.net/markers/34.png)
    HelicopterSymbol = 34,
    --- [Image Reference](https://docs.fivem.net/markers/35.png)
    BoatSymbol = 35,
    --- [Image Reference](https://docs.fivem.net/markers/36.png)
    CarSymbol = 36,
    --- [Image Reference](https://docs.fivem.net/markers/37.png)
    MotorcycleSymbol = 37,
    --- [Image Reference](https://docs.fivem.net/markers/38.png)
    BikeSymbol = 38,
    --- [Image Reference](https://docs.fivem.net/markers/39.png)
    TruckSymbol = 39,
    --- [Image Reference](https://docs.fivem.net/markers/40.png)
    ParachuteSymbol = 40,
    --- [Image Reference](https://docs.fivem.net/markers/41.png)
    JetPack = 41,
    --- [Image Reference](https://docs.fivem.net/markers/42.png)
    SawbladeSymbol = 42,
    --- [Image Reference](https://docs.fivem.net/markers/43.png)
    Unknown = 43
}

--- @class Model
Model = setmetatable({}, Model)

Model.__index = Model

Model.__call = function()
    return "Vector3"
end

--- @param model number | string the model hash or name
function Model.new(model)
    if type(model) == "string" then
        if tonumber(model) ~= nil then
            model = GetHashKey(model)
        end
    end
    local _Model = {
        Raw = model,
        Hash = model
    }
    
    return setmetatable(_Model, Model)
end

function Model:Load()
    if not IsModelInCdImage(self.Hash) then
        print("^1Error: Invalid model " .. self.Hash)
    end

    RequestModel(self.Hash)
    local time = GetGameTimer()
    while not HasModelLoaded(self.Hash) do
        if GetGameTimer() - time > 5000 then
            print("^1Error: Failed to load model " .. self.Hash)
            return false
        end
        Wait(100)
    end
    
    return true
end

function Model:Unload()
    SetModelAsNoLongerNeeded(self.Hash)
end

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
        y = y + 0.0,
        Z = z + 0.0
    }
    
    return setmetatable(_Vector3, Vector3)
end

--- @class Vehicle
Vehicle = setmetatable({}, Vehicle)

Vehicle.__index = Vehicle

Vehicle.__call = function()
    return "Vehicle"
end

function Vehicle.new(handle)
    local _Vehicle = {
        Handle = handle,
        PassengerCapacity = GetVehicleMaxNumberOfPassengers(handle)
    }
    
    return setmetatable(_Vehicle, Vehicle)
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

World = {}

--- creates a vehicle in the world at a given position
--- @param model number | string the model of the vehicle to spawn
--- @param position Vector3 the position to spawn the vehicle at
--- @param heading number the heading of the vehicle (optional. Default: `true`)
--- @param networked boolean  whether the vehicle will be networked (optional. Default: `true`)
--- @return Vehicle
function World:CreateVehicle(model, position, heading, networked)
    local vehModel = Model.new(model)
    if not vehModel:Load() then return end
    local veh = CreateVehicle(vehModel.Hash, position.X, position.Y, position.Z, heading or 0, networked or true, true)
    vehModel:Unload()
    if veh == 0 then
        print("^1Error: An Unknown error happened while creating the vehicle")
    end
    
    return Vehicle.new(veh)
end

--- Creates a ped in the world
--- @param model number | string the model hash
--- @param position Vector3 the position to spawn the ped at
--- @param heading number | nil the heading to of the ped (optional. Default `0.0`)
--- @param networked boolean | nil whether to create the ped as a networked entity (optional. Default: `true`)
--- @return Ped
function World:CreatePed(model, position, heading, networked, pedType)
    local pedModel = Model.new(model)
    if not pedModel:Load() then return end
    local ped = CreatePed(pedType or PedType.CIVMALE, pedModel.Hash, position.x, position.y, position.z, heading or 0.0, networked or true)
    pedModel:Unload()

    if ped == 0 then
        return Error.new("Failed to create ped"):Print()
    end

    return Ped.new(ped)
end

function World:Weather(weatherType)
    if type(weatherType) == "string" then
        for k,v in pairs(WeatherType) do
            if v == weatherType then
                return SetWeatherTypeNow(weatherType)
            end
        end

        return Error.new("Invalid weather type"):Print()
    end

end

PedType = {
    PLAYER_0 = 0,
    PLAYER_1 = 1,
    NETWORK_PLAYER = 2,
    PLAYER_2 = 3,
    CIVMALE = 4,
    CIVFEMALE = 5,
    COP = 6,
    GANG_ALBANIAN = 7,
    GANG_BIKER_1 = 8,
    GANG_BIKER_2 = 9,
    GANG_ITALIAN = 10,
    GANG_RUSSIAN = 11,
    GANG_RUSSIAN_2 = 12,
    GANG_IRISH = 13,
    GANG_JAMAICAN = 14,
    GANG_AFRICAN_AMERICAN = 15,
    GANG_KOREAN = 16,
    GANG_CHINESE_JAPANESE = 17,
    GANG_PUERTO_RICAN = 18,
    DEALER = 19,
    MEDIC = 20,
    FIREMAN = 21,
    CRIMINAL = 22,
    BUM = 23,
    PROSTITUTE = 24,
    SPECIAL = 25,
    MISSION = 26,
    SWAT = 27,
    ANIMAL = 28,
    ARMY = 29
}

WeatherType = {
    Clear = "CLEAR",
    ExtraSunny = "EXTRASUNNY",
    Clouds = "CLOUDS",
    Overcast = "OVECAST",
    Rain = "RAIN",
    Clearing = "CLEARING",
    Thunder = "THUNDER",
    Smog = "SMOG",
    Foggy = "FOGGY",
    Christmas = "XMAS",
    LightSnow = "SNOWLIGHT",
    Blizzard = "BLIZZARD"
}

