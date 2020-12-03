Events = {}

--- Creates a non-networked event
--- @param eventName string Th name of the event
--- @param eventHandler fun(...):nil The handler for this event
function Events:On(eventName, eventHandler)
    AddEventHandler(eventName, eventHandler)
end

--- Creates a networked event
--- @param eventName string The name of the event
--- @param eventHandler fun(...):nil The handler for this event
function Events:OnNet(eventName, eventHandler)
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, eventHandler)
end

--- Triggers a non-networked event
--- @param eventName string The event to trigger
function Events:Emit(eventName, ...)
    TriggerEvent(eventName, ...)
end

--- Triggers a networked event
--- @param eventName string The event to trigger
function Events:EmitNet(eventName, ...)
    TriggerServerEvent(eventName, ...)
end

