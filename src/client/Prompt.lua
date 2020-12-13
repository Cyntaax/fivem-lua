--- @class HelpPrompt
HelpPrompt = setmetatable({}, HelpPrompt)

HelpPrompt.__index = HelpPrompt

HelpPrompt.__call = function()
    return "HelpPrompt"
end

function HelpPrompt.new(text)
    local _HelpPrompt = {
        _Text = text,
        EachFrame = eachFrame or false,
        _Drawing = false,
        _Actions = {},
        _WaitingForAction = false
    }

    return setmetatable(_HelpPrompt, HelpPrompt)
end

function HelpPrompt:Draw(duration)
    if self._Drawing == true then return end
    self._Drawing = true
    if type(duration) == "number" then
        if duration > 0 then
            self:WaitForAction()
            Citizen.CreateThread(function()
                SetTimeout(duration * 1000, function()
                    self:Destroy()
                end)
                while self._Drawing == true do
                    Citizen.Wait(0)
                    SetTextComponentFormat("STRING")
                    AddTextComponentString(self._Text)
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                end
            end)
        elseif duration == -1 then
            self:WaitForAction()
            Citizen.CreateThread(function()
                while self._Drawing == true do
                    Citizen.Wait(0)
                    SetTextComponentFormat("STRING")
                    AddTextComponentString(self._Text)
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                end
            end)
        end
    elseif duration == nil then
        SetTextComponentFormat("STRING")
        AddTextComponentString(self._Text)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
end

--- Sets an action for the prompt
--- @param key number The key to trigger the action
--- @param handler fun(prompt: HelpPrompt): void The handler function
function HelpPrompt:Action(key, handler)
    for k,v in pairs(self._Actions) do
        if v.key == key then
            Self._Actions.handler = handler
            return
        end
    end

    table.insert(self._Actions, {
        key = key,
        handler = handler
    })
end

function HelpPrompt:WaitForAction()
    if self._WaitingForAction == true then return end
    self._WaitingForAction = true
    Citizen.CreateThread(function()
        while self._WaitingForAction == true do
            Citizen.Wait(0)
            for k,v in pairs(self._Actions) do
                if IsControlJustReleased(0, v.key) then
                    v.handler(self)
                end
            end
        end
    end)
end

function HelpPrompt:Text(text)
    if type(text) == "string" then
        self._Text = text
        return self._Text
    end

    return self._Text
end

function HelpPrompt:Destroy()
    if self._Drawing == true then
        self._Drawing = false
    end

    if self._WaitingForAction == true then
        self._WaitingForAction = false
    end
end
