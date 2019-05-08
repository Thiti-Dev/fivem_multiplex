policeLocation = {
    {x=441.03414916992,y=-981.56689453125,z=30.68959236145}
}

local vehSentLoc = {
    {x=408.27941894531,y=-980.03363037109,z=28.594520568848,heading=231.14297485352}, -- police-car-spawn
    {x=407.83993530273,y=-984.28552246094,z=28.592430114746,heading=230.34191894531}, -- police-car-spawn
    {x=407.52105712891,y=-988.52349853516,z=28.592102050781,heading=231.68417358398}, -- police-car-spawn
    {x=407.35675048828,y=-992.92742919922,z=28.593086242676,heading=232.57089233398}, -- police-car-spawn
    {x=407.59646606445,y=-997.83319091797,z=28.592329025269,heading=229.41398620605}, -- police-car-spawn
}

local listMenu = {
     {Name="Buy Kits",Index="kit"},
     {Name="Rent Uniform [ Ready to work ]",Index="uniform"},
     {Name="Return Uniform [ Stop work ]",Index="uniform-return"},
     {Name="Rent Vehicle",Index="vehicle"},
     {Name="Return Vehicle",Index="vehicle-return"},
}

local rentVehicle = nil
local currentMenu = "NONE"

local function interactMenu(target)
    if target == "kit" then
        if moneyPay(-10) then
            TriggerEvent("onAddItem", "9mm")
            TriggerEvent("onAddItem", "PistolMagazine:12", 3)
            WarMenu.CloseMenu()
        else
            ShowNotification("You don't have enough money")
        end
    elseif target == "vehicle" then
        local isPlaceFree = false
        local indexUse = nil
        for index , z in ipairs(vehSentLoc) do
            local x = IsAnyVehicleNearPoint(z.x,z.y,z.z,5.0)
            if not x then
                isPlaceFree = true
                indexUse = index
                break
            end
        end
        if isPlaceFree and indexUse then
            if moneyPay(-30) then
                local model = GetHashKey("Police")
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                rentVehicle = CreateVehicle(model,vehSentLoc[indexUse].x,vehSentLoc[indexUse].y,vehSentLoc[indexUse].z,vehSentLoc[indexUse].heading,true,false)
                SetModelAsNoLongerNeeded(model)
                SetVehicleOnGroundProperly(rentVehicle)
                --SetVehicleNumberPlateText(personalvehicle,plate)
                --SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
                --local id = NetworkGetNetworkIdFromEntity(personalvehicle)
                --SetNetworkIdCanMigrate(id, true)
                --SetVehicleColours(personalvehicle,primary,secondary)
                SetEntityAsMissionEntity(rentVehicle , true,true)
                SetNotificationTextEntry("STRING")
                AddTextComponentString("Your rented car has been sent")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_ARTHUR", "CHAR_ARTHUR", true, 1, "Vehicle Rent", "For job", 1.000)
                DrawNotification_4(false, true)            
                WarMenu.CloseMenu()
            else
                ShowNotification("You don't have enough money to rent")
            end
        else
            ShowNotification("No place to sent the vehicle")
        end
    elseif target == "vehicle-return" then
        if rentVehicle ~= nil then
            local posCar =  GetEntityCoords(rentVehicle)
            Citizen.Trace(posCar.x .. " " .. posCar.y .. " " .. posCar.z)
            local found = false
            for index , z in ipairs(vehSentLoc) do
                if GetDistanceBetweenCoords( z.x,z.y,z.z, GetEntityCoords(rentVehicle)) < 5.0 then
                    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( rentVehicle ) )
                    rentVehicle = nil
                    moneyPay(25)
                    WarMenu.CloseMenu()
                    SetNotificationTextEntry("STRING")
                    AddTextComponentString("Thank you for sent the car back")
                    Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_ARTHUR", "CHAR_ARTHUR", true, 1, "Vehicle Rent", "For job", 1.000)
                    DrawNotification_4(false, true)  
                    found = true
                    break
                end
            end
            if not found then
                ShowNotification("No car park, in the certain area")
            end
        else
            ShowNotification("You haven't rent any car")
        end
    elseif target == "uniform" then
        if playerTempData.UNIFORM ~= "POLICE" then
            if moneyPay(-5) then
                playerTempData.UNIFORM = "POLICE"
                updatePedLook(true)
                SetNotificationTextEntry("STRING")
                AddTextComponentString("You've rent uniform")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_CALL911", "CHAR_CALL911", true, 1, "Uniform Rent", "For job", 1.000)
                DrawNotification_4(false, true)  
                TriggerServerEvent("police:ready")
            else
                ShowNotification("You don't have enough money to rent")
            end
        else
            ShowNotification("You already wore a uniform")
        end
    elseif target == "uniform-return" then
        if playerTempData.UNIFORM == "POLICE" then
            moneyPay(5)
            playerTempData.UNIFORM = "NONE"
            updatePedLook()
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Thank you for sending uniform back")
            Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_CALL911", "CHAR_CALL911", true, 1, "Uniform Rent", "For job", 1.000)
            DrawNotification_4(false, true)  
            TriggerServerEvent("police:off")
        else
            ShowNotification("You don't have any uniform on you")
        end
    end
