--- @class Player
Player = setmetatable({}, nil)

Player.__index = Player

Player.__call = function()
    return "Player"
end

function Player.new()
    local _Player = {

    }

    local ped = Ped.new(PlayerPedId())

    for k,v in pairs(ped) do
        print("assigning", k, v)
        _Player[k] = v
    end

    local mt = getmetatable(ped)

    for k,v in pairs(mt) do
        if k ~= "__call" and k ~= "__index" and k ~= "new" then
            print("assigning", k)
            _Player[k] = v
        end
    end

    return setmetatable(_Player, Player)
end

Player = Player.new()
