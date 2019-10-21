RegisterNUICallback( 'JoinChannel', function( data, cb )
    Callbacks:ServerCallback('mythic_phone:server:JoinChannel', { channel = data.channel }, cb)
end)

RegisterNUICallback( 'LeaveChannel', function( data, cb )
    Callbacks:ServerCallback('mythic_phone:server:LeaveChannel', { channel = data.channel }, cb)
end)

RegisterNUICallback( 'GetChannelMessages', function( data, cb )
    Callbacks:ServerCallback('mythic_phone:server:GetChannelMessages', { channel = data.channel }, cb)
end)