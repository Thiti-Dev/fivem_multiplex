local currentPlace = nil
local currentStarting = 1
local currentEnding = 7
local amountPick = 1
storeLocation = {
    {x=281.98928833008,y=-649.47161865234,z=55.030990600586,place="first"}
}

local listMenu = {
}

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('storeview', '')
    --WarMenu.CreateSubMenu('closeMenu', 'storeview', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('storeview', 0.015)
    WarMenu.SetMenuY('storeview', 0.20)
    WarMenu.SetTitleColor('storeview', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('storeview', 0, 0, 0,0)
    WarMenu.SetSubTitle('storeview', "APARTMENT-STORE-LIST")
    WarMenu.SetMenuBackgroundColor('storeview', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('storeview',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('storeview') then
            
            if currentPlace ~= nil then
                for _ , x in ipairs(playerApartments[currentPlace].INVENTORY) do
                    if WarMenu.Button(x.Name .. "  ---> ~g~X ~r~" .. x.Amount) then
                        if x.Amount > 1 then
                            enterAmountUse(x.Name,currentPlace)
                        else
                            if removeItemAps(x.Name,1,currentPlace) then
                                TriggerEvent("onAddItem", x.Name)
                            else
                                ShowNotification("Something went wrong")
                            end                            
                        end
                    end                    
                end
            end

            
            
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'storeview') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, storeLoc in ipairs(storeLocation) do
                    if GetDistanceBetweenCoords( storeLoc.x,storeLoc.y,storeLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        defApsStore()
                        currentPlace = storeLoc.place
                        WarMenu.OpenMenu('storeview')
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function upApsStore()
    currentEnding = currentEnding+7
    currentStarting = currentStarting + 7
end

function downApsStore()
    currentEnding = currentEnding-7
    currentStarting = currentStarting -7
end

function defApsStore()
    currentEnding = 7
    currentStarting = 1
end

--[[function buyFood(target)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if target == "pepsi" then
        if moneyPay(-3) then
            TriggerEvent("onAddItem", "pepsi:5")
        else
            ShowNotification("You don't have enough money")
        end
    elseif target == "donut" then
        if moneyPay(-4) then
            TriggerEvent("onAddItem", "donut:3")
        else
            ShowNotification("You don't have enough money")
        end
    end
end]]

function enterAmountUse(itemname,place) -- this should not be syncd to the target func
    Citizen.CreateThread(function()
        amountPick = KeyboardInput("Enter the amount you want to get", "", 20)
        if tonumber(amountPick) and tonumber(amountPick) > 0 then
            if removeItemAps(itemname,amountPick,place) then
                TriggerEvent("onAddItem", itemname,amountPick)
            else
                ShowNotification("You enter the wrong amount")
            end
        else
            ShowNotification("[NUMBER ONLY]")
        end
    end)
end