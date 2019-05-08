recieveLocation = {
    {x=211.81335449219,y=-807.95141601563,z=30.836181640625}
}

local spawnVehLoc = {
    {x=206.4656829834,y=-801.04522705078,z=30.389783859253,heading=249.2102355957}, -- car-spawn-1
    {x=207.6778717041,y=-798.75848388672,z=30.368339538574,heading=248.85717773438}, -- car-spawn-2
    {x=208.53918457031,y=-796.228515625,z=30.349891662598,heading=249.68499755859}, -- car-spawn-3
    {x=209.42495727539,y=-793.62957763672,z=30.329818725586,heading=249.92984008789}, -- car-spawn-5
    {x=210.82209777832,y=-791.32696533203,z=30.299800872803,heading=249.03060913086}, -- car-spawn-6
    {x=211.25820922852,y=-788.78302001953,z=30.296915054321,heading=249.06677246094}, -- car-spawn-7
    {x=212.39042663574,y=-786.25311279297,z=30.280517578125,heading=250.5885925293}, -- car-spawn-8
    {x=213.4854888916,y=-783.76300048828,z=30.264335632324,heading=249.00610351563}, -- car-spawn-9
    {x=213.93130493164,y=-781.1689453125,z=30.262655258179,heading=250.90171813965}, -- car-spawn-10
    {x=215.20854187012,y=-778.63122558594,z=30.245271682739,heading=249.95425415039}, -- car-spawn-11
    {x=215.64587402344,y=-776.064453125,z=30.245840072632,heading=250.22782897949}, -- car-spawn-12
    {x=216.8419342041,y=-773.67443847656,z=30.232875823975,heading=250.67381286621}, -- car-spawn-13
    {x=217.86581420898,y=-771.05523681641,z=30.225130081177,heading=248.86172485352}, -- car-spawn-14
    {x=218.37847900391,y=-768.50299072266,z=30.226486206055,heading=251.35424804688}, -- car-spawn-14
    {x=219.49308776855,y=-765.96685791016,z=30.221584320068,heading=249.98252868652}, -- car-spawn-15
}

