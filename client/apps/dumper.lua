RegisterNetEvent('mythic_phone:client:UseSDCard')
AddEventHandler('mythic_phone:client:UseSDCard', function(isAdvanced)
    SendNUIMessage({
        action = 'InsertSDCard',
        advanced = isAdvanced
    })
end)

RegisterNUICallback('EjectSDCard', function(data, cb)
    Callbacks:ServerCallback('mythic_phone:server:EjectSDCard', data, cb)
end)