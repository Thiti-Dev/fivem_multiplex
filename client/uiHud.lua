
-- HUD SECTION
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(100)
        DisplayCash(false) -- hide money hud
        --local thirst, hunger = hudServer.getBasics()
        local boolUsed = false
        if playerData.LOGGEDIN and not IsPauseMenuActive() and not IsScreenFadedOut() and IsScreenFadedIn() then
            boolUsed = false
        else
            boolUsed = true
        end
        SendNUIMessage({
            show = boolUsed,
            armor = GetPedArmour(GetPlayerPed(-1)),
            life = (GetEntityHealth(GetPlayerPed(-1))-100),
            thirst = 70.0,
            hunger = 50.0
        })
    end
end)
---------------------------------