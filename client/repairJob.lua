repairLocation = {
    {x=548.71588134766,y=-172.85455322266,z=54.481338500977}
}

local listMenu = {
    {Name="Start work",Index="start"},
    {Name="Stop work",Index="stop"},
    {Name="Buy Spanner",Index="buy"},
}

local isStart = false
local pedTarget = nil
local step = 1
local answer = nil
local trueResult = nil
local previousTarget = nil
local outRange = 5
local taskClear = nil
local taskCar = nil
local blipShow = nil

local function clearNpcJob()
    --[[if pedTarget ~= nil then
        ClearPedTasksImmediately(pedTarget)
    end]]
    SetEntityAsMissionEntity(taskCar , false,false)
    SetEntityAsMissionEntity(pedTarget , false,false)
    SetEntityAsNoLongerNeeded(pedTarget)
    SetVehicleAsNoLongerNeeded(taskCar)
    step = 1
    pedTarget = nil
    taskCar = nil
    outRange = 5
    --taskClear = nil
    --previousTarget = nil

    -- clear the blip
    if DoesBlipExist(blipShow) then
        RemoveBlip(blipShow)
    end
    --
end

local function interactMenu(target)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if target == "start" then
        isStart = true
        ShowNotification("You've ~g~start ~w~your repair job")
        WarMenu.CloseMenu()
    elseif target == "stop" then
        isStart = false
        ShowNotification("You've ~r~stop ~w~your job")
        clearNpcJob()
        WarMenu.CloseMenu()
    elseif target == "buy" then
        if moneyPay(-5) then
            TriggerEvent("onAddItem", "Spanner")
            WarMenu.CloseMenu()
        else
            ShowNotification("You don't have enough money to buy")
        end
    end
