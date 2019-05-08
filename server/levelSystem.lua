RegisterServerEvent("annouceLevel")
AddEventHandler("annouceLevel", function(current)
    TriggerClientEvent('chatMessage', -1, "Annoucement ", {11, 132, 246} , userData[source].NAME .. " just leveled-up from ^1" .. tostring(current-1) .. " ^0to ^2" .. tostring(current))
end)