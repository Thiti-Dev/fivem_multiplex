local currentApartmentMenu = "NONE"

apartmentLocation = {
    {x=272.84884643555,y=-644.87799072266,z=42.654365539551,index="first"}
}

apartmentEntrace = {
    {
        X=276.01834106445,Y=-643.07299804688,Z=42.654411315918,HEADING=71.08228302002,index="first",
        inside={X=285.55871582031,Y=-644.240234375,Z=55.030982971191,HEADING=159.95252990723}
    }
}

local listMenu = {
     {Name="Rent Room [ 3 day ]",Index="rent"},
     {Name="Rent More time [ when-expired only ]",Index="rent-more"},
}

function hasApartment(nametarget)
    if playerApartments[nametarget] then
        return true
    end
    return false
end


local function interactMenu(target)
    if target == "rent" then
        if not hasApartment(currentApartmentMenu) then
            if moneyPay(-20) then
                playerApartments[currentApartmentMenu] = {EXPIRED="NEVER",INVENTORY={}}
                --table.insert(playerApartments, {PLACE=currentApartmentMenu,EXPIRED="NEVER",INVENTORY={}})
                TriggerEvent("chatMessage", "System ", {1,170,0}, "Congratuation, you've rent the apartments")
                TriggerServerEvent("onApartmentRent",playerData.CHARACTER_NAME,currentApartmentMenu,"")
            else
                ShowNotification("You don't have enough money")
            end
        else
            ShowNotification("You already had a room")
        end
    end
