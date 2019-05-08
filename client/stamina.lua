Citizen.CreateThread( function()
 while true do
    Citizen.Wait(0)
        RestorePlayerStamina(PlayerId(), 1.0)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
	end
end)