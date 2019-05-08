local targetAmmo = nil
local amountFill = nil
local isFueling = false
local currentVehicleFuel = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        --/// UI HUD
        if playerData.LOGGEDIN then
            local upperName = string.upper(playerData.CHARACTER_NAME)
            local upperJob = string.upper(playerData.JOB)
            local upperHold = string.upper(playerData.HOLDING)
            drawTxt(0.671, 1.392, 1.0,1.0,0.3, "~w~Name: ~b~" .. upperName, 255, 255, 255, 255)
            drawTxt(0.671, 1.412, 1.0,1.0,0.3, "~w~Level: ~g~" .. tostring(playerData.LEVEL) .. "~w~  EXP: ~b~" .. tostring(playerData.EXP) .. "~w~/~r~" .. tostring(levelupMax[playerData.LEVEL]), 255, 255, 255, 255)
            drawTxt(0.671, 1.432, 1.0,1.0,0.3, "~w~Job: ~b~" .. upperJob, 255, 255, 255, 255)
            drawTxt(0.671, 1.452, 1.0,1.0,0.3, "~w~HOLDING: ~b~" .. upperHold, 255, 255, 255, 255)
        end

        --
    end
end)


AddEventHandler("onUse9mm", function(target,shouldreload)
    local weapon = GetHashKey("WEAPON_PISTOL")
    SetPedAmmo(PlayerPedId(), weapon , 0)
    RemoveAllPedWeapons(PlayerPedId())
    if shouldreload then
        GiveWeaponToPed(PlayerPedId(), weapon, 24, false, true)
        targetAmmo = tonumber(target)
    else
        GiveWeaponToPed(PlayerPedId(), weapon, tonumber(target), false, true)
    end
end)


--////////////Separated controlled task

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if playerData.HOLDING ~= "9mm" and playerData.HOLDING ~= "9mm&Magazine" and playerData.HOLDING ~= "NONE" then
			if IsPedArmed(PlayerPedId(), 7) then
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
				--TriggerEvent("chatMessage", "[Action impossible]", {255, 0, 0}, "คุณมีบางอย่างถือไว้ในมืออยู่แล้ว")
			end
            DisableControlAction(0,23,true) -- disable attack
            DisableControlAction(0,24,true) -- disable attack
        end
    end
end)

