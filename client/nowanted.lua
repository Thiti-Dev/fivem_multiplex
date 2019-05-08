isPvp = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            if not isPvp then
                SetPlayerWantedLevel(PlayerId(), 0, false)
                SetPlayerWantedLevelNow(PlayerId(), false)
            end
        end

        if isPvp then
            SetPedCanSwitchWeapon(PlayerPedId(), true)
        end
    end
end)