local currentPointing = 1
local totalIndex = 3

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerTempData.CURRENTMENU == "CLOTHESACTION" then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            local startZ = 1.100
            --local spaceFor = "                          "
            local formattedTextHead = "Clothing Customization"
            local beautyStringHead = string.format("%30s" , formattedTextHead )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringHead, 4, 0.1, 0.1,true)
            startZ = startZ + 0.400

            local formattedTextInvCustom
            if currentPointing == 1 then
                formattedTextInvCustom = "~r~>~w~Shirt:"
            else
                formattedTextInvCustom = "Shirt"
            end

            local beautyStringInvCustom = string.format("                %s  ~b~%s" , formattedTextInvCustom , playerData.APPEARANCE.SHIRT )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringInvCustom, 4, 0.1, 0.1,true) 
            startZ = startZ + 0.200

            local formattedTextClothesCustom
            if currentPointing == 2 then
                formattedTextClothesCustom = "~r~>~w~Pant"
            else
                formattedTextClothesCustom = "Pant"
            end

            local beautyStringClothesCustom = string.format("                %s  ~b~%s" , formattedTextClothesCustom , playerData.APPEARANCE.PANT)
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringClothesCustom, 4, 0.1, 0.1,true) 
            startZ = startZ + 0.200


            local formattedTextClothesCustom
            if currentPointing == 3 then
                formattedTextClothesCustom = "~r~>~w~Shoes"
            else
                formattedTextClothesCustom = "Shoes"
            end

            local beautyStringClothesCustom = string.format("                %s  ~b~%s" , formattedTextClothesCustom , playerData.APPEARANCE.SHOE)
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringClothesCustom, 4, 0.1, 0.1,true) 
            startZ = startZ + 0.200   
        end

        if playerTempData.CURRENTMENU == "CLOTHESACTION" then
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
                if playerTempData.UNIFORM == "NONE" then
                    if currentPointing == 1 and playerData.APPEARANCE.SHIRT ~= "NO-SHIRT" then --onAddItem
                        TriggerEvent("onAddItem", playerData.APPEARANCE.SHIRT)
                        playerData.APPEARANCE.SHIRT = "NO-SHIRT"
                        updatePedLook()
                        TriggerServerEvent("proxMsg", "took off the clothes")
                        TriggerServerEvent("updateDressed", "shirt", playerData.APPEARANCE.SHIRT)
                    elseif currentPointing == 2 and playerData.APPEARANCE.PANT ~= "NO-PANT" then
                        TriggerEvent("onAddItem", playerData.APPEARANCE.PANT)
                        playerData.APPEARANCE.PANT = "NO-PANT"
                        updatePedLook()
                        TriggerServerEvent("proxMsg", "took off the pants")
                        TriggerServerEvent("updateDressed","pant", playerData.APPEARANCE.PANT)
                    elseif currentPointing == 3 and playerData.APPEARANCE.SHOE ~= "NO-SHOE" then
                        TriggerEvent("onAddItem", playerData.APPEARANCE.SHOE)
                        playerData.APPEARANCE.SHOE = "NO-SHOE"
                        updatePedLook()
                        TriggerServerEvent("proxMsg", "took off the shoes")
                        TriggerServerEvent("updateDressed","shoe", playerData.APPEARANCE.SHOE)
                    end
                else
                    ShowNotification("Return your uniform first")
                end
            end
        end
    
    end
end)