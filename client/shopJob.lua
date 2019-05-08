shopLocation = {
    {x=-705.95867919922,y=-911.88891601563,z=19.215587615967}
}

local listMenu = {
    {Name="Start work",Index="start"},
     {Name="Stop work",Index="stop"},
}

local rentVehicle = nil
local isStart = false
local pedTarget = nil
local step = 1
local answer = nil
local trueResult = nil
local previousTarget = nil
local outRange = 5
local taskClear = nil

local function clearNpcJob()
    --[[if pedTarget ~= nil then
        ClearPedTasksImmediately(pedTarget)
    end]]

    step = 1
    pedTarget = nil
    answer = nil
    trueResult = nil
    --outRange = 5
    --taskClear = nil
    --previousTarget = nil
end

local function clearTask(pedToClear) -- this should not be syncd to the target func
    Citizen.CreateThread(function()
        Citizen.Wait(10*1000) -- // awaiting the timer to see if this is still in the scoped that generate
        ----Citizen.Trace("This is done : == " .. showparams)
        Citizen.InvokeNative( 0x9614299DCB53E54B, Citizen.PointerValueIntInitialized( pedToClear ) )
        --Citizen.Trace("Remove done task ;P")
    end)
end

local function interactMenu(target)
    --TriggerEvent("chatMessage", "[GUN-CHECK]", {255, 0, 0}, "You're try to buy " .. target) 
    if target == "start" then
        isStart = true
        ShowNotification("You've ~g~start ~w~your job")
        WarMenu.CloseMenu()
    elseif target == "stop" then
        isStart = false
        ShowNotification("You've ~r~stop ~w~your job")
        clearNpcJob()
        WarMenu.CloseMenu()
    end
end

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('shopkeeper', 'Shopkeeper Menu')
    --WarMenu.CreateSubMenu('closeMenu', 'foodshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('shopkeeper', 0.015)
    WarMenu.SetMenuY('shopkeeper', 0.20)
    WarMenu.SetTitleColor('shopkeeper', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('shopkeeper', 0, 0, 0,0)
    WarMenu.SetSubTitle('shopkeeper', "JOB-MENU")
    WarMenu.SetMenuMaxOptionCountOnScreen('shopkeeper',10)
    --//

    while true do
        if WarMenu.IsMenuOpened('shopkeeper') then
            
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
            elseif WarMenu.MenuButton('No', 'shopkeeper') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 38) then --M by default
            if WarMenu.CurrentMenu() == nil then
                for _, shopLoc in ipairs(shopLocation) do
                    if GetDistanceBetweenCoords( shopLoc.x,shopLoc.y,shopLoc.z, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
                        if playerData.JOB == "Shopkeeper" then
                            WarMenu.OpenMenu('shopkeeper')
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isStart then
            --Citizen.Trace("Try fetch npc")
            if pedTarget == nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                local pedArray = GetNearbyPeds(pos.x,pos.y,pos.z, tonumber(40))
                local npcArray = getNpcFromPedArray(pedArray)
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
                    end
                else
                    --Citizen.Trace("Not Found")
                end
            else
                --Citizen.Trace("pedTarget in controlled")
                if step == 1 then
                    --Citizen.Trace("pedTarget is walking here")
                    ClearPedTasksImmediately(pedTarget)
                    TaskGoToCoordAnyMeans(pedTarget, -707.59069824219, -913.80804443359, 19.215589523315, 5.0, 0, 0, 1, 10.0)
                    step = 2
                elseif step == 2 then
                    if GetDistanceBetweenCoords( -707.59069824219, -913.80804443359, 19.215589523315, GetEntityCoords(pedTarget)) < 1.5 then
                        --Citizen.Trace("Ped arrive set turn")
                        TaskTurnPedToFaceEntity(pedTarget, PlayerPedId(), 1000)
                        Citizen.Wait(1000)
                        --Citizen.Trace("Ped standing still")
                        TaskStandStill(pedTarget, 5000)
                        step = 3
                    else
                        --Citizen.Trace("Ped still walking here")
                    end
                elseif step == 3 then
                    --Citizen.Trace("step = 3 Creating quiz")
                    math.randomseed(GetGameTimer())
                    math.random(); math.random(); math.random()
                    local randomNum1 = math.random(0,20)
                    local randomNum2 = math.random(0,20)
                    trueResult = randomNum1 + randomNum2
                    --Citizen.Trace("True result == " .. trueResult)
                    local stringShow = string.format("What's the result of %d + %d ?" , randomNum1, randomNum2)
                    answer = KeyboardInput(stringShow, "", 20)
                    step = 4
                elseif step == 4 then
                    if tonumber(answer) == trueResult then
                        if GetDistanceBetweenCoords( -707.59069824219, -913.80804443359, 19.215589523315, GetEntityCoords(pedTarget)) < 1.5 then
                            --Citizen.Trace("Success, quiiz with npc still here")
                            RequestAnimDict("gestures@m@car@std@casual@ps")
                            while (not HasAnimDictLoaded("gestures@m@car@std@casual@ps")) do Citizen.Wait(0) end
                            TaskPlayAnim(pedTarget, 'gestures@m@car@std@casual@ps', 'gesture_why', 5.0, -1, 3000, 50, 0, false, false, false)
                            math.randomseed(GetGameTimer())
                            math.random(); math.random(); math.random()
                            local randomPay = math.random(1,5)
                            moneyPay(randomPay)
                            earnExp(0.8)
                            --playerData.EXP = playerData.EXP + 0.8
                            clearTask(pedTarget) -- create new task to clear the npc after , to prevent the same npc
                            Citizen.Wait(5000)
                        else
                            --Citizen.Trace("Success, quiiz , with no npc T_T")
                            ShowNotification("Too-slow , try again")
                            clearTask(pedTarget) -- create new task to clear the npc after , to prevent the same npc
                        end
                        clearNpcJob()
                    else
                        --Citizen.Trace("Fail, quiiz , start all again")
                        ShowNotification("Wrong answer T_T")
                        clearNpcJob()
                        clearTask(pedTarget) -- create new task to clear the npc after , to prevent the same npc
                        Citizen.Wait(5000)
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
            if GetDistanceBetweenCoords( -705.68389892578, -913.59356689453, 19.215593338013, GetEntityCoords(PlayerPedId())) > 3.5 then
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isStart then
            if GetDistanceBetweenCoords( -705.68389892578, -913.59356689453, 19.215593338013, GetEntityCoords(PlayerPedId())) > 3.5 then
                drawTxt(1.025, 1.274, 1.0,1.0,0.4, "~w~Please return to your position in ~b~" .. outRange .. " ~w~seconds", 255, 255, 255, 255,true)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isStart then
            if step == 2 then
                if GetDistanceBetweenCoords( -707.59069824219, -913.80804443359, 19.215589523315, GetEntityCoords(pedTarget)) > 2.0 then
                    TaskGoToCoordAnyMeans(pedTarget, -707.59069824219, -913.80804443359, 19.215589523315, 5.0, 0, 0, 1, 10.0) -- repeat
                    Citizen.Wait(5000) -- delay
                end
            end
        end
    end
end)