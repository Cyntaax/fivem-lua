Marker = setmetatable({}, Marker)

Marker.__index = Marker

Marker.__call = function()
    return "Marker"
end

--- @param markerType MarkerType
--- @param color table e.g. { 255, 255, 255, 255 } 
--- @param position table
--- @param direction table
--- @param rotation table
--- @param scale table
--- @param bobble boolean
--- @param faceCamera boolean
--- @param param19 boolean
--- @param textureDict string
--- @param textureName string
--- @param drawOnEntity boolean
function Marker.new(
        markerType,
        color,
        position,
        direction,
        scale,
        rotation,
        bobble,
        faceCamera,
        param19,
        textureDict,
        textureName,
        drawOnEntity
)
    _Marker = {
        _Color = color or { 255.0, 255.0, 255.0, 255.0 },
        _MarkerType = markerType or MarkerType.CircleSkinny,
        _Position = position or {},
        _Direction = direction or {},
        _Rotation = rotation or 0,
        _Bobble = bobble or false,
        _FaceCamera = faceCamera or false,
        _Param19 = param19 or 0,
        _Rotate = rotate or 0,
        _TextureDict = textureDict or "",
        _TextureName = textureName or "",
        _DrawOnEntity = drawOnEntity or false,
        _Scale = scale or { 1.0, 1.0, 1.0 },
        _Drawing = false
    }
    
    return setmetatable(_Marker, Marker)
end

function table.valsToFloat(input)
    for i = 1, #input, 1 do
        if type(input[i]) == "number" then
            input[i] = input[i] + 0.0
        end
    end
    
    return input
end

--- Draws the marker. Creates its own thread, only needs run once.
function Marker:Draw()
    if self._Drawing == true then
        return
    end
    
    self._Drawing = true
    Citizen.CreateThread(function()
        while self._Drawing == true do
            Citize.Wait(0)
            DrawMarker(
                    self._MarkerType,
                    self._Position[1],
                    self._Position[2],
                    self._Position[3],
                    self._Direction[1],
                    self._Direction[2],
                    self._Direction[3],
                    self._Rotation[1],
                    self._Rotation[2],
                    self._Rotation[3],
                    self._Scale[1],
                    self._Scale[2],
                    self._Scale[3],
                    self._Color[1],
                    self._Color[2],
                    self._Color[3],
                    self._Color[4],
                    self._Bobble,
                    self._FaceCamera,
                    self._Param19,
                    self._TextureDict,
                    self._TextureName,
                    self._DrawOnEntity
            )
        end
    end)
end

--- Stops the marker from being drawn
function Marker:Destroy()
    self._Drawing = false
end

--- Gets or sets the color of the marker
--- @param color table | nil the current color value. If `nil`, returns the current color value
function Marker:Color(color)
    if color == nil then
        return self._Color
    end

    if type(color) == "table" then
        if #color ~= 4 then
            print("^1Error setting color:^0 Requires 4 fields, but got " .. #color)
            return
        end
        
        color = table.valsToFloat(color)
        
        self._Color = color
        
        return self._Color
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(color) .. ")")
    end
end

function Marker:Position(position)
    if position == nil then
        return self._Position
    end

    if type(position) == "table" then
        if #position ~= 3 then
            print("^1Error setting color:^0 Requires 3 fields, but got " .. #position)
            return
        end

        position = table.valsToFloat(position)

        self._Position = position

        return self._Position
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(position) .. ")")
    end
end

function Marker:Direction(direction)
    if direction == nil then
        return self._Direction
    end

    if type(direction) == "table" then
        if #direction ~= 3 then
            print("^1Error setting color:^0 Requires 3 fields, but got " .. #direction)
            return
        end

        direction = table.valsToFloat(direction)

        self._Direction = direction

        return self._Direction
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(direction) .. ")")
    end
end

function Marker:Scale(scale)
    if scale == nil then
        return self._Scale
    end

    if type(scale) == "table" then
        if #scale ~= 3 then
            print("^1Error setting color:^0 Requires 3 fields, but got " .. #scale)
            return
        end

        scale = table.valsToFloat(scale)

        self._Scale = scale

        return self._Scale
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(scale) .. ")")
    end
end

local testMarker = Marker.new(MarkerType.CarSymbol)

testMarker:Draw()

