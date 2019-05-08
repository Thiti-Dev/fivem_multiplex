chopLocation = {
    {x=-474.44287109375,y=5319.5703125,z=80.988121032715},
    {x=-492.05026245117,y=5301.3110351563,z=81.029876708984},
    {x=-495.78936767578,y=5296.296875,z=80.903869628906}
}

woodLocation = {
    {x=1200.5936279297,y=-1276.2464599609,z=35.224723815918},
    {x=1195.6632080078,y=-1303.8109130859,z=35.133209228516}
}

local listMenu = {
    {Name="Rent Car",Index="rentcar"},
}

local rentVehicle = nil
local currentMenu = 1

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('woodjob', 'Wood Cutter')
    --WarMenu.CreateSubMenu('closeMenu', 'woodjob', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('woodjob', 0.015)
    WarMenu.SetMenuY('woodjob', 0.20)
    WarMenu.SetTitleColor('woodjob', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('woodjob', 0, 0, 0,0)
    WarMenu.SetSubTitle('woodjob', "JOB-MENU")
    WarMenu.SetMenuBackgroundColor('woodjob', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('woodjob',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('woodjob') then
            if currentMenu == 1 then
                for _, x in ipairs(listMenu) do
                    if WarMenu.Button(x.Name) then
                        --TriggerEvent("chatMessage", "[Index]", {255, 0, 0}, "This is " .. x.Name) 
                        interAct(x.Index)
                    end
                end         
    
                if WarMenu.Button('Return rent vehicle') then
                    returnCar()
                end
                if WarMenu.Button('Buy hatchet') then
                    buyHatchet()
                end
            elseif currentMenu == 2 then
                if WarMenu.Button('Sent wood') then
                    sendWood()
                    --WarMenu.CloseMenu()
                end               
            end

            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'woodjob') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                --[[for _, jobLoc in ipairs(jobLocation) do
                    if GetDistanceBetweenCoords( jobLoc.x,jobLoc.y,jobLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        WarMenu.OpenMenu('woodjob')
                    end
                end]]
                if GetDistanceBetweenCoords( 1200.5936279297,-1276.2464599609,35.224723815918, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                    if playerData.JOB == "Wood Cutter" then
                        currentMenu = 1
                        WarMenu.OpenMenu('woodjob')
                    else
                        ShowNotification("You don't have access here")
                    end
                elseif GetDistanceBetweenCoords( 1195.6632080078,-1303.8109130859,35.133209228516, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                     if playerData.JOB == "Wood Cutter" then
                        currentMenu = 2
                        WarMenu.OpenMenu('woodjob')
                    else
                        ShowNotification("You don't have access here")
                    end                   
                end
            end
        end
        Citizen.Wait(0)
    end
end)


function interAct(target)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if target == "rentcar" then
        local x = IsAnyVehicleNearPoint(1206.6938476563,-1271.4067382813,35.314445495605,5.0)
        if x then
            ShowNotification("No place to send the vehicle, some car already exist")
        else
            if moneyPay(-30) then
                local model = GetHashKey("phantom")
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                rentVehicle = CreateVehicle(model,1206.6938476563,-1271.4067382813,35.314445495605,177.55174255371,true,false)
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
    end
end

function returnCar()
    if rentVehicle ~= nil then
        local posCar =  GetEntityCoords(rentVehicle)
        Citizen.Trace(posCar.x .. " " .. posCar.y .. " " .. posCar.z)
        if GetDistanceBetweenCoords( 1206.6938476563,-1271.4067382813,35.314445495605, GetEntityCoords(rentVehicle)) < 5.0 then
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
end

function sendWood()
    local isHas , amount = hasItem("Piece of wood")
    if isHas then
        if removeItem("Piece of wood",amount) then
            local payment = amount * 2
            moneyPay(payment)
            WarMenu.CloseMenu()
        else
            ShowNotification("Somethings wrong , try again")
        end
    else
        ShowNotification("You don't have any goods to sent")
    end
end

function buyHatchet()
    if moneyPay(-4) then
        TriggerEvent("onAddItem", "Hatchet")
        WarMenu.CloseMenu()
    else
        ShowNotification("You don't have enough money to buy")
    end
end