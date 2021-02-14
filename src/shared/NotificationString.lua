--- @class NotificationString
NotificationString = setmetatable({}, NotificationString)

NotificationString.__index = NotificationString

NotificationString.__call = function()
    return "NotificationString"
end


function NotificationString.new()
    local _NotificationString = {
        Text = ""
    }

    return setmetatable(_NotificationString, NotificationString)
end

function NotificationString:Format(format, text)
    self.Text = self.Text .. format .. text
    return self
end

function NotificationString:Icon(icon)
    self.Text = self.Text .. " " .. icon
    return self
end

function NotificationString:End()
    self.Text = self.Text .. NotifyColors.Default
    return self.Text
end

NotifyColors = {
    Blue = "~b~",
    Green = "~g~",
    Black = "~l~",
    Purple = "~p~",
    Red = "~r~",
    White = "~w~",
    Yellow = "~y~",
    Orange = "~o~",
    Grey = "~c~",
    DarkGrey = "~m~",
    Black = "~u~",
    Default = "~s~",
}

NotifyIcons = {
    WantedStar = "~ws~",
    Verified = "~|~",
    RockStar = "~∑~",
    Lock = "~Ω~",
    Race = "~BLIP_RACE~"
}
