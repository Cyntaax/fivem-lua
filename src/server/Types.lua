---@class Deferrals
Deferrals = {}

--- deferrals.defer will initialize deferrals for the current resource. It is required to wait for at least a tick after calling defer before calling update, presentCard or done
Deferrals.defer = function()

end

--- will send a progress message to the connecting client
---@param message string
Deferrals.update = function(message)

end

--- will send an Adaptive Card to the client
---@param card table|string be an object containing card data, or a serialized JSON string with the card information.
---@param cb fun(data: table, rawData: string): void  if present, will be invoked on an Action.Submit event from the Adaptive Card
Deferrals.presentCard = function(card, cb)

end

--- finalizes a deferral. It is required to wait for at least a tick before calling done after calling a prior deferral method.
---@param failureReason string|nil If failureReason is specified, the connection will be refused, and the user will see the specified message as a result. If this is not specified, the user will be allowed to connect.
Deferrals.done = function(failureReason)

end
