RegisterServerEvent("doctor:ready")
AddEventHandler("doctor:ready", function()
    TriggerClientEvent('chatMessage', -1, "[ 🚨 Government ] ", {56, 95, 0} , "Doctor " .. userData[source].NAME .. " is now ^2on ^0^_duty")
end)

RegisterServerEvent("doctor:off")
AddEventHandler("doctor:off", function()
    TriggerClientEvent('chatMessage', -1, "[ 🚨 Government ] ", {56, 95, 0} , "Doctor " .. userData[source].NAME .. " is now ^1off ^0^_duty")
end)

RegisterServerEvent("police:ready")
AddEventHandler("police:ready", function()
    TriggerClientEvent('chatMessage', -1, "[ 🚨 Government ] ", {56, 95, 0} , "Police Officer " .. userData[source].NAME .. " is now ^2on ^0^_duty")
end)

RegisterServerEvent("police:off")
AddEventHandler("police:off", function()
    TriggerClientEvent('chatMessage', -1, "[ 🚨 Government ] ", {56, 95, 0} , "Police Officer " .. userData[source].NAME .. " is now ^1off ^0^_duty")
end)

RegisterServerEvent("arrest:surrender")
AddEventHandler("arrest:surrender", function(seconds,senderName)
    if not senderName then
        TriggerClientEvent('chatMessage', -1, "[ 📢 Crime News ] ", {128, 0, 0} , userData[source].NAME .. " deserved time in ^_jail ^rfor [ ^1 " .. seconds .. " ^0seconds ]")
    else
        TriggerClientEvent('chatMessage', -1, "[ 📢 Crime News ] ", {128, 0, 0} , userData[source].NAME .. " deserved time in ^_jail ^rfor [ ^1 " .. seconds .. " ^0seconds ] by Officer " .. senderName)
    end
end)
