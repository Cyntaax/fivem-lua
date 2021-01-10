ServerEvent = {
    LocalEvents = {},
    NetEvents = {}
}

function ServerEvent:On(event, handler)
    self.LocalEvents[event] = {
        Handler = handler,
        Triggers = 0
    }
    RegisterServerEvent(event)
    AddEventHandler(event, function(...)
        self.LocalEvents[event].Triggers = self.LocalEvents[event].Triggers + 1
        handler(...)
    end)
end

function ServerEvent:OnNet(event, handler)
    self.NetEvents[event] = {
        Handler = handler,
        Triggers = 0
    }

    AddEventHandler(event, function(...)
        self.NetEvents[event].Triggers = self.NetEvents[event].Triggers + 1
        local source = source
        handler(source, ...)
    end)
end
