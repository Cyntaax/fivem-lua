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

function Context.new()
    local _Context = {
        Tests ={}
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
        print(v.description)
        if type(context) == nil then
            print("Context not return. Be sure to return context at the end of Describe")
            return
        end
        local passed = 0
        local failed = 0
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
                    local output = ColorString.new():LightGreen("✅ " .. z.description):LightBlue(" ⏱️: " .. seconds .. "." .. remainder .. "s"):End()
                    print(output)
                end
                passed = passed + 1
            else
                if not ColorString then
                    print("    ❌ should " .. z.description .. " ⏱️: " .. diff)
                else
                    local output = ColorString.new():RedOrange("    ❌" .. z.description):LightBlue(" ⏱️: " .. seconds .. "." .. remainder .. "s"):End()
                    print(output)
                end
                failed = failed + 1
            end
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
    local veh = World:CreateVehicle("panto", Player:Position(), 0, true)
    Citizen.Wait(2000)
    return veh
end

Lester.Describe("CreateTruck()", function(context)
    context:Should("return an instance of the Vehicle class", function()
        local val = CreateTruck()
        local response = context:Assert(val.__call(), "Vehicle")
        val:Delete()
        return response
    end)

    context:Should("have a model equal to 'panto'", function()
        local val = CreateTruck()
        local response = context:Assert(val:Model(), GetHashKey("panto"))
        val:Delete()
        return response
    end)

    return context
end)

RegisterCommand("test", function()
    Lester.Run()
end)

