TriggerEvent('mythic_base:server:RegisterUsableItem', 'sdcard', function(source, item)
    -- TriggerEvent('mythic_phone:server:StartInstallApp', source, item)
    local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')

    if item.metadata ~= nil and item.metadata.app ~= nil then

    else
        char.Inventory.Temporary:Check('advsdcard', 1, function(status)
            if status ~= nil then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Advanced SD Card Already Installed' })
            else
                char.Inventory.Temporary:Check('sdcard', 1, function(status)
                    if status ~= nil then
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'SD Card Already Installed' })
                    else
                        char.Inventory.Temporary:Add(item, function(status)
                            if not status ~= nil then
                                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'SD Card Inserted' })
                                TriggerClientEvent('mythic_phone:client:UseSDCard', source, false)
                            else
                                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Unable To Use SD Card' })
                            end
                        end)
                    end
                end)
            end
        end)
    end
end)

TriggerEvent('mythic_base:server:RegisterUsableItem', 'advsdcard', function(source, item)
    -- TriggerEvent('mythic_phone:server:StartInstallApp', source, item)
    local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')
    if item.metadata ~= nil and item.metadata.app ~= nil then

    else
        char.Inventory.Temporary:Check('advsdcard', 1, function(status)
            if status ~= nil then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Advanced SD Card Already Installed' })
            else
                char.Inventory.Temporary:Check('sdcard', 1, function(status)
                    if status ~= nil then
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'SD Card Already Installed' })
                    else
                        char.Inventory.Temporary:Add(item, function(status)
                            if not status ~= nil then
                                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Advanced SD Card Inserted' })
                                TriggerClientEvent('mythic_phone:client:UseSDCard', source, true)
                            else
                                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Unable To Use SD Card' })
                            end
                        end)
                    end
                end)
            end
        end)
    end
end)

RegisterServerEvent('mythic_base:server:CharacterSpawned')
AddEventHandler('mythic_base:server:CharacterSpawned', function()
    local src = source
    Citizen.Wait(100) -- Try to ensure we're waiting until thd base action happens
    local char = exports['mythic_base']:FetchComponent('Fetch'):Source(src):GetData('character')
    local cData = char:GetData()

    Citizen.CreateThread(function()
        char.Inventory.Temporary:Check('advsdcard', 1, function(status)
            if status ~= nil then
                TriggerClientEvent('mythic_phone:client:UseSDCard', src, true)
            else
                char.Inventory.Temporary:Check('sdcard', 1, function(status)
                    if status ~= nil then
                        TriggerClientEvent('mythic_phone:client:UseSDCard', src, false)
                    end
                end)
            end
        end)
    end)
end)

AddEventHandler('mythic_base:shared:ComponentsReady', function()
    Callbacks = Callbacks or exports['mythic_base']:FetchComponent('Callbacks')

    Callbacks:RegisterServerCallback('mythic_phone:server:EjectSDCard', function(source, data, cb)
        local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')

        if data.advanced then
            char.Inventory.Temporary:Check('advsdcard', 1, function(item)
                if item ~= nil then
                    char.Inventory.Temporary:Remove(item, function(status)
                        cb(status ~= nil)
                    end)
                else
                    cb(false)
                end
            end)
        else
            char.Inventory.Temporary:Check('sdcard', 1, function(item)
                if item ~= nil then
                    char.Inventory.Temporary:Remove(item, function(status)
                        cb(status ~= nil)
                    end)
                else
                    cb(false)
                end
            end)
        end
    end)
end)

local PendingInstalls = {}
RegisterServerEvent('mythic_phone:server:StartInstallApp')
AddEventHandler('mythic_phone:server:StartInstallApp', function(source, item)
    local data = json.decode(item.metadata)

    if data ~= nil and data.app ~= nil then
        local app = data.app

        PendingInstalls[source] = {
            app = app,
            item = item
        }

        TriggerClientEvent('mythic_phone:client:UseSDCard', source, app)
    else
        local char = exports['mythic_base']:FetchComponent('Fetch'):Source(source):GetData('character')

        -- char.Inventory.Move
    end
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
                    char.Inventory.Remove:Personal(app.item.id, 1, function()
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