function ToJSON(object)
    local tmp = {}

    local mt = getmetatable(object)
    for k,v in pairs(mt) do
        if k ~= "__call" and k ~= "__index" and k ~= "new" then
            tmp[k] = v(object)
        end
    end

    for k,v in pairs(object) do
        if type(v) == "function" then
            tmp[k] = v()
        elseif type(v) == "table" then
            local tmp2 = {}
            local mt2 = getmetatable(v)
            if mt2 ~= nil then
                for b,z in pairs(mt2) do
                    if b ~= "_call" and b ~= "__index" and b~= "new" then
                        tmp2[b] = z(v)
                    end
                end
                tmp[k] = tmp2
            else
                tmp[k] = v
            end
        else
            tmp[k] = v
        end
    end

    return tmp
end

API = {}

function API:Emit(event, ...)
    local np = NetPlayer.new(GetPlayerServerId(PlayerId()))
    local no = ToJSON(np)

    TriggerServerEvent("fivem-lua:api:on", event, no, ...)
end

function API:Receive(target, func, ...)
    if type(_G[target]) == nil then
        Error.new("Invalid target " .. target):Print()
        return
    end

    if target == "Player" then
        _G[target][func](Player, ...)
    end
end

RegisterNetEvent("fivem-lua:api:dispatch")
AddEventHandler("fivem-lua:api:dispatch", function(target, func, ...)
    API:Receive(target, func, ...)
end)
