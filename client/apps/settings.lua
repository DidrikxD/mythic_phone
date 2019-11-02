

RegisterNUICallback('SaveSettings', function(data, cb)
    Config.Settings = data
    Callbacks:ServerCallback('mythic_phone:server:SaveSettings', data, cb)
end)