end

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('aps', 'Apartment Menu')


    --FRONTEND OPTION
    WarMenu.SetMenuX('aps', 0.015)
    WarMenu.SetMenuY('aps', 0.35)
    WarMenu.SetTitleColor('aps', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('aps', 0, 0, 0,0)
    WarMenu.SetSubTitle('aps', "Apartment Action")
    WarMenu.SetMenuBackgroundColor('aps', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('aps',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('aps') then
            
            for _, x in ipairs(listMenu) do
                if WarMenu.Button(x.Name) then
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
            elseif WarMenu.MenuButton('No', 'aps') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, apartmentLoc in ipairs(apartmentLocation) do
                    if GetDistanceBetweenCoords( apartmentLoc.x,apartmentLoc.y,apartmentLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        WarMenu.OpenMenu('aps')
                        currentApartmentMenu = apartmentLoc.index
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
	while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        
        if(Vdist(pos.x, pos.y, pos.z, 281.98928833008, -649.47161865234, 55.030990600586) < 8.0) then
            DrawText3Ds(281.98928833008, -649.47161865234, 55.030990600586, "Use ~g~ITEM HERE~w~ to store your item or Press ~r~E ~w~ to open")
        end
        for _, apartmentLoc in ipairs(apartmentLocation) do
            if Vdist( apartmentLoc.x,apartmentLoc.y,apartmentLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 8.0 then
                DrawText3Ds(apartmentLoc.x,apartmentLoc.y,apartmentLoc.z, "Press ~g~E~w~ to open menu")
            end
        end


		for _, apsEntrance in ipairs(apartmentEntrace) do
			if(Vdist(pos.x, pos.y, pos.z, apsEntrance.X, apsEntrance.Y, apsEntrance.Z) < 8.0) then
				DrawMarker(1, apsEntrance.X, apsEntrance.Y, apsEntrance.Z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 100, 212, 197,120, 0, 0, 0,0)
				displayTextInfo2(pos.x,pos.y,pos.z,apsEntrance.X, apsEntrance.Y, apsEntrance.Z)
            end		
            if(Vdist(pos.x, pos.y, pos.z, apsEntrance.inside.X, apsEntrance.inside.Y, apsEntrance.inside.Z) < 8.0) then
				DrawMarker(1, apsEntrance.inside.X, apsEntrance.inside.Y, apsEntrance.inside.Z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 100, 212, 197,120, 0, 0, 0,0)
				displayTextInfo2(pos.x,pos.y,pos.z,apsEntrance.inside.X, apsEntrance.inside.Y, apsEntrance.inside.Z)
			end			
        end

        if IsControlJustReleased(0, 191) then --M by default
            for _, apsEntrance in ipairs(apartmentEntrace) do
                if GetDistanceBetweenCoords( apsEntrance.X, apsEntrance.Y, apsEntrance.Z, GetEntityCoords(GetPlayerPed(-1))) < 2.0 then
                    if hasApartment(apsEntrance.index) then
                        DoScreenFadeOut(500)
                        Citizen.Wait(600)
                        TriggerEvent("freezeAdjust")
                        SetEntityCoords(GetPlayerPed(-1), apsEntrance.inside.X, apsEntrance.inside.Y, apsEntrance.inside.Z - 0.95, 1, 0, 0, 1)
                        SetEntityHeading(GetPlayerPed(-1), apsEntrance.inside.HEADING)
                        playerTempData.INSIDE = apsEntrance.index
                        TriggerServerEvent("updateInside" , apsEntrance.index)
                        Citizen.Wait(2000)
                        DoScreenFadeIn(1000)   
                    else
                        ShowNotification("You don't have any room")
                    end
                elseif GetDistanceBetweenCoords( apsEntrance.inside.X, apsEntrance.inside.Y, apsEntrance.inside.Z, GetEntityCoords(GetPlayerPed(-1))) < 2.0 then
                    --WarMenu.OpenMenu('jobcenter')
                    DoScreenFadeOut(500)
                    Citizen.Wait(600)
                    TriggerEvent("freezeAdjust")
                    SetEntityCoords(GetPlayerPed(-1), apsEntrance.X, apsEntrance.Y, apsEntrance.Z - 0.95, 1, 0, 0, 1)
                    SetEntityHeading(GetPlayerPed(-1), apsEntrance.HEADING)
                    playerTempData.INSIDE = "NONE"
                    TriggerServerEvent("updateInside" , "NONE")
                    Citizen.Wait(2000)
                    DoScreenFadeIn(1000)   
                end
            end
        end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerTempData.INSIDE ~= "NONE" then
			for i=0, 32, 1 do
                local otherPlayerPed = GetPlayerPed(i)
                if otherPlayerPed ~= PlayerPedId() then
                    SetEntityLocallyInvisible(otherPlayerPed)
                    SetEntityNoCollisionEntity(PlayerPedId(), otherPlayerPed, true)
                end
            end
            NetworkSetVoiceChannel(playerTempData.INSIDE .. ":" .. playerData.CHARACTER_NAME)
        else
            NetworkClearVoiceChannel()
        end
    end
end)

AddEventHandler("safeStartCheck" , function()
    Citizen.CreateThread(function()
        Citizen.Trace("--------------------SAFTY INSTANCE CHECK STARTING IN 2 SEC ----------------------")
        Citizen.Wait(2000) -- hold for 2 second before the real check gonna start
        local warnCount = 0
        while true do
            Citizen.Wait(1000)
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            if playerTempData.INSIDE == "first" then
                if GetDistanceBetweenCoords( 283.7451171875, -646.72015380859, 55.030990600586, GetEntityCoords(GetPlayerPed(-1))) > 8.0 then
                    warnCount = warnCount + 1
                    Citizen.Trace("You're bugged , warn count = " .. warnCount)
                    if warnCount >= 4 then -- this is bug for sure
                        playerTempData.INSIDE = "NONE"
                        TriggerServerEvent("updateInside" , "NONE")
                        NetworkClearVoiceChannel()
                        Citizen.Trace("We've reset your instance to NONE and clear the voice channel")
                        warnCount = 0
                    end
                else
                    warnCount = 0
                end
            end
        end
    end)
end)


function addItemAps(itemname,amount,which)
    local realAmount = 1
    if amount then
      realAmount = math.floor(tonumber(amount)) 
    end
    if hasItemAps(itemname,which) then
        for i , x in ipairs(playerApartments[which].INVENTORY) do
            if x.Name == itemname then
                playerApartments[which].INVENTORY[i].Amount = playerApartments[which].INVENTORY[i].Amount + realAmount
                break
            end
        end
    else
        table.insert(playerApartments[which].INVENTORY, {Name=itemname,Amount=realAmount})
    end

    for index, z in ipairs(playerApartmentsItemRemoveTask) do
        if itemname == z.Name and which == z.Place then
            table.remove(playerApartmentsItemRemoveTask, index)
            --TriggerEvent("chatMessage", "Debug ", {105,7,73}, itemname .. " just refilled , cancel the noremoreinv task ;D")
            Citizen.Trace(itemname .. "just refill , cancel the nomoreinvAps task ;D")
            break
        end
    end
    TriggerServerEvent('updateApsInventory', playerApartments, playerApartmentsItemRemoveTask)
end

function hasItemAps(itemname,which)
    local found = false
    local amount = 0

    for i , x in ipairs(playerApartments[which].INVENTORY) do
        if x.Name == itemname then
            found = true
            amount = x.Amount
            break
        end
    end

    return found , amount
end
function removeItemAps(itemname,amount,which)
    amount = math.floor(tonumber(amount)) 
    for i , x in ipairs(playerApartments[which].INVENTORY) do
        if x.Name == itemname then
            if x.Amount - amount < 0 then
                return false
            elseif x.Amount - amount == 0 then
                table.remove(playerApartments[which].INVENTORY, i)
                table.insert(playerApartmentsItemRemoveTask, {Name=itemname,Place=which})   
                TriggerServerEvent('updateApsInventory', playerApartments, playerApartmentsItemRemoveTask)
                --ShowNotification("~w~" .. amount .. "~w~x ~w~" .. string.lower(itemname) .. " ~r~removed")
                return true            
            else
                x.Amount = x.Amount - amount
                TriggerServerEvent('updateApsInventory', playerApartments, playerApartmentsItemRemoveTask)
                --ShowNotification("~w~" .. amount .. "~w~x ~w~" .. string.lower(itemname) .. " ~r~removed")
                return true
            end
        end
    end
    return false    
end