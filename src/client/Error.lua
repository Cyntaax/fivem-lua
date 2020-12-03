ErrorCache = {}

--- @class Error
Error = setmetatable({}, Error)

Error.__index = Error

Error.__call = function()
    return "Error"
end

--- Creates a new instance of the `Error` class
--- @param message string The content of this error message
function Error.new(message)
    local _Error = {
        Message = message
    }
    table.insert(ErrorCache, message)
    return setmetatable(_Error, Error)
end

--- Prints the error message
function Error:Print()
    print("^1" .. self.Message)
end

Events:On('errors_get' .. GetCurrentResourceName(), function(cb)
    cb(ErrorCache)
end)