end

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('police', 'Police Menu')
    --WarMenu.CreateSubMenu('closeMenu', 'foodshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('police', 0.015)
    WarMenu.SetMenuY('police', 0.20)
    WarMenu.SetTitleColor('police', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('police', 0, 0, 0,0)
    WarMenu.SetSubTitle('police', "JOB-MENU")
    WarMenu.SetMenuBackgroundColor('police', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('police',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('police') then
            
            if currentMenu == "NONE" then
                for _, x in ipairs(listMenu) do
                    if WarMenu.Button(x.Name) then
                        --TriggerEvent("chatMessage", "[Index]", {255, 0, 0}, "This is " .. x.Name) 
                        interactMenu(x.Index)
                    end
                end
            elseif currentMenu == "GUEST" then
                if WarMenu.Button("Surrender & spend time in jail") then
                    Citizen.Trace("Good choice Prisoner")
                    TriggerEvent("safeJailMySelf")
                    WarMenu.CloseMenu()
                end
            end

            
            
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'police') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, policeLoc in ipairs(policeLocation) do
                    if GetDistanceBetweenCoords( policeLoc.x,policeLoc.y,policeLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        if playerData.JOB == "Police Officer" then
                            currentMenu = "NONE"
                            WarMenu.OpenMenu('police')
                        else
                            currentMenu = "GUEST"
                            WarMenu.OpenMenu('police')
                            --ShowNotification("You don't have access here")
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)

        createMarkerWithText(451.73834228516,-980.18365478516,30.689596176147,"Press ~r~E ~w~to send your suspect to the jail", {r=0,g=0,b=255,a=150})
    end
end)

RegisterNetEvent('police:toggleDrag')
AddEventHandler('police:toggleDrag', function(t)
	--if(handCuffed) then
		playerTempData.DRAG = not playerTempData.DRAG
		playerTempData.DRAGGER = t
	--end
end)

RegisterNetEvent('police:toggleHandCuff')
AddEventHandler('police:toggleHandCuff', function(cufferName)
    playerTempData.handCuffed = not playerTempData.handCuffed
    if playerTempData.handCuffed then
        TriggerServerEvent("proxMsg", "was handcuffed by " .. cufferName)
    else
         TriggerServerEvent("proxMsg", "was released handcuff by " .. cufferName)
    end
end)

RegisterNetEvent('police:toggleSeat')
AddEventHandler('police:toggleSeat', function(seaterName)
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    --Citizen.Trace("here")
    if DoesEntityExist(targetVehicle) then
        --Citizen.Trace("here")
        if(IsVehicleSeatFree(targetVehicle, 1)) then
            SetPedIntoVehicle(PlayerPedId(), targetVehicle, 1)

            TriggerServerEvent("proxMsg", "was put into vehicle by " .. seaterName)
        else 
            if(IsVehicleSeatFree(targetVehicle, 2)) then
                SetPedIntoVehicle(PlayerPedId(), targetVehicle, 2)
                TriggerServerEvent("proxMsg", "was put into vehicle by " .. seaterName)
            else
                if(IsVehicleSeatFree(targetVehicle, 0)) then
                    SetPedIntoVehicle(PlayerPedId(), targetVehicle, 0)
                    TriggerServerEvent("proxMsg", "was put into vehicle by " .. seaterName)   
                end                
            end
        end
    end
end)

RegisterNetEvent('police:arrestNow')
AddEventHandler('police:arrestNow', function(arresterName)
    TriggerEvent("safeJailMySelf", arresterName)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if playerData.LOGGEDIN then
            if playerTempData.DRAG then
                local ped = GetPlayerPed(GetPlayerFromServerId(playerTempData.DRAGGER))
                local myped = PlayerPedId()
                AttachEntityToEntity(myped, ped, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                playerTempData.STILLDRAG = true
            else
                if(playerTempData.STILLDRAG) then
                    DetachEntity(PlayerPedId(), true, false)
                    playerTempData.STILLDRAG = false
                end
            end
        end
    end
end)


-- handcuff check section to be sure that it's safe
Citizen.CreateThread(function()
     while true do
        if playerTempData.handCuffed then
            if IsPedFalling(GetPlayerPed(-1)) then
                StopAnimTask(GetPlayerPed(-1), "mp_arresting","idle", 1.0)  
            end
            if IsPedClimbing(PlayerPedId()) then
                --loadAnimDict("mp_arresting")
                --TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 5.0, -1, -1, 49, 0, false, false, false)  
                --Citizen.Trace("CLIMBING")
                ClearPedTasksImmediately(PlayerPedId())
            end
            if not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) and not IsPedFalling(GetPlayerPed(-1)) then
                loadAnimDict("mp_arresting")
                TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 5.0, -1, -1, 49, 0, false, false, false)  
            end

            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                DisableControlAction(0, 23, true)	-- Enter
            end
            DisableControlAction(0, 24, true)	-- Left Click
            SetPedPathCanUseLadders(GetPlayerPed(-1), false)
        else
            if IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) then
                StopAnimTask(GetPlayerPed(-1), "mp_arresting","idle", 1.0)  
            end            
        end
        Wait(0)
     end
 end)