function Marker:Rotation(rotation)
    if rotation == nil then
        return self._Rotation
    end

    if type(rotation) == "table" then
        if #rotation ~= 3 then
            print("^1Error setting color:^0 Requires 3 fields, but got " .. #rotation)
            return
        end

        rotation = table.valsToFloat(rotation)

        self._Rotation = rotation

        return self._Rotation
    else
        print("^1Error: Invalid type.^0 Expected (table) got (" .. type(rotation) .. ")")
    end
end

function Marker:Bobble(bobble)
    if bobble == nil then
        return self._Bobble
    end

    if type(bobble) == "boolean" then
        self._Bobble = bobble
        return self._Bobble
    else
        print("^Error: Invalid type.^0 Expected (boolean) got (" .. type(bobble) .. ")")
    end
end

function Marker:FaceCamera(faceCamera)
    if faceCamera == nil then
        return self._FaceCamera
    end

    if type(faceCamera) == "boolean" then
        self._FaceCamera = faceCamera
        return self._FaceCamera
    else
        print("^Error: Invalid type.^0 Expected (boolean) got (" .. type(faceCamera) .. ")")
    end
end

function Marker:Rotate(rotate)
    if rotate == nil then
        return self._Rotate
    end

    if type(rotate) == "boolean" then
        self._Rotate = rotate
        return self._Rotate
    else
        print("^Error: Invalid type.^0 Expected (boolean) got (" .. type(rotate) .. ")")
    end
end

function Marker:MarkerType(markerType)
    if markerType == nil then
        return self._MarkerType
    end

    if type(markerType) == "number" then
        local valid = false
        for k,v in pairs(MarkerType) do
            if v == markerType then
                valid = true
                break
            end
        end

        if valid == false then
            print("^1Error: Marker type not found")
            return
        end
        
        self._MarkerType = markerType
    end
end



local marker = Marker.new(
        MarkerType.CircleSkinny,
        { 255, 255, 255, 255 },
        { 0, 0, 0 },
        { 0, 0, 0 },
        { 1.0, 1.0, 1.0 },
        { 0.0, 0.0, 0.0 },
        false,
        false
)

--- @class MarkerType
MarkerType = {
    --- [Image Reference](https://docs.fivem.net/markers/0.png)
    UpsideDownCone = 0,
    --- [Image Reference](https://docs.fivem.net/markers/1.png)
    VerticalCylinder = 1,
    --- [Image Reference](https://docs.fivem.net/markers/2.png)
    ThickChevronUp = 2,
    --- [Image Reference](https://docs.fivem.net/markers/3.png)
    ThinChevronUp = 3,
    --- [Image Reference](https://docs.fivem.net/markers/4.png)
    CheckeredFlagRect = 4,
    --- [Image Reference](https://docs.fivem.net/markers/5.png)
    CheckeredFlagCircle = 5,
    --- [Image Reference](https://docs.fivem.net/markers/6.png)
    VerticleCircle = 6,
    --- [Image Reference](https://docs.fivem.net/markers/7.png)
    PLaneModel = 7,
    --- [Image Reference](https://docs.fivem.net/markers/8.png)
    LostMCTransparent = 8,
    --- [Image Reference](https://docs.fivem.net/markers/9.png)
    LostMC = 9,
    --- [Image Reference](https://docs.fivem.net/markers/10.png)
    Number0 = 10,
    --- [Image Reference](https://docs.fivem.net/markers/11.png)
    Number1 = 11,
    --- [Image Reference](https://docs.fivem.net/markers/12.png)
    Number2 = 12,
    --- [Image Reference](https://docs.fivem.net/markers/13.png)
    Number3 = 13,
    --- [Image Reference](https://docs.fivem.net/markers/14.png)
    Number4 = 14,
    --- [Image Reference](https://docs.fivem.net/markers/15.png)
    Number5 = 15,
    --- [Image Reference](https://docs.fivem.net/markers/16.png)
    Number6 = 16,
    --- [Image Reference](https://docs.fivem.net/markers/17.png)
    Number7 = 17,
    --- [Image Reference](https://docs.fivem.net/markers/18.png)
    Number8 = 18,
    --- [Image Reference](https://docs.fivem.net/markers/19.png)
    Number9 = 19,
    --- [Image Reference](https://docs.fivem.net/markers/20.png)
    ChevronUpx1 = 20,
    --- [Image Reference](https://docs.fivem.net/markers/21.png)
    ChevronUpx2 = 21,
    --- [Image Reference](https://docs.fivem.net/markers/22.png)
    ChevronUpx3 = 22,
    --- [Image Reference](https://docs.fivem.net/markers/23.png)
    HorizontalCircleFat = 23,
    --- [Image Reference](https://docs.fivem.net/markers/24.png)
    ReplayIcon = 24,
    --- [Image Reference](https://docs.fivem.net/markers/25.png)
    CircleSkinny = 25,
    --- [Image Reference](https://docs.fivem.net/markers/26.png)
    CircleSkinny_Arrow = 26,
    --- [Image Reference](https://docs.fivem.net/markers/27.png)
    HorizontalSplitArrowCircle = 27,
    --- [Image Reference](https://docs.fivem.net/markers/28.png)
    DebugSphere = 28,
    --- [Image Reference](https://docs.fivem.net/markers/29.png)
    DollarSign = 29,
    --- [Image Reference](https://docs.fivem.net/markers/30.png)
    HorizontalBars = 30,
    --- [Image Reference](https://docs.fivem.net/markers/31.png)
    WolfHead = 31,
    --- [Image Reference](https://docs.fivem.net/markers/32.png)
    QuestionMark = 32,
    --- [Image Reference](https://docs.fivem.net/markers/33.png)
    PlaneSymbol = 33,
    --- [Image Reference](https://docs.fivem.net/markers/34.png)
    HelicopterSymbol = 34,
    --- [Image Reference](https://docs.fivem.net/markers/35.png)
    BoatSymbol = 35,
    --- [Image Reference](https://docs.fivem.net/markers/36.png)
    CarSymbol = 36,
    --- [Image Reference](https://docs.fivem.net/markers/37.png)
    MotorcycleSymbol = 37,
    --- [Image Reference](https://docs.fivem.net/markers/38.png)
    BikeSymbol = 38,
    --- [Image Reference](https://docs.fivem.net/markers/39.png)
    TruckSymbol = 39,
    --- [Image Reference](https://docs.fivem.net/markers/40.png)
    ParachuteSymbol = 40,
    --- [Image Reference](https://docs.fivem.net/markers/41.png)
    JetPack = 41,
    --- [Image Reference](https://docs.fivem.net/markers/42.png)
    SawbladeSymbol = 42,
    --- [Image Reference](https://docs.fivem.net/markers/43.png)
    Unknown = 43
}