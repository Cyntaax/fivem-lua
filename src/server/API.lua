--- @class ServerPlayer
ServerPlayer = setmetatable({}, ServerPlayer)

ServerPlayer.__index = ServerPlayer

ServerPlayer.__call = function()
    return "ServerPlayer"
end

function ServerPlayer.new(serverId)
    local _ServerPlayer = {
        ServerID = serverId,
        _Health = 0
    }
    return setmetatable(_ServerPlayer, ServerPlayer)
end

function ServerPlayer:Health(health)
    health = tonumber(health)
    if type(health) ~= "number" then
        return self._Health
    end

    print("My server id", self.ServerID)

    TriggerClientEvent("fivem-lua:api:dispatch", self.ServerID, "Player", "Health", health)
end

---@return ServerPlayer
function MarshallPlayer(player)
    if type(player.ServerID) ~= "number" then
        return
    end

    local iplayer = ServerPlayer.new(player.ServerID)

    for k,v in pairs(player) do
        if iplayer["_" .. k] ~= nil then
            iplayer["_" .. k] = v
        end
    end

    for k,v in pairs(player.Ped) do
        if iplayer["_" .. k] ~= nil then
            iplayer["_" .. k] = v
        end
    end

    return iplayer
end

API = {
    Handlers = {}
}

---@param event string
---@param handler fun(player: ServerPlayer, ...:any): void
function API:On(event, handler)
    self.Handlers[event] = handler
end

RegisterServerEvent("fivem-lua:api:on")
AddEventHandler("fivem-lua:api:on", function(event, player, ...)
    local source = source
    if API.Handlers[event] == nil then
        print("^2Error: Event not found (" .. event .. ")^0")
        return
    end
    print("player", json.encode(player))
    local marshalled = MarshallPlayer(player)

    API.Handlers[event](marshalled, ...)
end)

