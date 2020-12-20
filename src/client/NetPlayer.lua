--- @class NetPlayer
NetPlayer = setmetatable({}, NetPlayer)

NetPlayer.__index = NetPlayer

NetPlayer.__call = function()
    return "NetPlayer"
end

function NetPlayer.new(serverId)
    local _NetPlayer = {
        ServerID = serverId,
        LocalID = GetPlayerFromServerId(serverId),
        Ped = Ped.new(GetPlayerPed(GetPlayerFromServerId(serverId)))
    }

    _NetPlayer._Name = GetPlayerName(_NetPlayer.LocalID)

    return setmetatable(_NetPlayer, NetPlayer)
end

---@return Ped
function NetPlayer:GetPed()
    return self.Ped
end

---@return string
function NetPlayer:Name()
    return self._Name
end

---@param entity table|number
---@return boolean
function NetPlayer:OwnsEntity(entity)
    if entity == nil then return end
    local checker
    if type(entity) == "table" then
        if type(entity.Handle) == "number" then
            checker = entity
        end
    elseif type(tonumber(entity)) == "number" then
        checker = tonumber(entity)
    else
        Error.new("Invalid entity. Please pass an instance of an entity or a handle"):Print()
        return false
    end

    return self:GetPed().Handle == NetworkGetEntityOwner(checker)
end
