local scoreBoard = {}


RegisterServerEvent("regisPlayerToPvp")
AddEventHandler("regisPlayerToPvp", function(player2)
    TriggerClientEvent("inviteSuccess", player2, source)
    --TriggerClientEvent('chatMessage', -1, "[ 📢 PVP SCOREBOARD ] ", {128, 0, 0} , userData[killer].NAME .. " got 1 point for eliminate " .. userData[dead].NAME)
    scoreBoard[userData[source].NAME] = 0
    scoreBoard[userData[player2].NAME] = 0
    TriggerClientEvent('chatMessage', -1, "[ 📢 PVP ANNOCEMENT ] ", {128, 0, 0} , "^3" .. userData[source].NAME .. " ^0VS ^3" .. userData[player2].NAME)
end)


RegisterServerEvent("pvpScoreUpdate")
AddEventHandler("pvpScoreUpdate", function(killer)
    if scoreBoard[userData[killer].NAME] and scoreBoard[userData[source].NAME] then
        if scoreBoard[userData[killer].NAME] + 1 >= 10 then
            TriggerClientEvent("stopPvp", killer)
            TriggerClientEvent("stopPvp", source)
            TriggerClientEvent('chatMessage', -1, "[ 📢 PVP ANNOCEMENT ] ", {128, 0, 0} , "^1" .. userData[killer].NAME .. " ^0won ^1" .. scoreBoard[userData[killer].NAME]+1 .. "^0-^2" .. scoreBoard[userData[source].NAME] .. "^0againt ^3" .. userData[source].NAME)
            scoreBoard[userData[source].NAME] = 0
            scoreBoard[userData[killer].NAME] = 0
        else
            scoreBoard[userData[killer].NAME] = scoreBoard[userData[killer].NAME] + 1
            TriggerClientEvent('chatMessage', -1, "[ 📢 PVP SCOREBOARD ] ", {128, 0, 0} , "[^3" .. scoreBoard[userData[killer].NAME] .. "^0] ^3".. userData[killer].NAME .. " ^0got ^11 ^0point for eliminate [^2" .. scoreBoard[userData[source].NAME] .. "^0] ^4" .. userData[source].NAME)
        end
    else
        TriggerClientEvent("stopPvp", killer)
        TriggerClientEvent("stopPvp", source)
    end
end)