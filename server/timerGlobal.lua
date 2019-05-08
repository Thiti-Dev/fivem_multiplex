function updateScoreboard()
    TriggerClientEvent("recieveTrueList", -1, userData) --update the scoreboard
    print("------ update scoreboard schedule every 1 minute ----")
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        updateScoreboard()
    end
end)