Tests = {}
Lester = {}

if not GetGameTimer then
    GetGameTimer = function()
        return os.time()
    end
end

--- @class Context
Context = setmetatable({}, Context)

Context.__index = Context

Context.__call = function()
    return "Context"
end

function Context.new(parent)
    local _Context = {
        _Parent = parent,
        Tests ={},
        Cleaner = function()

        end
    }
    return setmetatable(_Context, Context)
end

---@param description string
---@param handler fun(context: Context): void
---@return Context
function Context:Should(description, handler)
    table.insert(self.Tests, {
        description = description,
        handler = handler
    })
    return self
end

function Context:Clean(handler)
    self.Cleaner = handler
end

function Context:Assert(val1, val2)
    return val1 == val2
end

---@param description string
---@param handler fun(context: Context): void
---@return Context
function Lester.Describe(description, handler)
    table.insert(Tests, {
        description = description,
        handler = handler
    })
end

function Lester.Assert(val, check)
    return val == check
end

function Lester.Run()
    for k,v in pairs(Tests) do
        local context = v.handler(Context.new())
        local testStr = ColorString.new():LightGreen("Testing: "):LightBlue(v.description):End()
        print(testStr)
        local passed = 0
        local failed = 0
        if type(context) == "table" then
            if context.__call() == "Context" then
                for b,z in pairs(context.Tests) do
                    local startTime = GetGameTimer()
                    local res = z.handler()
                    local endTime = GetGameTimer()
                    local diff = endTime - startTime
                    local seconds = math.floor(diff / 1000)
                    local rawRemainder = diff % 1000
                    local remainder
                    if rawRemainder < 10 then
                        remainder = "00" .. rawRemainder
                    elseif rawRemainder < 100 then
                        remainder = "0" .. rawRemainder
                    end
                    if res == true then
                        if not ColorString then
                            print("    ✅ should " .. z.description .. " ⏱️: " .. diff)
                        else
                            local output = ColorString.new():LightGreen("+ " .. z.description):LightBlue(" => " .. seconds .. "." .. remainder .. "s"):End()
                            print(output)
                        end
                        passed = passed + 1
                    else
                        if not ColorString then
                            print("    ❌ should " .. z.description .. " ⏱️: " .. diff)
                        else
                            local output = ColorString.new():RedOrange("!"  .. z.description):LightBlue(" => " .. seconds .. "." .. remainder .. "s"):End()
                            print(output)
                        end
                        failed = failed + 1
                    end
                end
                context.Cleaner()
            else
                print(ColorString.new():LightYellow("Skipping because of invalid config"))
            end
        else
            print(ColorString.new():LightYellow("Skipping because of invalid config"))
        end

        print("Passed: " .. passed .. " - Failed: " .. failed .. " - " .. (passed / (passed + failed) * 100) .. " % of tests passed")
    end
end

if not Vehicle then
    --- @class Vehicle
    Vehicle = setmetatable({}, Vehicle)

    Vehicle.__index = Vehicle

    Vehicle.__call = function()
        return "Vehicle"
    end

    function Vehicle.new()
        local _Vehicle = {}
        return setmetatable(_Vehicle, Vehicle)
    end
end

function CreateTruck()
    local veh = World:CreateVehicle("panto", Player:ForwardVector(3), 0, true)
    print("Created vehicle", veh)
    Citizen.Wait(2000)
    return veh
end

Lester.Describe("CreateTruck()", function(context)
    local val = CreateTruck()
    context:Should("return an instance of the Vehicle class", function()
        local response = context:Assert(val.__call(), "Vehicle")
        Citizen.Wait(2000)
        return response
    end)

    val:Model("sultan")


    context:Should("have a model equal to 'sultan'", function()
        local response = context:Assert(val:Model(), GetHashKey("sultan"))
        return response
    end)

    context:Clean(function()
        val:Delete()
    end)

    print("Returning ", context)

    return context
end)

Lester.Describe("Getting net player name", function(context)
    local testVehicle = World:CreateVehicle("zentorno",Player:ForwardVector(5), 0, true)
    local owner = testVehicle:GetNetworkOwner():Name()
    print("Owner is", owner)
    context:Should("be owned by Cyntaax", function()
        return context:Assert(owner, "Cyntaax")
    end)

    context:Clean(function()
        testVehicle:Delete()
    end)

    return context
end)

RegisterCommand("test", function()
    Lester.Run()
end)

RegisterCommand('cammit', function()


    local coords = GetGameplayCamCoord()

    local vcoords = Vector3.new(coords.x, coords.y, coords.z)

    local rot = GetGameplayCamRot()

    local rcoords = Vector3.new(rot.x, rot.y, rot.z)

    local tcam = World:CreateCamera(vcoords, rcoords, 120)
    local newpos = tcam:ForwardVector():Multiply(3)
    tcam:Position(newpos)
    tcam:Active(true)
    World:RenderScriptCams(true, true, 300)
end)

Command.new("json"):SetHandler(function()
    local p = NetPlayer.new(GetPlayerServerId(PlayerId()))
    print(json.encode(ToJSON(p)))
end):Register()
