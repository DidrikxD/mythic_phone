RegisterNetEvent('mythic_base:client:BankBalanceChanged')
AddEventHandler('mythic_base:client:BankBalanceChanged', function(account, balance)
    SendNUIMessage({
        action = 'BankBalanceUpdate',
        account = account,
        balance = balance
    })
end)

RegisterNUICallback('FindNearestAtm', function(data, cb)
    -- Make a call to whatever the fuck resource is doing ATM shit
end)

RegisterNUICallback('FindNearestBranch', function(data, cb)
    -- Make a call to wahtever the fuck resource is doing bank shit
end)

RegisterNUICallback('GetBankTransactions', function(data, cb)
    Callbacks:ServerCallback('mythic_phone:server:GetBankTransactions', data, cb)
end)

RegisterNUICallback('Transfer', function(data, cb)
    Callbacks:ServerCallback('mythic_phone:server:Transfer', data, cb)
end)

RegisterNUICallback('MazePay', function(data, cb)
    Callbacks:ServerCallback('mythic_phone:server:MazePay', data, cb)
end)

-- Citizen.CreateThread(function()
--     TriggerServerEvent('mythic_phone:server:Bank_test')
-- end)