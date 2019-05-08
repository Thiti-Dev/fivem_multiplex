postalLocation = {
    {x=78.793640136719,y=112.20546722412,z=81.168167114258}
}

local listMenu = {
     {Name="Rent Vehicle",Index="vehicle"},
     {Name="Return Vehicle",Index="vehicle-return"},
    {Name="Stop unfinished-delivery",Index="stop"},
     --{Name="Full Pistol Magazine",Index="pistolMagFull"},
     ---{Name="Pistol Bullet [ x 3 ]",Index="bullet"}
}

local rentVehicle = nil



local function interactMenu(target)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if target == "vehicle" then
        local x = IsAnyVehicleNearPoint(59.313888549805,125.68978118896,79.155174255371,5.0)
        if x then
            ShowNotification("No place to send the vehicle, some car already exist")
        else
            if moneyPay(-30) then
                local model = GetHashKey("boxville2")
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                rentVehicle = CreateVehicle(model,59.313888549805,125.68978118896,79.155174255371,161.6862487793,true,false)
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
        end
    elseif target == "vehicle-return" then
        if rentVehicle ~= nil then
            local posCar =  GetEntityCoords(rentVehicle)
            Citizen.Trace(posCar.x .. " " .. posCar.y .. " " .. posCar.z)
            if GetDistanceBetweenCoords( 59.313888549805,125.68978118896,79.155174255371, GetEntityCoords(rentVehicle)) < 5.0 then
                Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( rentVehicle ) )
                rentVehicle = nil
                moneyPay(25)
                WarMenu.CloseMenu()
                SetNotificationTextEntry("STRING")
                AddTextComponentString("Thank you for sent the car back")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_ARTHUR", "CHAR_ARTHUR", true, 1, "Vehicle Rent", "For job", 1.000)
                DrawNotification_4(false, true)  
            else
                ShowNotification("No car park, in the certain area")
            end
        else
            ShowNotification("You haven't rent any car")
        end
    elseif target == "stop" then
        TriggerEvent("stopUnFinished")
    end
end

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('postal', 'Postal Delivery Menu')
    --WarMenu.CreateSubMenu('closeMenu', 'foodshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('postal', 0.015)
    WarMenu.SetMenuY('postal', 0.20)
    WarMenu.SetTitleColor('postal', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('postal', 0, 0, 0,0)
    WarMenu.SetSubTitle('postal', "JOB-MENU")
    WarMenu.SetMenuBackgroundColor('postal', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('postal',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('postal') then
            
            for _, x in ipairs(listMenu) do
                if WarMenu.Button(x.Name) then
                    --TriggerEvent("chatMessage", "[Index]", {255, 0, 0}, "This is " .. x.Name) 
                    interactMenu(x.Index)
                end
            end

            
            
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'postal') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, postalLoc in ipairs(postalLocation) do
                    if GetDistanceBetweenCoords( postalLoc.x,postalLoc.y,postalLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        if playerData.JOB == "Postal Delivery" then
                            WarMenu.OpenMenu('postal')
                        else
                            ShowNotification("You don't have access here")
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)