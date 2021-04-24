ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)


Citizen.CreateThread(function()
    local current_player = Player:new()
    --- current_player:stop_anim() Had this in as debug. If the script gets restarted WHILE something is in the animation, they can get stuck. Pulling it out for now
    while true do
        PushVehicle(current_player)
        Citizen.Wait(500)
    end
end)


function PushVehicle(current_player)
    while IsAnyVehicleNearPoint(current_player:coords().x, current_player:coords().y, current_player:coords().z, Config.min_distance) and not current_player:in_vehicle() do
        current_vehicle = Vehicle:new(Config.push_speed)

        if IsControlPressed(0, Keys[Config.key_modifier]) and current_vehicle:is_seat_free() and not IsEntityAttachedToEntity(current_player.ped, current_vehicle.vehicle) and IsControlJustPressed(0, Keys[Config.key_interact]) then
            current_vehicle:take_control()
            current_player:attach_to_vehicle(current_vehicle)
            current_player:start_anim()

            while IsDisabledControlPressed(0, Keys[Config.key_interact]) do
                current_vehicle:push(current_player:coords())

                if HasEntityCollidedWithAnything(current_vehicle.vehicle) then
                    SetVehicleOnGroundProperly(current_vehicle.vehicle)

                elseif IsDisabledControlPressed(0, Keys["A"]) then
                    current_vehicle:steer(current_player.ped, "A")

                elseif IsDisabledControlPressed(0, Keys["D"]) then
                    current_vehicle:steer(current_player.ped, "D")

                end
                Citizen.Wait(5)
            end
            current_player:stop_anim()
        end
        Citizen.Wait(5)
    end
end
