---@class SourcePlayer
SourcePlayer = setmetatable({}, SourcePlayer)

SourcePlayer.__call = function()
    return "SourcePlayer"
end

SourcePlayer.__index = SourcePlayer

local PlayerIdentifiers = {
    SteamID = "steam:",
    DiscordID = "discord:",
    IP = "ip:",
    FiveM = "fivem:",
    License = "license:"
}

function SourcePlayer.new(source)
    local identifiers = {}
    for k,v in pairs(PlayerIdentifiers) do
        local plIds = GetPlayerIdentifiers(source)
        for b,z in pairs(plIds) do
            if string.find(plIds, v) then
                identifiers[k] = z
            end
        end
    end
    local _SourcePlayer = {
        Source = source,
        Identifiers = {
            SteamID = "",
            DiscordID = "",
            IP = "",
            FiveM = "",
            License = ""
        }
    }

    for k,v in pairs(identifiers) do
        _SourcePlayer.Identifiers[k] = v
    end

    return setmetatable(_SourcePlayer, SourcePlayer)
end

function SourcePlayer:Drop(reason)
    if type(reason) ~= "string" then
        Error.new("Drop player expects type string got " .. type(reason)):Print()
        return
    end
    DropPlayer(self.Source, reason)
end
