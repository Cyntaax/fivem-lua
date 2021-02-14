--- @class ColorString
ColorString = setmetatable({}, ColorString)

ColorString.__index = ColorString

ColorString.__call = function()
    return "ColorString"
end

function ColorString.new()
    local _ColorString = {
        Text = ""
    }

    return setmetatable(_ColorString, ColorString)
end

function ColorString:RedOrange(text)
    self.Text = self.Text .. TextColors.RedOrange .. text
    return self
end

function ColorString:LightGreen(text)
    self.Text = self.Text .. TextColors.LightGreen .. text
    return self
end

function ColorString:LightYellow(text)
    self.Text = self.Text .. TextColors.LightYellow .. text
    return self
end

function ColorString:DarkBlue(text)
    self.Text = self.Text .. TextColors.DarkBlue .. text
    return self
end

function ColorString:LightBlue(text)
    self.Text = self.Text .. TextColors.LightBlue .. text
    return self
end

function ColorString:Violet(text)
    self.Text = self.Text .. TextColors.Violet .. text
    return self
end

function ColorString:White(text)
    self.Text = self.Text .. TextColors.White .. text
    return self
end

function ColorString:BloodRed(text)
    self.Text = self.Text .. TextColors.BloodRed .. text
    return self
end

function ColorString:Fuchsia(text)
    self.Text = self.Text .. TextColors.Fuchsia .. text
    return self
end

function ColorString:End()
    self.Text = self.Text .. "^7"
    return self.Text
end

TextFormat = {
    Bold = "^*",
    Underline = "^_",
    StrikeThrough = "^~",
    UnderlineStrikeThrough = "^=",
    BoldUnderlineStrikeThrough = "^*^=",
    Cancel = "^r"
}

TextColors = {
    RedOrange = "^1",
    LightGreen = "^2",
    LightYellow = "^3",
    DarkBlue = "^4",
    LightBlue = "^5",
    Violet = "^6",
    White = "^7",
    BloodRed = "^8",
    Fuchsia = "^9"
}


