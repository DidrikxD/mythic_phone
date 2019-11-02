RegisterNetEvent('mythic_phone:client:SetSettings')
AddEventHandler('mythic_phone:client:SetSettings', function(data)
    Config.Setetings = data
    SendNUIMessage({
        action = 'setup',
        data = { name = 'settings', data = data }
    })
end)