local Unreads = {}

function UpdateUnreads(data)
    Citizen.CreateThread(function()
        exports['ghmattimysql']:execute('INSERT INTO `phone_unread` (`charid`, `data`) VALUES (@charid, @data) ON DUPLICATE KEY UPDATE `data` = VALUES(`data`)', {
            ['charid'] = data.charid,
            ['data'] = data.unread
        }, function()
            local player = exports['mythic_base']:FetchComponent('Fetch'):CharId(data.charid)

            if player == nil then
                Cache:Remove('phone-unreads', data.charid)
            end
        end)
    end)
end

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
    
    local unreads = Cache:Get('phone-unread')[char:GetData('id')]
    if unreads == nil then
        exports['ghmattimysql']:scalar('SELECT data FROM phone_unread WHERE charid = @charid', { ['charid'] = char:GetData('id') }, function(unread)
            if unread ~= nil and json.decode(unread) ~= nil then
                if  json.decode(unread) ~= nil then
                    Cache.Add:Key('phone-unread', char:GetData('id'), {
                        charid = char:GetData('id'),
                        unread = json.decode(unread)
                    })

                    TriggerClientEvent('mythic_phone:client:SyncUnread', src, json.decode(unread))
                end
            end
        end)
    end
end)

AddEventHandler('mythic_base:shared:ComponentsReady', function()
    Callbacks = Callbacks or exports['mythic_base']:FetchComponent('Callbacks')
    Cache = Cache or exports['mythic_base']:FetchComponent('Cache')

    Cache:Set('phone-unread', {}, function(data)
        for k, v in pairs(data) do
            if v.charid ~= nil and v.data ~= nil then
                UpdateUnreads(v)
            end
        end
    end)

    Callbacks:RegisterServerCallback('mythic_phone:server:SetUnread', function(source, data, cb)
        local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')

        local unreads = Cache:Get('phone-unread')[char:GetData('id')]
        if unreads == nil then
            exports['ghmattimysql']:scalar('SELECT data FROM phone_unread WHERE charid = @charid', { ['charid'] = char:GetData('id') }, function(unread)
                if unread ~= nil then
                    unreads = json.decode(unread)
                else
                    local template = {}
                    for k, v in ipairs(Config.Apps) do
                        template[v.container] = 0
                    end
                    unread = template
                end
            end)

            while unread do
                Citizen.Wait(5)
            end
        end

        unreads[data.app] = data.unread
        Cache.Add:Key('phone-unread', data.app, unreads)
        cb(unreads[data.app])
    end)
end)