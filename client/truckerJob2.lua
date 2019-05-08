truckerLocation = {
    {x=119.47424316406,y=6626.6030273438,z=31.955596923828}
}

sendLocation = {
    {x=2871.810546875,y=4708.0805664063,z=48.314315795898},
    {x=1981.0946044922,y=3779.5541992188,z=31.685541152954},
    {x=1694.6481933594,y=3771.7836914063,z=34.204166412354}
}

local listMenu = {
     {Name="Rent Vehicle",Index="vehicle"},
     {Name="Return Vehicle",Index="vehicle-return"},
     {Name="Get trailer [ start job ]",Index="trailer-get"},
     {Name="Stop unfinished-delivery",Index="stop"},
     --{Name="Full Pistol Magazine",Index="pistolMagFull"},
     ---{Name="Pistol Bullet [ x 3 ]",Index="bullet"}
}

local isStart = false
local rentVehicle = nil
local trailerVehicle = nil
local trailerBlip = nil
local destinationBlip = nil
local targetLocation = nil


local function generateBlipFirstStart()
    if DoesBlipExist(trailerBlip) then
        RemoveBlip(trailerBlip)
    end

    if DoesBlipExist(destinationBlip) then
        RemoveBlip(destinationBlip)
    end

    trailerBlip = AddBlipForEntity(trailerVehicle) 
    SetBlipSprite(trailerBlip, 1)
    SetBlipDisplay(trailerBlip, 4)
    SetBlipScale(trailerBlip, 1.0)
    SetBlipColour(trailerBlip, 17)
    SetBlipAsShortRange(trailerBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("1.@Trailer : For job")
    EndTextCommandSetBlipName(trailerBlip)

    destinationBlip = AddBlipForCoord(sendLocation[targetLocation].x,sendLocation[targetLocation].y,sendLocation[targetLocation].z) 
    SetBlipSprite(destinationBlip, 1)
    SetBlipDisplay(destinationBlip, 4)
    SetBlipScale(destinationBlip, 1.0)
    SetBlipColour(destinationBlip, 1)
    SetBlipAsShortRange(destinationBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("1.@Trailer : Destination [ SEND HERE ]")
    EndTextCommandSetBlipName(destinationBlip)
end

local function interactMenu(target)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if target == "vehicle" then
        local x = IsAnyVehicleNearPoint(127.7416229248,6622.9643554688,32.020908355713,5.0)
        if x then
            ShowNotification("No place to send the vehicle, some car already exist")
        else
            if moneyPay(-30) then
                local model = GetHashKey("HAULER")
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                rentVehicle = CreateVehicle(model,127.7416229248,6622.9643554688,32.020908355713,314.2080078125,true,false)
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
            if GetDistanceBetweenCoords( 127.7416229248,6622.9643554688,32.020908355713, GetEntityCoords(rentVehicle)) < 5.0 then
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
        --TriggerEvent("stopUnFinished")
        isStart = false
        if DoesBlipExist(trailerBlip) then
            RemoveBlip(trailerBlip)
        end

        if DoesBlipExist(destinationBlip) then
            SetBlipRoute(destinationBlip, false)
            RemoveBlip(destinationBlip)
        end

        if DoesEntityExist(trailerVehicle) then
            Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( trailerVehicle ) )
        end
        trailerBlip = nil
        destinationBlip = nil
        ShowNotification("You've stop your job")
        WarMenu.CloseMenu()
    elseif target == "trailer-get" then
        local x = IsAnyVehicleNearPoint(148.39822387695,6620.4096679688,31.799896240234,5.0)
        if x then
            ShowNotification("No place to send the vehicle, some car already exist")
        else
            local model = GetHashKey("TRAILERS")
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            trailerVehicle = CreateVehicle(model,148.39822387695,6620.4096679688,31.799896240234,67.573608398438,true,false)
            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(trailerVehicle)
            SetEntityAsMissionEntity(trailerVehicle , false,false)
            SetVehicleAsNoLongerNeeded(trailerVehicle)
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Your trailer has been sent")
            Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_ARTHUR", "CHAR_ARTHUR", true, 1, "Trailer Sent", "For job", 1.000)
            DrawNotification_4(false, true)            
            isStart = true
            math.randomseed(GetGameTimer())
            math.random(); math.random(); math.random()
            local randomSpot = math.random(1,#sendLocation)
            targetLocation = randomSpot
            generateBlipFirstStart()
            WarMenu.CloseMenu()
        end
    end
end

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('truck', 'Trucker Man Menu')
    --WarMenu.CreateSubMenu('closeMenu', 'foodshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('truck', 0.015)
    WarMenu.SetMenuY('truck', 0.20)
    WarMenu.SetTitleColor('truck', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('truck', 0, 0, 0,0)
    WarMenu.SetSubTitle('truck', "JOB-MENU")
    WarMenu.SetMenuBackgroundColor('truck', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('truck',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('truck') then
            
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
            elseif WarMenu.MenuButton('No', 'truck') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, truckLoc in ipairs(truckerLocation) do
                    if GetDistanceBetweenCoords( truckLoc.x,truckLoc.y,truckLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        if playerData.JOB == "Trucker Man" then
                            WarMenu.OpenMenu('truck')
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isStart then
            if not IsEntityAttachedToEntity(trailerVehicle, rentVehicle) then
                drawTxt(1.025, 1.274, 1.0,1.0,0.4, "Attach the ~o~trailer~w~.", 255, 255, 255, 255,true)
                if DoesBlipExist(trailerBlip) then
                    SetBlipSprite(trailerBlip, 1)
                    SetBlipColour(trailerBlip, 17)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("1.@Trailer : For job")
                    EndTextCommandSetBlipName(trailerBlip)
                end
                --[[if DoesBlipExist(destinationBlip) then
                    SetBlipSprite(destinationBlip, 2)
                    SetBlipRoute(destinationBlip, false)
                end]]
                SetWaypointOff()
            else
                if DoesBlipExist(trailerBlip) then
                    SetBlipSprite(trailerBlip, 2) --invisible
                end
                --[[if DoesBlipExist(destinationBlip) then
                    SetBlipSprite(destinationBlip, 1)
                    SetBlipColour(destinationBlip, 6)
                    SetBlipRoute(destinationBlip, true)
                end]]
                SetNewWaypoint(sendLocation[targetLocation].x,sendLocation[targetLocation].y)
            end
            DrawMarker(1, sendLocation[targetLocation].x,sendLocation[targetLocation].y,sendLocation[targetLocation].z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0) --- The GoPostal depot location
            if GetDistanceBetweenCoords( sendLocation[targetLocation].x,sendLocation[targetLocation].y,sendLocation[targetLocation].z, GetEntityCoords(trailerVehicle)) < 5.0 and not IsEntityAttached(trailerVehicle) then
                DrawMissionText('Delivered ~g~trailer~w~.', 10000)
                if DoesBlipExist(trailerBlip) then
                    RemoveBlip(trailerBlip)
                end

                if DoesBlipExist(destinationBlip) then
                    SetBlipRoute(destinationBlip, false)
                    RemoveBlip(destinationBlip)
                end
                trailerBlip = nil
                destinationBlip = nil
                SetEntityAsMissionEntity(trailerVehicle , true,true)
                Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( trailerVehicle ) )
                trailerVehicle = nil
                isStart = false
                moneyPay(25)
            end
        end
    end
end)