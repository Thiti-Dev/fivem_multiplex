local debugEnable = false
local currentPointing = 1
local exceedLimit = 7
local tierLast = 1
local money = 500

RegisterNetEvent("onTest3d")
AddEventHandler("onTest3d", function()
    --[[local pos = GetEntityCoords(GetPlayerPed(-1), true)
    Draw3DText( 11.936089515686, -1108.482421875, 29.797029495239  -1.400, "Register Here", 4, 0.1, 0.1)
    Draw3DText( 11.936089515686, -1108.482421875, 29.797029495239  -1.600, "Press E", 4, 0.1, 0.1)]]
    debugEnable = not debugEnable
end)

RegisterNetEvent("onAddItem")
AddEventHandler("onAddItem", function(itemname,amount)
    addItem(itemname,amount)
    local lastShow = 1
    if amount then
        lastShow = tonumber(amount)
    end
    ShowNotification("~w~" .. lastShow .. "~w~x ~w~" .. string.lower(itemname) .. " ~g~added")
    --TriggerEvent("chatMessage", "System ", {1,170,0}, itemname .. " was added to your inventory")
end)

RegisterNetEvent("onCheckItem")
AddEventHandler("onCheckItem", function(itemname)
    if hasItem(itemname) then
        TriggerEvent("chatMessage", "System ", {1,170,0}, "You have " .. itemname)
    else
        TriggerEvent("chatMessage", "System ", {1,170,0}, "You Don't have " .. itemname) 
    end
end)

RegisterNetEvent("onRemoveAllItem")
AddEventHandler("onRemoveAllItem", function(itemname)
    if removeItem(itemname) then
        TriggerEvent("chatMessage", "System ", {1,170,0}, itemname .. " has been removed")
    else
        TriggerEvent("chatMessage", "System ", {1,170,0}, "Remove failure") 
    end
end)

RegisterNetEvent("onRemoveItem")
AddEventHandler("onRemoveItem", function(itemname, amount)
    if removeItem(itemname, amount) then
        TriggerEvent("chatMessage", "System ", {1,170,0}, itemname .. " has been removed")
    else
        TriggerEvent("chatMessage", "System ", {1,170,0}, "Remove failure") 
    end
    --[[if removeItem(itemname) then
        TriggerEvent("chatMessage", "[Inventory]", {1,170,0}, itemname .. " has been removed")
    else
        TriggerEvent("chatMessage", "[Inventory]", {1,170,0}, "Remove failure") 
    end]]
end)


