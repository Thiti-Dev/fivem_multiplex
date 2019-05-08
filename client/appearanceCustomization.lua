local totalIndex = 7

local currentPointing = 1
local currentHair = 1
local currentFace = 1
local currentShirt = 1
local currentPant = 1
local currentShoe = 1
local gender = "MALE"




local freeClothes = {
    ['MALE'] = {
        HAIRS= {
            {INDEX={2,0,0}},
            {INDEX={2,1,1}},
            {INDEX={2,1,2}},
            {INDEX={2,1,3}},
            {INDEX={2,1,4}},
            {INDEX={2,4,1}},
            {INDEX={2,4,2}},
            {INDEX={2,4,3}},
            {INDEX={2,4,4}},
            {INDEX={2,7,1}},
            {INDEX={2,7,2}},
            {INDEX={2,7,3}},
            {INDEX={2,7,4}},
            {INDEX={2,8,1}},
            {INDEX={2,8,2}},
            {INDEX={2,8,3}},
            {INDEX={2,8,4}},
            {INDEX={2,10,1}},
            {INDEX={2,10,2}},
            {INDEX={2,10,3}},
            {INDEX={2,10,4}},
            {INDEX={2,12,1}},
            {INDEX={2,12,2}},
            {INDEX={2,12,3}},
            {INDEX={2,12,4}},
            {INDEX={2,20,1}},
            {INDEX={2,20,2}},
            {INDEX={2,20,3}},
            {INDEX={2,20,4}},
        },
        FACES= {
            {INDEX={0,0,0}},
            {INDEX={0,1,0}},
            {INDEX={0,2,0}},
            {INDEX={0,3,0}},
            {INDEX={0,4,0}},
            {INDEX={0,5,0}},
            {INDEX={0,6,0}},
            {INDEX={0,7,0}},
            {INDEX={0,8,0}},
            {INDEX={0,9,0}},
            {INDEX={0,10,0}},
            {INDEX={0,11,0}},
            {INDEX={0,12,0}},
            {INDEX={0,13,0}},
            {INDEX={0,14,0}},
            {INDEX={0,15,0}},
            {INDEX={0,16,0}},
            {INDEX={0,17,0}},
            {INDEX={0,18,0}},
            {INDEX={0,19,0}},
            {INDEX={0,20,0}},
            {INDEX={0,21,0}},
            {INDEX={0,22,0}},
            {INDEX={0,23,0}},
            {INDEX={0,24,0}},
            {INDEX={0,25,0}},
            {INDEX={0,26,0}},
            {INDEX={0,27,0}},
            {INDEX={0,28,0}},
            {INDEX={0,29,0}},
            {INDEX={0,30,0}},
            {INDEX={0,31,0}},
            {INDEX={0,32,0}},
            {INDEX={0,33,0}},
            {INDEX={0,34,0}},
            {INDEX={0,35,0}},
            {INDEX={0,36,0}},
            {INDEX={0,37,0}},
            {INDEX={0,38,0}},
            {INDEX={0,39,0}},
            {INDEX={0,40,0}},
            {INDEX={0,41,0}},
            {INDEX={0,42,0}},
            {INDEX={0,43,0}},
            {INDEX={0,44,0}},
            {INDEX={0,45,0}},
        },
        SHIRTS={
            {NAME="NO-SHIRT"},
            {NAME="YELLOW-SHIRT_[MALE]"},
            {NAME="BLACK-SHIRT_[MALE]"},
        },
        PANTS={
            {NAME="NO-PANT"},
            {NAME="YELLOW-PANT_[MALE]"},
            {NAME="RED-PANT_[MALE]"},
        },
        SHOES={
            {NAME="GREY-SHOE_[MALE]"},
            {NAME="YELLOW-SHOE_[MALE]"},
        }
    },
    ['FEMALE'] = {
        HAIRS= {
            {INDEX={2,7,1}},
            {INDEX={2,7,2}},
            {INDEX={2,7,3}},
            {INDEX={2,7,4}},
            {INDEX={2,10,1}},
            {INDEX={2,10,2}},
            {INDEX={2,10,3}},
            {INDEX={2,10,4}},
            {INDEX={2,11,1}},
            {INDEX={2,11,2}},
            {INDEX={2,11,3}},
            {INDEX={2,11,4}},
            {INDEX={2,16,1}},
            {INDEX={2,16,2}},
            {INDEX={2,16,3}},
            {INDEX={2,17,1}},
            {INDEX={2,17,2}},
            {INDEX={2,17,3}},
            {INDEX={2,17,4}},
        },
        FACES= {
            {INDEX={0,0,0}},
            {INDEX={0,1,0}},
            {INDEX={0,2,0}},
            {INDEX={0,3,0}},
            {INDEX={0,4,0}},
            {INDEX={0,5,0}},
            {INDEX={0,6,0}},
            {INDEX={0,7,0}},
            {INDEX={0,8,0}},
            {INDEX={0,9,0}},
            {INDEX={0,10,0}},
            {INDEX={0,11,0}},
            {INDEX={0,12,0}},
            {INDEX={0,13,0}},
            {INDEX={0,14,0}},
            {INDEX={0,15,0}},
            {INDEX={0,16,0}},
            {INDEX={0,17,0}},
            {INDEX={0,18,0}},
            {INDEX={0,19,0}},
            {INDEX={0,20,0}},
            {INDEX={0,21,0}},
            {INDEX={0,22,0}},
            {INDEX={0,23,0}},
            {INDEX={0,24,0}},
            {INDEX={0,25,0}},
            {INDEX={0,26,0}},
            {INDEX={0,27,0}},
            {INDEX={0,28,0}},
            {INDEX={0,29,0}},
            {INDEX={0,30,0}},
            {INDEX={0,31,0}},
            {INDEX={0,32,0}},
            {INDEX={0,33,0}},
            {INDEX={0,34,0}},
            {INDEX={0,35,0}},
            {INDEX={0,36,0}},
            {INDEX={0,37,0}},
            {INDEX={0,38,0}},
            {INDEX={0,39,0}},
            {INDEX={0,40,0}},
            {INDEX={0,41,0}},
            {INDEX={0,42,0}},
            {INDEX={0,43,0}},
            {INDEX={0,44,0}},
            {INDEX={0,45,0}},
        },
        SHIRTS={
            {NAME="NO-SHIRT"},
            {NAME="WHITE-SHIRT_[FEMALE]"},
            {NAME="GREY-SHIRT_[FEMALE]"},
        },
        PANTS={
            {NAME="NO-PANT"},
            {NAME="BLUE-PANT_[FEMALE]"},
            {NAME="YELLOW-PANT_[FEMALE]"},
        },
        SHOES={
            {NAME="BLACK-SHOE_[FEMALE]"},
            {NAME="YELLOW-SHOE_[FEMALE]"},
        }
    }
}









