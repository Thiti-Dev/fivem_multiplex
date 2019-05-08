levelupMax = {}

levelupMax[0] = 5
levelupMax[1] = 10
levelupMax[2] = 50
levelupMax[3] = 100
levelupMax[4] = 150
levelupMax[5] = 250
levelupMax[6] = 350
levelupMax[7] = 450
levelupMax[8] = 600
levelupMax[9] = 750
levelupMax[10] = 900
levelupMax[11] = 1000
levelupMax[12] = 1000
levelupMax[13] = 1000
levelupMax[14] = 1000
levelupMax[15] = 1000
levelupMax[16] = 1000
levelupMax[17] = 1000
levelupMax[18] = 1000
levelupMax[19] = 1000
levelupMax[20] = 1000


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1000)
        if playerData.LOGGEDIN and playerData.GENDER ~= "NONE" then
            if playerData.EXP >= levelupMax[playerData.LEVEL] then
                playerData.LEVEL = playerData.LEVEL + 1
                playerData.EXP = 0
                TriggerServerEvent("annouceLevel", playerData.LEVEL)
            end
        end
	end
end)