local listMenu = {

}

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('recieveCar', 'Vehicle recieve')
    --WarMenu.CreateSubMenu('closeMenu', 'gunshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('recieveCar', 0.015)
    WarMenu.SetMenuY('recieveCar', 0.20)
    WarMenu.SetTitleColor('recieveCar', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('recieveCar', 0, 0, 0,0)
    WarMenu.SetSubTitle('recieveCar', "MY-PERSONAL-CAR-LIST")
    WarMenu.SetMenuBackgroundColor('recieveCar', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('recieveCar',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('recieveCar') then
            
            for _, x in ipairs(playerVehicles) do
                if WarMenu.Button(x.MODEL .. "  Plate : " .. x.PLATE) then
                    recieveNow(x.MODEL,x.PLATE,x.COLORS,x.MODS,x.NEONS,x.BW)
                    WarMenu.CloseMenu()
                end
            end

            
            
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'recieveCar') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, recieveLoc in ipairs(recieveLocation) do
                    if GetDistanceBetweenCoords( recieveLoc.x,recieveLoc.y,recieveLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        WarMenu.OpenMenu('recieveCar')
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)


function recieveNow(model,plate,colors,mods,neons,bw)
    TriggerServerEvent("reqVehicle", model,plate,colors,mods,neons,bw)
end

RegisterNetEvent("recieveSuccess")
AddEventHandler("recieveSuccess", function(netid,model,plate,colors,mods,neons,bw)
    local checkExist = NetworkGetEntityFromNetworkId(netid)
    if not DoesEntityExist(checkExist) then
        local isPlaceFree = false
        local indexUse = nil
        for index , z in ipairs(spawnVehLoc) do
            local x = IsAnyVehicleNearPoint(z.x,z.y,z.z,5.0)
            if not x then
                isPlaceFree = true
                indexUse = index
                break
                --ShowNotification("No place to send the vehicle, some car already exist")
            end
        end
        if isPlaceFree and indexUse then
            local vehicle = veh
            local veh = GetVehiclePedIsUsing(PlayerPedId())
            --local model = GetEntityModel(veh)
            local model = GetHashKey(model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            local color = stringsplit(colors , ":")
            local mod = stringsplit(mods , ":")
            local neon = stringsplit(neons , ":")
            local bw = stringsplit(bw , ":")




            personalvehicle = CreateVehicle(model,spawnVehLoc[indexUse].x,spawnVehLoc[indexUse].y,spawnVehLoc[indexUse].z,spawnVehLoc[indexUse].heading,true,false)
            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(personalvehicle)
            SetVehicleNumberPlateText(personalvehicle,plate)
            SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
            local id = NetworkGetNetworkIdFromEntity(personalvehicle)
            SetNetworkIdCanMigrate(id, true)

            SetVehicleModKit(personalvehicle,0)
            SetVehicleColours(personalvehicle,tonumber(color[1]),tonumber(color[2]))
            SetVehicleExtraColours(personalvehicle, tonumber(color[3]), tonumber(color[4]))

            SetVehicleWindowTint(personalvehicle,tonumber(mod[46+1]))

            SetVehicleTyresCanBurst(personalvehicle, tonumber(bw[1]))
            SetVehicleWheelType(personalvehicle, tonumber(bw[2]))
            SetVehicleTyreSmokeColor(personalvehicle,tonumber(bw[3]),tonumber(bw[4]),tonumber(bw[5]))

            
            ToggleVehicleMod(personalvehicle, 18, tonumber(mod[18+1]))
            ToggleVehicleMod(personalvehicle, 20, tonumber(mod[20+1]))
            ToggleVehicleMod(personalvehicle, 22, tonumber(mod[22+1]))

            SetVehicleNeonLightEnabled(personalvehicle,0, tonumber(neon[1]))
            SetVehicleNeonLightEnabled(personalvehicle,1, tonumber(neon[2]))
            SetVehicleNeonLightEnabled(personalvehicle,2, tonumber(neon[3]))
            SetVehicleNeonLightEnabled(personalvehicle,3, tonumber(neon[4]))
            SetVehicleNeonLightsColour(personalvehicle,tonumber(neon[5]),tonumber(neon[6]),tonumber(neon[7]))


            for i,modz in ipairs(mod) do 
                if i ~= 18+1 and i ~= 20+1 and i ~= 22+1 and i ~= 46+1 then
                    SetVehicleMod(personalvehicle, tonumber(i-1), tonumber(modz))
                end
            end



            SetEntityAsMissionEntity(personalvehicle , true,true)

            SetNotificationTextEntry("STRING")
            AddTextComponentString("Your car have been spawned")
            Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_CARSITE", "CHAR_CARSITE", true, 1, "Vehicle System", "By Thiti", 2.000)
            DrawNotification_4(false, true)
            TriggerServerEvent("syncVehicle", plate , NetworkGetNetworkIdFromEntity(personalvehicle))
        else
            ShowNotification("No place to spawn your vehicles")
        end
    else
        local platePre = GetVehicleNumberPlateText(checkExist)
        if platePre == plate then
            if GetEntityHealth(checkExist) > 0 then
                ShowNotification("Your car already been somewhere")
            else
                --showMeConfirmMenu = true
                TriggerEvent("confirmMenuCreate", "Pay for $1000 for bring your car back?","bringCarBack",{car=checkExist,model=model,plate=plate,colors=colors,mods=mods,neons=neons,bw=bw})
                TriggerEvent("chatMessage", "^0[^a 🚗 System ^0] ", {1,170,0}, "Your car has been destroyed , you need to pay 1000$ for recieve back")
            end
        else
            TriggerEvent("recieveSuccessWithoutCheck" , model,plate,colors,mods,neons,bw)
        end
    end
end)


RegisterNetEvent("recieveSuccessWithoutCheck")
AddEventHandler("recieveSuccessWithoutCheck", function(model,plate,colors,mods,neons,bw)
    local isPlaceFree = false
    local indexUse = nil
    for index , z in ipairs(spawnVehLoc) do
        local x = IsAnyVehicleNearPoint(z.x,z.y,z.z,5.0)
        if not x then
            isPlaceFree = true
            indexUse = index
            break
            --ShowNotification("No place to send the vehicle, some car already exist")
        end
    end
    if isPlaceFree and indexUse then
        local vehicle = veh
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        --local model = GetEntityModel(veh)
        local model = GetHashKey(model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        local color = stringsplit(colors , ":")
        local mod = stringsplit(mods , ":")
        local neon = stringsplit(neons , ":")
        local bw = stringsplit(bw , ":")
        
        personalvehicle = CreateVehicle(model,spawnVehLoc[indexUse].x,spawnVehLoc[indexUse].y,spawnVehLoc[indexUse].z,spawnVehLoc[indexUse].heading,true,false)
        SetModelAsNoLongerNeeded(model)
        SetVehicleOnGroundProperly(personalvehicle)
        SetVehicleNumberPlateText(personalvehicle,plate)
        SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
        local id = NetworkGetNetworkIdFromEntity(personalvehicle)
        SetNetworkIdCanMigrate(id, true)

        SetVehicleModKit(personalvehicle,0)
        SetVehicleColours(personalvehicle,tonumber(color[1]),tonumber(color[2]))
        SetVehicleExtraColours(personalvehicle, tonumber(color[3]), tonumber(color[4]))

        SetVehicleWindowTint(personalvehicle,tonumber(mod[46+1]))

        SetVehicleTyresCanBurst(personalvehicle, tonumber(bw[1]))
        SetVehicleWheelType(personalvehicle, tonumber(bw[2]))
        SetVehicleTyreSmokeColor(personalvehicle,tonumber(bw[3]),tonumber(bw[4]),tonumber(bw[5]))
        
        ToggleVehicleMod(personalvehicle, 18, tonumber(mod[18+1]))
        ToggleVehicleMod(personalvehicle, 20, tonumber(mod[20+1]))
        ToggleVehicleMod(personalvehicle, 22, tonumber(mod[22+1]))

        SetVehicleNeonLightEnabled(personalvehicle,0, tonumber(neon[1]))
        SetVehicleNeonLightEnabled(personalvehicle,1, tonumber(neon[2]))
        SetVehicleNeonLightEnabled(personalvehicle,2, tonumber(neon[3]))
        SetVehicleNeonLightEnabled(personalvehicle,3, tonumber(neon[4]))
        SetVehicleNeonLightsColour(personalvehicle,tonumber(neon[5]),tonumber(neon[6]),tonumber(neon[7]))


        for i,modz in ipairs(mod) do 
            if i ~= 18+1 and i ~= 20+1 and i ~= 22+1 and i ~= 46+1 then
                SetVehicleMod(personalvehicle, tonumber(i-1), tonumber(modz))
            end
        end

        SetEntityAsMissionEntity(personalvehicle , true,true)

        SetNotificationTextEntry("STRING")
        AddTextComponentString("Your car have been spawned")
        Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_CARSITE", "CHAR_CARSITE", true, 1, "Vehicle System", "By Thiti", 2.000)
        DrawNotification_4(false, true)
        TriggerServerEvent("syncVehicle", plate , NetworkGetNetworkIdFromEntity(personalvehicle))
    else
        ShowNotification("No place to spawn your vehicles")
    end
end)

function bringCarBack(arg)
    if moneyPay(-1000) then
        Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( arg.car ) )
        TriggerEvent("recieveSuccessWithoutCheck" , arg.model,arg.plate,arg.colors,arg.mods,arg.neons,arg.bw)
    else
        ShowNotification("Your don't have enough money")
    end
end