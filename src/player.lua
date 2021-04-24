
Player = {
    anim_dict = 'missfinale_c2ig_11',
    anim_name = 'pushcar_offcliff_m'
}

function Player:new()
    local o =  {
        ped = PlayerPedId()
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Check to see if the player is in a vehicle, or attempting to get in one
function Player:in_vehicle()
    return IsPedInAnyVehicle(self.ped, true)
end

-- Gets the players current coordinates
function Player:coords()
    return GetEntityCoords(self.ped)
end

-- Attaches the player to the given entity
function Player:attach_to_vehicle(va)
    if va:is_in_front(self:coords()) then
        AttachEntityToEntity(self.ped, va.vehicle, GetPedBoneIndex(6286), 0.0, va.dimensions.y - 0.3, va.dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
    else
        AttachEntityToEntity(self.ped, va.vehicle, GetPedBoneIndex(6286), 0.0, va.dimensions.y * -1 + 0.1 , va.dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
    end
end

-- Starts the configured player animation
function Player:start_anim()
    ESX.Streaming.RequestAnimDict(self.anim_dict)
    TaskPlayAnim(self.ped, self.anim_dict, self.anim_name, 2.0, -8.0, -1, 35, 0, 0, 0, 0)
end

-- Stops the configured player animation
function Player:stop_anim()
    DetachEntity(self.ped, false, false)
    StopAnimTask(self.ped, self.anim_dict, self.anim_name, 2.0)
    FreezeEntityPosition(self.ped, false)
end