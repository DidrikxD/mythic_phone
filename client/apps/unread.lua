RegisterNetEvent('mythic_phone:client:SyncUnread')
AddEventHandler('mythic_phone:client:SyncUnread', function(unreads)
    for k, v in ipairs(Config.Apps) do
        v.unread = unreads[v.container]
    end
    
    SendNUIMessage({
        action = 'SyncUnread',
        unreads = unreads
    })
end)

RegisterNUICallback('SetUnread', function(data, cb)
    Callbacks:ServerCallback('mythic_phone:server:SetUnread', data, function(status)
        for k, v in ipairs(Config.Apps) do
            if data.app == v.container then
                v.unread = data.unread
            end
        end
        cb(status)
    end)
end)