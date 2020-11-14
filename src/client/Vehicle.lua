--- @class Vehicle
Vehicle = setmetatable({}, Vehicle)

Vehicle.__index = Vehicle

Vehicle.__call = function()
    return "Vehicle"
end

function Vehicle.new(handle)
    local _Vehicle = {
        Handle = handle,
        PassengerCapacity = GetVehicleMaxNumberOfPassengers(handle)
    }
    
    return setmetatable(_Vehicle, Vehicle)
end

--- opens a vehicle door
--- @param door VehicleDoor the door to open
--- @param loosely boolean to open the door loosely (Optional. Default: false)
--- @param instantly boolean to open the door instantly (Optional. Default true)
function Vehicle:OpenDoor(door, loosely, instantly)
    SetVehicleDoorOpen(self.Handle, door, loosely or false, instantly or false)
end

--- gets the first free seat of the vehicle
--- @return number the the index of the free seat
function Vehicle:GetFreeSeat()
    local maxSeats, freeSeat = self.PassengerCapacity

    for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(self.Handle, i) then
            freeSeat = i
            break
        end
    end
end

--- @class VehicleDoor
VehicleDoor = {
    FrontLeft = 0,
    FrightRight = 1,
    BackLeft = 2,
    BackRight = 3,
    Hood = 4,
    Trunk = 5,
    Back = 6,
    Back2 = 7
}