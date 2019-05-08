gunLocation = {
    {x=21.337158203125,y=-1106.8634033203,z=29.797029495239}
}

local listMenu = {
    {Name="Private Pistol",Index="pistol",Price=-2500},
     {Name="Empty Pistol Magazine",Index="pistolMag",Price=-40},
     {Name="Full Pistol Magazine",Index="pistolMagFull",Price=-60},
      {Name="Pistol Bullet [ x 3 ]",Index="bullet",Price=-2}
}

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('gunshop', 'Weapon shop')
    --WarMenu.CreateSubMenu('closeMenu', 'gunshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('gunshop', 0.015)
    WarMenu.SetMenuY('gunshop', 0.20)
    WarMenu.SetTitleColor('gunshop', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('gunshop', 0, 0, 0,0)
    WarMenu.SetSubTitle('gunshop', "WEAPON-SELLER")
    WarMenu.SetMenuBackgroundColor('gunshop', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('gunshop',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('gunshop') then
            
            for _, x in ipairs(listMenu) do
                if WarMenu.Button(x.Name .. " -~g~$ ~r~" .. x.Price) then
                    --TriggerEvent("chatMessage", "[Index]", {255, 0, 0}, "This is " .. x.Name) 
                    buyGun(x.Index,x.Price)
                end
            end

            
            
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'gunshop') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, gunLoc in ipairs(gunLocation) do
                    if GetDistanceBetweenCoords( gunLoc.x,gunLoc.y,gunLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        WarMenu.OpenMenu('gunshop')
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)


function buyGun(target,price)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if target == "pistol" then
        if moneyPay(price) then
            TriggerEvent("onAddItem", "9mm")
        else
            ShowNotification("You don't have enough money")
        end
    elseif target == "pistolMagFull" then
        if moneyPay(price) then
            TriggerEvent("onAddItem", "PistolMagazine:12")
        else
            ShowNotification("You don't have enough money")
        end
    elseif target == "pistolMag" then
        if moneyPay(price) then
            TriggerEvent("onAddItem", "PistolMagazine:0")
        else
            ShowNotification("You don't have enough money")
        end
    elseif target == "bullet" then
        if moneyPay(price) then --Bullet[Pistol] x1
            TriggerEvent("onAddItem", "Bullet[Pistol] x1", 3)
        else
            ShowNotification("You don't have enough money")
        end
    end
end