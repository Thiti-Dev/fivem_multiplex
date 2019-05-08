doctorLocation = {
    {x=305.24853515625,y=-1431.7532958984,z=14.490288734436}
}

local listMenu = {
    {Name="Buy CPR-kit",Index="cpr"},
     {Name="Rent Uniform [ Ready to work ]",Index="uniform"},
     {Name="Return Uniform [ Stop work ]",Index="uniform-return"},
     {Name="Rent Vehicle",Index="vehicle"},
     {Name="Return Vehicle",Index="vehicle-return"},
     --{Name="Full Pistol Magazine",Index="pistolMagFull"},
     ---{Name="Pistol Bullet [ x 3 ]",Index="bullet"}
}

local rentVehicle = nil

local function interactMenu(target)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if target == "cpr" then
        if moneyPay(-5) then
            TriggerEvent("onAddItem", "CPR-kit")
            WarMenu.CloseMenu()
        else
            ShowNotification("You don't have enough money")
        end
    elseif target == "vehicle" then
        local x = IsAnyVehicleNearPoint(-486.82815551758,-331.84735107422,33.879821777344,5.0)
        if x then
            ShowNotification("No place to send the vehicle, some car already exist")
        else
            if moneyPay(-30) then
                local model = GetHashKey("ambulance")
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                rentVehicle = CreateVehicle(model,-486.82815551758,-331.84735107422,33.879821777344,261.8069152832,true,false)
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
            if GetDistanceBetweenCoords( -486.82815551758,-331.84735107422,33.879821777344, GetEntityCoords(rentVehicle)) < 5.0 then
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
    elseif target == "uniform" then
        if playerTempData.UNIFORM ~= "DOCTOR" then
            if moneyPay(-5) then
                playerTempData.UNIFORM = "DOCTOR"
                updatePedLook(true)
                SetNotificationTextEntry("STRING")
                AddTextComponentString("You've rent uniform")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_CALL911", "CHAR_CALL911", true, 1, "Uniform Rent", "For job", 1.000)
                DrawNotification_4(false, true)  
                TriggerServerEvent("doctor:ready")
            else
                ShowNotification("You don't have enough money to rent")
            end
        else
            ShowNotification("You already wore a uniform")
        end
    elseif target == "uniform-return" then
        if playerTempData.UNIFORM == "DOCTOR" then
            moneyPay(5)
            playerTempData.UNIFORM = "NONE"
            updatePedLook()
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Thank you for sending uniform back")
            Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_CALL911", "CHAR_CALL911", true, 1, "Uniform Rent", "For job", 1.000)
            DrawNotification_4(false, true)  
            TriggerServerEvent("doctor:off")
        else
            ShowNotification("You don't have any uniform on you")
        end
    end
end

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('doctor', 'Doctor Menu')
    --WarMenu.CreateSubMenu('closeMenu', 'foodshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('doctor', 0.015)
    WarMenu.SetMenuY('doctor', 0.20)
    WarMenu.SetTitleColor('doctor', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('doctor', 0, 0, 0,0)
    WarMenu.SetSubTitle('doctor', "JOB-MENU")
    WarMenu.SetMenuBackgroundColor('doctor', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('doctor',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('doctor') then
            
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
            elseif WarMenu.MenuButton('No', 'doctor') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, doctorLoc in ipairs(doctorLocation) do
                    if GetDistanceBetweenCoords( doctorLoc.x,doctorLoc.y,doctorLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        if playerData.JOB == "Doctor" then
                            WarMenu.OpenMenu('doctor')
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