Command = setmetatable({}, Command)

Command.__index = Command

Command.__call = function()
    return "Command"
end

--- @class CommandOptions
CommandOptions = {
    --- @type string
    Default = ""
}

function Command.new(trigger)
    local _Command = {
        Trigger = trigger,
        ArgsList = {},
        Restrictors = {},
        Handler = nil
    }

    return setmetatable(_Command, Command)
end

--- @param name string
---@param options CommandOptions
function Command:String(name, options)
    table.insert(self.ArgsList, {
        type = "string",
        name = name
    })
    return self
end

function Command:Number(name)
    table.insert(self.ArgsList, {
        type = "number",
        name = name
    })
    return self
end

function Command:Boolean(name)
    table.insert(self.ArgsList, {
        type = "boolean",
        name = name
    })
    return self
end

--- @param handler fun(source: number): boolean
function Command:Restrict(handler)
    table.insert(self.Restrictors, handler)
    return self
end

--- @param handler fun(source: number)
function Command:SetHandler(handler)
    self.Handler = handler
    return self
end

function Command:Register()
    RegisterCommand(self.Trigger, function(source, args)
        local numRestrict = #self.Restrictors
        local passed = 0
        for k,v in pairs(self.Restrictors) do
            local val = v()
            if val == true then
                passed = passed + 1
            end
        end

        if passed ~= numRestrict then
            Error.new("Restrictors failed for command", self.Trigger):Print()
            return
        end

        for k,v in pairs(self.ArgsList) do
            if v.type == "boolean" then
                if args[k] == "true" or args[k] == "false" or args[k] == "1" or args[k] == "0" then
                    if args[k] == "true" then args[k] = true end
                    if args[k] == "1" then args[k] = true end
                    if args[k] == "false" then args[k] = false end
                    if args[k] == "0" then args[k] = false end
                end
            elseif v.type == "number" then
                local out = tonumber(args[k])
                if out == nil then
                    Error.new("Could not assert to number"):Print()
                    return
                end
                args[k] = out
            end
        end
        print(json.encode(args))
        self.Handler(source, table.unpack(args))
    end)
end