RegisterNetEvent("onSetCustomization")
AddEventHandler("onSetCustomization", function()
    --if playerTempData.CURRENTMENU == nil then
        playerTempData.CURRENTMENU = "CUSTOM"
        currentPointing = 1
        TriggerEvent("onSetSkin", "male")
    --else
        --playerTempData.CURRENTMENU = nil
    --end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerTempData.CURRENTMENU == "CUSTOM" then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            local startZ = 1.100
            --local spaceFor = "                          "
            local formattedTextHead = "Character Customization"
            local beautyStringHead = string.format("%70s" , formattedTextHead )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringHead, 4, 0.1, 0.1)
            startZ = startZ + 0.200

            local formattedTextGenderCustom
            if currentPointing == 1 then
                formattedTextGenderCustom = "~r~>~w~Gender"
            else
                formattedTextGenderCustom = "Gender"
            end

            local beautyStringGenderCustom = string.format("                 %s      ~g~%s" , formattedTextGenderCustom, gender )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringGenderCustom, 4, 0.1, 0.1,true)  
            startZ = startZ + 0.200



            local formattedTextHeadCustom
            if currentPointing == 2 then
                formattedTextHeadCustom = "~r~>~w~Face"
            else
                formattedTextHeadCustom = "Face"
            end

            local beautyStringHeadCustom = string.format("                 %s      ~b~%d~w~/%d" , formattedTextHeadCustom, currentFace , #freeClothes[gender].FACES )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringHeadCustom, 4, 0.1, 0.1,true)  
            startZ = startZ + 0.200

            local formattedTextHairCustom

            if currentPointing == 3 then
                formattedTextHairCustom = "~r~>~w~Hair"
            else
                formattedTextHairCustom = "Hair"
            end

            local beautyStringHairCustom = string.format("                 %s      ~b~%d~w~/%d" , formattedTextHairCustom, currentHair , #freeClothes[gender].HAIRS)
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringHairCustom, 4, 0.1, 0.1,true)  
            startZ = startZ + 0.200


            local formattedTextShirtCustom

            if currentPointing == 4 then
                formattedTextShirtCustom = "~r~>~w~Shirt"
            else
                formattedTextShirtCustom = "Shirt"
            end

            local beautyStringShirtCustom = string.format("                 %s      ~b~%d~w~/%d" , formattedTextShirtCustom, currentShirt , #freeClothes[gender].SHIRTS)
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringShirtCustom, 4, 0.1, 0.1,true)  
            startZ = startZ + 0.200

            local formattedTextPantCustom

            if currentPointing == 5 then
                formattedTextPantCustom = "~r~>~w~Pant"
            else
                formattedTextPantCustom = "Pant"
            end

            local beautyStringPantCustom = string.format("                 %s      ~b~%d~w~/%d" , formattedTextPantCustom, currentPant , #freeClothes[gender].PANTS)
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringPantCustom, 4, 0.1, 0.1,true)  
            startZ = startZ + 0.200

            local formattedTextShoeCustom

            if currentPointing == 6 then
                formattedTextShoeCustom = "~r~>~w~Shoes"
            else
                formattedTextShoeCustom = "Shoes"
            end

            local beautyStringShoeCustom = string.format("                 %s      ~b~%d~w~/%d" , formattedTextShoeCustom, currentShoe , #freeClothes[gender].SHOES)
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringShoeCustom, 4, 0.1, 0.1,true)  
            startZ = startZ + 0.200


            local formattedTextDoneCustom

            if currentPointing == 7 then
                formattedTextDoneCustom = "~r~>~w~Done"
            else
                formattedTextDoneCustom = "Done"
            end

            local beautyStringDoneCustom = string.format("                 %s" , formattedTextDoneCustom)
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringDoneCustom, 4, 0.1, 0.1,true)  
            startZ = startZ + 0.200                     
        end

        if playerTempData.CURRENTMENU == "CUSTOM" then
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
            end


            if IsControlJustPressed(1, 175) then
                if currentPointing == 1 then
                    if gender == "MALE" then
                        gender = "FEMALE"
                    else
                        gender = "MALE"
                    end
                elseif currentPointing == 2 then
                    if currentFace + 1 > #freeClothes[gender].FACES then
                        currentFace = #freeClothes[gender].FACES
                    else
                        currentFace = currentFace + 1
                    end
                elseif currentPointing == 3 then
                     if currentHair + 1 > #freeClothes[gender].HAIRS then
                        currentHair = #freeClothes[gender].HAIRS
                    else
                        currentHair = currentHair + 1
                    end
                elseif currentPointing == 4 then
                     if currentShirt + 1 > #freeClothes[gender].SHIRTS then
                        currentShirt = #freeClothes[gender].SHIRTS
                    else
                        currentShirt = currentShirt + 1
                    end
                elseif currentPointing == 5 then
                     if currentPant + 1 > #freeClothes[gender].PANTS then
                        currentPant = #freeClothes[gender].PANTS
                    else
                        currentPant = currentPant + 1
                    end
                elseif currentPointing == 6 then
                     if currentShoe + 1 > #freeClothes[gender].SHOES then
                        currentShoe = #freeClothes[gender].SHOES
                    else
                        currentShoe = currentShoe + 1
                    end                               
                end
            elseif IsControlJustPressed(1, 174) then
                if currentPointing == 1 then
                    if gender == "MALE" then
                        gender = "FEMALE"
                    else
                        gender = "MALE"
                    end
                elseif currentPointing == 2 then
                    if currentFace - 1 < 1 then
                        currentFace = 1
                    else
                        currentFace = currentFace - 1
                    end
                elseif currentPointing == 3 then
                     if currentHair - 1 < 1 then
                        currentHair = 1
                    else
                        currentHair = currentHair - 1
                    end
                elseif currentPointing == 4 then
                     if currentShirt - 1 < 1 then
                        currentShirt = 1
                    else
                        currentShirt = currentShirt - 1
                    end
                elseif currentPointing == 5 then
                     if currentPant - 1 < 1 then
                        currentPant = 1
                    else
                        currentPant = currentPant - 1
                    end
                elseif currentPointing == 6 then
                     if currentShoe - 1 < 1 then
                        currentShoe = 1
                    else
                        currentShoe = currentShoe - 1
                    end                       
                end
            elseif IsControlJustPressed(1, 191) then
                if currentPointing == 7 then
                    playerTempData.CURRENTMENU = nil
                    playerData.APPEARANCE.FACE = "0:" .. tostring(GetPedDrawableVariation(GetPlayerPed(-1),0)) .. ":" .. tostring(GetPedTextureVariation(GetPlayerPed(-1),0))
                    playerData.APPEARANCE.HAIR = "2:" .. tostring(GetPedDrawableVariation(GetPlayerPed(-1),2)) .. ":" .. tostring(GetPedTextureVariation(GetPlayerPed(-1),2))
                    playerData.APPEARANCE.SHIRT = freeClothes[gender].SHIRTS[currentShirt].NAME
                    playerData.APPEARANCE.PANT = freeClothes[gender].PANTS[currentPant].NAME
                    playerData.APPEARANCE.SHOE = freeClothes[gender].SHOES[currentShoe].NAME
                    playerData.GENDER = gender
                    TriggerServerEvent("updateLooks", playerData.APPEARANCE.FACE,playerData.APPEARANCE.HAIR,playerData.APPEARANCE.SHIRT,playerData.APPEARANCE.PANT,playerData.APPEARANCE.SHOE,gender)
                    DoScreenFadeOut(500)
                    TriggerEvent("freezeAdjust")
                    Citizen.Wait(1000)
                    TriggerEvent("removeCam")

                    SetEntityCoords(GetPlayerPed(-1), 214.0629119873, -918.81604003906, 30.69202041626 - 0.95, 1, 0, 0, 1)
                    Citizen.Wait(1500)
                    DoScreenFadeIn(4000)   
                    SetEntityHeading(GetPlayerPed(-1), 319.52593994141)
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Enjoy you're life in our server")
                    --disable from switching
                    SetPedCanSwitchWeapon(PlayerPedId(), false)
                    --

                end
            end
        end

        --freeClothes[gender].SHIRTS[currentShirt].NAME

        if playerTempData.CURRENTMENU == "CUSTOM" then

             if gender == "MALE" and GetEntityModel(GetPlayerPed(-1)) ~= GetHashKey("mp_m_freemode_01") then
                local modelhashed = GetHashKey("mp_m_freemode_01")
                RequestModel(modelhashed)
                while not HasModelLoaded(modelhashed) do 
                    RequestModel(modelhashed)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), modelhashed)
                defAllValues()
             elseif gender == "FEMALE" and GetEntityModel(GetPlayerPed(-1)) ~= GetHashKey("mp_f_freemode_01") then
                local modelhashed = GetHashKey("mp_f_freemode_01")
                RequestModel(modelhashed)
                while not HasModelLoaded(modelhashed) do 
                    RequestModel(modelhashed)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), modelhashed)          
                defAllValues()      
             end

            --// after the above

            -- Appearance --
            SetPedComponentVariation(GetPlayerPed(-1), freeClothes[gender].FACES[currentFace].INDEX[1], freeClothes[gender].FACES[currentFace].INDEX[2], freeClothes[gender].FACES[currentFace].INDEX[3], 2)
            SetPedComponentVariation(GetPlayerPed(-1), freeClothes[gender].HAIRS[currentHair].INDEX[1], freeClothes[gender].HAIRS[currentHair].INDEX[2], freeClothes[gender].HAIRS[currentHair].INDEX[3], 2)
            -- Look --
            ---*Shity*---
             SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[gender].SHIRTS[freeClothes[gender].SHIRTS[currentShirt].NAME].INDEX[1], clothesIndex[gender].SHIRTS[freeClothes[gender].SHIRTS[currentShirt].NAME].INDEX[2], clothesIndex[gender].SHIRTS[freeClothes[gender].SHIRTS[currentShirt].NAME].INDEX[3], 2)
             SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[gender].SHIRTS[freeClothes[gender].SHIRTS[currentShirt].NAME].ACS[1], clothesIndex[gender].SHIRTS[freeClothes[gender].SHIRTS[currentShirt].NAME].ACS[2], clothesIndex[gender].SHIRTS[freeClothes[gender].SHIRTS[currentShirt].NAME].ACS[3], 2)
             SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[gender].SHIRTS[freeClothes[gender].SHIRTS[currentShirt].NAME].ARM[1], clothesIndex[gender].SHIRTS[freeClothes[gender].SHIRTS[currentShirt].NAME].ARM[2], clothesIndex[gender].SHIRTS[freeClothes[gender].SHIRTS[currentShirt].NAME].ARM[3], 2)
             --*Pant*--
             SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[gender].PANTS[freeClothes[gender].PANTS[currentPant].NAME].INDEX[1], clothesIndex[gender].PANTS[freeClothes[gender].PANTS[currentPant].NAME].INDEX[2], clothesIndex[gender].PANTS[freeClothes[gender].PANTS[currentPant].NAME].INDEX[3], 2)
            --*Shoe*--
             SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[gender].SHOES[freeClothes[gender].SHOES[currentShoe].NAME].INDEX[1], clothesIndex[gender].SHOES[freeClothes[gender].SHOES[currentShoe].NAME].INDEX[2], clothesIndex[gender].SHOES[freeClothes[gender].SHOES[currentShoe].NAME].INDEX[3], 2)


        end
    end
end)

function defAllValues()
    currentPointing = 1
    currentHair = 1
    currentFace = 1
    currentShirt = 1
    currentPant = 1
    currentShoe = 1
end