--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerTempData.CURRENTMENU == "INVENTORY" then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            local startZ = 1.100
            --local spaceFor = "                          "
            local formattedTextHead = "Inventory  ~g~$ : " .. tostring(playerData.MONEY)
            local beautyStringHead = string.format("%58s" , formattedTextHead )
            Draw3DText( pos.x, pos.y, pos.z - startZ, beautyStringHead, 4, 0.1, 0.1)
            startZ = startZ + 0.200        

            for i = tierLast, #playerData.INVENTORY do
               if(i > exceedLimit) then
                    break
                end                
                local formattedText
                local beautyString
                if i == currentPointing then
                    formattedText = tostring(i) .. ".~r~>~w~" .. playerData.INVENTORY[i].Name
                    beautyString = string.format("                %s[~b~%s~w~]" , formattedText, tostring(playerData.INVENTORY[i].Amount))
                    --beautyString = string.format("                %s%10s" , formattedText, tostring(playerData.INVENTORY[i].Amount))
                else
                    formattedText = tostring(i) .. "." .. playerData.INVENTORY[i].Name
                    local finalCal = 20 - #formattedText
                    beautyString = string.format("                %s[~b~%s~w~]" , formattedText, tostring(playerData.INVENTORY[i].Amount))
                    --beautyString = string.format("                %s%" .. tostring(finalCal) .. "s" , formattedText, tostring(playerData.INVENTORY[i].Amount))
                end
                --beautyString = string.format("%45s" , formattedText)
                Draw3DText( pos.x, pos.y, pos.z - startZ, beautyString, 4, 0.1, 0.1,true)
                startZ = startZ + 0.200
            end



            if #playerData.INVENTORY > exceedLimit then
                local lastNext
                if currentPointing == 0 then
                    lastNext = string.format("                %s" , "~r~>~w~Next")
                else
                    lastNext = string.format("                %s" , "Next")
                end
                Draw3DText( pos.x, pos.y, pos.z - startZ, lastNext, 4, 0.1, 0.1,true)
                startZ = startZ + 0.200
            end
            if tierLast ~= 1 then
                local lastBack
                if currentPointing == -1 then
                    lastBack = string.format("                %s" , "~r~>~w~Back")
                else
                    lastBack = string.format("                %s" , "Previous [ ~r~Backspace~w~ ]")
                end
                Draw3DText( pos.x, pos.y, pos.z - startZ, lastBack, 4, 0.1, 0.1,true)
                startZ = startZ + 0.200               
            end
        end

        if playerTempData.CURRENTMENU == "INVENTORY" then
            if #playerData.INVENTORY > 0 then
                --// fix bug

                if currentPointing > #playerData.INVENTORY then
                    currentPointing = #playerData.INVENTORY
                end
                if IsControlJustPressed(1, 173) then
                    if WarMenu.CurrentMenu() == nil then
                        if #playerData.INVENTORY <= exceedLimit then
                            if currentPointing+1 > #playerData.INVENTORY then
                                currentPointing = tierLast
                            else
                                currentPointing = currentPointing + 1
                            end
                        else
                            if currentPointing ~= 0 then
                                if currentPointing+1 > exceedLimit then
                                    currentPointing = 0
                                else
                                    currentPointing = currentPointing + 1
                                end  
                            else
                                currentPointing = tierLast
                            end                   
                        end
                    end
                elseif IsControlJustPressed(1, 172) then
                    if WarMenu.CurrentMenu() == nil then
                        if #playerData.INVENTORY <= exceedLimit then
                            if currentPointing-1 < tierLast then
                                currentPointing = #playerData.INVENTORY
                            else
                                currentPointing = currentPointing - 1
                            end
                        else
                            if currentPointing-1 < tierLast then
                                if currentPointing == 0 then
                                    currentPointing = exceedLimit
                                else
                                    currentPointing = 0
                                end
                                --currentPointing = 0
                            else
                                currentPointing = currentPointing - 1
                            end                      
                        end
                    end
                elseif IsControlJustPressed(1, 191) then
                    if WarMenu.CurrentMenu() == nil then
                        if currentPointing == 0 then
                            --TriggerEvent("chatMessage", "[Inventory]", {1,170,0}, "Triggerred")
                            currentPointing = exceedLimit +1
                            exceedUpdateUp()
                        elseif currentPointing == -1 then
                            --TriggerEvent("chatMessage", "[Inventory]", {1,170,0}, "Triggerred")
                            currentPointing = tierLast - 1
                            exceedUpdateDown()  
                        else
                            checkForUseItem()
                        end
                    end
                elseif IsControlJustPressed(1, 194) then
                    if tierLast ~= 1 then
                        currentPointing = tierLast - 1
                        exceedUpdateDown() 
                    end
                end
            end
        end
    end
end)]]



function addItem(itemname,amount)
    local realAmount = 1
    if amount then
      realAmount = math.floor(tonumber(amount)) 
    end
    if hasItem(itemname) then
        for i , x in ipairs(playerData.INVENTORY) do
            if x.Name == itemname then
                playerData.INVENTORY[i].Amount = playerData.INVENTORY[i].Amount + realAmount
                break
            end
        end
    else
        table.insert(playerData.INVENTORY, {Name=itemname,Amount=realAmount})
    end

    for index, z in ipairs(playerData.NOMOREINV) do
        if itemname == z.Name then
            table.remove(playerData.NOMOREINV, index)
            --TriggerEvent("chatMessage", "Debug ", {105,7,73}, itemname .. " just refilled , cancel the noremoreinv task ;D")
            Citizen.Trace(itemname .. "just refill , cancel the nomoreinv task ;D")
            break
        end
    end
    TriggerServerEvent('updateInventory', playerData.INVENTORY, playerData.NOMOREINV)
end

function hasItem(itemname)
    local found = false
    local amount = 0
    for i , x in ipairs(playerData.INVENTORY) do
        if x.Name == itemname then
            found = true
            amount = x.Amount
            break
        end
    end

    return found , amount
end

function removeItem(itemname,amount)
    amount = math.floor(tonumber(amount)) 
    for i , x in ipairs(playerData.INVENTORY) do
        if x.Name == itemname then
            if x.Amount - amount < 0 then
                return false
            elseif x.Amount - amount == 0 then
                table.remove(playerData.INVENTORY, i)
                table.insert(playerData.NOMOREINV, {Name=itemname})   
                TriggerServerEvent('updateInventory', playerData.INVENTORY, playerData.NOMOREINV)
                ShowNotification("~w~" .. amount .. "~w~x ~w~" .. string.lower(itemname) .. " ~r~removed")
                return true            
            else
                x.Amount = x.Amount - amount
                TriggerServerEvent('updateInventory', playerData.INVENTORY, playerData.NOMOREINV)
                ShowNotification("~w~" .. amount .. "~w~x ~w~" .. string.lower(itemname) .. " ~r~removed")
                return true
            end
        end
    end
    return false    
