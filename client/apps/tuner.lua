local TunedVehs = {}
local currentVehicle = nil

RegisterNetEvent('mythic_veh:client:EnteredVehicle')
AddEventHandler('mythic_veh:client:EnteredVehicle', function(currVeh, currSeat, name)
    if currentVehicle ~= currVeh then  
        SendNUIMessage({
            action = 'ResetVehicle'
        })

        currentVehicle = currVeh
    end
end)

DecorRegister('MYTH_TUNER_CHIP', 2)
RegisterNetEvent('mythic_phone:client:TestChip')
AddEventHandler('mythic_phone:client:TestChip', function()
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if veh ~= 0 then
        DecorSetBool(veh, 'MYTH_TUNER_CHIP', true)
    end
end)

RegisterNUICallback( 'SetupTuner', function( data, cb )
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if veh ~= 0 then
        exports['mythic_base']:FetchComponent('Progress'):Progress({
            name = "tuner_action",
            duration = 5000,
            label = 'Scanning For Chip',
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if not status then
                if GetPedInVehicleSeat(veh, -1) == PlayerPedId() and DecorExistOn(veh, 'MYTH_TUNER_CHIP') then
                    local plate = GetVehicleNumberPlateText(veh)
                    local data = {
                        id = veh,
                        model = GetDisplayNameFromVehicleModel(GetEntityModel(veh)):upper(),
                        plate = plate,
                        tune = TunedVehs[plate]
                    }
                    currentVehicle = veh
                    cb(data)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end)
    else
        local myPos = GetEntityCoords(PlayerPedId())
        local itr = exports['mythic_base']:FetchComponent('EnumEnts')
        local matchVeh = {}

        for veh2 in itr:EnumerateVehicles() do
            local pos = GetEntityCoords(veh2)
            local dist = #(vector3(pos.x, pos.y, pos.z) - myPos)

            if dist < 5.0 then
                if DecorExistOn(veh2, 'MYTH_TUNER_CHIP') then
                    local plate = GetVehicleNumberPlateText(veh2)
                    matchVeh = {
                        id = veh,
                        model = GetDisplayNameFromVehicleModel(GetEntityModel(veh2)):upper(),
                        plate = plate,
                        tune = TunedVehs[plate]
                    }
                    currentVehicle = veh2
                    break
                end
            end
        end

        if matchVeh.id == nil or currentVehicle ~= matchVeh.id then
            exports['mythic_base']:FetchComponent('Progress'):Progress({
                name = "tuner_action",
                duration = 5000,
                label = 'Scanning For Chip',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
            }, function(status)
                if not status then
                    cb(matchVeh)
                else
                    cb(false)
                end
            end)
        else
            cb(matchVeh)
        end
    end
end)

RegisterNUICallback( 'CheckInVeh', function( data, cb )
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    if veh ~= 0 then 
        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() and DecorExistOn(veh, 'MYTH_TUNER_CHIP') then
            if currentVehicle ~= veh then
                local plate = GetVehicleNumberPlateText(veh)
                local data = {
                    id = veh,
                    model = GetDisplayNameFromVehicleModel(GetEntityModel(veh)):upper(),
                    plate = plate,
                    tune = TunedVehs[plate]
                }
                currentVehicle = veh
                cb(data)
            else
                cb({ sameVeh = true })
            end
        else
            cb(nil)
        end
    else
        local myPos = GetEntityCoords(PlayerPedId())
        local itr = exports['mythic_base']:FetchComponent('EnumEnts')
        local matchVeh = -1

        for veh2 in itr:EnumerateVehicles() do
            local pos = GetEntityCoords(veh2)
            local dist = #(vector3(pos.x, pos.y, pos.z) - myPos)

            if dist < 5.0 then
                if DecorExistOn(veh2, 'MYTH_TUNER_CHIP') then
                    local plate = GetVehicleNumberPlateText(veh2)
                    matchVeh = {
                        id = veh2,
                        model = GetDisplayNameFromVehicleModel(GetEntityModel(veh2)):upper(),
                        plate = plate,
                        tune = TunedVehs[plate]
                    }
                    currentVehicle = veh2
                    break
                end
            end
        end

        if matchVeh.id == nil or currentVehicle ~= matchVeh.id then
            exports['mythic_base']:FetchComponent('Progress'):Progress({
                name = "tuner_action",
                duration = 5000,
                label = 'Scanning For Chip',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
            }, function(status)
                if not status then
                    cb(matchVeh)
                else
                    cb(false)
                end
            end)
        else
            cb(matchVeh)
        end
    end
end)

RegisterNUICallback( 'ApplyTune', function( data, cb )

end)

RegisterNUICallback( 'SaveTune', function( data, cb )
    Callbacks:ServerCallback('mythic_phone:server:SaveTune', {  }, function(status)
        cb(status)
    end)
end)

RegisterNUICallback( 'DeleteTune', function( data, cb )
    Callbacks:ServerCallback('mythic_phone:server:DeleteTune', {  }, function(status)
        cb(status)
    end)
end)