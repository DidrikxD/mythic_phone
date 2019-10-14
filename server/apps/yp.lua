local Advertisements = {}

RegisterServerEvent('mythic_base:server:CharacterSpawned')
AddEventHandler('mythic_base:server:CharacterSpawned', function()
    TriggerClientEvent('mythic_phone:client:SetupData', source, { { name = 'adverts', data = Advertisements } })
end)

AddEventHandler('mythic_base:shared:ComponentsReady', function()
    Callbacks = Callbacks or exports['mythic_base']:FetchComponent('Callbacks')

    Callbacks:RegisterServerCallback('mythic_phone:server:NewAd', function(source, data, cb)
        local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')
        local id = char:GetData('id')

        Advertisements[id] = {
            id = id,
            author = char:getFullName(),
            number = char:GetData('phone'),
            date = data.date,
            title = data.title,
            message = data.message
        }

        TriggerClientEvent('mythic_phone:client:ReceiveAd', -1, Advertisements[id])
        cb()
    end)

    Callbacks:RegisterServerCallback('mythic_phone:server:DeleteAd', function(source, data, cb)
        local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')
        local id = char:GetData('id')
        Advertisements[id] = nil
        TriggerClientEvent('mythic_phone:client:DeleteAd', -1, id)
        cb()
    end)
end)