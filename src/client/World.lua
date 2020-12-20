World = {}

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"f \n' end
            s = s .. '['..k..'] = ' .. dump(v) .. ', \n'
        end
        return s .. '} \n'
    else
        return tostring(o)
    end
end

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
        return
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

---@return Camera
function World:CreateCamera(position, rotation, fov)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", position.X, position.Y, position.Z, rotation.X, rotation.Y, rotation.Z, fov, true, 2)
    print("Created Camera", cam)
    return Camera.new(cam)
end

---@param render boolean
---@param ease boolean
---@param easeTime number
function World:RenderScriptCams(render, ease, easeTime)
    RenderScriptCams(render, ease or false, tonumber(easeTime) or 0, true, true)
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