end

function removeAllItem(itemname)
    local found = false
    local success = false
    local indexAt = nil
    for i , x in ipairs(playerData.INVENTORY) do
        if x.Name == itemname then
            found = true
            indexAt = i
            break
        end
    end

    if found then
        table.remove( playerData.INVENTORY, indexAt )
        success = true
        table.insert(playerData.NOMOREINV, {Name=itemname})
        return success
    else
        return success
    end
end

function exceedUpdateUp()
    exceedLimit = exceedLimit+7
    tierLast = tierLast + 7
end

function exceedUpdateDown()
    exceedLimit = exceedLimit-7
    tierLast = tierLast -7
end

function exceedDefault()
    exceedLimit = 7
    tierLast = 1
end

function enterAmountKeep(itemname,place) -- this should not be syncd to the target func
    Citizen.CreateThread(function()
        amountPick = KeyboardInput("Enter the amount you want to get", "", 20)
        if tonumber(amountPick) and tonumber(amountPick) > 0 then
            if removeItemAps(itemname,amountPick,place) then
                TriggerEvent("onAddItem", itemname,amountPick)
            else
                ShowNotification("You enter the wrong amount")
            end
        else
            ShowNotification("[NUMBER ONLY]")
        end
    end)
end


function checkForUseItem(extra)
    local pretendValue
    if not extra then
        pretendValue = playerData.INVENTORY[currentPointing].Name
    else
        pretendValue = extra
        Citizen.Trace("this is extra == " .. extra .. " Do wait for safe bring off")
        Citizen.Wait(500)
    end
    if GetDistanceBetweenCoords( 281.98928833008, -649.47161865234, 55.030990600586, GetEntityCoords(GetPlayerPed(-1))) < 2.0 and playerTempData.INSIDE == "first" then
        local isHas , index = hasApartment("first")
        if isHas then
            local prepareValues = pretendValue
            local has , amount = hasItem(pretendValue)
            if has then
                if amount > 1 then
                    local tempAmount = KeyboardInput("Enter the amount you want to keep", "", 20)
                    if tonumber(tempAmount) and tonumber(tempAmount) > 0 then
                        if removeItem(pretendValue,tonumber(tempAmount)) then
                            addItemAps(prepareValues,tonumber(tempAmount),"first")
                        else
                            ShowNotification("You enter the wrong amount")
                        end
                    else
                        ShowNotification("[NUMBER ONLY]")
                    end
                else
                    if removeItem(pretendValue,1) then
                        addItemAps(prepareValues,1,"first")
                    else
                        ShowNotification("Somethings went wrong")
                    end
                end
            end
        else
            ShowNotification("You're bugged , you don't have any aps please quit")
        end
    elseif GetDistanceBetweenCoords( -1215.8590087891, -1498.9047851563, 4.3344511985779, GetEntityCoords(GetPlayerPed(-1))) < 2.0 then
        local prepareValues = pretendValue
        local has , amount = hasItem(pretendValue)
        if has then
            if amount > 1 then
                local tempAmount = KeyboardInput("Enter the amount you want to sell", "", 20)
                if tonumber(tempAmount) and tonumber(tempAmount) > 0 then
                    TriggerEvent("sellToPawn", pretendValue, tonumber(tempAmount))
                else
                    ShowNotification("[NUMBER ONLY]")
                end
            else
                TriggerEvent("sellToPawn", pretendValue, 1)
            end
        end
    else
        if pretendValue ==  "9mm"  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                --local targetAmmo = stringsplit(pretendValue, ":")
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = "9mm"
                    TriggerEvent("onUse9mm", 0)
                    TriggerServerEvent("proxMsg", "hold 9mm in the hand")
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your 9mm has gone already")
                end
            end
        elseif string.find(pretendValue,  "9mm&Magazine")  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                local targetAmmo = stringsplit(pretendValue, ":")
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = "9mm&Magazine"
                    TriggerEvent("onUse9mm", targetAmmo[2])
                    TriggerServerEvent("proxMsg", "hold 9mm in the hand")
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your 9mm has gone already")
                end
            end
        elseif string.find(pretendValue,  "PistolMagazine")  then
            local preSave = pretendValue
            if playerData.HOLDING ~= "9mm" and playerData.HOLDING ~= "9mm&Magazine" then
                if playerData.HOLDING ~= "NONE" then
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
                else
                    if removeItem(pretendValue,1) then
                        playerData.HOLDING = preSave
                        TriggerServerEvent("proxMsg", "hold the magazine to the hand")
                        TriggerEvent("holdObject", "w_pi_vintage_pistol_mag2")
                    else
                        TriggerEvent("chatMessage", "System ", {1,170,0}, "Your magazine has gone already")
                    end
                end
            elseif playerData.HOLDING == "9mm" then
                local targetAmmo = stringsplit(pretendValue, ":")
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = "9mm&Magazine"
                    TriggerEvent("onUse9mm", targetAmmo[2],true)
                    TriggerServerEvent("proxMsg", "reload pistol")
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your Ammo has gone already")
                end
            elseif playerData.HOLDING == "9mm&Magazine" then
                local targetAmmo = stringsplit(pretendValue, ":")
                if removeItem(pretendValue,1) then
                    local weapon = GetHashKey("WEAPON_PISTOL")
                    local x = GetAmmoInPedWeapon(PlayerPedId(), weapon)
                    TriggerEvent("onAddItem", "PistolMagazine:" .. tostring(x))
                    TriggerEvent("onUse9mm", targetAmmo[2],true)
                    TriggerServerEvent("proxMsg", "put the magazine out and reload new magazine in pistol")
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your Ammo has gone already")
                end
            end
        elseif string.find(pretendValue,  "pepsi")  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                local targetAmount = stringsplit(pretendValue, ":")
                local preSave = pretendValue
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = preSave
                    TriggerServerEvent("proxMsg", "hold the pepsi in the hand")
                    TriggerEvent("holdObject", "prop_energy_drink")
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your pepsi has gone already")
                end
            end
        elseif string.find(pretendValue,  "donut")  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                local targetAmount = stringsplit(pretendValue, ":")
                local preSave = pretendValue
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = preSave
                    TriggerServerEvent("proxMsg", "hold the donut in the hand")
                    TriggerEvent("holdObject", "prop_food_cb_nugets")
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your donut has gone already")
                end
            end
        elseif pretendValue == "CPR-kit"  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = "CPR-kit"
                    TriggerServerEvent("proxMsg", "hold medical cpr kit in the hand")
                    TriggerEvent("holdObject", "prop_ld_health_pack")
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your kits has gone already")
                end
            end
        elseif pretendValue == "Hatchet"  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = "Hatchet"
                    TriggerServerEvent("proxMsg", "hold the hatchet in the hand")
                    TriggerEvent("holdObject", "prop_w_me_hatchet", 300.0,0.0,0.0)
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your hatchet has gone already")
                end
            end
        elseif pretendValue == "Spanner"  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = "Spanner"
                    TriggerServerEvent("proxMsg", "hold the spanner in the hand")
                    TriggerEvent("holdObject", "prop_tool_adjspanner", 300.0,0.0,0.0)
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your spanner has gone already")
                end
            end
        elseif pretendValue == "Fishing-Rod"  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = "Fishing-Rod"
                    TriggerServerEvent("proxMsg", "hold the fishing rod in the hand")
                    TriggerEvent("holdObject", "prop_fishing_rod_01", 250.0,160.0,60.0)
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your fishing rod has gone already")
                end
            end
        elseif string.find(pretendValue, "-SHIRT")  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = pretendValue
                    TriggerServerEvent("proxMsg", "hold the shirt in the hand")
                    TriggerEvent("holdObject", "prop_cs_lazlow_shirt_01", 300.0,0.0,0.0)
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your shirt has gone already")
                end
            end
        elseif string.find(pretendValue, "-PANT")  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = pretendValue
                    TriggerServerEvent("proxMsg", "hold the pant in the hand")
                    TriggerEvent("holdObject", "prop_ld_jeans_01", 0.0,0.0,0.0)
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your pant has gone already")
                end
            end
        elseif string.find(pretendValue, "-SHOE")  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = pretendValue
                    TriggerServerEvent("proxMsg", "hold the shoe in the")
                    TriggerEvent("holdObject", "prop_ld_shoe_01", 300.0,0.0,90.0)
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your shoe has gone already")
                end
            end
        elseif string.find(pretendValue, "-Tank")  then
            if playerData.HOLDING ~= "NONE" then
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Please keep your current holding item in the inventory first")
            else
                if removeItem(pretendValue,1) then
                    playerData.HOLDING = pretendValue
                    TriggerServerEvent("proxMsg", "hold the fuel tank in the hand")
                    TriggerEvent("holdObject", "w_am_jerrycan", 300.0,0.0,0.0)
                else
                    TriggerEvent("chatMessage", "System ", {1,170,0}, "Your fuel tank has gone already")
                end
            end
        end
    end
end