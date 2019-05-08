Citizen.CreateThread( function()
    while true do
        Citizen.Wait(0)
        if playerTempData.FIRSTSPAWN then
            DoScreenFadeOut(20)
        end
	end
end)

-- CLIENTSIDED --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		SetCanAttackFriendly(GetPlayerPed(-1), true, false)
		NetworkSetFriendlyFireOption(true)
	end
end)

AddEventHandler("playerSpawned", function(spawn)
    Citizen.CreateThread(function()

        local player = PlayerId()
        local playerPed = GetPlayerPed(-1)

        -- Enable pvp
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(playerPed, true, true)

        --disable
        SetPedCanSwitchWeapon(PlayerPedId(), false)
        --

  end)
   if playerTempData.FIRSTSPAWN then
        playerTempData.FIRSTSPAWN = false
        Citizen.Wait(5000)
        TriggerEvent("freezeAdjust")
        --DoScreenFadeOut(1000)
        -- Here is where you set where you want to player to spawn after they complete the tutorial
        SetEntityCoords(GetPlayerPed(-1), 13.432950019836, -1112.5704345703, 29.797008514404, 1, 0, 0, 1)
        Citizen.Wait(2500)
        DoScreenFadeIn(1000)   
        SetEntityHeading(GetPlayerPed(-1), 340.65362548828)

        startNewbieCheck() -- start safe newbie position check
        --playerTempData.FIRSTSPAWN = false
   end
end)