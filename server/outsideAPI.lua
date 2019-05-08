RegisterServerEvent("getPlayersData")
AddEventHandler("getPlayersData", function(y,cb)
    print("Successful y == " , y)
    cb(2,3)
end)

RegisterServerEvent("proxMsg")
AddEventHandler("proxMsg", function(text)
    local name = userData[source].NAME
    --print("[ProxAction] : " .. name)
    TriggerClientEvent("sendProximityMessageMe", -1, source, name, tostring(text))
end)

RegisterCommand('ooc', function(source, args, user)
    local name = userData[source].NAME
    local levelSplit = stringsplit(userData[source].LEVEL, ":")
    local jobText = ""
    if userData[source].JOB == "NONE" then
        jobText = "Free Man"
    else
        jobText = userData[source].JOB
    end
  	TriggerClientEvent('chatMessage', -1, "[ 🔊 OOC ] | ^1[ ^6" .. jobText .. " ^1][^0LVL: ^5" .. tostring(levelSplit[1]) .. "^1] ^0>^3" .. name .. "^0< ", {26, 229, 87}, table.concat(args, " "))
  end, false)