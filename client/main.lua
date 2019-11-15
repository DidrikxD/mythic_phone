local isLoggedIn = false

CharData = nil
Callbacks = nil
isPhoneOpen = false

Death = nil
Callbacks = nil
Inventory = nil

AddEventHandler('mythic_base:shared:ComponentsReady', function()
  Callbacks = Callbacks or exports['mythic_base']:FetchComponent('Callbacks')
  Inventory = Inventory or exports['mythic_base']:FetchComponent('Inventory')
  Death = exports['mythic_base']:FetchComponent('Death')
  
  Citizen.CreateThread(function()
		while CharData == nil do
			CharData = exports['mythic_base']:FetchComponent('Character')
			Citizen.Wait(250)
    end
	end)
end)

AddEventHandler('playerSpawned', function()
  SendNUIMessage({
    action = 'SetServerID',
    id = GetPlayerServerId(PlayerId())
  })
end)

RegisterNetEvent('mythic_base:client:Logout')
AddEventHandler('mythic_base:client:Logout', function()
  SendNUIMessage({
      action = 'Logout'
  })
end)

RegisterNetEvent('mythic_base:client:CharacterDataChanged')
AddEventHandler('mythic_base:client:CharacterDataChanged', function(charData)
    CharData = charData
end)

RegisterNetEvent('mythic_phone:client:TogglePhone')
AddEventHandler('mythic_phone:client:TogglePhone', function(identifier, data)
  TogglePhone()
end)

RegisterNetEvent('mythic_phone:client:SetupData')
AddEventHandler('mythic_phone:client:SetupData', function(data)
  SendNUIMessage({
    action = 'setup',
    data = data
  })
end)

function DrawUIText(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y) 
end

function CalculateTimeToDisplay()
  hour = GetClockHours()
  minute = GetClockMinutes()
  
  local obj = {}
  
  if hour <= 9 then
    hour = "0" .. hour
  end
  
  if minute <= 9 then
    minute = "0" .. minute
  end
  
  obj.hour = hour
  obj.minute = minute

  return obj
end

function hasPhone(cb)
  Inventory.Checks:HasItem({ { item = 'phone', count = 1 } }, function(status)
    cb(status)
  end)
end

function hasDecrypt(cb)
  Inventory.Checks:HasItem({ { item = 'decryptor', count = 1 } }, cb)
end

RegisterNetEvent('mythic_base:client:Logout')
AddEventHandler('mythic_base:client:Logout', function()
  isLoggedIn = false
end)

RegisterNetEvent('mythic_base:client:CharacterSpawned')
AddEventHandler('mythic_base:client:CharacterSpawned', function()
  isLoggedIn = true
end)

local counter = 0
Citizen.CreateThread(function()
  while true do
    if IsDisabledControlJustReleased(1, 170) or IsControlJustReleased(1, 170) then
      TogglePhone()
    end

    if counter <= 0 then
      local time = CalculateTimeToDisplay()
      SendNUIMessage({
        action = 'updateTime',
        time = time.hour .. ':' .. time.minute
      })
      counter = 50
    else
      counter = counter - 1
    end

    Citizen.Wait(1)
  end
end)

function TogglePhone()
  if not openingCd or isPhoneOpen then
    isPhoneOpen = not isPhoneOpen
    if isPhoneOpen then
      hasPhone(function(hasPhone)
        if hasPhone then
          PhonePlayIn()
          SetNuiFocus(true, true)
          if Call ~= nil then
            SendNUIMessage( { action = 'show', number = Call.number, initiator = Call.initiator } )
          else
            SendNUIMessage( { action = 'show' } )
          end
        else
          exports['mythic_notify']:SendAlert('error', 'You Don\'t Have a Phone')
          isPhoneOpen = false
        end
      end)
    else
      SetNuiFocus(false, false)
      if not IsInCall() then
        PhonePlayOut()
      end
      SendNUIMessage( { action = 'hide' } )
    end

    if not IsPedInAnyVehicle(PlayerPedId(), true) then
      DisplayRadar(isPhoneOpen)
    end

    openingCd = true
  end

  Citizen.CreateThread(function()
    Citizen.Wait(2000)
    openingCd = false
  end)
end

function ForceClosePhone()
  isPhoneOpen = false
  SetNuiFocus(isPhoneOpen, isPhoneOpen)
  if not IsInCall() then
    PhonePlayOut()
  end
  SendNUIMessage( { action = 'hide' } )
end

RegisterNetEvent('mythic_phone:client:EnableApp')
AddEventHandler('mythic_phone:client:EnableApp', function(app)
  for k, v in pairs(Config.Apps) do
    if v.container == app then
      v.enabled = true
      SendNUIMessage({
        action = 'EnableApp',
        app = app
      })
    end
  end
end)

RegisterNUICallback('RegisterData', function(data, cb)
  Callbacks:ServerCallback('mythic_phone:server:RegisterData', {
    key = data.key,
    data = data.data
  })
  cb(true)
end)

RegisterNUICallback('GetData', function(data, cb)
  Callbacks:ServerCallback('mythic_phone:server:GetData', {
    key = data.key
  }, function(data)
    cb(data)
  end)
end)

RegisterNUICallback('ClosePhone', function(data, cb)
  TogglePhone()
end)