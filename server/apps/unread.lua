local Unreads = {}
RegisterServerEvent('mythic_base:server:Logout')
AddEventHandler('mythic_base:server:Logout', function()
    local src = source
    local mPlayer = exports['mythic_base']:FetchComponent('Fetch'):Source(src)
    if mPlayer ~= nil then
        local char = mPlayer:GetData('character')
        if char ~= nil then
            exports['ghmattimysql']:execute('UPDATE phone_unread SET data = @data WHERE charid = @charid', { ['data'] = json.encode(Unreads[char:GetData('id')]), ['charid'] = char:GetData('id') })
        end
    end
end)


AddEventHandler('playerDropped', function()
    local src = source
    local mPlayer = exports['mythic_base']:FetchComponent('Fetch'):Source(src)
    if mPlayer ~= nil then
        local char = mPlayer:GetData('character')
        if char ~= nil then
            exports['ghmattimysql']:execute('UPDATE phone_unread SET data = @data WHERE charid = @charid', { ['data'] = json.encode(Unreads[char:GetData('id')]), ['charid'] = char:GetData('id') })
        end
    end
end)

RegisterServerEvent('mythic_base:server:CharacterSpawned')
AddEventHandler('mythic_base:server:CharacterSpawned', function()
    local src = source
    local char = exports['mythic_base']:FetchComponent('Fetch'):Source(src):GetData('character')
    exports['ghmattimysql']:scalar('SELECT data FROM phone_unread WHERE charid = @charid', { ['charid'] = char:GetData('id') }, function(unread)
        if unread ~= nil and json.decode(unread) ~= nil then
            if  json.decode(unread) ~= nil then
                local apps = Config.Apps
                local unreads = json.decode(unread)
                Unreads[char:GetData('id')] = unreads
    
                for k, v in ipairs(apps) do
                    apps[k].unread = unreads[v.container]
                end
                
                TriggerClientEvent('mythic_phone:client:SetupData', src, { { name = 'apps', data = apps } })
            end
        end
    end)
end)

AddEventHandler('mythic_base:shared:ComponentsReady', function()
    Callbacks = Callbacks or exports['mythic_base']:FetchComponent('Callbacks')

    Callbacks:RegisterServerCallback('mythic_phone:server:SetUnread', function(source, data, cb)
        local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')

        if Unreads[char:GetData('id')] == nil then
            exports['ghmattimysql']:scalar('SELECT data FROM phone_unread WHERE charid = @charid', { ['charid'] = char:GetData('id') }, function(unread)
                if unread ~= nil then
                    Unreads[char:GetData('id')] = json.decode(unread)
                else
                    local unreads = {}
                    for k, v in ipairs(Config.Apps) do
                        unreads[v.container] = 0
                    end
                    Unreads[char:GetData('id')] = unreads
                end
            end)

            while Unreads[char:GetData('id')] == nil do
                Citizen.Wait(5)
            end
        end

        Unreads[char:GetData('id')][data.app] = data.unread
        cb(Unreads[char:GetData('id')][data.app])
    end)
end)