jobLocation = {
    {x=-268.61962890625,y=-957.13537597656,z=31.223134994507}
}

local listMenu = {
    {Name="1.Wood Cutter [ LEVEL : 1 ]",Index="wood"},
    {Name="2.Shop Keeper [ LEVEL : 1 ]",Index="shop"},
    {Name="3.Repair Man [ LEVEL : 3 ]",Index="repair"},
    {Name="4.Taxi Driver [ LEVEL : 3 ]",Index="taxi"},
    {Name="5.Postal Delivery [ LEVEL : 3 ]",Index="postal"},
    {Name="6.Trucker Man [ LEVEL : 3 ]",Index="truck"},
    {Name="6.Pro Fising [ LEVEL : 3 ]",Index="fish"},
    {Name="7.Doctor [ LEVEL : 5 ]",Index="doctor"},
    {Name="8.Police Officer [ LEVEL : 7 ]",Index="police"},
}

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('jobcenter', 'Job Center')
    --WarMenu.CreateSubMenu('closeMenu', 'jobcenter', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('jobcenter', 0.015)
    WarMenu.SetMenuY('jobcenter', 0.20)
    WarMenu.SetTitleColor('jobcenter', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('jobcenter', 0, 0, 0,0)
    WarMenu.SetSubTitle('jobcenter', "AVIALABLE-JOB-MENU")
    WarMenu.SetMenuBackgroundColor('jobcenter', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('jobcenter',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('jobcenter') then
            
            for _, x in ipairs(listMenu) do
                if WarMenu.Button(x.Name) then
                    --TriggerEvent("chatMessage", "[Index]", {255, 0, 0}, "This is " .. x.Name) 
                    getJob(x.Index)
                end
            end

            if WarMenu.Button('Quit current job') then
                quitJob()
            end           
            
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'jobcenter') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, jobLoc in ipairs(jobLocation) do
                    if GetDistanceBetweenCoords( jobLoc.x,jobLoc.y,jobLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        WarMenu.OpenMenu('jobcenter')
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)


function getJob(target)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if target == "wood" then
        if playerData.JOB == "NONE" then
            playerData.JOB = "Wood Cutter"
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Welcome to the new job")
            Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_BEVERLY", "CHAR_BEVERLY", true, 1, "Wood Cutter", "Company", 2.000)
            DrawNotification_4(false, true)
            TriggerServerEvent("updateJob" , playerData.JOB)
            WarMenu.CloseMenu()
        else
            ShowNotification("You already have a job")
        end
    elseif target == "shop" then
        if playerData.JOB == "NONE" then
            playerData.JOB = "Shopkeeper"
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Welcome to the new job")
            Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_MULTIPLAYER", "CHAR_MULTIPLAYER", true, 1, "Shop Keeper", "24/7", 2.000)
            DrawNotification_4(false, true)
            TriggerServerEvent("updateJob" , playerData.JOB)
            WarMenu.CloseMenu()
        else
            ShowNotification("You already have a job")
        end
    elseif target == "repair" then
        if playerData.JOB == "NONE" then
            if playerData.LEVEL >= 3 then
                playerData.JOB = "Repair Man"
                SetNotificationTextEntry("STRING")
                AddTextComponentString("Welcome to the new job")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_DEVIN", "CHAR_DEVIN", true, 1, "Repair Company", "Service", 2.000)
                DrawNotification_4(false, true)
                TriggerServerEvent("updateJob" , playerData.JOB)
                WarMenu.CloseMenu()
            else
                ShowNotification("You need to be level >= 3")
            end
        else
            ShowNotification("You already have a job")
        end
    elseif target == "taxi" then
        if playerData.JOB == "NONE" then
            if playerData.LEVEL >= 3 then
                playerData.JOB = "Taxi Driver"
                SetNotificationTextEntry("STRING")
                AddTextComponentString("Welcome to the new job")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_HAO", "CHAR_HAO", true, 1, "Taxi Company", "Service", 2.000)
                DrawNotification_4(false, true)
                TriggerServerEvent("updateJob" , playerData.JOB)
                WarMenu.CloseMenu()
            else
                ShowNotification("You need to be level >= 3")
            end
        else
            ShowNotification("You already have a job")
        end
    elseif target == "postal" then
        if playerData.JOB == "NONE" then
            if playerData.LEVEL >= 3 then
                playerData.JOB = "Postal Delivery"
                SetNotificationTextEntry("STRING")
                AddTextComponentString("Welcome to the new job")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_PEGASUS_DELIVERY", "CHAR_PEGASUS_DELIVERY", true, 1, "Postal Company", "Service", 2.000)
                DrawNotification_4(false, true)
                TriggerServerEvent("updateJob" , playerData.JOB)
                WarMenu.CloseMenu()
            else
                ShowNotification("You need to be level >= 3")
            end
        else
            ShowNotification("You already have a job")
        end
    elseif target == "truck" then
        if playerData.JOB == "NONE" then
            if playerData.LEVEL >= 3 then
                playerData.JOB = "Trucker Man"
                SetNotificationTextEntry("STRING")
                AddTextComponentString("Welcome to the new job")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_PEGASUS_DELIVERY", "CHAR_PEGASUS_DELIVERY", true, 1, "Truck Company", "Service", 2.000)
                DrawNotification_4(false, true)
                TriggerServerEvent("updateJob" , playerData.JOB)
                WarMenu.CloseMenu()
            else
                ShowNotification("You need to be level >= 3")
            end
        else
            ShowNotification("You already have a job")
        end
    elseif target == "fish" then
        if playerData.JOB == "NONE" then
            if playerData.LEVEL >= 3 then
                playerData.JOB = "Pro Fishing"
                SetNotificationTextEntry("STRING")
                AddTextComponentString("Welcome to the new job")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_BOATSITE", "CHAR_BOATSITE", true, 1, "Pro fishing Company", "Center", 2.000)
                DrawNotification_4(false, true)
                TriggerServerEvent("updateJob" , playerData.JOB)
                WarMenu.CloseMenu()
            else
                ShowNotification("You need to be level >= 3")
            end
        else
            ShowNotification("You already have a job")
        end
    elseif target == "doctor" then
        if playerData.JOB == "NONE" then
            if playerData.LEVEL >= 5 then
                playerData.JOB = "Doctor"
                SetNotificationTextEntry("STRING")
                AddTextComponentString("Welcome to the new job")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_CALL911", "CHAR_CALL911", true, 1, "Emergency", "SAVE_PEOPLE", 2.000)
                DrawNotification_4(false, true)
                TriggerServerEvent("updateJob" , playerData.JOB)
                WarMenu.CloseMenu()
            else
                ShowNotification("You need to be level >= 5")
            end
        else
            ShowNotification("You already have a job")
        end
    elseif target == "police" then
        if playerData.JOB == "NONE" then
            if playerData.LEVEL >= 7 then
                playerData.JOB = "Police Officer"
                SetNotificationTextEntry("STRING")
                AddTextComponentString("Welcome to the new job")
                Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_CALL911", "CHAR_CALL911", true, 1, "Emergency", "SAVE_PEOPLE", 2.000)
                DrawNotification_4(false, true)
                TriggerServerEvent("updateJob" , playerData.JOB)
                WarMenu.CloseMenu()
            else
                ShowNotification("You need to be level >= 7")
            end
        else
            ShowNotification("You already have a job")
        end
    end
end

function quitJob()
    if playerData.JOB == "NONE" then
         ShowNotification("You don't have a job")
    else
        playerData.JOB = "NONE"
        ShowNotification("You've quit your job")
        TriggerServerEvent("updateJob" , playerData.JOB)
        WarMenu.CloseMenu()
    end   
end