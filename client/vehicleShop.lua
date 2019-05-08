local currentPreModel = nil
local currentPrePrice = 0
local fakeCar = nil

function drawTxtVehicle(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end


vehicleLocation = {
    {x=-33.305843353271,y=-1102.0725097656,z=26.422351837158}
}

local listMenu = {
    {Name="Intruder",Index="intruder",Price=-3000},
    {Name="Emperor",Index="emperor",Price=-3000},
     {Name="Gresley",Index="gresley",Price=-3000},
     {Name="Ingot",Index="ingot",Price=-3000},
     {Name="Manana",Index="manana",Price=-3000},
     {Name="Rocoto",Index="rocoto",Price=-3000},
     {Name="Stanier",Index="stanier",Price=-3000},
    {Name="Picador",Index="picador",Price=-3500},
    {Name="Bullet",Index="bullet",Price=-3500},
    {Name="Vigero",Index="vigero",Price=-4500},
     {Name="Sentinel",Index="sentinel",Price=-5000},
     {Name="Ruiner",Index="ruiner",Price=-5000},
     {Name="Phoenix",Index="phoenix",Price=-5000},
     {Name="Penumbra",Index="penumbra",Price=-5000},
    {Name="Gauntlet",Index="gauntlet",Price=-5000},
     {Name="Monroe",Index="monroe",Price=-5500},
     {Name="Voltic",Index="voltic",Price=-7000},
     {Name="Alpha",Index="alpha",Price=-7300},
     {Name="Sultan",Index="sultan",Price=-7500},
     {Name="Elegy [ Skyline ]",Index="elegy",Price=-7900},
    {Name="Of Godz 1",Index="2f2fgtr34",Price=-20000},
    {Name="Of Godz 2",Index="2f2fgts",Price=-20000},
    {Name="Of Godz 3",Index="2f2fmk4",Price=-20000},
    {Name="Of Godz 4",Index="2f2fmle7",Price=-20000},
    {Name="Of Godz 5",Index="ff4wrx",Price=-20000},
    {Name="Of Godz 6",Index="fnf4r34",Price=-20000},
    {Name="Of Godz 7",Index="fnflan",Price=-20000},
    {Name="Of Godz 8",Index="fnfmits",Price=-20000},
    {Name="Of Godz 9",Index="fnfmk4",Price=-20000},
    {Name="Of Godz 10",Index="fnfrx7",Price=-20000},
}

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('vehicleShop', '')
    --WarMenu.CreateSubMenu('closeMenu', 'gunshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('vehicleShop', 0.015)
    WarMenu.SetMenuY('vehicleShop', 0.20)
    WarMenu.SetTitleColor('vehicleShop', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('vehicleShop', 0, 0, 0,0)
    WarMenu.SetSubTitle('vehicleShop', "Vehicle-List")
    WarMenu.SetMenuBackgroundColor('vehicleShop', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('vehicleShop',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('vehicleShop') then
            
            for _, x in ipairs(listMenu) do
                if WarMenu.Button(tostring(_) .. ". " .. x.Name .. " - ~g~$~r~" .. x.Price) then
                    --TriggerEvent("chatMessage", "[Index]", {255, 0, 0}, "This is " .. x.Name) 
                    buyCar(x.Index,x.Price)
                end
            end

            
            if WarMenu.Button('Buy This Car') then
                --WarMenu.CloseMenu()
                boughtHis()
            end
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
                stopView()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'vehicleShop') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, vehicleLoc in ipairs(vehicleLocation) do
                    if GetDistanceBetweenCoords( vehicleLoc.x,vehicleLoc.y,vehicleLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        WarMenu.OpenMenu('vehicleShop')
                        SetEntityVisible(PlayerPedId(),false)
                        FreezeEntityPosition(PlayerPedId(),true)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)


function buyCar(target,price)
    currentPreModel = target
    currentPrePrice = price
    if DoesEntityExist(fakeCar) then
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeCar))
    end
    --local pos = currentlocation.pos.inside
    local hash = GetHashKey(target)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
        drawTxtVehicle("~b~Loading...",0,1,0.5,0.5,1.5,255,255,255,255)

    end
    local veh = CreateVehicle(hash,-42.697044372559,-1097.9171142578,26.422330856323,117.6300201416,false,false)
    while not DoesEntityExist(veh) do
        Citizen.Wait(0)
        drawTxtVehicle("~b~Loading...",0,1,0.5,0.5,1.5,255,255,255,255)
    end
    FreezeEntityPosition(veh,true)
    SetEntityInvincible(veh,true)
    SetVehicleDoorsLocked(veh,4)
    --SetEntityCollision(veh,false,false)
    TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
    for i = 0,24 do
        SetVehicleModKit(veh,0)
        RemoveVehicleMod(veh,i)
    end
    fakeCar = veh
end

function stopView()
    currentPreModel = nil
    currentPrePrice = 0
    if DoesEntityExist(fakeCar) then
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeCar))
    end
    fakeCar = nil
    SetEntityVisible(PlayerPedId(),true)
    FreezeEntityPosition(PlayerPedId(),false)
    SetEntityCoords(PlayerPedId(),-33.305843353271,-1102.0725097656,26.422351837158)
