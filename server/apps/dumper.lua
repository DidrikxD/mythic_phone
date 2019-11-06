RegisterServerEvent('mythic_base:server:CharacterSpawned')
AddEventHandler('mythic_base:server:CharacterSpawned', function()
    local src = source
    Citizen.Wait(100) -- Try to ensure we're waiting until thd base action happens
    local char = exports['mythic_base']:FetchComponent('Fetch'):Source(src):GetData('character')
    local cData = char:GetData()

    Citizen.CreateThread(function()
        local myChannels = {}
        exports['ghmattimysql']:execute('SELECT ch.* FROM phone_irc_channels ch INNER JOIN phone_irc_messages mess ON ch.channel = mess.channel WHERE charid = @charid GROUP BY mess.channel ORDER BY mess.date DESC', {
            ['charid'] = cData.id
        }, function(channels)
            TriggerClientEvent('mythic_phone:client:SetupData', src, { { name = 'irc-channels', data = channels } })
        end)
    end)
end)

local PendingInstalls = {}
RegisterServerEvent('mythic_phone:server:StartInstallApp')
AddEventHandler('mythic_phone:server:StartInstallApp', function(source, item)
    local data = json.decode(item.metadata)
    local app = data.app

    PendingInstalls[source] = {
        app = app,
        item = item
    }

    TriggerClientEvent('mythic_phone:client:UseSDCard', source, app)
end)

RegisterServerEvent('mythic_phone:server:FinishInstallApp')
AddEventHandler('mythic_phone:server:FinishInstallApp', function()
    local src = source
    local char = exports['mythic_base']:FetchComponent('Fetch'):Source(src):GetData('character')
    local app = PendingInstalls[src]
    
    if app ~= nil then
        exports['ghmattimysql']:scalar('SELECT app FROM phone_installed_apps WHERE charid = @charid AND app = @app', { ['charid'] = char:GetData('id'), ['app'] = app.app }, function(installed)
            if installed == nil then
                exports['ghmattimysql']:execute('INSERT INTO phone_installed_apps (charid, app) VALUES(@charid, @app)', { ['charid'] = char:GetData('id'), ['app'] = app.app }, function(res)
                    char:removeItem(app.item.id, 1, function()
                        TriggerClientEvent('mythic_phone:client:EnableApp', src, app.app)
                        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = app.app .. ' Installed' })
                    end)
                end)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'App Is Already Installed' })
            end
        end)
    else
        -- Todo : Some sort of interface to select which app to dump onto SD card
    end
end)

RegisterServerEvent('mythic_phone:server:CancelInstallApp')
AddEventHandler('mythic_phone:server:CancelInstallApp', function()
    local src = source
    PendingInstalls[src] = nil
end)