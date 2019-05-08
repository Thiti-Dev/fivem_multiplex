fishLocation = {
    {x=-1667.9873046875,y=-995.13903808594,z=8.1624460220337}
}

local listMenu = {
     {Name="Buy fishing rod",Index="buy"},
}



local function interactMenu(target)
    if target == "buy" then
        if moneyPay(-10) then
            TriggerEvent("onAddItem", "Fishing-Rod")
            WarMenu.CloseMenu()
        else
            ShowNotification("You don't have enough money")
        end
    end
end

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('fish', 'Pro fishing Menu')
    --WarMenu.CreateSubMenu('closeMenu', 'foodshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('fish', 0.015)
    WarMenu.SetMenuY('fish', 0.20)
    WarMenu.SetTitleColor('fish', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('fish', 0, 0, 0,0)
    WarMenu.SetSubTitle('fish', "JOB-MENU")
    WarMenu.SetMenuBackgroundColor('fish', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('fish',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('fish') then
            
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
            elseif WarMenu.MenuButton('No', 'fish') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, fishLoc in ipairs(fishLocation) do
                    if GetDistanceBetweenCoords( fishLoc.x,fishLoc.y,fishLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        if playerData.JOB == "Pro Fishing" then
                            WarMenu.OpenMenu('fish')
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