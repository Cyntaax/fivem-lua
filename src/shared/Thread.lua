Threads = {}

---@class Thread
Thread = setmetatable({}, Thread)

Thread.__call = function()
    return "Thread"
end

Thread.__index = Thread

---@param name string
---@param handler fun(thread: Thread): any
function Thread.new(name, wait, handler)
    if type(tonumber(wait)) ~= "number" then wait = 0 end
    if wait < 0 then wait = 0 end
    local tmpFun = function()

    end
    local _Thread = {
        _Name = name,
        _Handler = handler or tmpFun,
        _Running = false,
        _Wait = wait or 0,
        _Deferral = function()
        end,
        _Stats = {
            LongestRun = 0,
            TimesRun = 0
        }
    }

    return setmetatable(_Thread, Thread)
end

---@param running boolean
function Thread:Running(running)
    if type(running) ~= "boolean" then return self._Running end
    self._Running = running
end

---@param wait number
function Thread:Wait(wait)
    if type(tonumber(wait)) ~= "number" then return self._Wait end
    if wait < 0 then wait = 0 end
    self._Wait = wait
end

---@param handler fun(handler: Thread): any
function Thread:Handler(handler)
    if type(handler) ~= "function" then return self._Handler end
    self._Handler = handler
end

---@param handler fun(handler: Thread): any
function Thread:Deferral(handler)
    if type(handler) ~= "function" then return self._Deferral end
    self._Deferral = handler
end

function Thread:Name()
    return self._Name
end

function Thread:Start()
    if self:Running() == true then print(ColorString.new():RedOrange("thread [" .. self:Name() .. "] already running"):End()) end
    self._Stats.TimesRun = self._Stats.TimesRun + 1
    self:Running(true)
    TriggerEvent('fxl:threadCreated', self:Name())
    Citizen.CreateThread(function()
        while self:Running() == true do
            Citizen.Wait(self:Wait())
            if self:Running() == false then
                break
            end
            local start = GetGameTimer()
            local res = self:Handler()(self)
            local duration = GetGameTimer() - start
            if duration > self._Stats.LongestRun then
                self._Stats.LongestRun = duration
                if self:Wait() > 0 then
                    TriggerEvent('fxl:updateThreadStat', self:Name(), "LongestRun", duration)
                end
            end
        end
        self:Deferral()(self)
    end)
end

function Thread:Stop()
    self:Running(false)
end

if GetCurrentResourceName() == "fxl" then
    AddEventHandler("fxl:threadCreated", function(threadName)
        if Threads[threadName] == nil then
            Threads[threadName] = {
                Runs = 1,
                LongestTime = 0,
                Stats = {}
            }
        else
            Threads[threadName].Runs = Threads[threadName].Runs + 1
        end
    end)

    AddEventHandler("fxl:updateThreadStat", function(threadName, stat, value)
        if Threads[threadName] then
            Threads[threadName].Stats[stat] = value
        end
    end)

    AddEventHandler('fxl:getThread', function(threadName, cb)
        if Threads[threadName] ~= nil then
            if type(cb) == "function" then
                cb(Threads[threadName])
            end
        else
            if type(cb) == "function" then
                cb(nil)
            end
        end
    end)
end
