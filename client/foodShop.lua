foodLocation = {
    {x=26.251571655273,y=-1346.7451171875,z=29.497020721436}
}

local listMenu = {
    {Name="Pepsi Soda",Index="pepsi:5",Price=-3},
    {Name="Donut",Index="donut:3",Price=-4},
    {Name="Fuel Tank",Index="Fuel-Tank:100",Price=-40},
     --{Name="Full Pistol Magazine",Index="pistolMagFull"},
     ---{Name="Pistol Bullet [ x 3 ]",Index="bullet"}
}

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('foodshop', 'FOOD SHOP')
    --WarMenu.CreateSubMenu('closeMenu', 'foodshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('foodshop', 0.015)
    WarMenu.SetMenuY('foodshop', 0.20)
    WarMenu.SetTitleColor('foodshop', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('foodshop', 0, 0, 0,0)
    WarMenu.SetSubTitle('foodshop', "Sell List")
    WarMenu.SetMenuBackgroundColor('foodshop', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('foodshop',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('foodshop') then
            
            for _, x in ipairs(listMenu) do
                if WarMenu.Button(x.Name .. " - ~g~$~r~ " .. x.Price) then
                    --TriggerEvent("chatMessage", "[Index]", {255, 0, 0}, "This is " .. x.Name) 
                    buyFood(x.Index,x.Price)
                end
            end

            
            
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'foodshop') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, foodLoc in ipairs(foodLocation) do
                    if GetDistanceBetweenCoords( foodLoc.x,foodLoc.y,foodLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        WarMenu.OpenMenu('foodshop')
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)


function buyFood(target,price)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if moneyPay(price) then
        TriggerEvent("onAddItem", target)
    else
        ShowNotification("You don't have enough money")
    end
end