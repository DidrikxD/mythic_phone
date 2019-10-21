RegisterServerEvent('mythic_base:server:CharacterSpawned')
AddEventHandler('mythic_base:server:CharacterSpawned', function()
    local src = source
    local char = exports['mythic_base']:FetchComponent('Fetch'):Source(src):GetData('character')
    local cData = char:GetData()

    Citizen.CreateThread(function()
        local myChannels = {}
        exports['ghmattimysql']:execute('SELECT * FROM phone_irc_channels WHERE charid = @charid', { ['charid'] = cData.id }, function(channels) 
            for k, v in pairs(channels) do
                myChannels[v.channel] = {}
                exports['ghmattimysql']:execute('SELECT * FROM phone_irc_messages WHERE channel = @channel AND date >= @joined ORDER BY `date` ASC LIMIT 150', { ['channel'] = v.channel, ['joined'] = v.date }, function(messages) 
                    for k2, v2 in pairs(messages) do
                        table.insert(myChannels[v.channel], {
                            channel = v2.channel,
                            message = v2.message,
                            date = v2.date
                        })
                    end
        
                    TriggerClientEvent('mythic_phone:client:SetupData', src, { { name = 'irc-messages', data = myChannels } })
                end)
            end
        end)
    end)
end)

AddEventHandler('mythic_base:shared:ComponentsReady', function()
    Callbacks = Callbacks or exports['mythic_base']:FetchComponent('Callbacks')

    Callbacks:RegisterServerCallback('mythic_phone:server:JoinChannel', function(source, data, cb)
        local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')
        local cData = char:GetData()

        exports['ghmattimysql']:execute('INSERT INTO phone_irc_channels (`charid`, `channel`) VALUES(@charid, @number, @name)', { ['charid'] = cData.id, ['number'] = data.number, ['name'] = data.name }, function(status) 
            if status.affectedRows > 0 then
                cb(true)
            else
                cb(false)
            end
        end)
    end)

end)