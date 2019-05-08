local currentPointing = 1
local totalIndex = 2
local targetPed = nil
local targetServerId = nil

RegisterNetEvent("getPedToPrepare")
AddEventHandler("getPedToPrepare",function(target)
    targetPed = target
    Citizen.Trace("----------GOT PED IN SLIGHT----------")
end)
--phase
RegisterNetEvent("gotSomeItemFrom")
AddEventHandler("gotSomeItemFrom",function(fromwho,itemname)
    if playerData.HOLDING == "NONE" then
        --playerData.HOLDING = itemname
        TriggerServerEvent("giveSuccessRemoveHim", fromwho)
        -- holding phase
        TriggerEvent("onAddItem", itemname)
        checkForUseItem(itemname)
        -- end phase
    else
        TriggerServerEvent("giveFailed", fromwho)
    end
end)

RegisterNetEvent("gotSomeMoneyFrom")
AddEventHandler("gotSomeMoneyFrom",function(fromwho,amount)
    if moneyPay(amount) then
        TriggerServerEvent("giveSuccessMoneyHim", fromwho)
    end
end)

RegisterNetEvent("giveSuccess")
AddEventHandler("giveSuccess",function(name)
    TriggerServerEvent("proxMsg", "give some item to " .. name)    
    DeleteObject(playerTempData.HOLDINGOBJECT)
    playerTempData.HOLDINGOBJECT = nil
    playerData.HOLDING = "NONE"
    RemoveAllPedWeapons(PlayerPedId()) -- forsure
end)

RegisterNetEvent("giveSuccessMoney")
AddEventHandler("giveSuccessMoney",function(name)
    TriggerServerEvent("proxMsg", "give some amount of money to " .. name)    
end)

