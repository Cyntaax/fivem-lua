--- @class Model
Model = setmetatable({}, Model)

Model.__index = Model

Model.__call = function()
    return "Model"
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
    if not IsModelValid(self.Hash) then
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
