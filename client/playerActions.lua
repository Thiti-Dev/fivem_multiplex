local currentPointing = 1
local totalIndex = 2

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerTempData.CURRENTMENU == "MAINACTION" then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            local startZ = 1.100
            --local spaceFor = "                          "
            local formattedTextHead = "Character Action Menu"
            local beautyStringHead = string.format("%30s" , formattedTextHead )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringHead, 4, 0.1, 0.1,true)
            startZ = startZ + 0.200

            local formattedTextNeed = "FOOD: ~g~100% ~w~WATER: ~g~80%"
            local beautyStringNeed = string.format("%50s" , formattedTextNeed )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringNeed, 4, 0.05, 0.05,true)
            startZ = startZ + 0.200

            local formattedTextInvCustom
            if currentPointing == 1 then
                formattedTextInvCustom = "~r~>~w~Inventory"
            else
                formattedTextInvCustom = "Inventory"
            end

            local beautyStringInvCustom = string.format("                %s" , formattedTextInvCustom )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringInvCustom, 4, 0.1, 0.1,true) 
            startZ = startZ + 0.200

            local formattedTextClothesCustom
            if currentPointing == 2 then
                formattedTextClothesCustom = "~r~>~w~Clothing"
            else
                formattedTextClothesCustom = "Clothing"
            end

            local beautyStringClothesCustom = string.format("                %s" , formattedTextClothesCustom )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringClothesCustom, 4, 0.1, 0.1,true) 
            startZ = startZ + 0.200
                   
        end

        if playerTempData.CURRENTMENU == "MAINACTION" then
            if IsControlJustPressed(1, 173) then
                if currentPointing + 1 <= totalIndex then
                    currentPointing = currentPointing + 1
                else
                    currentPointing = 1
                end
            elseif IsControlJustPressed(1, 172) then
                if currentPointing -1 < 1 then
                    currentPointing = totalIndex
                else
                    currentPointing = currentPointing - 1
                end
            elseif IsControlJustPressed(1, 191) then
                if currentPointing == 1 then
                    playerTempData.CURRENTMENU = "INVENTORY"
                elseif currentPointing == 2 then
                    playerTempData.CURRENTMENU = "CLOTHESACTION"
                end
            end
        end


        if IsControlJustPressed(1, 244) then
            if playerTempData.CURRENTMENU == nil then
                playerTempData.CURRENTMENU = "MAINACTION"
            elseif playerTempData.CURRENTMENU == "MAINACTION" or playerTempData.CURRENTMENU == "INVENTORY" or playerTempData.CURRENTMENU == "CLOTHESACTION" then
                playerTempData.CURRENTMENU = nil
            end
            currentPointing = 1
            --exceedDefault()
        end
    
    end
end)