RegisterNetEvent("failedGive")
AddEventHandler("failedGive",function()
    ShowNotification("Other player is already holding somethings")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerTempData.CURRENTMENU == "MAINOTHERINTERACTACTION" then
            local pos = GetEntityCoords(targetPed, true)
            local startZ = 1.100
            local formattedTextHead = "~r~Player Action Menu"
            local beautyStringHead = string.format("%30s" , formattedTextHead )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringHead, 4, 0.1, 0.1,true)
            startZ = startZ + 0.200

            local formattedTextInvCustom
            if currentPointing == 1 then
                formattedTextInvCustom = "~r~>~w~Give ~g~item"
            else
                formattedTextInvCustom = "Give ~g~item"
            end

            local beautyStringInvCustom = string.format("                   %s" , formattedTextInvCustom )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringInvCustom, 4, 0.1, 0.1,true) 
            startZ = startZ + 0.200

            local formattedTextClothesCustom
            if currentPointing == 2 then
                formattedTextClothesCustom = "~r~>~w~Give ~g~money"
            else
                formattedTextClothesCustom = "Give ~g~money"
            end

            local beautyStringClothesCustom = string.format("                   %s" , formattedTextClothesCustom )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringClothesCustom, 4, 0.1, 0.1,true) 
            startZ = startZ + 0.200

            if playerData.JOB == "Police Officer" then
                local formattedTextDragCustom
                if currentPointing == 3 then
                    formattedTextDragCustom = "~r~>~w~Drag player"
                else
                    formattedTextDragCustom = "Drag player"
                end

                local beautyStringDragCustom = string.format("                   %s" , formattedTextDragCustom )
                Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringDragCustom, 4, 0.1, 0.1,true) 
                startZ = startZ + 0.200

                local formattedTextCuffCustom
                if currentPointing == 4 then
                    formattedTextCuffCustom = "~r~>~w~Cuff / Uncuff"
                else
                    formattedTextCuffCustom = "Cuff / Uncuff"
                end

                local beautyStringCuffCustom = string.format("                   %s" , formattedTextCuffCustom )
                Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringCuffCustom, 4, 0.1, 0.1,true) 
                startZ = startZ + 0.200

                local formattedTextSeatCustom
                if currentPointing == 5 then
                    formattedTextSeatCustom = "~r~>~w~Put in vehicle"
                else
                    formattedTextSeatCustom = "Put in vehicle"
                end

                local beautyStringSeatCustom = string.format("                   %s" , formattedTextSeatCustom )
                Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringSeatCustom, 4, 0.1, 0.1,true) 
                startZ = startZ + 0.200

                local formattedTextArrestCustom
                if currentPointing == 6 then
                    formattedTextArrestCustom = "~r~>~w~Arrest player [ AT LSPD ]"
                else
                    formattedTextArrestCustom = "Arrest player [ AT LSPD ]"
                end

                local beautyStringArrestCustom = string.format("                   %s" , formattedTextArrestCustom )
                Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringArrestCustom, 4, 0.1, 0.1,true) 
                startZ = startZ + 0.200
            end
                   
        end

        if playerTempData.CURRENTMENU == "MAINOTHERINTERACTACTION" then
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
                    if playerData.HOLDING ~= "NONE" then
                        TriggerServerEvent("giveItemToPlayer", targetServerId, playerData.HOLDING)
                    else
                        ShowNotification("Please hold the item on your hand")
                    end
                elseif currentPointing == 2 then
                    enterAmountGiveMoney()
                elseif playerData.JOB == "Police Officer" then
                    if currentPointing == 3 then
                        TriggerServerEvent("dragHim", targetServerId)
                    elseif currentPointing == 4 then
                        TriggerServerEvent("cuffHim", targetServerId)
                    elseif currentPointing == 5 then
                        TriggerServerEvent("seatHim", targetServerId)
                    elseif currentPointing == 6 then
                        if GetDistanceBetweenCoords( 451.73834228516,-980.18365478516,30.689596176147, GetEntityCoords(targetPed)) < 2.0 then
                            TriggerServerEvent("arrestHim", targetServerId)
                        else
                            TriggerEvent("chatMessage", "^0[^8 💢 Error ^0] ", {1,170,0}, "You need to be with suspect at the LSPD point")
                        end
                    end
                end
            end
        end


        if IsControlJustPressed(1, 348) then
            if playerTempData.CURRENTMENU == nil then
                local player , distance = GetClosestPlayer()
                if distance ~= -1 and distance <= 1.5 then
                    targetPed = GetPlayerPed(player)
                    targetServerId =  GetPlayerServerId(player)
                end
                if DoesEntityExist(targetPed) and targetServerId ~= nil  then
                    playerTempData.CURRENTMENU = "MAINOTHERINTERACTACTION"
                    if playerData.JOB == "Police Officer" then
                        totalIndex = 6
                    else
                        totalIndex = 2
                    end
                end
            elseif playerTempData.CURRENTMENU == "MAINOTHERINTERACTACTION" then
                playerTempData.CURRENTMENU = nil
            end
            currentPointing = 1
            --exceedDefault()
        end

        -- interval check , if distance is too far --
        if playerTempData.CURRENTMENU == "MAINOTHERINTERACTACTION" then
            if not DoesEntityExist(targetPed) or targetServerId == nil then
                playerTempData.CURRENTMENU = nil
                targetPed = nil
                targetServerId = nil
            else
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if GetDistanceBetweenCoords( pos.x,pos.y,pos.z, GetEntityCoords(targetPed)) > 1.5 then
                    playerTempData.CURRENTMENU = nil
                    targetPed = nil
                    targetServerId = nil
                end
            end
        end
    end
end)


function enterAmountGiveMoney() -- this should not be syncd to the target func
    Citizen.CreateThread(function()
        amountPick = KeyboardInput("Enter the amount of money you want to give", "", 20)
        if tonumber(amountPick) and tonumber(amountPick) > 0 then
            if DoesEntityExist(targetPed) and targetServerId ~= nil then
                local resultPay = (-1) * tonumber(amountPick)
                if moneyPay(resultPay) then
                    TriggerServerEvent("giveMoneyToPlayer", targetServerId, tonumber(amountPick))
                else
                    ShowNotification("You don't have enough money")
                end
            else
                ShowNotification("No nearby ped found")
            end
        else
            ShowNotification("[NUMBER ONLY]")
        end
    end)
end