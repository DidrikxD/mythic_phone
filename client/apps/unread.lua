RegisterNetEvent('mythic_phone:client:SyncUnread')
AddEventHandler('mythic_phone:client:SyncUnread', function(unreads)
    SendNUIMessage({
        action = 'SyncUnread',
        unreads = unreads
    })
end)

RegisterNUICallback('SetUnread', function(data, cb)
    Callbacks:ServerCallback('mythic_phone:server:SetUnread', data, function(status)
        print(status)
        for k, v in ipairs(Config.Apps) do
            if data.app == v.container then
                data.unread = data.unread
            end
        end
        cb(status)
    end)
end)