end

function boughtHis()
    if currentPreModel ~= nil then
        if moneyPay(currentPrePrice) then
            local vehicle = veh
            local veh = GetVehiclePedIsUsing(PlayerPedId())
            local model = GetEntityModel(veh)
            local colors = table.pack(GetVehicleColours(veh))
            local extra_colors = table.pack(GetVehicleExtraColours(veh))

            local mods = {}
            for i = 0,24 do
                mods[i] = GetVehicleMod(veh,i)
            end
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))

            --local pos = currentlocation.pos.outside

            FreezeEntityPosition(PlayerPedId(),false)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            personalvehicle = CreateVehicle(model,-45.611335754395,-1082.3067626953,26.703832626343,69.220695495605,true,false)
            SetModelAsNoLongerNeeded(model)
            for i,mod in pairs(mods) do
                SetVehicleModKit(personalvehicle,0)
                SetVehicleMod(personalvehicle,i,mod)
            end
            SetVehicleOnGroundProperly(personalvehicle)
            --///// seed
            --math.randomseed(os.clock()*100000000000)
            math.randomseed(GetGameTimer())
            math.random(); math.random(); math.random()
            --////// seeed
            local randomNum = math.random(0,99999)
            SetVehicleNumberPlateText(personalvehicle, "RP " .. randomNum)
            local plate = GetVehicleNumberPlateText(personalvehicle)
            Citizen.Trace("plate == " .. plate)
            SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
            local id = NetworkGetNetworkIdFromEntity(personalvehicle)
            SetNetworkIdCanMigrate(id, true)
            --Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
            SetVehicleColours(personalvehicle,colors[1],colors[2])
            SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
            SetEntityAsMissionEntity(personalvehicle , true,true)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1),personalvehicle,-1)
            SetEntityVisible(PlayerPedId(),true)  

            local translateIndex = {}
            translateIndex['false'] = '0'
            translateIndex['true'] = '1'
            translateIndex['0'] = '0'
            translateIndex['1'] = '1'
            local colours = table.pack(GetVehicleColours(personalvehicle))
            local extra_colors = table.pack(GetVehicleExtraColours(personalvehicle))
            local neon = table.pack(GetVehicleNeonLightsColour(personalvehicle))
            local stringColors = colours[1] .. ":" .. colours[2] .. ":" .. extra_colors[1] .. ":" .. extra_colors[2]
            local stringNeons = translateIndex[tostring(IsVehicleNeonLightEnabled(personalvehicle,0))] .. ":" .. translateIndex[tostring(IsVehicleNeonLightEnabled(personalvehicle,1))] .. ":" .. translateIndex[tostring(IsVehicleNeonLightEnabled(personalvehicle,2))] .. ":" .. translateIndex[tostring(IsVehicleNeonLightEnabled(personalvehicle,3))] .. ":" .. neon[1] .. ":" .. neon[2] .. ":" .. neon[3]   
            local mods = {}
            for i=0,49 do
                mods[i] = GetVehicleMod(personalvehicle, i)
            end      
            mods[46] = GetVehicleWindowTint(personalvehicle) -- Tinted Windows
            mods[18] = translateIndex[tostring(IsToggleModOn(personalvehicle,18))]
            mods[20] = translateIndex[tostring(IsToggleModOn(personalvehicle,20))]
            mods[22] = translateIndex[tostring(IsToggleModOn(personalvehicle,22))]
            local stringMods = ""
            for i=0,49 do
                stringMods = stringMods .. tostring(mods[i])
                if i ~= 49 then
                    stringMods = stringMods .. ":"
                end
            end 
            local bw = translateIndex[tostring(GetVehicleTyresCanBurst(personalvehicle))] .. ":" .. tostring(GetVehicleWheelType(personalvehicle))

            table.insert(playerVehicles, {PLATE=plate,MODEL=currentPreModel,COLORS=stringColors,MODS=stringMods,NEONS=stringNeons,BW=bw})
            --table.insert(playerVehicles, {PLATE=x.plate,MODEL=x.model,COLORS=x.colors,MODS=x.mods,NEONS=x.neon,BW=x.bvw})
            TriggerServerEvent('onCarPurchase', playerData.CHARACTER_NAME,currentPreModel, plate, stringColors, stringMods ,stringNeons,bw, NetworkGetNetworkIdFromEntity(personalvehicle))

            currentPreModel = nil
            currentPrePrice = 0
            fakeCar = nil
            WarMenu.CloseMenu()
        else
            ShowNotification("You don't have enough money")
        end
    else
        TriggerEvent("chatMessage", "System ", {1,170,0}, "No selected vehicle")
    end
end