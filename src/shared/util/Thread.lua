Thread = {
    Timeouts = {},
    Intervals = {}
}

function Thread.SetTimeout(cb, time)
    table.insert(Thread.Timeouts, {
        cb = cb,
        cancelled = false
    })
    local id = #Thread.Timeouts
    SetTimeout(time, function()
        if Thread.Timeouts[id] ~= nil then
            if Thread.Timeouts[id].cancelled == false then
                Thread.Timeouts[id].cb()
            end
        end
    end)
    return id
end

function Thread.ClearTimeout(id)
    if Thread.Timeouts[id] ~= nil then
        Thread.Timeouts[id].cancelled = true
    end
end

local function runTimeout(id)
    SetTimeout(time, function()
        if Thread.Timeouts[id] ~= nil then
            if Thread.Timeouts[id].cancelled == false then
                Thread.Timeouts[id].cb()
                runTimeout(id)
            end
        end
    end)
end

function Thread.SetInterval(cb, time)
    table.insert(Thread.Timeouts, {
        cb = cb,
        cancelled = false,
        time = time
    })
    local id = #Thread.Timeouts
    SetTimeout(time, function()
        if Thread.Timeouts[id] ~= nil then
            if Thread.Timeouts[id].cancelled == false then
                Thread.Timeouts[id].cb()
                runTimeout(id)
            end
        end
    end)
    return id
end

function Thread.ClearInterval(id)
    if Thread.Intervals[id] ~= nil then
        Thread.Intervals[id].cancelled = true
    end
end

