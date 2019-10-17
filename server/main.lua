AppData = {}
Callbacks = nil

function RegisterData(source, key, data)
    if AppData[source] ~= nil then
        AppData[source].key = data
    else
        AppData[source] = {}
        AppData[source].key = data
    end
end

RegisterServerEvent('mythic_base:shared:CharacterSpawned')
AddEventHandler('mythic_base:shared:CharacterSpawned', function()
    local src = source
    local char = exports['mythic_base']:FetchComponent('Fetch'):Source(src):GetData('character')
    local cData = char:GetData()

    TriggerClientEvent('mythic_phone:client:SetupData', src, {
        { name = 'myData', data = {
            id = cData.id,
            name = cData.firstName .. ' ' .. cData.lastName,
            phone = cData.phone
        }},
        { name = 'apps', data = Config.Apps }
    })
end)

AddEventHandler('mythic_base:shared:ComponentsReady', function()
    Callbacks = Callbacks or exports['mythic_base']:FetchComponent('Callbacks')

    Callbacks:RegisterServerCallback('mythic_phone:server:GetData', function(source, data, cb)
        RegisterData(source, data.key, data.data)
        cb(true)
    end)

    Callbacks:RegisterServerCallback('mythic_phone:server:GetData', function(source, data, cb)
        cb(AppData[source][data.key])
    end)
end)