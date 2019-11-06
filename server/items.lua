TriggerEvent('mythic_base:server:RegisterUsableItem', 'simcard', function(source, item)
    TriggerClientEvent('mythic_hospital:items:gauze', source, item)
end)

TriggerEvent('mythic_base:server:RegisterUsableItem', 'sdcard', function(source, item)
    TriggerEvent('mythic_phone:server:StartInstallApp', source, item)
end)