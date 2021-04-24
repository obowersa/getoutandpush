
Vehicle = {
    control_map = {['A'] = 11, ['D'] = 10 } -- Maps vehicle control keys to TaskVehicleTempAction maigc numbers
}

-- Magic Bullshit. Need to play with this
local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)


function Vehicle:new(s)
    local c = ESX.Game.GetClosestVehicle()
    local o =  {
        vehicle = c,
        push_speed = s,
        forward_vector = function() return GetEntityForwardVector(c) end,
        dimensions = GetModelDimensions(GetEntityModel(c), First, Second)
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Calculates if the player is towards the front or rear of the selected vehicle
function Vehicle:is_in_front(p_coord)
    local f_coords = self:coords() + self.forward_vector() -- Vehicle front coords
    local r_coords = self:coords() + self.forward_vector() * -1 -- Vehicle rear coordinates
    return GetDistanceBetweenCoords(f_coords, p_coord, true) > GetDistanceBetweenCoords(r_coords, p_coord, true)
end

-- Checks if there is anyone in the drivers seat of the vehicle
function Vehicle:is_seat_free()
    return IsVehicleSeatFree(self.vehicle, -1) -- -1 is a magic number for the drivers seat
end

-- Gets the current coordinates of the vehicle
function Vehicle:coords()
    return GetEntityCoords(self.vehicle)
end

-- Moves the vehicle either forwards or backwards based on if the player is at the front or rear of the vehicle
function Vehicle:push(p_coords)
    SetVehicleForwardSpeed(self.vehicle, (self:is_in_front(p_coords) and self.push_speed or -self.push_speed))
end

-- Takes control of the vehicle so we can control speed/direction
function Vehicle:take_control()
    NetworkRequestControlOfEntity(self.vehicle)
end

-- Steers the vehicle based on what key we are passed
function Vehicle:steer(p_ped, direction) 
    TaskVehicleTempAction(p_ped, self.vehicle, self.control_map[direction], 1000)
end