World = {}

--- creates a vehicle in the world at a given position
--- @param model Model the model of the vehicle to spawn
--- @param position Vector3 the position to spawn the vehicle at
--- @param heading number the heading of the vehicle (optional. Default: `true`)
--- @param networked boolean  whether the vehicle will be networked (optional. Default: `true`)
--- @return Vehicle
function World:CreateVehicle(model, position, heading, networked)
    local veh = CreateVehicle(model.Hash, position.X, position.Y, position.Z, heading or 0, networked or true, true)
    if veh == 0 then
        print("^1Error: An Unknown error happened while creating the vehicle")
    end
    
    return Vehicle.new(veh)
end

local veh2 = World:CreateVehicle(Model.new("panto"), Vector3.new(0,0,0), 0, true)

veh2:OpenDoor(VehicleDoor.FrontLeft, true, true)