--/////////////////

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if playerData.HOLDING == "9mm" or playerData.HOLDING == "9mm&Magazine" then
            local weapon = GetHashKey("WEAPON_PISTOL")
            local x = GetAmmoInPedWeapon(PlayerPedId(), weapon)
            if GetSelectedPedWeapon(PlayerPedId()) ~= weapon then
                SetCurrentPedWeapon(PlayerPedId(), weapon, true)
                TriggerEvent("chatMessage", "Debug ", {105,7,73}, "swap weapon now")
                Citizen.Wait(500)
            end
            if x > 12 then
                --SetCurrentPedWeapon(PlayerPedId(), weapon, true)
                SetPedAmmo(PlayerPedId(), weapon , 24)
                TriggerEvent("chatMessage", "Debug ", {105,7,73}, "set ammo to 24")
                Citizen.Wait(500)
                TriggerEvent("chatMessage", "Debug ", {105,7,73}, "set ammo in clip to 0")
                SetAmmoInClip(PlayerPedId(), weapon , 0)
                Citizen.Wait(1000)
                --TriggerEvent("chatMessage", "[Action impossible]", {105,7,73}, "คุณมีบางอย่างถือไว้ในมืออยู่แล้ว")
            end
            if IsPedReloading(PlayerPedId()) then
                if targetAmmo ~= nil then
                    SetPedAmmo(PlayerPedId(), weapon , targetAmmo)
                    targetAmmo = nil
                    TriggerEvent("chatMessage", "Debug ", {105,7,73}, "set target ammo")
                end
            end
        elseif string.find(playerData.HOLDING, "pepsi") then
            if IsDisabledControlJustPressed(1, 24) then
                local ableToEat = stringsplit(playerData.HOLDING, ":")
                if tonumber(ableToEat[2]) - 1 > 0 then
                    local result = tonumber(ableToEat[2]) - 1
                    RequestAnimDict("amb@code_human_wander_drinking@male@idle_a")
                    while (not HasAnimDictLoaded("amb@code_human_wander_drinking@male@idle_a")) do Citizen.Wait(0) end
                    TaskPlayAnim(GetPlayerPed(-1), 'amb@code_human_wander_drinking@male@idle_a', 'idle_c', 5.0, -1, 3000, 50, 0, false, false, false)
                    Wait(2500)
                    playerData.HOLDING = "pepsi:" .. tostring(result)
                else
                    RequestAnimDict("amb@code_human_wander_drinking@male@idle_a")
                    while (not HasAnimDictLoaded("amb@code_human_wander_drinking@male@idle_a")) do Citizen.Wait(0) end
                    TaskPlayAnim(GetPlayerPed(-1), 'amb@code_human_wander_drinking@male@idle_a', 'idle_c', 5.0, -1, 3000, 50, 0, false, false, false)
                    Wait(2500)
                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                end
            end
        elseif string.find(playerData.HOLDING, "donut") then
            if IsDisabledControlJustPressed(1, 24) then
                local ableToEat = stringsplit(playerData.HOLDING, ":")
                if tonumber(ableToEat[2]) - 1 > 0 then
                    local result = tonumber(ableToEat[2]) - 1
                    RequestAnimDict("amb@code_human_wander_eating_donut_fat@male@idle_a")
                    while (not HasAnimDictLoaded("amb@code_human_wander_eating_donut_fat@male@idle_a")) do Citizen.Wait(0) end
                    TaskPlayAnim(GetPlayerPed(-1), 'amb@code_human_wander_eating_donut_fat@male@idle_a', 'idle_a', 5.0, -1, 3000, 50, 0, false, false, false)
                    Wait(2500)
                    playerData.HOLDING = "donut:" .. tostring(result)
                else
                    RequestAnimDict("amb@code_human_wander_eating_donut_fat@male@idle_a")
                    while (not HasAnimDictLoaded("amb@code_human_wander_eating_donut_fat@male@idle_a")) do Citizen.Wait(0) end
                    TaskPlayAnim(GetPlayerPed(-1), 'amb@code_human_wander_eating_donut_fat@male@idle_a', 'idle_a', 5.0, -1, 3000, 50, 0, false, false, false)
                    Wait(2500)
                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                end
            end
        elseif string.find(playerData.HOLDING, "PistolMagazine") then
            local ableToFill = stringsplit(playerData.HOLDING, ":")
            local saveRight = playerData.HOLDING
            if IsDisabledControlJustPressed(1, 24) then
                if tonumber(ableToFill[2]) >= 12 then
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "this magazine is already full")
                else
                    amountFill = KeyboardInput("Amount of bullet to fill", "", 20)
                    --[[while amountFill == nil do
                        Citizen.Wait(200)
                    end]]
                    if tonumber(amountFill) then
                        if tonumber(amountFill) + tonumber(ableToFill[2]) > 12 then
                            TriggerEvent("chatMessage", "System ", {1,170,0}, "Maximum bullet in magazine is 12")
                        else
                            if playerData.HOLDING == saveRight then -- anti bug
                                if removeItem("Bullet[Pistol] x1", tonumber(amountFill)) then
                                    TriggerServerEvent("proxMsg", "fill some ammo in to the magazine")
                                    local result = tonumber(amountFill) + tonumber(ableToFill[2])
                                    playerData.HOLDING = ableToFill[1] .. ":" ..  result
                                else
                                    TriggerEvent("chatMessage", "System ", {1,170,0}, "You don't have enough pistol-bullet to fill")
                                end
                            else
                                TriggerEvent("chatMessage", "System ", {1,170,0}, "You did not hold the pistol magazine anymore")
                            end
                        end
                    else
                        TriggerEvent("chatMessage", "System ", {1,170,0}, "Wrong input type [ NUMBER ]")
                    end
                end
            end
        elseif playerData.HOLDING == "CPR-kit" then
            if IsDisabledControlJustPressed(1, 24) then
                local player , distance = GetClosestPlayer()
                if distance ~= -1 and distance < 2 then
                    RequestAnimDict("mini@cpr@char_b@cpr_str")
                    while not HasAnimDictLoaded("mini@cpr@char_b@cpr_str") do
                        Citizen.Wait(100)
                    end
                    if IsEntityPlayingAnim(GetPlayerPed(player), "mini@cpr@char_b@cpr_str", "cpr_fail", 3) then
                        TriggerEvent("chatMessage", "Debug ", {105,7,73}, "you're trying to cpr stranger")
                        TaskTurnPedToFaceEntity(PlayerPedId(), GetPlayerPed(player), 1000)
                        Citizen.Wait(1000)
                        RequestAnimDict("mini@cpr@char_a@cpr_str")
                        while (not HasAnimDictLoaded("mini@cpr@char_a@cpr_str")) do Citizen.Wait(0) end
                        TaskPlayAnim(GetPlayerPed(-1), 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest', 5.0, -1, -1, 9, 0, false, false, false)  
                        Citizen.Wait(3000)
                        StopAnimTask(GetPlayerPed(-1), "mini@cpr@char_a@cpr_str","cpr_pumpchest", 1.0)
                        TriggerServerEvent("onCprReq" , GetPlayerServerId(player))
                    else
                        TriggerEvent("chatMessage", "Debug ", {105,7,73}, "he's not need cpr")
                    end                   
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "nobody near you")
                end
            end
        elseif playerData.HOLDING == "Hatchet" then
            if IsDisabledControlJustPressed(1, 24) then
                local atSpot = false
                for _ , chopLoc in ipairs(chopLocation) do
                    if GetDistanceBetweenCoords( chopLoc.x,chopLoc.y,chopLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 7.0 then 
                        TaskTurnPedToFaceCoord(PlayerPedId(), chopLoc.x,chopLoc.y,chopLoc.z, 1000)
                        Citizen.Wait(1000)
                        atSpot = true
                        break
                    end
                end
                RequestAnimDict("melee@large_wpn@streamed_core")
                while (not HasAnimDictLoaded("melee@large_wpn@streamed_core")) do Citizen.Wait(0) end
                TaskPlayAnim(GetPlayerPed(-1), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 5.0, -1, -1, 9, 0, false, false, false)   
                Citizen.Wait(2000)            
                --StopAnimTask(GetPlayerPed(-1), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot')
                StopAnimTask(GetPlayerPed(-1), "melee@large_wpn@streamed_core","ground_attack_on_spot", 1.0)
                if atSpot then
                    TriggerEvent("onAddItem", "Piece of wood")
                    --playerData.EXP = playerData.EXP + 0.3
                    earnExp(0.3)
                end
            end
        elseif playerData.HOLDING == "Fishing-Rod" then
            if IsDisabledControlJustPressed(1, 24) then
                TriggerEvent("checkIfCanFish")
            end
        elseif string.find(playerData.HOLDING, "-Tank") then
            if IsDisabledControlJustPressed(1, 24) then
                if not isFueling then
                    local ableToFuel = stringsplit(playerData.HOLDING, ":")
                    local realAmount = tonumber(ableToFuel[2])
                    Citizen.Trace("Real fuel = " .. realAmount)
                    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
                    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 0.0)
                    local targetVehicle = getVehicleInDirection(coordA, coordB)
                    if DoesEntityExist(targetVehicle) then
                        fuelUpdate(targetVehicle)
                        currentVehicleFuel = targetVehicle
                        loadAnimDict("timetable@gardener@filling_can")
                        TaskPlayAnim(GetPlayerPed(-1), 'timetable@gardener@filling_can', 'gar_ig_5_filling_can', 5.0, -1, -1, 9, 0, false, false, false)  
                    end
                else
                    TriggerEvent("recieveOutsideVehicleInfo", "stop","nil")
                    isFueling = false
                    currentVehicleFuel = nil
                    StopAnimTask(GetPlayerPed(-1), "timetable@gardener@filling_can","gar_ig_5_filling_can", 1.0)
                end
            end




        elseif string.find(playerData.HOLDING, "-SHIRT") or string.find(playerData.HOLDING, "-PANT") or string.find(playerData.HOLDING, "-SHOE") then
            if IsDisabledControlJustPressed(1, 24) then
                if string.find(playerData.HOLDING, "-SHIRT") then
                    if playerData.APPEARANCE.SHIRT ~= "NO-SHIRT" then
                        TriggerEvent("chatMessage", "System ", {1,170,0}, "Please take off your current shirt first ;D")
                    else
                        if playerTempData.UNIFORM == "NONE" then
                            local gender = "NONE"
                            if string.find(playerData.HOLDING, "FEMALE") then
                                gender = "FEMALE"
                            else
                                gender = "MALE"
                            end
                            if playerData.GENDER == gender then
                                playerData.APPEARANCE.SHIRT = playerData.HOLDING
                                TriggerServerEvent("proxMsg", "wear some clothes on")
                                updatePedLook()
                                TriggerServerEvent("updateDressed","shirt", playerData.APPEARANCE.SHIRT)
                                DeleteObject(playerTempData.HOLDINGOBJECT)
                                playerTempData.HOLDINGOBJECT = nil
                                playerData.HOLDING = "NONE"
                            else
                                ShowNotification("You can't wear opposite gender clothes")
                            end
                        else
                            ShowNotification("You are in uniform!")
                        end
                    end
                elseif string.find(playerData.HOLDING, "-PANT") then
                    if playerData.APPEARANCE.PANT ~= "NO-PANT" then
                        TriggerEvent("chatMessage", "System ", {1,170,0}, "Please take off your current pant first ;D")
                    else
                        if playerTempData.UNIFORM == "NONE" then
                            local gender = "NONE"
                            if string.find(playerData.HOLDING, "FEMALE") then
                                gender = "FEMALE"
                            else
                                gender = "MALE"
                            end
                            if playerData.GENDER == gender then
                                playerData.APPEARANCE.PANT = playerData.HOLDING
                                TriggerServerEvent("proxMsg", "wear some pant on")
                                updatePedLook()
                                TriggerServerEvent("updateDressed","pant", playerData.APPEARANCE.PANT)
                                DeleteObject(playerTempData.HOLDINGOBJECT)
                                playerTempData.HOLDINGOBJECT = nil
                                playerData.HOLDING = "NONE"
                            else
                                ShowNotification("You can't wear opposite gender clothes")
                            end
                        else
                            ShowNotification("You are in uniform!")
                        end
                    end
                elseif string.find(playerData.HOLDING, "-SHOE") then
                    if playerData.APPEARANCE.SHOE ~= "NO-SHOE" then
                        TriggerEvent("chatMessage", "System ", {1,170,0}, "Please take off your current shoe first ;D")
                    else
                        if playerTempData.UNIFORM == "NONE" then
                            local gender = "NONE"
                            if string.find(playerData.HOLDING, "FEMALE") then
                                gender = "FEMALE"
                            else
                                gender = "MALE"
                            end
                            if playerData.GENDER == gender then
                                playerData.APPEARANCE.SHOE = playerData.HOLDING
                                TriggerServerEvent("proxMsg", "wear some shoes on")
                                updatePedLook()
                                TriggerServerEvent("updateDressed","shoe", playerData.APPEARANCE.SHOE)
                                DeleteObject(playerTempData.HOLDINGOBJECT)
                                playerTempData.HOLDINGOBJECT = nil
                                playerData.HOLDING = "NONE"
                            else
                                ShowNotification("You can't wear opposite gender clothes")
                            end
                        else
                            ShowNotification("You are in uniform!")
                        end
                    end
                end
            end
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        --------------------KEEP EVENT--------------------------
        if IsControlJustPressed(1, 26) then
            if playerData.HOLDING == "9mm" or playerData.HOLDING == "9mm&Magazine" then
                local weapon = GetHashKey("WEAPON_PISTOL")
                local x = GetAmmoInPedWeapon(PlayerPedId(), weapon)
                if not IsPlayerFreeAiming(PlayerId()) then
                    --playerData.HOLDING = "NONE"
                    --TriggerServerEvent("proxMsg", "keep the 9mm in the pocket")
                    if playerData.HOLDING == "9mm" then
                        TriggerEvent("onAddItem", "9mm")
                    else
                        TriggerEvent("onAddItem", "9mm&Magazine:" .. x)
                    end
                    playerData.HOLDING = "NONE"
                    SetPedAmmo(PlayerPedId(), weapon , 0)
                    RemoveAllPedWeapons(PlayerPedId())
                    TriggerServerEvent("proxMsg", "keep the 9mm in the pocket")
                else
                    if playerData.HOLDING == "9mm&Magazine" then
                        playerData.HOLDING = "9mm"
                        TriggerServerEvent("proxMsg", "put pistol magazine in the pocket")
                        TriggerEvent("onAddItem", "PistolMagazine:" .. tostring(x))
                        SetPedAmmo(PlayerPedId(), weapon , 24)
                        targetAmmo = 0
                    else
                        TriggerEvent("chatMessage", "System ", {1,170,0}, "You don't have any magazine on this weapon")
                    end
                end
            elseif string.find(playerData.HOLDING, "pepsi") then
                TriggerEvent("onAddItem", playerData.HOLDING)
                TriggerServerEvent("proxMsg", "keep the pepsi in the pocket")
                DeleteObject(playerTempData.HOLDINGOBJECT)
                playerTempData.HOLDINGOBJECT = nil
                playerData.HOLDING = "NONE"
            elseif string.find(playerData.HOLDING, "donut") then
                TriggerEvent("onAddItem", playerData.HOLDING)
                TriggerServerEvent("proxMsg", "keep the donut in the pocket")
                DeleteObject(playerTempData.HOLDINGOBJECT)
                playerTempData.HOLDINGOBJECT = nil
                playerData.HOLDING = "NONE"
            elseif string.find(playerData.HOLDING, "PistolMagazine") then
                TriggerEvent("onAddItem", playerData.HOLDING)
                TriggerServerEvent("proxMsg", "keep the pistol magazine in the pocket")
                DeleteObject(playerTempData.HOLDINGOBJECT)
                playerTempData.HOLDINGOBJECT = nil
                playerData.HOLDING = "NONE"
            elseif playerData.HOLDING == "CPR-kit" then
                TriggerEvent("onAddItem", playerData.HOLDING)
                TriggerServerEvent("proxMsg", "keep the medical CPR kit in the pocket")
                DeleteObject(playerTempData.HOLDINGOBJECT)
                playerTempData.HOLDINGOBJECT = nil
                playerData.HOLDING = "NONE"
            elseif playerData.HOLDING == "Hatchet" then
                TriggerEvent("onAddItem", playerData.HOLDING)
                TriggerServerEvent("proxMsg", "keep the hatchet to the back")
                DeleteObject(playerTempData.HOLDINGOBJECT)
                playerTempData.HOLDINGOBJECT = nil
                playerData.HOLDING = "NONE"
            elseif playerData.HOLDING == "Spanner" then
                TriggerEvent("onAddItem", playerData.HOLDING)
                TriggerServerEvent("proxMsg", "keep the spanner to the back")
                DeleteObject(playerTempData.HOLDINGOBJECT)
                playerTempData.HOLDINGOBJECT = nil
                playerData.HOLDING = "NONE"
            elseif playerData.HOLDING == "Fishing-Rod" then
                TriggerEvent("onAddItem", playerData.HOLDING)
                TriggerServerEvent("proxMsg", "keep the fishing rod to the back")
                DeleteObject(playerTempData.HOLDINGOBJECT)
                playerTempData.HOLDINGOBJECT = nil
                playerData.HOLDING = "NONE"
            elseif string.find(playerData.HOLDING, "-Tank") then
                TriggerEvent("onAddItem", playerData.HOLDING)
                TriggerServerEvent("proxMsg", "keep the fuel tank in the pocket")
                DeleteObject(playerTempData.HOLDINGOBJECT)
                playerTempData.HOLDINGOBJECT = nil
                playerData.HOLDING = "NONE"


            elseif string.find(playerData.HOLDING, "-SHIRT") or string.find(playerData.HOLDING, "-PANT") or string.find(playerData.HOLDING, "-SHOE")  then
                TriggerEvent("onAddItem", playerData.HOLDING)
                TriggerServerEvent("proxMsg", "keep some clothes in the pocket")
                DeleteObject(playerTempData.HOLDINGOBJECT)
                playerTempData.HOLDINGOBJECT = nil
                playerData.HOLDING = "NONE"
            end
        -----------------------DROP EVENT----------------------
        elseif IsControlJustPressed(1, 73) then
            if playerTempData.INSIDE == "NONE" and playerData.HOLDING ~= "NONE" then
                if playerData.HOLDING == "9mm" or playerData.HOLDING == "9mm&Magazine" then
                    dropAnim()
                    if playerData.HOLDING == "9mm" then
                        TriggerEvent("dropItem" , "w_pi_pistol50", "9mm")
                    else
                        local weapon = GetHashKey("WEAPON_PISTOL")
                        local x = GetAmmoInPedWeapon(PlayerPedId(), weapon)
                        TriggerEvent("dropItem" , "w_pi_pistol50", "9mm&Magazine:" .. x)
                    end

                    SetPedAmmo(PlayerPedId(), weapon , 0)
                    RemoveAllPedWeapons(PlayerPedId())
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the 9mm on the floor")
                elseif string.find(playerData.HOLDING, "pepsi") then
                    dropAnim()
                    TriggerEvent("dropItem" , "prop_energy_drink", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the pepsi on the floor")  
                elseif string.find(playerData.HOLDING, "donut") then
                    dropAnim()
                    TriggerEvent("dropItem" , "prop_food_cb_nugets", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the donut on the floor")       
                elseif string.find(playerData.HOLDING, "PistolMagazine") then
                    dropAnim()
                    TriggerEvent("dropItem" , "w_pi_vintage_pistol_mag2", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the pistol magazine on the floor")   
                elseif playerData.HOLDING == "CPR-kit" then
                    dropAnim()
                    TriggerEvent("dropItem" , "prop_ld_health_pack", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the medical CPR kit on the floor")   
                elseif playerData.HOLDING == "Hatchet" then
                    dropAnim()
                    TriggerEvent("dropItem" , "prop_w_me_hatchet", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the hatchet on the floor")   
                elseif playerData.HOLDING == "Spanner" then
                    dropAnim()
                    TriggerEvent("dropItem" , "prop_tool_adjspanner", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the spanner on the floor")   
                elseif playerData.HOLDING == "Fishing-Rod" then
                    dropAnim()
                    TriggerEvent("dropItem" , "prop_fishing_rod_01", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the fishing rod on the floor")

                elseif string.find(playerData.HOLDING, "-Tank") then
                    dropAnim()
                    TriggerEvent("dropItem" , "w_am_jerrycan", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the fuel tank on the floor")   





                elseif string.find(playerData.HOLDING, "-SHIRT") then
                    dropAnim()
                    TriggerEvent("dropItem" , "prop_cs_lazlow_shirt_01", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the shirt on the floor")       
                elseif string.find(playerData.HOLDING, "-PANT") then
                    dropAnim()
                    TriggerEvent("dropItem" , "prop_ld_jeans_01", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the pant on the floor")     
                elseif string.find(playerData.HOLDING, "-SHOE") then
                    dropAnim()
                    TriggerEvent("dropItem" , "prop_ld_shoe_01", playerData.HOLDING)

                    DeleteObject(playerTempData.HOLDINGOBJECT)
                    playerTempData.HOLDINGOBJECT = nil
                    playerData.HOLDING = "NONE"
                    TriggerServerEvent("proxMsg", "drop the shoe on the floor")                         
                end
            elseif playerData.HOLDING ~= "NONE" and playerTempData.INSIDE ~= "NONE" then
                ShowNotification("You can't drop item inside instance")
            end
        end
    end
end)

function dropAnim()
    RequestAnimDict("missfbi_s4mop")
    while (not HasAnimDictLoaded("missfbi_s4mop")) do Citizen.Wait(0) end
    TaskPlayAnim(GetPlayerPed(-1), 'missfbi_s4mop', 'put_down_bucket', 5.0, -1, -1, 9, 0, false, false, false)   
    Citizen.Wait(1300)            
    StopAnimTask(GetPlayerPed(-1), "missfbi_s4mop","put_down_bucket", 1.0)
end

RegisterNetEvent("holdObject")
AddEventHandler("holdObject", function(strn,rotx,roty,rotz)

	x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	
	
	nstrn = GetHashKey(strn)
	
	RequestModel(nstrn)
	while not HasModelLoaded(nstrn) do
	   Wait(1)
	end
	
	if playerTempData.HOLDINGOBJECT ~= nil then
		DeleteObject(playerTempData.HOLDINGOBJECT)
		playerTempData.HOLDINGOBJECT = nil
		TriggerEvent("chatMessage", "[Object Test]", {255, 0, 0}, "Delete the previous one and set it to nil  :P")
	end

	playerTempData.HOLDINGOBJECT = CreateObject(nstrn, x, y, z, true, true, false)
	PlaceObjectOnGroundProperly(playerTempData.HOLDINGOBJECT) -- This function doesn't seem to work.
    
    local rotX
    local rotY
    local rotZ
    if not rotx then
        rotX = 90.0
    else
        rotX = tonumber(rotx)
    end
    if not roty then
        rotY = 360.0
    else
        rotY = tonumber(roty)
    end
    if not rotz then
        rotZ = 180.0
    else
        rotZ = tonumber(rotz)
    end
	AttachEntityToEntity(playerTempData.HOLDINGOBJECT, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.1, 0, -0.025, rotX, rotY, rotZ, true, true, false, true, 1, true)
	DisplayHelpText("~w~Press ~INPUT_ATTACK~ ~g~Use ~w~ OR ~INPUT_LOOK_BEHIND~ ~b~Keep ~w~OR ~INPUT_VEH_DUCK~ TO ~r~DROP")
	
	--TriggerEvent("chatMessage", "[Clothes Test]", {255, 0, 0}, "คุุุณได้เสก " .. strn .. " มาไว้ในมือของคุณ" .. " with " .. GetEntityModel(object))
end)

function fuelUpdate(targetcar)
    if not isFueling then
        isFueling = true
        Citizen.Trace("Starting to fuel vehicle plate " .. GetVehicleNumberPlateText(targetcar))
        TriggerEvent("recieveOutsideVehicleInfo", "start",targetcar)
        Citizen.CreateThread(function()
            while isFueling do
                local position = GetEntityCoords(targetcar)
                local fuel 	   = round(GetVehicleFuelLevel(targetcar), 1)
                DrawText3Ds(position.x, position.y, position.z + 0.5, fuel .. "%")
                if fuel >= 100 then
                    TriggerEvent("recieveOutsideVehicleInfo", "stop","nil")
                    isFueling = false
                    StopAnimTask(GetPlayerPed(-1), "timetable@gardener@filling_can","gar_ig_5_filling_can", 1.0)
                end
                Citizen.Wait(0)
            end    
        end)
    end
end

-- for check if car is gone or player is dead
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        if isFueling and currentVehicleFuel ~= nil then
            local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
            local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 0.0)
            local targetVehicle = getVehicleInDirection(coordA, coordB)
            if targetVehicle ~= currentVehicleFuel then
                TriggerEvent("recieveOutsideVehicleInfo", "stop","nil")
                isFueling = false
                currentVehicleFuel = nil
                StopAnimTask(GetPlayerPed(-1), "timetable@gardener@filling_can","gar_ig_5_filling_can", 1.0)
            end
            if not IsEntityPlayingAnim(GetPlayerPed(-1), "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                TriggerEvent("recieveOutsideVehicleInfo", "stop","nil")
                isFueling = false
                currentVehicleFuel = nil
                --StopAnimTask(GetPlayerPed(-1), "timetable@gardener@filling_can","gar_ig_5_filling_can", 1.0)
            end
            if string.find(playerData.HOLDING, "-Tank") then
                local ableToFuel = stringsplit(playerData.HOLDING, ":")
                local realAmount = tonumber(ableToFuel[2])
                if realAmount > 0 then
                    playerData.HOLDING = "Fuel-Tank:" .. realAmount-1
                else
                     playerData.HOLDING = "Fuel-Tank:0"
                    TriggerEvent("recieveOutsideVehicleInfo", "stop","nil")
                    isFueling = false
                    currentVehicleFuel = nil
                    StopAnimTask(GetPlayerPed(-1), "timetable@gardener@filling_can","gar_ig_5_filling_can", 1.0)
                end
            else
                TriggerEvent("recieveOutsideVehicleInfo", "stop","nil")
                isFueling = false
                currentVehicleFuel = nil
                StopAnimTask(GetPlayerPed(-1), "timetable@gardener@filling_can","gar_ig_5_filling_can", 1.0)
            end
        end
    end
end)


RegisterNetEvent("onCprDone")
AddEventHandler("onCprDone", function(reviveName)
    DeleteObject(playerTempData.HOLDINGOBJECT)
    playerTempData.HOLDINGOBJECT = nil
    playerData.HOLDING = "NONE"
    earnExp(15)
    TriggerServerEvent("proxMsg", "do cpr to " .. reviveName)      
end)