end

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('Repair-Man', 'Repair-Man Menu')
    --WarMenu.CreateSubMenu('closeMenu', 'foodshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('Repair-Man', 0.015)
    WarMenu.SetMenuY('Repair-Man', 0.35)
    --//

    while true do
        if WarMenu.IsMenuOpened('Repair-Man') then
            
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
            elseif WarMenu.MenuButton('No', 'Repair-Man') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, repairLoc in ipairs(repairLocation) do
                    if GetDistanceBetweenCoords( repairLoc.x,repairLoc.y,repairLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        if playerData.JOB == "Repair Man" then
                            WarMenu.OpenMenu('Repair-Man')
                        else
                            ShowNotification("You don't have access here")
                        end
                        --WarMenu.OpenMenu('Repair-Man')
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isStart then
            --Citizen.Trace("Try fetch npc")
            if pedTarget == nil then
                local x = IsAnyVehicleNearPoint(533.25952148438, -178.73878479004, 54.415306091309,5.0)

                if x then
                    --Citizen.Trace("Some car exist , wait 2 sec then try again")
                    ShowNotification("Please clear the area for the next customer")
                    Citizen.Wait(2000)
                else


                    local pos = GetEntityCoords(GetPlayerPed(-1))
                    local pedArray = GetNearbyPeds(pos.x,pos.y,pos.z, tonumber(50.0))
                    local npcArray = getDriverNpcFromPedArray(pedArray)
                    if #npcArray > 0 then
                        --Citizen.Trace("Found , adjust to pedTarget")
                        math.randomseed(GetGameTimer())
                        math.random(); math.random(); math.random()
                        local getRandomPed = math.random(1,#npcArray)
                        pedTarget = npcArray[getRandomPed]
                        if pedTarget == previousTarget then
                            --Citizen.Trace("This is the previous target , Wait 3 sec and find new")
                            pedTarget = nil
                            Citizen.Wait(3000)
                        else
                            previousTarget = pedTarget
                            SetEntityAsMissionEntity(pedTarget , true,true)
                        end
                    else
                        --Citizen.Trace("Not Found")
                    end
                end
            else
                --Citizen.Trace("pedTarget in controlled")
                if step == 1 then
                    --Citizen.Trace("pedTarget is driving here")
                    --ClearPedTasksImmediately(pedTarget)
                    local NpcCar = GetVehiclePedIsIn(pedTarget, false)
                    taskCar = NpcCar
                    SetEntityAsMissionEntity(taskCar , true,true)
                    TaskVehicleDriveToCoord(pedTarget, NpcCar, 533.25952148438, -178.73878479004, 54.415306091309, 13.0, 0, GetEntityModel(NpcCar), 411, 0.1)
                    SetPedKeepTask(pedTarget , true)
                    step = 2
                elseif step == 2 then
                    if GetDistanceBetweenCoords( 533.25952148438, -178.73878479004, 54.415306091309, GetEntityCoords(pedTarget)) < 3.5 then
                        --Citizen.Trace("Ped arrive set exit")
                        TaskLeaveVehicle(pedTarget, taskCar, 0)
                        while IsPedInAnyVehicle(pedTarget, false) do
                            Citizen.Wait(100)
                        end
                        --Citizen.Trace("Ped walking to wait point")
                        TaskGoToCoordAnyMeans(pedTarget, 541.08630371094, -180.61793518066, 54.481338500977, 2.0, 0, 0, 1, 10.0)
                        SetPedKeepTask(pedTarget , true)
                        --TaskStandStill(pedTarget, 5000)
                        step = 3
                    else
                        --Citizen.Trace("Ped still driving to point here")
                    end
                elseif step == 3 then
                    if GetDistanceBetweenCoords( 541.08630371094, -180.61793518066, 54.481338500977, GetEntityCoords(pedTarget)) < 2.5 then
                        TaskTurnPedToFaceEntity(pedTarget, taskCar, -1)
                        --TaskTurnPedToFaceCoord(pedTarget, GetEntityCoords(taskCar), -1)
                        --Citizen.Wait(1000)
                        --TaskStandStill(pedTarget, -1)
                        SetPedKeepTask(pedTarget , true)
                        step = 4
                        -- apply blip phase
                    
                        if DoesBlipExist(blipShow) then
                            RemoveBlip(blipShow)
                        end
                        blipShow = AddBlipForEntity(taskCar) 
                        SetBlipSprite(blipShow, 1)
                        SetBlipDisplay(blipShow, 4)
                        SetBlipScale(blipShow, 1.0)
                        SetBlipColour(blipShow, 45)
                        SetBlipAsShortRange(blipShow, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Job : objective")
                        EndTextCommandSetBlipName(blipShow)
                    end
                elseif step == 4 then
                    --Citizen.Trace("Done all progress, ped should standing at right position")
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isStart then
            if step == 2 then
                if GetDistanceBetweenCoords( 533.25952148438, -178.73878479004, 54.415306091309, GetEntityCoords(pedTarget)) > 2.5 then
                    TaskVehicleDriveToCoord(pedTarget, NpcCar, 533.25952148438, -178.73878479004, 54.415306091309, 13.0, 0, GetEntityModel(NpcCar), 411, 0.1)
                    SetPedKeepTask(pedTarget , true)
                    --Citizen.Trace("Fix bug , try to adjust the npc to the same place that's it should be again")
                    Citizen.Wait(5000) -- delay
                end
                if GetDistanceBetweenCoords( 533.25952148438, -178.73878479004, 54.415306091309, GetEntityCoords(pedTarget)) > 80.0 then
                    --Citizen.Trace("Bug, find new")
                    clearNpcJob()
                end
            elseif step == 3 then
                if GetDistanceBetweenCoords( 533.25952148438, -178.73878479004, 54.415306091309, GetEntityCoords(pedTarget)) > 2.5 then
                    --Citizen.Trace("ped still not walk to point , set this again")
                    TaskGoToCoordAnyMeans(pedTarget, 541.08630371094, -180.61793518066, 54.481338500977, 2.0, 0, 0, 1, 10.0)
                    SetPedKeepTask(pedTarget , true)
                    Citizen.Wait(2000) -- delay
                end
            end

            -- should include this , if this is what i've looking for IsPedStrafing
            if step ~= 1 then
                if IsPedFleeing(pedTarget) or IsEntityDead(pedTarget) or IsPedStrafing(pedTarget) then -- check if the entity is running away or dead or shooting at someone
                    --Citizen.Trace("Ped is running away , or ped is dead , find new")
                    clearNpcJob()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isStart then
            if GetDistanceBetweenCoords( 538.3603515625, -180.91542053223, 54.484775543213, GetEntityCoords(PlayerPedId())) > 25.0 then
                drawTxt(1.025, 1.274, 1.0,1.0,0.4, "~w~Please return to your position in ~b~" .. outRange .. " ~w~seconds", 255, 255, 255, 255,true)
            end
            if playerData.HOLDING == "Spanner" then
                if IsDisabledControlJustPressed(1, 24) then
                    --Citizen.Trace("Clicking spanner")
                    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
                    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 0.0)
                    local targetVehicle = getVehicleInDirection(coordA, coordB)
                    if targetVehicle == taskCar then
                        if step == 4 then
                            RequestAnimDict("mini@golf")
                            while (not HasAnimDictLoaded("mini@golf")) do Citizen.Wait(0) end
                            TaskPlayAnim(GetPlayerPed(-1), 'mini@golf', 'iron_idle_b', 5.0, -1, -1, 9, 0, false, false, false)   
                            Citizen.Wait(4000)
                            StopAnimTask(GetPlayerPed(-1), "mini@golf","iron_idle_b", 1.0)            
                            ClearPedTasksImmediately(pedTarget)
                            TaskEnterVehicle(pedTarget, targetVehicle, -1, -1, 2.0001, 1) -- set bot to vehicle
                            clearNpcJob()
                            math.randomseed(GetGameTimer())
                            math.random(); math.random(); math.random()
                            local randomPay = math.random(8,15)
                            moneyPay(randomPay)
                            --playerData.EXP = playerData.EXP + 4.5
                            earnExp(4.5)
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isStart then
            if GetDistanceBetweenCoords( 538.3603515625, -180.91542053223, 54.484775543213, GetEntityCoords(PlayerPedId())) > 25.0 then
                if outRange < 1 then
                    isStart = false
                    ShowNotification("You've ~r~stop ~w~your job")
                    clearNpcJob()
                    return
                end
                outRange = outRange - 1
            else
                outRange = 5
            end
        end
    end
end)