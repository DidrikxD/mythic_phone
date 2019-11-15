RegisterServerEvent('mythic_base:server:CharacterSpawned')
AddEventHandler('mythic_base:server:CharacterSpawned', function()
    local src = source
    local char = exports['mythic_base']:FetchComponent('Fetch'):Source(src):GetData('character')
    exports['ghmattimysql']:scalar('SELECT data FROM phone_settings WHERE charid = @charid', { ['charid'] = char:GetData('id') }, function(settings)
        if settings ~= nil then
            TriggerClientEvent('mythic_phone:client:SetSettings', src, json.decode(settings))
            TriggerClientEvent('mythic_phone:client:SetupData', src, { { name = 'settings', data = json.decode(settings) } })
        else
            local default = {
                volume = 100,
                wallpaper = 1,
                ringtone = 1,
                text = 1
            }
            exports['ghmattimysql']:scalar('INSERT INTO phone_settings (charid, data) VALUES(@charid, @data)', { ['charid'] = char:GetData('id'), ['data'] = json.encode(default) })
            TriggerClientEvent('mythic_phone:client:SetSettings', src, json.decode(default))
            TriggerClientEvent('mythic_phone:client:SetupData', src, { { name = 'settings', data = default } })
        end
    end)
end)

AddEventHandler('mythic_base:shared:ComponentsReady', function()
    Callbacks = Callbacks or exports['mythic_base']:FetchComponent('Callbacks')

    Callbacks:RegisterServerCallback('mythic_phone:server:SaveSettings', function(source, data, cb)
        local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')
        exports['ghmattimysql']:execute('UPDATE phone_settings SET data = @data WHERE charid = @charid', { ['charid'] = char:GetData('id'), ['data'] = json.encode(data) }, function(res) 
            cb(res.affectedRows > 0)
        end)
    end)
end)