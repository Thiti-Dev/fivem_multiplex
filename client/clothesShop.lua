clothLocation = {
    {x=-1224.4348144531,y=-1491.1862792969,z=4.3398156166077}
}

local listMenuShirtMale = {
    {Name="White shirt",Index="WHITE-SHIRT_[MALE]",Price=-20},
     {Name="Grey shirt",Index="GREY-SHIRT_[MALE]",Price=-20},
}

local listMenuShirtFemale = {
    {Name="White shirt",Index="WHITE-SHIRT_[FEMALE]",Price=-20},
     {Name="Grey shirt",Index="GREY-SHIRT_[FEMALE]",Price=-20},
}

local currentMenu = "NONE"

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('clothshop', 'Weapon shop')
    --WarMenu.CreateSubMenu('closeMenu', 'clothshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('clothshop', 0.015)
    WarMenu.SetMenuY('clothshop', 0.20)
    WarMenu.SetTitleColor('clothshop', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('clothshop', 0, 0, 0,0)
    WarMenu.SetSubTitle('clothshop', "CLOTHES-SELLER")
    WarMenu.SetMenuBackgroundColor('clothshop', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('clothshop',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('clothshop') then
            
            if currentMenu == "NONE" then
                if WarMenu.Button('MALE ZONE') then
                    currentMenu = "MALE"
                    WarMenu.ResetSelection()
                end    
                if WarMenu.Button('FEMALE ZONE') then
                    currentMenu = "FEMALE"
                    WarMenu.ResetSelection()
                end     
            elseif currentMenu == "MALE" then
                if WarMenu.Button('SHIRTS') then
                    currentMenu = "MALE-SHIRT"
                    WarMenu.ResetSelection()
                end    
            elseif currentMenu == "FEMALE" then
                if WarMenu.Button('SHIRTS') then
                    currentMenu = "FEMALE-SHIRT"
                    WarMenu.ResetSelection()
                end 
            elseif currentMenu == "MALE-SHIRT" then
                for _, x in ipairs(listMenuShirtMale) do
                    if WarMenu.Button(x.Name .. " - $ ~r~" .. x.Price) then
                        buyCloth(x.Index,x.Price)
                    end
                end 
                if WarMenu.Button('Back') then
                    currentMenu = "MALE"
                    WarMenu.ResetSelection()
                end
            elseif currentMenu == "FEMALE-SHIRT" then
                for _, x in ipairs(listMenuShirtFemale) do
                    if WarMenu.Button(x.Name .. " - $ ~r~" .. x.Price) then
                        buyCloth(x.Index,x.Price)
                    end
                end 
                if WarMenu.Button('Back') then
                    currentMenu = "FEMALE"
                    WarMenu.ResetSelection()
                end
            end

            
            
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'clothshop') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, clothLoc in ipairs(clothLocation) do
                    if GetDistanceBetweenCoords( clothLoc.x,clothLoc.y,clothLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        currentMenu = "NONE"
                        WarMenu.OpenMenu('clothshop')
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)


function buyCloth(target,price)
    if moneyPay(price) then
        TriggerEvent("onAddItem", target)
        WarMenu.CloseMenu()
    else
        ShowNotification("You don't have enough money")
    end
end